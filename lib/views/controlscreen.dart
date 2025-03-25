// import 'dart:async';
// import 'package:aqua_master/controller/mqtt_controller.dart';
// import 'package:aqua_master/controller/switch_controller.dart';
// import 'package:aqua_master/views/boiler_view.dart';
// import 'package:aqua_master/views/booster_view.dart';
// import 'package:aqua_master/views/comfort_view.dart';
// import 'package:aqua_master/views/cooler_view.dart';
// import 'package:aqua_master/views/makeup_view.dart';
// import 'package:aqua_master/views/recirculation_view.dart';
// import 'package:aqua_master/views/season/season_switch.dart';
// import 'package:aqua_master/water_indicator/level.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';

// class ControlMasterPage extends StatefulWidget {
//   @override
//   _ControlMasterPageState createState() => _ControlMasterPageState();
// }

// class _ControlMasterPageState extends State<ControlMasterPage> {
//   late Stream<String> _timeStream;
//   final MqttController mqttController = Get.put(MqttController());

//   @override
//   void initState() {
//     super.initState();
//     _timeStream = Stream.periodic(const Duration(seconds: 1), (_) {
//       return DateFormat('EEEE').format(DateTime.now()) +
//           '\n' +
//           DateFormat('hh:mm:ss a').format(DateTime.now());
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text("AQUA MASTER", style: TextStyle(color: Colors.white)),
//             StreamBuilder<String>(
//               stream: _timeStream,
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) return const SizedBox.shrink();

//                 List<String> parts = snapshot.data!.split('\n');
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(
//                       parts[0],
//                       style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     Text(
//                       parts[1],
//                       style: const TextStyle(color: Colors.white, fontSize: 14),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ],
//         ),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: SingleChildScrollView(
//         child: GetBuilder<SwitchCardController>(
//           init: SwitchCardController(),
//           builder: (controller) {
//             return Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Obx(() {
//                       return Icon(
//                         Icons.circle,
//                         color: mqttController.isConnected.value
//                             ? Colors.green
//                             : Colors.red,
//                         size: 14,
//                       );
//                     }),
//                     IconButton(
//                       icon: const Icon(
//                         Icons.refresh,
//                         color: Colors.blue,
//                       ),
//                       tooltip: "Refresh Page",
//                       onPressed: () {
//                         mqttController.onInit(); // 🔄 Reconnect MQTT
//                       },
//                     ),
//                   ],
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(
//                       right: 8, left: 8, top: 28, bottom: 28),
//                   child: SeasonSwitchCard(),
//                 ),
//                 WaterLevelContainer(),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 8.0, horizontal: 8.0),
//                         child: CoolerView(index: 0),
//                       ),
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 8.0, horizontal: 8.0),
//                         child: BoilerView(index: 1),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 8.0, horizontal: 8.0),
//                         child: ComfortView(index: 2),
//                       ),
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 8.0, horizontal: 8.0),
//                         child: BoosterView(index: 3),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 8.0, horizontal: 8.0),
//                         child: MakeUpView(index: 4),
//                       ),
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 8.0, horizontal: 8.0),
//                         child: RecirculationView(index: 5),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:aqua_master/controller/mqtt_controller.dart';
import 'package:aqua_master/controller/switch_controller.dart';
import 'package:aqua_master/views/azam.dart' show SettingScreen;
import 'package:aqua_master/views/boiler_view.dart';
import 'package:aqua_master/views/booster_view.dart';
import 'package:aqua_master/views/comfort_view.dart';
import 'package:aqua_master/views/cooler_view.dart';
import 'package:aqua_master/views/makeup_view.dart';
import 'package:aqua_master/views/recirculation_view.dart';
import 'package:aqua_master/views/season/season_switch.dart';
import 'package:aqua_master/water_indicator/level.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ControlMasterPage extends StatefulWidget {
  @override
  _ControlMasterPageState createState() => _ControlMasterPageState();
}

class _ControlMasterPageState extends State<ControlMasterPage> {
  late Stream<String> _timeStream;
  final MqttController mqttController = Get.put(MqttController());

  @override
  void initState() {
    super.initState();
    _timeStream = Stream.periodic(const Duration(seconds: 1), (_) {
      return DateFormat('EEEE').format(DateTime.now()) +
          '\n' +
          DateFormat('hh:mm:ss a').format(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("AQUA MASTER", style: TextStyle(color: Colors.white)),
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
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14)),
                  ],
                );
              },
            ),
          ],
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: GetBuilder<SwitchCardController>(
          init: SwitchCardController(),
          builder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     Obx(() {
                //       return Icon(
                //         Icons.circle,
                //         color: mqttController.isConnected.value
                //             ? Colors.green
                //             : Colors.red,
                //         size: 14,
                //       );
                //     }),
                //     IconButton(
                //       icon: const Icon(Icons.refresh, color: Colors.blue),
                //       tooltip: "Refresh Page",
                //       onPressed: mqttController.onInit, // 🔄 Reconnect MQTT
                //     ),
                //   ],
                // ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: SeasonSwitchCard(),
                ),
                WaterLevelContainer(),
                const SizedBox(height: 2),
                Padding(
                  padding: EdgeInsets.only(
                    left: 16.0 * Get.width / 375,
                    right: 16.0 * Get.width / 375,
                  ),
                  child: Container(
                    color: const Color.fromARGB(255, 198, 198, 199),
                    child: Stack(
                      children: [
                        Positioned(
                            left: Get.width * 0.8,
                            child: IconButton(
                              onPressed: () {
                                Get.to(() => SettingScreen());
                              },
                              icon: Icon(Icons.settings),
                            )),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: _buildRow(
                            CoolerView(index: 0),
                            BoilerView(index: 1),
                            ComfortView(index: 2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.025,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 16.0 * Get.width / 375,
                    right: 16.0 * Get.width / 375,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 198, 198, 199),
                        width: 4,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(1),
                      child: Container(
                        color: const Color.fromARGB(255, 198, 198, 199),
                        child: _buildRow(
                          BoosterView(index: 3),
                          MakeUpView(index: 4),
                          RecirculationView(
                            index: 5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // _buildRow(ComfortView(index: 2), BoosterView(index: 3)),
                // _buildRow(MakeUpView(index: 4), RecirculationView(index: 5)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildRow(Widget leftWidget, Widget centerWidget, Widget rightWidget) {
    return Row(
      children: [
        Expanded(child: leftWidget),
        Expanded(child: centerWidget),
        Expanded(child: rightWidget),
      ],
    );
  }
}
