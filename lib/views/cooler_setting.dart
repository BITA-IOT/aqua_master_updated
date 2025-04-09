import 'package:aqua_master/controller/mqtt_controller.dart';
import 'package:aqua_master/controller/switch_controller.dart';
import 'package:aqua_master/views/switch_card_setting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CoolerViewSetting extends StatelessWidget {
  final int index;
  CoolerViewSetting({Key? key, required this.index}) : super(key: key);

  final MqttController mqttController = Get.put(MqttController());
  final SwitchCardController controller = Get.find<SwitchCardController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      String temp1 = mqttController.receivedData['temp1']?.toString() ?? '0';

      return SwitchCardSettingNew(
        value: int.parse(temp1),
        index: index,
        heading: "  Cooler",
        title: "$temp1°C",
        icon: Icons.settings,
        controller: controller,
        click: () {
          // showTemperatureDialog(context, 'temp1');
        },
      );
    });
  }
}
