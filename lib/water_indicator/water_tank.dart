import 'package:aqua_master/controller/mqtt_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WaterTank extends StatefulWidget {
  @override
  _WaterTankState createState() => _WaterTankState();
}

class _WaterTankState extends State<WaterTank> with TickerProviderStateMixin {
  late AnimationController _waterLevelController;
  late Animation<double> _waterLevelAnimation;
  final MqttController mqttController = Get.put(MqttController());

  RxInt userSetValue = 0.obs;

  double get baseWaterLevel {
    switch (userSetValue.value) {
      case 0:
        return 0.05;
      case 1:
        return 0.6;
      case 2:
        return 0.95;
      default:
        return 0.6;
    }
  }

  @override
  void initState() {
    super.initState();

    _waterLevelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      lowerBound: 0.0,
      upperBound: 0.2,
    )..repeat(reverse: true);

    _waterLevelAnimation =
        _waterLevelController.drive(Tween(begin: 0.0, end: 0.2))
          ..addListener(() {
            setState(() {});
          });
    mqttController.receivedData.listen((data) {
      if (data.containsKey('waterlevel')) {
        userSetValue.value =
            int.tryParse(data['waterlevel'].toString())?.clamp(0, 2) ?? 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      double animatedWaterLevel = baseWaterLevel + _waterLevelAnimation.value;

      return Stack(
        children: [
          Positioned(
            right: 20,
            child: Container(
              width: 50,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(0),
                border: Border.all(color: Colors.black26, width: 2),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: double.infinity,
                  height: 150 * animatedWaterLevel,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(0)),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  @override
  void dispose() {
    _waterLevelController.dispose();
    super.dispose();
  }
}
