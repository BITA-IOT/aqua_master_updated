import 'package:aqua_master/controller/mqtt_controller.dart';
import 'package:aqua_master/controller/switch_controller.dart';
import 'package:aqua_master/dialog/setting_dialog.dart';
import 'package:aqua_master/views/switch_card_setting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ComfortViewSetting extends StatelessWidget {
  final int index;
  ComfortViewSetting({Key? key, required this.index}) : super(key: key);

  final MqttController mqttController = Get.put(MqttController());
  final SwitchCardController controller = Get.find<SwitchCardController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      String temp2 = mqttController.receivedData['temp2']?.toString() ?? '0';

      return SwitchCardSettingNew(
        value: int.parse(temp2),
        index: index,
        heading: "Comfort",
        title: "$temp2°C",
        icon: Icons.settings,
        controller: controller,
        click: () {
          showTemperatureDialog(context, 'temp2');
          print("comfort settings clicked");
        },
      );
    });
  }
}
