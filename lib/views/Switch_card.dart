import 'package:aqua_master/controller/switch_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SwitchCard extends StatelessWidget {
  final int index;
  final String? heading;
  final String? title;
  final IconData? icon;
  final SwitchCardController controller;
  final VoidCallback click;

  const SwitchCard({
    Key? key,
    required this.index,
    this.heading,
    this.title,
    this.icon,
    required this.controller,
    required this.click,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          if (icon != null)
            Positioned(
              top: -10,
              right: -14,
              child: IconButton(
                onPressed: click,
                icon: Icon(icon),
              ),
            ),
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
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: Get.height * 0.009),
                ],
                if (title != null) ...[
                  Text(
                    title!,
                    style: TextStyle(
                      fontSize: 16 * Get.textScaleFactor,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
                SizedBox(height: Get.height * 0.009),
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
                      padding: EdgeInsets.all(Get.width *
                          0.009), // Dynamic padding based on screen width
                      child: Switch(
                        value: controller.switchCards[index].status,
                        onChanged: (value) => controller.toggleSwitch(index),
                        activeColor: Colors.blue,
                        inactiveThumbColor: Colors.red,
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
