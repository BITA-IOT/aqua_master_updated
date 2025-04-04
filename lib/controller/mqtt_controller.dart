import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:aqua_master/controller/switch_controller.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttController extends GetxController {
  RxString mqttBroker = 'a31qubhv0f0qec-ats.iot.eu-north-1.amazonaws.com'.obs;
  RxInt port = 8883.obs;
  final RxString clientId = "flutter_mqtt_client123".obs;
  final String topicReceive = "/KRC/AM-AAA001";
  final String topicSend = "/test/AM-AAA001/1";

  MqttServerClient? client;
  var receivedData = {}.obs;
  var isConnected = false.obs;

  @override
  void onInit() {
    super.onInit();
    connectToMqtt();
    _setupMqttClient();
  }

  Future<void> connectToMqtt() async {
    try {
      log("Loading certificates...");
      final context = SecurityContext.defaultContext;

      final rootCa = await rootBundle.load('assets/root-CA.crt');
      final deviceCert = await rootBundle.load('assets/Temperature.cert.pem');
      final privateKey =
          await rootBundle.load('assets/Temperature.private.key');

      context.setClientAuthoritiesBytes(rootCa.buffer.asUint8List());
      context.useCertificateChainBytes(deviceCert.buffer.asUint8List());
      context.usePrivateKeyBytes(privateKey.buffer.asUint8List());

      client?.securityContext = context;
      client?.connectionMessage = MqttConnectMessage()
          .withClientIdentifier(clientId.value)
          .startClean();

      log("Connecting to MQTT broker...");
      await client?.connect();

      if (client?.connectionStatus!.state == MqttConnectionState.connected) {
        log('Connected to MQTT broker.');
        isConnected.value = true;
      } else {
        log('Connection failed: ${client?.connectionStatus!.state}');
        client?.disconnect();
      }
    } catch (e) {
      log('MQTT client exception: $e');
      client?.disconnect();
    }
  }

  void onConnected() {
    print("✅ Connected to MQTT Broker!");
    isConnected.value = true;
    client?.subscribe(topicReceive, MqttQos.atMostOnce);
    client?.updates?.listen(_onMessageReceived);
  }

  void _setupMqttClient() {
    client =
        MqttServerClient.withPort(mqttBroker.value, clientId.value, port.value);
    client?.secure = true;
    client?.keepAlivePeriod = 60;
    client?.setProtocolV311();
    client?.logging(on: false);

    client?.onDisconnected = onDisconnected;
    client?.onConnected = onConnected;
  }

  void onDisconnected() {
    isConnected.value = false;
  }

  void _onMessageReceived(List<MqttReceivedMessage<MqttMessage?>>? messages) {
    if (messages?.isEmpty ?? true) return;

    final MqttPublishMessage recMessage =
        messages![0].payload as MqttPublishMessage;
    final String message =
        MqttPublishPayload.bytesToStringAsString(recMessage.payload.message);

    if (message.trim().isEmpty) return;

    try {
      Map<String, dynamic> data = jsonDecode(message);
      receivedData.value = data;
      receivedData.refresh();
      update();

      final switchController = Get.find<SwitchCardController>();
      bool updated = data.keys.any((key) =>
          key.endsWith('sw') ||
          key.endsWith('sp') ||
          key.endsWith('state') ||
          key == 'waterlevel' ||
          key == 'timesch' ||
          key == 'timeschen' ||
          key == 'alarm' ||
          key == 'timenow' ||
          key == 'ip_address' ||
          key == 'packet_id');
      if (updated) {
        switchController.switchCards.refresh();
      }
    } catch (e) {
      print("❌ Error processing MQTT message: $e");
      print("📩 Raw message: $message");
    }
  }

  void sendData(Map<String, dynamic> receivedData,
      {int? switchIndex, int? switchState}) {
    Map<String, dynamic> jsonData = {
      "seasonsw": receivedData["seasonsw"] ?? 23,
      // "temp1": receivedData["temp1"] ?? 23,
      // "temp2": receivedData["temp2"] ?? 23,
      // "temp3": receivedData["temp3"] ?? 23,
      "coolersp": receivedData["coolersp"] ?? 28,
      "boilersp": receivedData["boilersp"] ?? 29,
      "comfortersp": receivedData["comfortersp"] ?? 29,
      // "alarm": receivedData["alarm"] ?? "No Alarm",
      // "timenow": receivedData["timenow"] ?? DateTime.now().toString(),
      // "ip_address": receivedData["ip_address"] ?? "192.168.18.164",
      // "packet_id": receivedData["packet_id"] ?? 1,
      // "ssid": receivedData["ssid"] ?? "defaultSSID",
      // "password": receivedData["password"] ?? "defaultPassword",
      "coolersw": receivedData["coolersw"] ?? 1,
      "boilersw": receivedData["boilersw"] ?? 1,
      "comfortersw": receivedData["comfortersw"] ?? 1,
      // "boostersw": receivedData["boostersw"] ?? 1,
      // "makeupsw": receivedData["makeupsw"] ?? 1,
      // "crculatonsw": receivedData["crculatonsw"] ?? 1
    };

    if (switchIndex != null && switchState != null) {
      bool switchFound = false;
      for (var switchItem in jsonData["switches"] ?? []) {
        if (switchItem["switch_index"] == switchIndex) {
          switchItem["switch_state"] = switchState;
          switchFound = true;
          break;
        }
      }

      if (!switchFound) {
        jsonData["switches"] ??= [];
        jsonData["switches"]
            .add({"switch_index": switchIndex, "switch_state": switchState});
      }
    }

    String jsonString = jsonEncode(jsonData);
    print("📤 Sending MQTT Message: $jsonString");

    final builder = MqttClientPayloadBuilder();
    builder.addString(jsonString);

    if (builder.payload?.isEmpty ?? true) {
      print("❌ MQTT Payload is empty! Message not sent.");
      return;
    }

    client?.publishMessage(topicSend, MqttQos.atMostOnce, builder.payload!);
    print("✅ MQTT Message Sent Successfully!");
  }
}
