import 'package:aqua_master/controller/mqtt_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SeasonSwitchCard extends StatelessWidget {
  final MqttController mqttController = Get.find<MqttController>();

  RxString seasonMode = "0".obs;
  RxBool userToggled = false.obs;

  SeasonSwitchCard({Key? key}) : super(key: key) {
    mqttController.receivedData.listen((data) {
      if (data.containsKey('seasonsw')) {
        String newMode = data['seasonsw'].toString().trim();
        if (!userToggled.value) {
          if (newMode == "0" || newMode == "1") {
            seasonMode.value = newMode;
          } else {
            print("⚠️ Invalid seasonmode value received: $newMode");
          }
        }
      }
    });
  }

  void toggleSeason(bool value) {
    String newSeasonMode = value ? "1" : "0";
    seasonMode.value = newSeasonMode;
    userToggled.value = true;

    mqttController.sendData({'seasonsw': newSeasonMode});
    print("📤 Sent season mode: $newSeasonMode");

    Future.delayed(Duration(milliseconds: 100), () {
      userToggled.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = Get.width;

    double textSize = screenWidth < 350 ? 14 : 18;
    double padding = screenWidth < 350 ? 5 : 6;

    return Obx(() {
      return Card(
        color: const Color.fromARGB(255, 198, 198, 199),
        // elevation: 5,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
              color: Color.fromARGB(255, 198, 198, 199), width: 3),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                seasonMode.value == "0" ? "Summer Mode" : "Winter Mode",
                style:
                    TextStyle(fontSize: textSize, fontWeight: FontWeight.bold),
              ),
              Switch(
                value: seasonMode.value == "1",
                onChanged: (value) {
                  toggleSeason(value);
                },
                activeColor: Colors.blue,
                inactiveThumbColor: Colors.red,
                inactiveTrackColor: Colors.white,
              ),
            ],
          ),
        ),
      );
    });
  }
}
