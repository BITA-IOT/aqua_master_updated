import 'package:aqua_master/controller/switch_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SwitchCardSettingNew extends StatelessWidget {
  final int index;
  final String? heading;
  final String? title;
  final String? titlemain;
  final IconData? icon;
  final SwitchCardController controller;
  final VoidCallback? click;

  const SwitchCardSettingNew({
    Key? key,
    required this.index,
    this.heading,
    this.title,
    this.titlemain,
    this.icon,
    required this.controller,
    required this.click,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double progressValue = 0.0;
    if (title != null) {
      int titleValue = int.tryParse(title!) ?? 10;

      titleValue = titleValue.clamp(10, 35);

      progressValue = (titleValue - 10) / (35 - 10);
    }

    return Center(
      child: Stack(
        children: [
          // if (icon != null)
          //   Positioned(
          //     top: -10,
          //     right: -14,
          //     child: IconButton(
          //       onPressed: click,
          //       icon: Icon(icon),
          //     ),
          //   ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: Get.height * 0.018),
                if (heading != null) ...[
                  Text(
                    heading!,
                    style: TextStyle(
                      fontSize: 18 * Get.textScaleFactor,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: Get.height * 0.018),
                ],
                if (title != null) ...[
                  Stack(alignment: Alignment.center, children: [
                    SizedBox(
                      height: Get.width * 0.12,
                      width: Get.width * 0.12,
                      child: CircularProgressIndicator(
                        value: progressValue,
                        strokeWidth: 5,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                    ),
                    Text(
                      title!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ])
                ],
                SizedBox(height: Get.height * 0.016),
                Obx(() => Text(
                      controller.switchCards[index].actualState ? 'On' : 'Off',
                      style: TextStyle(
                        fontSize: 18 * Get.textScaleFactor,
                        color: controller.switchCards[index].actualState
                            ? Colors.green
                            : Colors.red,
                      ),
                    )),
                Obx(() => Padding(
                      padding: EdgeInsets.all(Get.width * 0.009),
                      child: Switch(
                        value: controller.switchCards[index].status,
                        onChanged: (value) => controller.toggleSwitch(index),
                        activeColor: Colors.blue,
                        inactiveThumbColor: Colors.red,
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
