import 'dart:convert';

import 'package:absensi_cifo_v2/core/services/app.request.services.dart';
import 'package:absensi_cifo_v2/core/services/app.storage.services.dart';
import 'package:absensi_cifo_v2/features/essentials/attendances/checkin/check.in.confirm.ui.dart';
import 'package:absensi_cifo_v2/features/essentials/attendances/checkin/check.in.confirm.vm.dart';
import 'package:absensi_cifo_v2/features/essentials/init/init.ui.dart';
import 'package:absensi_cifo_v2/features/essentials/init/init.vm.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CheckInVM extends GetxController {
  // STATES
  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  RxBool isFilled = false.obs;
  RxString usernameWrapper = "".obs;

  late SingleValueDropDownController shiftController;

  final ImagePicker imagePicker = ImagePicker();

  Future<void> requestData() async {

    await AppRequestServices().requestProfile();

    final identityData = await AppStorageServices().getData("identity");

    if (identityData != null) {
      usernameWrapper.value = jsonDecode(identityData)['username'];
    }
    update();
  }

  void handleRequest() async {

    isLoading.value = true;

    var data = {
      "name": shiftController.dropDownValue?.name,
      "value": shiftController.dropDownValue?.value,
    };

    await AppStorageServices().saveData("selectedShift", jsonEncode(data));

    isLoading.value = false;

    update();

    Get.delete<CheckInConfirmVM>();

    Get.to(() => CheckInConfirmUi());
  }

  void handleLogout() async {
      await AppRequestServices().requestLogout();
      await AppStorageServices().removeAllData();
      Get.delete<InitVM>();
      Get.to(() => InitUi());
  }

  Future<bool> requestCameraPermission() async {
    PermissionStatus status = await Permission.camera.request();
    return status.isGranted;
  }

  @override
  void onInit() {
    shiftController = SingleValueDropDownController();
    requestData();
    super.onInit();
  }

}