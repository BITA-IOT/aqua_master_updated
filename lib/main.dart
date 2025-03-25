import 'package:aqua_master/views/azam.dart';
import 'package:aqua_master/views/controlscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: ControlMasterPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
