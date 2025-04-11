import 'package:aqua_master/controller/mqtt_controller.dart';
import 'package:aqua_master/controller/switch_controller.dart';
import 'package:aqua_master/dialog/mode_selection.dart';
import 'package:aqua_master/views/switch_card_second.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BoosterView extends StatelessWidget {
  final int index;
  BoosterView({Key? key, required this.index}) : super(key: key);

  final MqttController mqttController = Get.put(MqttController());
  final SwitchCardController controller = Get.find<SwitchCardController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      String temp3 =
          mqttController.receivedData['coolersw']?.toString() ?? '--';

      return SwitchCardSecond(
        index: index,
        heading: "Booster",
        title: temp3,
        controller: controller,
        click: () {
          ModeDialog();
          print("Cooler settings clicked");
        },
      );
    });
  }
}
