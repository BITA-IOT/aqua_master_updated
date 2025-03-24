import 'package:aqua_master/controller/mqtt_controller.dart';
import 'package:aqua_master/controller/switch_controller.dart';
import 'package:aqua_master/dialog/setting_dialog.dart';
import 'package:aqua_master/views/Switch_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ComfortView extends StatelessWidget {
  final int index;
  ComfortView({Key? key, required this.index}) : super(key: key);

  final MqttController mqttController = Get.put(MqttController());
  final SwitchCardController controller = Get.find<SwitchCardController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      String temp3 = mqttController.receivedData['temp3']?.toString() ?? '--';

      return SwitchCard(
        index: index,
        heading: "Comfort",
        title: "$temp3°C",
        icon: Icons.settings,
        controller: controller,
        click: () {
          showTemperatureDialog(context, 'temp3');
          print("comfort settings clicked");
        },
      );
    });
  }
}
