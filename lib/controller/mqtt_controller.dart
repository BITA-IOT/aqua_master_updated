// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:aqua_master/controller/switch_controller.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:mqtt_client/mqtt_client.dart';
// import 'package:mqtt_client/mqtt_server_client.dart';

// class MqttController extends GetxController {
//   RxString mqttBroker = 'a31qubhv0f0qec-ats.iot.eu-north-1.amazonaws.com'.obs;
//   RxInt port = 8883.obs;
//   final RxString clientId = "flutter_mqtt_client123".obs;
//   final String topicReceive = "/KRC/AM-AAA001";
//   final String topicSend = "/test/AM-AAA001/1";

//   MqttServerClient? client;
//   var receivedData = {}.obs;
//   var isConnected = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     connectToMqtt();
//     _setupMqttClient();
//   }

//   Future<void> connectToMqtt() async {
//     try {
//       log("Loading certificates...");
//       final context = SecurityContext.defaultContext;

//       final rootCa = await rootBundle.load('assets/root-CA.crt');
//       final deviceCert = await rootBundle.load('assets/Temperature.cert.pem');
//       final privateKey =
//           await rootBundle.load('assets/Temperature.private.key');

//       context.setClientAuthoritiesBytes(rootCa.buffer.asUint8List());
//       context.useCertificateChainBytes(deviceCert.buffer.asUint8List());
//       context.usePrivateKeyBytes(privateKey.buffer.asUint8List());

//       client?.securityContext = context;
//       client?.connectionMessage = MqttConnectMessage()
//           .withClientIdentifier(clientId.value)
//           .startClean();

//       log("Connecting to MQTT broker...");
//       await client?.connect();

//       if (client?.connectionStatus!.state == MqttConnectionState.connected) {
//         log('Connected to MQTT broker.');
//         isConnected.value = true;
//       } else {
//         log('Connection failed: ${client?.connectionStatus!.state}');
//         client?.disconnect();
//       }
//     } catch (e) {
//       log('MQTT client exception: $e');
//       client?.disconnect();
//     }
//   }

//   void onConnected() {
//     print("✅ Connected to MQTT Broker!");
//     isConnected.value = true;
//     client?.subscribe(topicReceive, MqttQos.atMostOnce);
//     client?.updates?.listen(_onMessageReceived);
//   }

//   void _setupMqttClient() {
//     client =
//         MqttServerClient.withPort(mqttBroker.value, clientId.value, port.value);
//     client?.secure = true;
//     client?.keepAlivePeriod = 60;
//     client?.setProtocolV311();
//     client?.logging(on: false);

//     client?.onDisconnected = onDisconnected;
//     client?.onConnected = onConnected;
//   }

//   void onDisconnected() {
//     isConnected.value = false;
//   }

//   void _onMessageReceived(List<MqttReceivedMessage<MqttMessage?>>? messages) {
//     if (messages?.isEmpty ?? true) return;

//     final MqttPublishMessage recMessage =
//         messages![0].payload as MqttPublishMessage;
//     final String message =
//         MqttPublishPayload.bytesToStringAsString(recMessage.payload.message);

//     if (message.trim().isEmpty) return;

//     try {
//       Map<String, dynamic> data = jsonDecode(message);
//       receivedData.value = data;
//       receivedData.refresh();
//       update();

//       final switchController = Get.find<SwitchCardController>();
//       bool updated = data.keys.any((key) =>
//           key.endsWith('sw') ||
//           key.endsWith('sp') ||
//           key.endsWith('state') ||
//           key == 'waterlevel' ||
//           key == 'timesch' ||
//           key == 'timeschen' ||
//           key == 'alarm' ||
//           key == 'timenow' ||
//           key == 'ip_address' ||
//           key == 'packet_id');
//       if (updated) {
//         switchController.switchCards.refresh();
//       }
//     } catch (e) {
//       print("❌ Error processing MQTT message: $e");
//       print("📩 Raw message: $message");
//     }
//   }

//   void sendData(Map<String, dynamic> receivedData,
//       {int? switchIndex, int? switchState}) {
//     // Create a map to keep track of the current state (preserving received data)
//     Map<String, dynamic> jsonData = {};

//     // Merge with the current values in `receivedData`, so that the unchanged values are preserved

//     jsonData["coolersp"] = receivedData["coolersp"] ?? 0;
//     jsonData["boilersp"] = receivedData["boilersp"] ?? 0;
//     jsonData["comfortersp"] = receivedData["comfortersp"] ?? 0;
//     jsonData["coolersw"] = receivedData["coolersw"] ?? 0;
//     jsonData["boilersw"] = receivedData["boilersw"] ?? 0;
//     jsonData["comfortersw"] = receivedData["comfortersw"] ?? 0;

//     // If switchIndex and switchState are provided, update the switches array
//     if (switchIndex != null && switchState != null) {
//       jsonData["switches"] ??= [];

