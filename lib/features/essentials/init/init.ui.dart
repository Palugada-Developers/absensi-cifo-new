import 'package:absensi_cifo_v2/core/statics/app.prefix.dart';
import 'package:absensi_cifo_v2/core/themes/app.themes.dart';
import 'package:absensi_cifo_v2/features/essentials/init/init.vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class InitUi extends StatelessWidget {
  InitUi({super.key});

  final initVM = Get.put(InitVM());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.whiteColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            AppPrefix.logoUrl,
            width: 0.5.sw,
            fit: BoxFit.fitWidth,
          ),

          Padding(
            padding: EdgeInsets.only(left: 50, right: 50),
            child: LinearProgressIndicator(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}