import 'package:aqua_master/controller/water_controller.dart';
import 'package:aqua_master/water_indicator/water_tank.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WaterLevelContainer extends StatelessWidget {
  final WaterLevelController controller = Get.put(WaterLevelController());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width * 0.85,
      height: height * 0.26,
      padding: EdgeInsets.all(width * 0.05),
      child: Stack(
        children: [
          Positioned(
            top: height * 0.013,
            left: width * 0.05,
            child: Container(
              width: width * 0.25,
              height: width * 0.25,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/pump.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            right: width * 0.24,
            top: height * 0.02,
            child: Container(
              height: height * 0.16,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("HI-",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                  Text("MID-",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                  Text("LOW-",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
            ),
          ),
          WaterTank(),
          Positioned(
            bottom: 1,
            left: width * 0.01,
            top: width * 0.28,
            child: Text(
              "WATER LEVEL",
              style: TextStyle(
                fontSize: 18 * Get.textScaleFactor,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
