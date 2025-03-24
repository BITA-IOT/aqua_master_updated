import 'package:get/get.dart';

class ModeController extends GetxController {
  var selectedMode = "Auto".obs;

  void setMode(String mode) {
    selectedMode.value = mode;

    Get.back();
  }
}
