import 'dart:io';

import 'package:absensi_cifo_v2/core/statics/app.prefix.dart';
import 'package:absensi_cifo_v2/features/essentials/attendances/checkin/check.in.confirm.vm.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckInConfirmUi extends StatelessWidget {
  CheckInConfirmUi({super.key});

  final checkInConfirmVM = Get.put(CheckInConfirmVM());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, result) {
        SystemNavigator.pop();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          body: Obx(() {
            if (checkInConfirmVM.isError.value) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                CherryToast.error(
                  backgroundColor: Colors.white,
                  shadowColor: Colors.black12,
                  enableIconAnimation: true,
                  description: Text(
                    'Oops, attendance check in failed, please try again.',
                    style: GoogleFonts.poppins(
                      color: Colors.red,
                      fontWeight: FontWeight.w300,
                      fontSize: 12,
                    ),
                  ),
                  animationType: AnimationType.fromTop,
                  animationDuration: const Duration(milliseconds: 500),
                  autoDismiss: true,
                  toastDuration: const Duration(seconds: 3),
                ).show(context);
              });

              checkInConfirmVM.isError.value = false;
            }
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 0.1.sh,
                  horizontal: 0.1.sw,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppPrefix.logoUrl,
                          width: 0.5.sw,
                          fit: BoxFit.fitWidth,
                        ),
                        SizedBox(
                          height: 0.05.sh,
                        ),
                        Card(
                          child: SizedBox(
                            width: 1.sw,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    checkInConfirmVM.usernameWrapper.value,
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 70.sp,
                                    ),
                                  ),
                                  Text(
                                    checkInConfirmVM.shift.value,
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 70.sp,
                                    ),
                                  ),
                                  Text(
                                    checkInConfirmVM.currentTime.value,
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 70.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (checkInConfirmVM.imageFile != null)
                      Card(
                        child: SizedBox(
                          width: 1.sw,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 30,
                            ),
                            child: Image.file(
                              File(checkInConfirmVM.imageFile!.path),
                              height: 200,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                      ),
                    ElevatedButton(
                      onPressed: checkInConfirmVM.handleRequest,
                      style: ButtonStyle(
                        minimumSize: WidgetStatePropertyAll(
                          Size(
                            1.sw,
                           0.05.sh,
                          ),
                        ),
                        backgroundColor: const WidgetStatePropertyAll(
                          Colors.amber,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (checkInConfirmVM.isLoading.value)
                            const SpinKitFadingCircle(
                              color: Colors.white,
                              size: 20,
                            )
                          else
                            Text(
                              "ABSEN MASUK",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 60.sp,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}