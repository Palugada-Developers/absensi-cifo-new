import 'package:absensi_cifo_v2/core/statics/app.prefix.dart';
import 'package:absensi_cifo_v2/core/themes/app.themes.dart';
import 'package:absensi_cifo_v2/features/essentials/attendances/checkcomplete/check.complete.vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

class CheckCompleteUi extends StatelessWidget {
  CheckCompleteUi({super.key});

  final checkCompleteVM = Get.put(CheckCompleteVM());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, result) {
        SystemNavigator.pop();
      },
      child: Scaffold(
        backgroundColor: AppThemes.whiteColor,
        body: Obx(() {
          return SizedBox(
            height: 1.sh,
            width: 1.sw,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 0.1.sh,
                      horizontal: 0.1.sw,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppPrefix.logoUrl,
                          width: 0.5.sw,
                          fit: BoxFit.fitWidth,
                        ),

                        SizedBox(height: 0.05.sh,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Halo, ",
                              style: GoogleFonts.poppins(
                                color: AppThemes.blackColor,
                                fontSize: 75.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            Text(
                              "${checkCompleteVM.usernameWrapper.value}!",
                              style: GoogleFonts.poppins(
                                color: AppThemes.blackColor,
                                fontSize: 75.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 0.02.sh),

                        Text(
                          checkCompleteVM.currentTime.value,
                          style: GoogleFonts.poppins(
                            color: AppThemes.blackColor,
                            fontSize: 60.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 0.005.sh),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Anda ",
                              style: GoogleFonts.poppins(
                                color: AppThemes.blackColor,
                                fontSize: 60.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              "sudah absen ",
                              style: GoogleFonts.poppins(
                                color: AppThemes.blackColor,
                                fontSize: 60.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "hari ini!",
                              style: GoogleFonts.poppins(
                                color: AppThemes.blackColor,
                                fontSize: 60.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () {
                      PanaraCustomDialog.show(
                          context,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          backgroundColor: AppThemes.whiteColor,
                          margin: EdgeInsets.all(20),
                          padding: EdgeInsets.all(20),
                          barrierDismissible: true,
                          children: [
                            SizedBox(height: 40.h),
                            Text(
                              "Konfirmasi Keluar Akun",
                              style: GoogleFonts.poppins(
                                color: AppThemes.blackColor,
                                fontSize: 70.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 40.h),
                            Text(
                              "Apakah Anda yakin ingin keluar akun?",
                              style: GoogleFonts.poppins(
                                color: AppThemes.blackColor,
                                fontSize: 60.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            SizedBox(height: 70.h),

                            Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "TIDAK",
                                        style: GoogleFonts.poppins(
                                          color: AppThemes.blackColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),

                                    SizedBox(width: 30,),

                                    GestureDetector(
                                      onTap: checkCompleteVM.handleLogout,
                                      child: Text(
                                        "IYA",
                                        style: GoogleFonts.poppins(
                                          color: AppThemes.blackColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                            ),
                            SizedBox(height: 40.h),
                          ]
                      );
                    },
                    child: Text(
                      "KELUAR AKUN",
                      style: GoogleFonts.poppins(
                        color: Colors.red,
                        fontSize: 60.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}