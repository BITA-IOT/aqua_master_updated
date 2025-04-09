import 'package:aqua_master/controller/mqtt_controller.dart';
import 'package:aqua_master/models/switch_model.dart';
import 'package:get/get.dart';

class SwitchCardController extends GetxController {
  RxList<SwitchCardModel> switchCards = <SwitchCardModel>[].obs;
  final MqttController mqttController = Get.find<MqttController>();

  final List<String> switchKeys = [
    'coolersw',
    'boilersw',
    'comfortersw',
    'boostersw',
    'makeupsw',
    'crculatonsw',
    'seasonsw'
  ];

  final List<String> stateKeys = [
    'coolerstate',
    'boilerstate',
    'comforterstate',
    'boosterstate',
    'makeupstate',
    'crculatonsw',
    'seasonsw'
  ];

  @override
  void onInit() {
    super.onInit();
    switchCards.addAll(
      List.generate(
        switchKeys.length,
        (index) => SwitchCardModel(
          status: _getInitialStatus(switchKeys[index]),
          actualState: _getInitialStatus(stateKeys[index]),
          title: _formatTitle(switchKeys[index]),
        ),
      ),
    );

    mqttController.receivedData.listen(_updateSwitchStatesFromMQTT);
  }

  bool _getInitialStatus(String key) {
    return mqttController.receivedData.containsKey(key) &&
        (mqttController.receivedData[key] == 1 ||
            mqttController.receivedData[key] == "1");
  }

  String _formatTitle(String key) {
    return key.replaceAll(RegExp(r'(sw|state)'), '').capitalizeFirst!;
  }

  void _updateSwitchStatesFromMQTT(Map<dynamic, dynamic> data) {
    print("✅ Received MQTT Data: $data");

    bool updated = false;

    for (int i = 0; i < switchKeys.length; i++) {
      if (data.containsKey(switchKeys[i])) {
        switchCards[i] = switchCards[i].copyWith(
          status: data[switchKeys[i]] == 1 || data[switchKeys[i]] == "1",
        );
        updated = true;
      }

      if (data.containsKey(stateKeys[i])) {
        switchCards[i] = switchCards[i].copyWith(
          actualState: data[stateKeys[i]] == 1 || data[stateKeys[i]] == "1",
        );
        updated = true;
      }
    }

    if (updated) {
      switchCards.refresh();
      print("🚀 UI Updated!");
    }
  }

  void toggleSwitch(int index) {
    if (index >= switchCards.length) return;

    switchCards[index] = switchCards[index].copyWith(
      status: !switchCards[index].status,
    );

    update();
    sendUpdatedState();
  }

  void sendUpdatedState() {
    if (!Get.isRegistered<MqttController>()) return;

    final mqttController = Get.find<MqttController>();

    Map<String, dynamic> data =
        Map<String, dynamic>.from(mqttController.receivedData);

    for (int i = 0; i < switchKeys.length; i++) {
      data[switchKeys[i]] = switchCards[i].status ? 1 : 0;
    }

    mqttController.sendData(data);
  }
}
