import 'dart:ui';
import 'package:aqua_master/controller/mode_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModeDialog extends StatelessWidget {
  final ModeController modeController = Get.find<ModeController>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white.withOpacity(0.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/mode_icon.png', height: 80),
                    const SizedBox(height: 10),
                    Obx(() => Column(
                          children: [
                            _modeOption("On"),
                            _modeOption("Off"),
                            _modeOption("Auto"),
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(8),
                child: Icon(Icons.close, color: Colors.white, size: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _modeOption(String mode) {
    return Obx(() => ListTile(
          title:
              Text(mode, style: TextStyle(color: Colors.white, fontSize: 18)),
          leading: Radio<String>(
            value: mode,
            groupValue: modeController.selectedMode.value,
            onChanged: (String? value) {
              modeController.setMode(value!);
            },
          ),
        ));
  }
}

void showModeDialogbox() {
  Get.dialog(ModeDialog());
}
