// import 'package:aqua_master/controller/mqtt_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'dart:ui';

// class TemperatureDialog extends StatefulWidget {
//   final String tempKey;

//   TemperatureDialog({required this.tempKey});

//   @override
//   _TemperatureDialogState createState() => _TemperatureDialogState();
// }

// class _TemperatureDialogState extends State<TemperatureDialog> {
//   late int temperature;
//   final MqttController mqttController = Get.find<MqttController>();

//   @override
//   void initState() {
//     super.initState();

//     String setpointKey;
//     if (widget.tempKey == "temp1") {
//       setpointKey = "coolersp";
//     } else if (widget.tempKey == "temp2") {
//       setpointKey = "boilersp";
//     } else if (widget.tempKey == "temp3") {
//       setpointKey = "comfortersp";
//     } else {
//       print("⚠️ Warning: Unknown temperature key ${widget.tempKey}");
//       setpointKey = "coolersp";
//     }

//     temperature = int.tryParse(
//             mqttController.receivedData[setpointKey]?.toString() ?? "25") ??
//         25;
//   }

//   void updateTemperature(int newTemp) {
//     setState(() {
//       temperature = newTemp;
//     });

//     String setpointKey;
//     if (widget.tempKey == "temp1") {
//       setpointKey = "coolersp";
//     } else if (widget.tempKey == "temp2") {
//       setpointKey = "boilersp";
//     } else if (widget.tempKey == "temp3") {
//       setpointKey = "comfortersp";
//     } else {
//       print("⚠️ Warning: Unknown temperature key ${widget.tempKey}");
//       return;
//     }

//     if (mqttController.receivedData.containsKey(setpointKey)) {
//       mqttController.receivedData[setpointKey] = newTemp;
//       mqttController.receivedData.refresh();
//     } else {
//       print("⚠️ Warning: Key $setpointKey not found in receivedData");
//     }
//     mqttController.sendData({setpointKey: newTemp});
//     print("📤 Sent new temperature: $newTemp for $setpointKey");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.transparent,
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           Container(
//             padding: EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               color: Colors.white.withOpacity(0.2),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 10,
//                   spreadRadius: 3,
//                 ),
//               ],
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(20),
//               child: BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Image.asset('assets/pump.png', height: 80),
//                     SizedBox(height: 10),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         IconButton(
//                           icon: Icon(Icons.remove, color: Colors.white),
//                           onPressed: () {
//                             if (temperature > 10) {
//                               updateTemperature(temperature - 1);
//                             }
//                           },
//                         ),
//                         AnimatedSwitcher(
//                           duration: Duration(milliseconds: 300),
//                           transitionBuilder: (child, animation) {
//                             return ScaleTransition(
//                                 scale: animation, child: child);
//                           },
//                           child: Text(
//                             "$temperature°C",
//                             key: ValueKey<int>(temperature),
//                             style: TextStyle(
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white),
//                           ),
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.add, color: Colors.white),
//                           onPressed: () {
//                             if (temperature < 35) {
//                               updateTemperature(temperature + 1);
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: 10,
//             right: 10,
//             child: GestureDetector(
//               onTap: () => Navigator.pop(context),
//               child: Container(
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                 ),
//                 padding: EdgeInsets.all(8),
//                 child: Icon(Icons.close, color: Colors.white, size: 24),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// void showTemperatureDialog(BuildContext context, String tempKey) {
//   showDialog(
//     context: context,
//     builder: (context) => TemperatureDialog(tempKey: tempKey),
//   );
// }

import 'package:aqua_master/controller/mqtt_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class TemperatureDialog extends StatefulWidget {
  final String tempKey;
  TemperatureDialog({required this.tempKey});

  @override
  _TemperatureDialogState createState() => _TemperatureDialogState();
}

class _TemperatureDialogState extends State<TemperatureDialog> {
  late int temperature;
  final MqttController mqttController = Get.find<MqttController>();

  late String setpointKey;
  late String appBarTitle;

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
        ? "Cooler SP"
        : setpointKey == "boilersp"
            ? "Boiler SP"
            : "Comfort SP";

    temperature = int.tryParse(
            mqttController.receivedData[setpointKey]?.toString() ?? "25") ??
        25;

    _timeStream = Stream.periodic(const Duration(seconds: 1), (_) {
      return DateFormat('EEEE').format(DateTime.now()) +
          '\n' +
          DateFormat('hh:mm:ss a').format(DateTime.now());
    });
  }

  void updateTemperature(int newTemp) {
    setState(() => temperature = newTemp);

    mqttController.receivedData[setpointKey] = newTemp;
    mqttController.receivedData.refresh();
    mqttController.sendData({setpointKey: newTemp});
    print("📤 Sent new temperature: $newTemp for $setpointKey");
  }

  late Stream<String> _timeStream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(appBarTitle, style: const TextStyle(color: Colors.white)),
              StreamBuilder<String>(
                stream: _timeStream,
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
          backgroundColor: Colors.blueAccent,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                                            progressBarWidth: Get.width * 0.010,
                                            handlerSize: Get.width * 0.030,
                                          ),
                                          customColors: CustomSliderColors(
                                            trackColor: Colors.grey[400]!,
                                            progressBarColors: [
                                              Colors.blueAccent,
                                              Colors.blue
                                            ],
                                            dotColor: Colors.blue,
                                          ),
                                        ),
                                        min: 10,
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
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
                                    color: Colors.white,
                                    size: Get.width * 0.06,
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
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
                                    color: Colors.white,
                                    size: Get.width * 0.06,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ])),
                  )
                ]),
              ],
            ),
          ],
        ));
  }
}

void showTemperatureDialog(BuildContext context, String tempKey) {
  showDialog(
      context: context,
      builder: (context) => TemperatureDialog(tempKey: tempKey),
      useSafeArea: false);
}
