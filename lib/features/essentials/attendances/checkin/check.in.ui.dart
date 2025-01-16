import 'package:absensi_cifo_v2/core/themes/app.themes.dart';
import 'package:absensi_cifo_v2/features/essentials/attendances/checkin/check.in.vm.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

class CheckInUi extends StatelessWidget
{
    CheckInUi({super.key});

    final checkInVM = Get.put(CheckInVM());

    @override
    Widget build(BuildContext context)
    {
        return PopScope(
            canPop: false,
            onPopInvokedWithResult: (_, result)
            {
                SystemNavigator.pop();
            },
            child: MaterialApp(
                debugShowCheckedModeBanner: false,
                home: GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: Scaffold(
                        backgroundColor: Colors.white,
                        resizeToAvoidBottomInset: true,
                        body: Obx(
                            ()
                            {
                                if (checkInVM.isError.value)
                                {
                                    WidgetsBinding.instance.addPostFrameCallback((_)
                                        {
                                            CherryToast.error(
                                                backgroundColor: Colors.white,
                                                shadowColor: Colors.black12,
                                                enableIconAnimation: true,
                                                description: Text(
                                                    'Oops, login failed, please fill with registered email and password.',
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.red,
                                                        fontWeight: FontWeight.w300,
                                                        fontSize: 12
                                                    )
                                                ),
                                                animationType: AnimationType.fromTop,
                                                animationDuration: const Duration(milliseconds: 500),
                                                autoDismiss: true,
                                                toastDuration: const Duration(seconds: 3)
                                            ).show(context);
                                        }
                                    );

                                    checkInVM.isError = false.obs;
                                }

                                return SingleChildScrollView(
                                    child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                            minHeight: 1.sh
                                        ),
                                        child: IntrinsicHeight(
                                            child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 0.1.sh,
                                                    horizontal: 0.1.sw
                                                ),
                                                child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                        Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                                SizedBox(
                                                                    height: 0.1.sh
                                                                ),
                                                                Image.asset(
                                                                    "assets/images/logo.png",
                                                                    width: 0.5.sw,
                                                                    fit: BoxFit.fitWidth
                                                                ),
                                                                SizedBox(
                                                                    height: 0.05.sh
                                                                ),
                                                                Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                        Text(
                                                                            "Halo, ",
                                                                            style: GoogleFonts.poppins(
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.w400,
                                                                                fontSize: 70.sp
                                                                            )
                                                                        ),

                                                                        Text(
                                                                            checkInVM.usernameWrapper.value,
                                                                            style: GoogleFonts.poppins(
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: 70.sp
                                                                            )
                                                                        ),
                                                                        Text(
                                                                            "!",
                                                                            style: GoogleFonts.poppins(
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: 70.sp
                                                                            )
                                                                        )
                                                                    ]
                                                                ),
                                                                Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                        Text(
                                                                            "Anda ",
                                                                            style: GoogleFonts.poppins(
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.w300,
                                                                                fontSize: 70.sp
                                                                            )
                                                                        ),
                                                                        Text(
                                                                            "belum absen ",
                                                                            style: GoogleFonts.poppins(
                                                                                color: Colors.red,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: 70.sp
                                                                            )
                                                                        ),

                                                                        Text(
                                                                            "hari ini.",
                                                                            style: GoogleFonts.poppins(
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.w300,
                                                                                fontSize: 70.sp
                                                                            )
                                                                        )
                                                                    ]
                                                                ),
                                                                SizedBox(height: 0.05.sh),

                                                                DropDownTextField(
                                                                    listTextStyle: GoogleFonts.poppins(
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.w400,
                                                                        fontSize: 70.sp
                                                                    ),
                                                                    textStyle: GoogleFonts.poppins(
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.w400,
                                                                        fontSize: 70.sp
                                                                    ),
                                                                    controller: checkInVM.shiftController,
                                                                    clearOption: true,
                                                                    clearIconProperty:
                                                                    IconProperty(color: Colors.black),
                                                                    textFieldDecoration: InputDecoration(
                                                                        label: Text(
                                                                            "Pilih shift",
                                                                            style: GoogleFonts.poppins(
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.w300,
                                                                                fontSize: 70.sp
                                                                            )
                                                                        )
                                                                    ),
                                                                    validator: (value)
                                                                    {
                                                                        if (value == null)
                                                                        {
                                                                            return "Required field";
                                                                        }
                                                                        else
                                                                        {
                                                                            return null;
                                                                        }
                                                                    },
                                                                    dropDownItemCount: 5,
                                                                    dropDownList: const [
                                                                        DropDownValueModel(
                                                                            name: 'Shift Pagi',
                                                                            value: "pagi"
                                                                        ),
                                                                        DropDownValueModel(
                                                                            name: 'Shift Sore',
                                                                            value: "sore"
                                                                        ),
                                                                        DropDownValueModel(
                                                                            name: 'Shift Malam',
                                                                            value: "malam"
                                                                        ),
                                                                        DropDownValueModel(
                                                                            name: 'Lembur Pagi',
                                                                            value: "lembur1"
                                                                        ),
                                                                        DropDownValueModel(
                                                                            name: 'Lembur Malam',
                                                                            value: "lembur2"
                                                                        )
                                                                    ],
                                                                    onChanged: (val)
                                                                    {
                                                                        checkInVM.isFilled.value = val != null;
                                                                    }
                                                                ),

                                                                SizedBox(height: 0.03.sh),

                                                                if (checkInVM.isFilled.value)
                                                                ElevatedButton(
                                                                    onPressed: ()
                                                                    {
                                                                        checkInVM.handleRequest();
                                                                    },
                                                                    style: ButtonStyle(
                                                                        minimumSize: WidgetStatePropertyAll(
                                                                            Size(
                                                                                1.sw,
                                                                                0.05.sh
                                                                            )
                                                                        ),
                                                                        backgroundColor: WidgetStatePropertyAll(
                                                                            checkInVM.isFilled.value
                                                                                ? Colors.amber
                                                                                : Colors.grey
                                                                        )
                                                                    ),
                                                                    child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                        CrossAxisAlignment.center,
                                                                        children: [
                                                                            if (checkInVM.isLoading.value)
                                                                            const SpinKitFadingCircle(
                                                                                color: Colors.white,
                                                                                size: 20
                                                                            )
                                                                            else
                                                                            Text(
                                                                                "ABSEN MASUK",
                                                                                style: GoogleFonts.poppins(
                                                                                    color: Colors.white,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    fontSize: 60.sp
                                                                                )
                                                                            )
                                                                        ]
                                                                    )
                                                                ),
                                                                if (!checkInVM.isFilled.value)
                                                                ElevatedButton(
                                                                    onPressed: null,
                                                                    style: ButtonStyle(
                                                                        minimumSize: WidgetStatePropertyAll(
                                                                            Size(
                                                                                1.sw,
                                                                                0.05.sh
                                                                            )
                                                                        ),
                                                                        backgroundColor: WidgetStatePropertyAll(
                                                                            checkInVM.isFilled.value
                                                                                ? Colors.amber
                                                                                : Colors.grey
                                                                        )
                                                                    ),
                                                                    child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                        CrossAxisAlignment.center,
                                                                        children: [
                                                                            if (checkInVM.isLoading.value)
                                                                            const SpinKitFadingCircle(
                                                                                color: Colors.white,
                                                                                size: 20
                                                                            )
                                                                            else
                                                                            Text(
                                                                                "ABSEN MASUK",
                                                                                style: GoogleFonts.poppins(
                                                                                    color: Colors.white,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    fontSize: 60.sp
                                                                                )
                                                                            )
                                                                        ]
                                                                    )
                                                                )
                                                            ]
                                                        ),
                                                        GestureDetector(
                                                            onTap: ()
                                                            {
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
                                                                                fontWeight: FontWeight.w600
                                                                            )
                                                                        ),
                                                                        SizedBox(height: 40.h),
                                                                        Text(
                                                                            "Apakah Anda yakin ingin keluar akun?",
                                                                            style: GoogleFonts.poppins(
                                                                                color: AppThemes.blackColor,
                                                                                fontSize: 60.sp,
                                                                                fontWeight: FontWeight.w500
                                                                            )
                                                                        ),

                                                                        SizedBox(height: 70.h),

                                                                        Align(
                                                                            alignment: Alignment.centerRight,
                                                                            child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                                children: [
                                                                                    GestureDetector(
                                                                                        onTap: ()
                                                                                        {
                                                                                            Navigator.pop(context);
                                                                                        },
                                                                                        child: Text(
                                                                                            "TIDAK",
                                                                                            style: GoogleFonts.poppins(
                                                                                                color: AppThemes.blackColor,
                                                                                                fontWeight: FontWeight.w600
                                                                                            )
                                                                                        )
                                                                                    ),

                                                                                    SizedBox(width: 30),

                                                                                    GestureDetector(
                                                                                        onTap: checkInVM.handleLogout,
                                                                                        child: Text(
                                                                                            "IYA",
                                                                                            style: GoogleFonts.poppins(
                                                                                                color: AppThemes.blackColor,
                                                                                                fontWeight: FontWeight.w600
                                                                                            )
                                                                                        )
                                                                                    )
                                                                                ]
                                                                            )
                                                                        ),
                                                                        SizedBox(height: 40.h)
                                                                    ]
                                                                );
                                                            },
                                                            child: Text(
                                                                "KELUAR AKUN",
                                                                style: GoogleFonts.poppins(
                                                                    color: Colors.red,
                                                                    fontSize: 60.sp,
                                                                    fontWeight: FontWeight.w600
                                                                )
                                                            )
                                                        )
                                                    ]
                                                )
                                            )
                                        )
                                    )
                                );
                            }
                        )
                    )
                )
            )
        );
    }
}
