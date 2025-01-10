import 'dart:async';
import 'dart:convert';

import 'package:absensi_cifo_v2/core/services/app.request.services.dart';
import 'package:absensi_cifo_v2/core/services/app.storage.services.dart';
import 'package:absensi_cifo_v2/features/essentials/attendances/checkin/check.in.ui.dart';
import 'package:absensi_cifo_v2/features/essentials/init/init.ui.dart';
import 'package:absensi_cifo_v2/features/essentials/init/init.vm.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CheckCompleteVM extends GetxController {

  RxString usernameWrapper = "".obs;
  RxString currentTime = ''.obs;

  Timer? timer;

  void handleLogout() async {
    try {
      await AppRequestServices().requestLogout();

      await AppStorageServices().removeAllData();

      Get.delete<InitVM>();
      Get.to(() => InitUi());

    } catch (e) {
      Get.to(() => CheckInUi());
    }
  }

  // DATA REQUEST
  Future<void> requestData() async {
    final identityData = await AppStorageServices().getData('identity');

    if (identityData != null){
      usernameWrapper.value = jsonDecode(identityData)['username'];
    }

    update();
  }

  // TIME REQUEST
  void handleUpdateClock() async {
    final now = DateTime.now();
    final formatter = DateFormat("dd/MM/yyyy | HH:mm:ss");
    currentTime.value = "${formatter.format(now)} WIB";
    update();
  }

  @override
  void onInit() {

    // TIME INIT
    handleUpdateClock();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      handleUpdateClock();
    });

    requestData();
    super.onInit();
  }

  @override
  void dispose() {
    if (timer != null) {
      timer?.cancel();
    }
    super.dispose();
  }
}