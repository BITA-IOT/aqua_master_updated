import 'package:aqua_master/controller/mqtt_controller.dart';
import 'package:aqua_master/controller/switch_controller.dart';
import 'package:aqua_master/views/switch_card_second.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecirculationView extends StatelessWidget {
  final int index;
  RecirculationView({Key? key, required this.index}) : super(key: key);

  final MqttController mqttController = Get.put(MqttController());
  final SwitchCardController controller = Get.find<SwitchCardController>();

  @override
  Widget build(BuildContext context) {
    return SwitchCardSecond(
      index: index,
      heading: "Recirculor",
      title: "",
      controller: controller,
      click: () {
        print("RecirculationView settings clicked");
      },
    );
  }
}