//       // Look for the switch to update
//       bool switchFound = false;
//       for (var switchItem in jsonData["switches"]!) {
//         if (switchItem["switch_index"] == switchIndex) {
//           switchItem["switch_state"] = switchState;
//           switchFound = true;
//           break;
//         }
//       }

//       // If the switch is not found, add it
//       if (!switchFound) {
//         jsonData["switches"]
//             .add({"switch_index": switchIndex, "switch_state": switchState});
//       }
//     }

//     // If no data has changed, return without sending
//     if (jsonData.isEmpty) {
//       print("❌ No data to send. Nothing has changed.");
//       return;
//     }

//     // Convert the data to a JSON string
//     String jsonString = jsonEncode(jsonData);
//     print("📤 Sending MQTT Message: $jsonString");

//     final builder = MqttClientPayloadBuilder();
//     builder.addString(jsonString);

//     // If the payload is empty, don't send the message
//     if (builder.payload?.isEmpty ?? true) {
//       print("❌ MQTT Payload is empty! Message not sent.");
//       return;
//     }

//     // Send the MQTT message
//     client?.publishMessage(topicSend, MqttQos.atMostOnce, builder.payload!);
//     print("✅ MQTT Message Sent Successfully!");
//   }

//   void seasonsendData(Map<String, dynamic> receivedData,
//       {int? switchIndex, int? switchState}) {
//     Map<String, dynamic> jsonData = {};

//     jsonData["seasonsw"] = receivedData["seasonsw"] ?? 0;

//     if (switchIndex != null && switchState != null) {
//       jsonData["switches"] ??= [];

//       bool switchFound = false;
//       for (var switchItem in jsonData["switches"]!) {
//         if (switchItem["switch_index"] == switchIndex) {
//           switchItem["switch_state"] = switchState;
//           switchFound = true;
//           break;
//         }
//       }

//       // If the switch is not found, add it
//       if (!switchFound) {
//         jsonData["switches"]
//             .add({"switch_index": switchIndex, "switch_state": switchState});
//       }
//     }

//     // If no data has changed, return without sending
//     if (jsonData.isEmpty) {
//       print("❌ No data to send. Nothing has changed.");
//       return;
//     }

//     String jsonString = jsonEncode(jsonData);
//     print("📤 Sending MQTT Message: $jsonString");

//     final builder = MqttClientPayloadBuilder();
//     builder.addString(jsonString);

