import 'package:aqua_master/controller/switch_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SwitchCardSetting extends StatelessWidget {
  final int index;
  final String? heading;
  final String? title;
  final String? titlemain;
  final IconData? icon;
  final SwitchCardController controller;
  final VoidCallback? click;

  const SwitchCardSetting({
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
    return Center(
      child: Stack(
        children: [
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
                      fontSize: 17 * Get.textScaleFactor,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: Get.height * 0.018),
                ],
                if (title != null) ...[
                  Stack(alignment: Alignment.center, children: [
                    Text(
                      title!,
                      style: TextStyle(
                        fontSize: 17,
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
                SizedBox(
                  height: Get.height * 0.04,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
