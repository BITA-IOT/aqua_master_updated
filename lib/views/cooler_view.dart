import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aqua_master/controller/mqtt_controller.dart';
import 'package:aqua_master/controller/switch_controller.dart';
import 'package:aqua_master/views/Switch_card.dart';

class CoolerView extends StatelessWidget {
  final int index;
  CoolerView({Key? key, required this.index}) : super(key: key);

  final MqttController mqttController = Get.put(MqttController());
  final SwitchCardController controller = Get.find<SwitchCardController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      String temp1 = mqttController.receivedData['temp1']?.toString() ?? '--';
      String coolersp =
          mqttController.receivedData['coolersp']?.toString() ?? '--';

      return SwitchCardSetting(
        index: index,
        heading: "Cooler",
        title: "$temp1°C",
        setpoint: "$coolersp SP",
        icon: Icons.settings,
        controller: controller,
        click: () {},
      );
    });
  }
}
