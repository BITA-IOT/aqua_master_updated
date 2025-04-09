import 'package:aqua_master/controller/mqtt_controller.dart';
import 'package:aqua_master/controller/switch_controller.dart';
import 'package:aqua_master/dialog/setting_dialog.dart';
import 'package:aqua_master/views/switch_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class BoilerView extends StatelessWidget {
  final int index;
  BoilerView({Key? key, required this.index}) : super(key: key);

  final MqttController mqttController = Get.put(MqttController());
  final SwitchCardController controller = Get.find<SwitchCardController>();

  @override
  Widget build(BuildContext context) {
    print("🔥 Updated MQTT Data: ${mqttController.receivedData}");

    return Obx(() {
      String temp1 = mqttController.receivedData['temp1']?.toString() ?? '--';
      String coolersp =
          mqttController.receivedData['boilersp']?.toString() ?? '--';

      return SwitchCardSetting(
        index: index,
        heading: "Boiler",
        title: "$temp1°C",
        setpoint: "$coolersp SP",
        icon: Icons.settings,
        controller: controller,
        click: () {
          showTemperatureDialog(context, 'temp1');

          print("Boiler settings clicked");
        },
      );
    });
  }
}