//     // If the payload is empty, don't send the message
//     if (builder.payload?.isEmpty ?? true) {
//       return;
//     }
//     client?.publishMessage(topicSend, MqttQos.atMostOnce, builder.payload!);
//   }
// }

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

  final RxInt port = 8883.obs;
  final RxString clientId = "flutter_mqtt_client".obs;
  final String topicReceive = "/KRC/AM-AAA001";
  final String topicSend = "/test/AM-AAA001/1";

  var receivedData = {}.obs;
  var isConnected = false.obs;
  var lastDamperValue = 24.0.obs;
  MqttServerClient? client;

  @override
  void onInit() {
    log("MQTT Controller Initialized");
    super.onInit();

    _setupMqttClient();
    _connectMqtt();
  }

  void onConnected() {
    print("✅ Connected to MQTT Broker!");
    isConnected.value = true;
    client?.subscribe(topicReceive, MqttQos.atMostOnce);
    client?.updates?.listen(_onMessageReceived);
  }

  void _onDisconnected() {
    log("Disconnected from MQTT broker. Reconnecting...");
    isConnected.value = false;
    Future.delayed(Duration(seconds: 5), _connectMqtt);
  }

  void _setupMqttClient() {
    client =
        MqttServerClient.withPort(mqttBroker.value, clientId.value, port.value);
    client?.secure = true;
    client?.keepAlivePeriod = 60;
    client?.setProtocolV311();
    client?.logging(on: false);

    client?.onDisconnected = _onDisconnected;
    client?.onConnected = onConnected;
    // client?.onSubscribed = onSubscribed;
  }

  Future<void> _connectMqtt() async {
    if (client == null) {
      log("MQTT Client is not initialized!");
      return;
    }

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

      client!.securityContext = context;
      client!.connectionMessage = MqttConnectMessage()
          .withClientIdentifier(clientId.value)
          .startClean();

      log("Connecting to MQTT broker...");
      await client!.connect();

      if (client!.connectionStatus!.state == MqttConnectionState.connected) {
        log('Connected to MQTT broker.');
        isConnected.value = true;
      } else {
        log('Connection failed: ${client!.connectionStatus!.state}');
        client!.disconnect();
      }
    } catch (e) {
      log('MQTT client exception: $e');
      client?.disconnect();
    }
  }

  void _onMessageReceived(List<MqttReceivedMessage<MqttMessage?>>? messages) {
    if (messages == null || messages.isEmpty) return;

    final MqttPublishMessage recMessage =
        messages[0].payload as MqttPublishMessage;
    final String message =
        MqttPublishPayload.bytesToStringAsString(recMessage.payload.message);

    if (message.trim().isEmpty) {
      print("⚠️ Received an empty MQTT message.");
      return;
    }

    try {
      // Parse JSON safely
      Map<String, dynamic> data = jsonDecode(message);
      receivedData.value = data; // ✅ Update global state

      // Log received data
      print("✅ Received MQTT Data: $data");

      // Get the switch controller instance
      final switchController = Get.find<SwitchCardController>();

      bool updated = false;

      // Update individual switch states
      if (data.containsKey('seasonsw')) {
        bool seasonSwitch = data['seasonsw'] == 1;
        if (switchController.switchCards[0].status != seasonSwitch) {
          switchController.switchCards[0].status = seasonSwitch;
          updated = true;
        }
      }

      if (data.containsKey('coolersw')) {
        bool coolerSwitch = data['coolersw'] == 1;
        if (switchController.switchCards[0].status != coolerSwitch) {
          switchController.switchCards[0].status = coolerSwitch;
          updated = true;
        }
      }

      // Handle array-based switch updates
      if (data.containsKey("switches") && data["switches"] is List) {
        for (var switchData in data["switches"]) {
          if (switchData is Map<String, dynamic>) {
            int index = switchData["switch_index"] ?? -1;
            bool state = (switchData["switch_state"] ?? 0) == 1;

            if (index >= 0 && index < switchController.switchCards.length) {
              switchController.switchCards[index].status = state;
              updated = true;
            }
          }
        }
      }

      // Refresh UI only if there were updates
      if (updated) {
        switchController.switchCards.refresh();
        print("🚀 UI Updated with new switch states!");
      }
    } catch (e) {
      print("❌ Error processing MQTT message: $e");
      print("📩 Raw message: $message");
    }
  }

  // Assuming these are global or previously declared variables to store the last known values
  Map<String, dynamic> lastKnownValues = {
    "seasonsw": 1,
    "coolersp": 25,
    "boilersp": 26,
    "comfortersp": 27,
    "coolersw": 0,
    "boilersw": 0,
    "comfortersw": 0,
    "boostersw": 0,
    "makeupsw": 0,
    "crculatonsw": 0,
  };

  void sendData(Map<String, dynamic> receivedData,
      {int? switchIndex, int? switchState}) {
    // Create a map to hold the current data, starting with the last known values
    Map<String, dynamic> jsonData = {
      "seasonsw": receivedData["seasonsw"] ?? lastKnownValues["seasonsw"],
      "coolersp": receivedData["coolersp"] ?? lastKnownValues["coolersp"],
      "boilersp": receivedData["boilersp"] ?? lastKnownValues["boilersp"],
      "comfortersp":
          receivedData["comfortersp"] ?? lastKnownValues["comfortersp"],
      "coolersw": receivedData["coolersw"] ?? lastKnownValues["coolersw"],
      "boilersw": receivedData["boilersw"] ?? lastKnownValues["boilersw"],
      "comfortersw":
          receivedData["comfortersw"] ?? lastKnownValues["comfortersw"],
      "boostersw": receivedData["boostersw"] ?? lastKnownValues["boostersw"],
      "makeupsw": receivedData["makeupsw"] ?? lastKnownValues["makeupsw"],
      "crculatonsw":
          receivedData["crculatonsw"] ?? lastKnownValues["crculatonsw"]
    };

    lastKnownValues["seasonsw"] = jsonData["seasonsw"];
    lastKnownValues["coolersp"] = jsonData["coolersp"];
    lastKnownValues["boilersp"] = jsonData["boilersp"];
    lastKnownValues["comfortersp"] = jsonData["comfortersp"];
    lastKnownValues["coolersw"] = jsonData["coolersw"];
    lastKnownValues["boilersw"] = jsonData["boilersw"];
    lastKnownValues["comfortersw"] = jsonData["comfortersw"];
    lastKnownValues["boostersw"] = jsonData["boostersw"];
    lastKnownValues["makeupsw"] = jsonData["makeupsw"];
    lastKnownValues["crculatonsw"] = jsonData["crculatonsw"];

    if (switchIndex != null && switchState != null) {
      jsonData["switches"] ??= [];

      bool switchFound = false;
      for (var switchItem in jsonData["switches"]) {
        if (switchItem["switch_index"] == switchIndex) {
          switchItem["switch_state"] = switchState;
          switchFound = true;
          break;
        }
      }

      if (!switchFound) {
        jsonData["switches"]
            .add({"switch_index": switchIndex, "switch_state": switchState});
      }
    }

    // Convert the data to a JSON string
    String jsonString = jsonEncode(jsonData);
    print("📤 Sending MQTT Message: $jsonString");

    final builder = MqttClientPayloadBuilder();
    builder.addString(jsonString);

    if (builder.payload == null || builder.payload!.isEmpty) {
      print("❌ MQTT Payload is empty! Message not sent.");
      return;
    }

    // Send the MQTT message
    client?.publishMessage(topicSend, MqttQos.atMostOnce, builder.payload!);
    print("✅ MQTT Message Sent Successfully!");
  }

  void selectSeason(bool bool) {}
}
