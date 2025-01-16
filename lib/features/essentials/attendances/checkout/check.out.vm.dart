import 'dart:async';
import 'dart:convert';
import 'package:absensi_cifo_v2/core/services/app.request.services.dart';
import 'package:absensi_cifo_v2/core/services/app.storage.services.dart';
import 'package:absensi_cifo_v2/features/essentials/attendances/checkin/check.in.ui.dart';
import 'package:absensi_cifo_v2/features/essentials/attendances/checkoutlate/check.out.late.ui.dart';
import 'package:absensi_cifo_v2/features/essentials/init/init.ui.dart';
import 'package:absensi_cifo_v2/features/essentials/init/init.vm.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CheckOutVM extends GetxController {
  // STATES
  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  RxString usernameWrapper = "".obs;
  RxDouble latitudeWrapper = 1.0.obs;
  RxDouble longitudeWrapper = 1.0.obs;
  RxInt absentIdWrapper = 0.obs;
  RxString currentTime = ''.obs;

  Timer? timer;

  void handleRequest() async {

    isLoading.value = true;

    var requestData = {
      "absentId" : absentIdWrapper.value,
      "latitude": latitudeWrapper.value,
      "longitude": longitudeWrapper.value,
    };

    try {
      final bool response = await AppRequestServices().requestCheckOut(requestData);
      if (response){
        Get.delete<InitVM>();
        Get.to(() => InitUi());
      } else {
        Get.to(() => CheckOutLateUi());
      }
    } catch (e) {
      Get.to(() => CheckInUi());
    }
  }

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

    await AppRequestServices().requestProfile();

    final identityData = await AppStorageServices().getData('identity');
    final absentData = await AppStorageServices().getData("absentCheck");
    final locationData = await AppStorageServices().getData("location");

    if (identityData != null){
      usernameWrapper.value = jsonDecode(identityData)['username'];
    }

    if (absentData != null){
      absentIdWrapper.value = jsonDecode(absentData)['absent_id'];
    }

    if (locationData != null) {

      final String latitudeData = jsonDecode(locationData)['latitude'];
      final String longitudeData = jsonDecode(locationData)['longitude'];
      latitudeWrapper.value = double.parse(latitudeData);
      longitudeWrapper.value = double.parse(longitudeData);
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