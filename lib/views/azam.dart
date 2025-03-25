// import 'package:aqua_master/controller/mqtt_controller.dart';
// import 'package:aqua_master/dialog/setting_dialog.dart';
// import 'package:aqua_master/views/boiler_view.dart';
// import 'package:aqua_master/views/cooler_view.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class AmpereScreen extends StatelessWidget {
//   const AmpereScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // final MqttController mqttController = Get.find<MqttController>();
//     // final MqttController mqttController = Get.put(MqttController());

//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: Colors.transparent,
//       body: Container(
//         decoration: BoxDecoration(color: Colors.black),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 60),
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.withValues(alpha: 0.3),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(
//                       Icons.electric_bolt_sharp,
//                       size: 30,
//                       color: Colors.red,
//                     ),
//                     SizedBox(width: 10),
//                     Text(
//                       'Amperes',
//                       style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 30),
//               _buildRow(CoolerView(index: 0), BoilerView(index: 1))
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildRow(Widget leftWidget, Widget rightWidget) {
//     return Row(
//       children: [
//         Expanded(child: leftWidget),
//         Expanded(child: rightWidget),
//       ],
//     );
//   }

// //   Widget _buildInfoCard({
// //     required BuildContext context,
// //     required IconData icon,
// //     required Color color,
// //     required String title,
// //     required String high,
// //     required String low,
// //     required String set,
// //     required VoidCallback onTap,
// //   }) {
// //     return GestureDetector(
// //       onTap: onTap,
// //       child: Container(
// //         height: Get.width * 0.4,
// //         decoration: BoxDecoration(
// //           color: Colors.grey.withValues(alpha: 0.3),
// //           borderRadius: BorderRadius.circular(12),
// //         ),
// //         width: Get.width * 0.4,
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             SizedBox(height: Get.height * 0.01),
// //             Text(
// //               title,
// //               style: const TextStyle(
// //                   fontSize: 14,
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.white),
// //               textAlign: TextAlign.center,
// //             ),
// //             SizedBox(height: Get.height * 0.02),
// //             // Icon(icon, size: 40, color: color),
// //             Stack(
// //               alignment: Alignment.center,
// //               children: [
// //                 SizedBox(
// //                   // height: Get.height * 0.059,
// //                   // width: Get.width * 0.12,
// //                   child: CircularProgressIndicator(
// //                     value: (double.parse(set) / 100),
// //                     strokeWidth: 4,
// //                     backgroundColor: Colors.white54,
// //                     valueColor:
// //                         AlwaysStoppedAnimation<Color>(Colors.greenAccent),
// //                   ),
// //                 ),
// //                 Text(
// //                   "${(double.parse(set)).toInt()}%", // Show percentage
// //                   style: TextStyle(
// //                     fontSize: 12,
// //                     fontWeight: FontWeight.bold,
// //                     color: Colors.white, // Change color as needed
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             SizedBox(height: Get.height * 0.027),

// //             Container(
// //               decoration: BoxDecoration(
// //                 borderRadius: BorderRadius.circular(12),
// //                 color: Colors.green.withValues(alpha: 0.8),
// //               ),
// //               width: Get.width * 1,
// //               height: Get.height * 0.055,
// //               child: Padding(
// //                 padding: const EdgeInsets.all(8.0),
// //                 child: Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     Row(
// //                       children: [
// //                         Text('Low: ',
// //                             style: const TextStyle(
// //                                 fontSize: 13, fontWeight: FontWeight.bold)),
// //                         Text(low,
// //                             style: const TextStyle(
// //                               fontSize: 13,
// //                             )),
// //                       ],
// //                     ),
// //                     Row(
// //                       children: [
// //                         Text('High: ',
// //                             style: const TextStyle(
// //                                 fontSize: 13, fontWeight: FontWeight.bold)),
// //                         Text(high,
// //                             style: const TextStyle(
// //                               fontSize: 13,
// //                             )),
// //                       ],
// //                     )
// //                     // Text('Temp.: $set',
// //                     //     style: const TextStyle(
// //                     //         fontSize: 12, fontWeight: FontWeight.bold)),
// //                   ],
// //                 ),
// //               ),
// //             )
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// }
import 'dart:async';
import 'package:aqua_master/controller/mqtt_controller.dart';
import 'package:aqua_master/controller/switch_controller.dart';
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
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Settings", style: TextStyle(color: Colors.white)),
            StreamBuilder<String>(
              stream: _timeStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return SizedBox.shrink();

                List<String> parts = snapshot.data!.split('\n');
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      parts[0],
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      parts[1],
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      right: Get.width * 0.09, left: Get.width * 0.05),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blueAccent,
                              width: 5,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 8.0),
                            child: CoolerView(index: 0),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.05,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blueAccent,
                              width: 5,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 8.0),
                            child: BoilerView(index: 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.05,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      right: Get.width * 0.5, left: Get.width * 0.05),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blueAccent,
                              width: 5,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 8.0),
                            child: ComfortView(index: 2),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.05,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
