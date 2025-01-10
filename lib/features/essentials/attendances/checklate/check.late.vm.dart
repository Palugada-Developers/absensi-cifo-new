import 'dart:convert';

import 'package:absensi_cifo_v2/core/services/app.request.services.dart';
import 'package:absensi_cifo_v2/core/services/app.storage.services.dart';
import 'package:absensi_cifo_v2/features/essentials/auth/auth.ui.dart';
import 'package:absensi_cifo_v2/features/essentials/auth/auth.vm.dart';
import 'package:absensi_cifo_v2/features/essentials/init/init.ui.dart';
import 'package:absensi_cifo_v2/features/essentials/init/init.vm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CheckLateVM extends GetxController {
  // STATES
  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  RxString reasonWrapper = "".obs;

  void handleRequest(context) async {
    FocusScope.of(context).unfocus();

    isLoading.value = true;

    update();

    Future.delayed(const Duration(seconds: 3)).then((_) async {
      var reason = reasonWrapper.value;

      if (reason.isEmpty) {
        isError.value = true;
        return;
      } else {
        final absentData = await AppStorageServices().getData("absent");

        if (absentData != null) {
          var absentIdData = jsonDecode(absentData)['absent_id'];

          var data = {
            'type': 'in',
            'absentId': absentIdData,
            'description': reason,
          };

          try {
            final bool response = await AppRequestServices().requestLate(data);
            if (response) {
              isError.value = false;
              isLoading.value = false;
              Get.delete<InitVM>();
              Get.to(() => InitUi());
            } else {
              isError.value = true;
            }
          } catch (e) {
            isError.value = true;
          }
        } else {
          isError.value = false;
          isLoading.value = false;
          Get.delete<AuthVM>();
          Get.to(() => AuthUi());
        }

        update();
      }
    });
  }
}