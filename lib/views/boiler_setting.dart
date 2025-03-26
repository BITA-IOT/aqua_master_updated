import 'package:aqua_master/controller/mqtt_controller.dart';
import 'package:aqua_master/controller/switch_controller.dart';
import 'package:aqua_master/dialog/setting_dialog.dart';
import 'package:aqua_master/views/switch_card.dart';
import 'package:aqua_master/views/switch_card_setting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class BoilerViewSetting extends StatelessWidget {
  final int index;
  BoilerViewSetting({Key? key, required this.index}) : super(key: key);

  final MqttController mqttController = Get.put(MqttController());
  final SwitchCardController controller = Get.find<SwitchCardController>();

  @override
  Widget build(BuildContext context) {
    print("🔥 Updated MQTT Data: ${mqttController.receivedData}");

    return Obx(() {
      String temp2 = mqttController.receivedData['temp2']?.toString() ?? '--';

      return SwitchCardSettingNew(
        index: index,
        heading: "Boiler",
        title: "$temp2°C",
        icon: Icons.settings,
        controller: controller,
        click: () {
          showTemperatureDialog(context, 'temp2');

          print("Boiler settings clicked");
        },
      );
    });
  }
}
