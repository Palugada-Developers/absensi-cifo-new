import 'package:absensi_cifo_v2/core/statics/app.prefix.dart';
import 'package:absensi_cifo_v2/core/themes/app.themes.dart';
import 'package:absensi_cifo_v2/features/essentials/attendances/checkoutlate/check.out.late.vm.dart';
import 'package:absensi_cifo_v2/features/globals/globals.form.widget.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckOutLateUi extends StatelessWidget
{
    CheckOutLateUi({super.key});

    final checkOutLateVM = Get.put(CheckOutLateVM());

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
                        backgroundColor: AppThemes.whiteColor,
                        resizeToAvoidBottomInset: true,
                        body: Obx(()
                            {
                                if (checkOutLateVM.isError.value)
                                {
                                    WidgetsBinding.instance.addPostFrameCallback((_)
                                        {
                                            CherryToast.error(
                                                backgroundColor: AppThemes.whiteColor,
                                                shadowColor: Colors.black12,
                                                enableIconAnimation: true,
                                                description: Text(
                                                    "Oops, pengisian absen pulang lebih cepat gagal, pastikan isi form alasan.",
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.red,
                                                        fontWeight: FontWeight.w300,
                                                        fontSize: 60.sp
                                                    )
                                                ),
                                                animationType: AnimationType.fromTop,
                                                animationDuration: const Duration(milliseconds: 500),
                                                autoDismiss: true,
                                                toastDuration: const Duration(seconds: 3)
                                            ).show(context);
                                        }
                                    );
                                    checkOutLateVM.isError.value = false;
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
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                        Image.asset(
                                                            AppPrefix.logoUrl,
                                                            width: 0.5.sw,
                                                            fit: BoxFit.fitWidth
                                                        ),

                                                        SizedBox(height: 0.05.sh),

                                                        Text(
                                                            "Anda pulang lebih cepat!",
                                                            style: GoogleFonts.poppins(
                                                                color: AppThemes.blackColor,
                                                                fontSize: 60.sp,
                                                                fontWeight: FontWeight.w600
                                                            )
                                                        ),
                                                        SizedBox(height: 0.03.sh),

                                                        WidgetsForm(
                                                            controller: checkOutLateVM.reasonWrapper,
                                                            label: "Alasan",
                                                            hint: "Ketik alasan pulang lebih cepat Anda disini.",
                                                            helper: "Harap isi form diatas untuk melanjutkan absensi pulang.",
                                                            isObscure: false,
                                                            minLines: 3
                                                        ),

                                                        SizedBox(height: 0.05.sh),

                                                        ElevatedButton(
                                                            onPressed: ()
                                                            {
                                                                checkOutLateVM.handleRequest(context);
                                                            },
                                                            style: ButtonStyle(
                                                                fixedSize: WidgetStatePropertyAll(
                                                                    Size(
                                                                        1.sw,
                                                                        0.06.sh
                                                                    )
                                                                ),
                                                                backgroundColor: WidgetStatePropertyAll(
                                                                    Colors.amber
                                                                )
                                                            ),
                                                            child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                    if (checkOutLateVM.isLoading.value)
                                                                    SpinKitFadingCircle(
                                                                        color: Colors.white,
                                                                        size: 80.sp
                                                                    )
                                                                    else
                                                                    Text(
                                                                        "KIRIM",
                                                                        style: GoogleFonts.poppins(
                                                                            color: AppThemes.whiteColor,
                                                                            fontSize: 60.sp,
                                                                            fontWeight: FontWeight.w600
                                                                        )
                                                                    )
                                                                ]
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
