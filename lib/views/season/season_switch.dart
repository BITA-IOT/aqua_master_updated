import 'package:aqua_master/controller/mqtt_controller.dart';
import 'package:aqua_master/controller/switch_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SeasonSwitchCard extends StatelessWidget {
  final MqttController mqttController = Get.find<MqttController>();
  final SwitchCardController controller = Get.put(SwitchCardController());

  RxString seasonMode = "".obs;
  RxBool userToggled = false.obs;

  SeasonSwitchCard({Key? key}) : super(key: key) {
    mqttController.receivedData.listen((data) {
      if (data.containsKey('seasonsw') && !userToggled.value) {
        String newMode = data['seasonsw'].toString().trim();
        if ((newMode == "0" || newMode == "1") && seasonMode.value != newMode) {
          seasonMode.value = newMode;
        }
      }
    });
  }

  void toggleSeason(bool value) {
    String newSeasonMode = value ? "1" : "0";

    if (seasonMode.value != newSeasonMode) {
      seasonMode.value = newSeasonMode;
      userToggled.value = true;

      mqttController.sendData({'seasonsw': newSeasonMode});
      print("📤 Sent season mode: $newSeasonMode");

      Future.delayed(Duration(milliseconds: 100), () {
        userToggled.value = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = Get.width;

    double textSize = screenWidth < 350 ? 14 : 18;
    double padding = screenWidth < 350 ? 5 : 6;

    return Obx(() {
      // Determine season mode based on the switch value
      String modeText =
          controller.switchCards[6].status ? "Winter Mode" : "Summer Mode";

      return Card(
        color: Color(0xFF202020),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 3),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: Get.height * 0.025,
                    bottom: Get.height * 0.025,
                    left: Get.width * 0.015),
                child: Text(
                  modeText, // Display "Summer Mode" or "Winter Mode"
                  style: TextStyle(
                      fontSize: textSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Obx(() => Padding(
                    padding: EdgeInsets.all(Get.width * 0.009),
                    child: Switch(
                      value: controller.switchCards[6].status,
                      onChanged: (value) => controller.toggleSwitch(6),
                      activeColor: Colors.blue,
                      inactiveThumbColor: Colors.red,
                    ),
                  ))
            ],
          ),
        ),
      );
    });
  }
}
