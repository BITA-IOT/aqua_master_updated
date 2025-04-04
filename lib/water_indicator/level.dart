import 'package:aqua_master/controller/water_controller.dart';
import 'package:aqua_master/water_indicator/water_tank.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WaterLevelContainer extends StatelessWidget {
  final WaterLevelController controller = Get.put(WaterLevelController());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.85,
      height: Get.height * 0.26,
      padding: EdgeInsets.all(Get.width * 0.05),
      child: Stack(
        children: [
          Positioned(
            top: Get.height * 0.013,
            left: Get.width * 0.05,
            child: Container(
              width: Get.width * 0.27,
              height: Get.width * 0.27,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/pump.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            right: Get.width * 0.24,
            top: Get.height * 0.02,
            child: Container(
              height: Get.height * 0.16,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("HI-", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("MID-", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("LOW-", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          WaterTank(),
          Positioned(
            bottom: 1,
            left: Get.width * 0.03,
            top: Get.width * 0.31,
            child: Text(
              "WATER LEVEL",
              style: TextStyle(
                fontSize: 18 * Get.textScaleFactor,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
