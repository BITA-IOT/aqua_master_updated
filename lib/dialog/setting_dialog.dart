import 'package:aqua_master/controller/mqtt_controller.dart';
import 'package:aqua_master/controller/switch_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class TemperatureDialog extends StatefulWidget {
  final String tempKey;
  final int switchIndex;
  TemperatureDialog({required this.tempKey, required this.switchIndex});

  @override
  _TemperatureDialogState createState() => _TemperatureDialogState();
}

class _TemperatureDialogState extends State<TemperatureDialog> {
  late int temperature;
  final MqttController mqttController = Get.find<MqttController>();

  late String setpointKey;
  late String appBarTitle;
  late String temp;
  final SwitchCardController controller = Get.put(SwitchCardController());

  @override
  void initState() {
    super.initState();

    setpointKey = {
          "temp1": "coolersp",
          "temp2": "boilersp",
          "temp3": "comfortersp",
        }[widget.tempKey] ??
        "coolersp";

    appBarTitle = setpointKey == "coolersp"
        ? "Cooler"
        : setpointKey == "boilersp"
            ? "Boiler"
            : "Comfort";

    temperature = int.tryParse(
            mqttController.receivedData[setpointKey]?.toString() ?? "25") ??
        25;
  }

  void updateTemperature(int newTemp) {
    setState(() => temperature = newTemp);

    mqttController.receivedData[setpointKey] = newTemp;
    mqttController.receivedData.refresh();
    mqttController.sendData({setpointKey: newTemp});
    print("📤 Sent new temperature: $newTemp for $setpointKey");
  }

  @override
  Widget build(BuildContext context) {
    String temp1 = mqttController.receivedData['temp1']?.toString() ?? '-- C';
    String temp2 = mqttController.receivedData['temp2']?.toString() ?? '-- C';

    temp = setpointKey == "coolersp"
        ? temp1
        : setpointKey == "boilersp"
            ? temp2
            : temp2;

    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(appBarTitle, style: const TextStyle(color: Colors.white)),
              StreamBuilder<String>(
                stream: Stream.periodic(const Duration(seconds: 1), (_) {
                  return DateFormat('EEEE').format(DateTime.now()) +
                      '\n' +
                      DateFormat('hh:mm:ss a').format(DateTime.now());
                }),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox.shrink();
                  final parts = snapshot.data!.split('\n');
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(parts[0],
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                      Text(parts[1],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14)),
                    ],
                  );
                },
              ),
            ],
          ),
          backgroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: Get.width * 0.02,
                  right: Get.width * 0.02,
                  top: Get.height * 0.01,
                ),
                child: Card(
                  color: Color(0xFF202020),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(Get.width * 0.02),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(Get.width * 0.025),
                              child: Text(
                                "$appBarTitle Temperature",
                                style: TextStyle(
                                    fontSize: Get.width * 0.04,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(
                          Get.width * 0.05,
                        ),
                        child: Row(
                          children: [
                            Text("$temp °C",
                                style: TextStyle(
                                    fontSize: Get.width * 0.04,
                                    color: Colors.white))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: Get.width * 0.02,
                  right: Get.width * 0.02,
                  top: Get.height * 0.001,
                ),
                child: Card(
                  color: Color(0xFF202020),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: Get.width * 0.02,
                        right: Get.width * 0.02,
                        top: Get.height * 0.01,
                        bottom: Get.height * 0.01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Obx(() => Padding(
                                  padding: EdgeInsets.all(Get.width * 0.009),
                                  child: Switch(
                                    value: controller
                                        .switchCards[widget.switchIndex].status,
                                    onChanged: (value) {
                                      controller
                                          .toggleSwitch(widget.switchIndex);
                                    },
                                    activeColor: Colors.blue,
                                    inactiveThumbColor: Colors.red,
                                  ),
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            Obx(() => Padding(
                                  padding:
                                      EdgeInsets.only(right: Get.width * 0.05),
                                  child: Text(
                                    controller.switchCards[widget.switchIndex]
                                            .actualState
                                        ? 'On'
                                        : 'Off',
                                    style: TextStyle(
                                      fontSize: 18 * Get.textScaleFactor,
                                      color: controller
                                              .switchCards[widget.switchIndex]
                                              .actualState
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.09),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(clipBehavior: Clip.none, children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: Get.width * 0.03,
                                      right: Get.width * 0.03),
                                  child: Center(
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SleekCircularSlider(
                                          appearance: CircularSliderAppearance(
                                            size: Get.height * 0.32,
                                            angleRange: 260,
                                            startAngle: 140,
                                            customWidths: CustomSliderWidths(
                                              trackWidth: Get.width * 0.008,
                                              progressBarWidth:
                                                  Get.width * 0.010,
                                              handlerSize: Get.width * 0.030,
                                            ),
                                            customColors: CustomSliderColors(
                                              trackColor: Colors.grey[400]!,
                                              progressBarColors: [
                                                Colors.red,
                                                Colors.green
                                              ],
                                              dotColor: Colors.green,
                                            ),
                                          ),
                                          min: 0,
                                          max: 35,
                                          initialValue: temperature.toDouble(),
                                          onChange: (double value) {
                                            setState(() {
                                              temperature = value.toInt();
                                            });
                                          },
                                          onChangeEnd: (double value) {
                                            updateTemperature(value.toInt());
                                          },
                                        ),
                                        Container(
                                          width: Get.width * 0.48,
                                          height: Get.height * 0.35,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 20,
                                                spreadRadius: 8,
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: Get.height * 0.1,
                                              ),
                                              Icon(
                                                Icons.circle,
                                                size: 10,
                                                color: mqttController
                                                        .isConnected.value
                                                    ? Colors.green
                                                    : Colors.red,
                                              ),
                                              SizedBox(
                                                height: Get.height * 0.025,
                                              ),
                                              SizedBox(
                                                height: Get.height * 0.1,
                                                child: Text("$temperature°C",
                                                    key: ValueKey<int>(
                                                        temperature),
                                                    style: TextStyle(
                                                        fontSize:
                                                            Get.width * 0.09,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: Get.height * 0.1,
                                  bottom: Get.height * 0.15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      elevation: 3,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: Get.width * 0.14,
                                          vertical: Get.height * 0.001),
                                    ),
                                    onPressed: () {
                                      if (temperature > 10) {
                                        updateTemperature(temperature - 1);
                                      }
                                    },
                                    child: Icon(
                                      Icons.remove,
                                      color: Colors.black,
                                      size: Get.width * 0.06,
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      elevation: 3,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: Get.width * 0.14,
                                          vertical: Get.height * 0.001),
                                    ),
                                    onPressed: () {
                                      if (temperature < 35) {
                                        updateTemperature(temperature + 1);
                                      }
                                    },
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.black,
                                      size: Get.width * 0.06,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // The switch is shown here dynamically based on `switchIndex`
                          ])),
                    )
                  ]),
                ],
              ),
            ],
          ),
        ));
  }
}

void showTemperatureDialog(BuildContext context, String tempKey) {
  // Determine the switch index based on the `tempKey`
  int switchIndex = tempKey == "temp1" ? 0 : (tempKey == "temp2" ? 1 : 2);

  showDialog(
    context: context,
    builder: (context) => TemperatureDialog(
      tempKey: tempKey,
      switchIndex: switchIndex, // Passing the correct index
    ),
    useSafeArea: false,
  );
}
