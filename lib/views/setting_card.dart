import 'dart:async';
import 'package:aqua_master/controller/mqtt_controller.dart';
import 'package:aqua_master/controller/switch_controller.dart';
import 'package:aqua_master/dialog/setting_dialog.dart';
import 'package:aqua_master/views/boiler_setting.dart';
import 'package:aqua_master/views/comfort_setting.dart';
import 'package:aqua_master/views/cooler_setting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late Stream<String> _timeStream;
  final MqttController mqttController = Get.put(MqttController());

  @override
  void initState() {
    super.initState();
    _timeStream = Stream.periodic(Duration(seconds: 1), (_) {
      return DateFormat('EEEE').format(DateTime.now()) +
          '\n' +
          DateFormat('hh:mm:ss a').format(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Settings", style: TextStyle(color: Colors.white)),
            StreamBuilder<String>(
              stream: _timeStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox.shrink();

                List<String> parts = snapshot.data!.split('\n');
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      parts[0],
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      parts[1],
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: GetBuilder<SwitchCardController>(
          init: SwitchCardController(),
          builder: (controller) {
            return Container(
              child: Padding(
                padding: EdgeInsets.only(
                    right: Get.width * 0.09,
                    top: Get.height * 0.07,
                    left: Get.width * 0.09),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  showTemperatureDialog(context, 'temp1'),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFF202020),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: Get.width * 0.099,
                                      left: Get.width * 0.099),
                                  child: CoolerViewSetting(index: 0),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  showTemperatureDialog(context, 'temp2'),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFF202020),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: Get.width * 0.099,
                                      left: Get.width * 0.099),
                                  child: BoilerViewSetting(index: 1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Get.height * 0.04,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => showTemperatureDialog(context, 'temp3'),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF202020),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right: Get.width * 0.092,
                                  left: Get.width * 0.092),
                              child: ComfortViewSetting(index: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
