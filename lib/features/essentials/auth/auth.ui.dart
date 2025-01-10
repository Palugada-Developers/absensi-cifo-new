import 'package:absensi_cifo_v2/core/statics/app.prefix.dart';
import 'package:absensi_cifo_v2/core/themes/app.themes.dart';
import 'package:absensi_cifo_v2/features/essentials/auth/auth.vm.dart';
import 'package:absensi_cifo_v2/features/globals/globals.form.widget.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthUi extends StatelessWidget {
  AuthUi({super.key});

  final authVM = Get.put(AuthVM());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, result) {
        SystemNavigator.pop();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: AppThemes.whiteColor,
            resizeToAvoidBottomInset: true,
            body: Obx(() {
              if (authVM.isError.value) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  CherryToast.error(
                    backgroundColor: AppThemes.whiteColor,
                    shadowColor: Colors.black12,
                    enableIconAnimation: true,
                    description: Text(
                      "Oops, login failed, please fill with registered email and password.",
                      style: GoogleFonts.poppins(
                        color: Colors.red,
                        fontWeight: FontWeight.w300,
                        fontSize: 60.sp,
                      ),
                    ),
                    animationType: AnimationType.fromTop,
                    animationDuration: const Duration(milliseconds: 500),
                    autoDismiss: true,
                    toastDuration: const Duration(seconds: 3),
                  ).show(context);
                  authVM.isError.value = false;
                });
              }

              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 1.sh,
                  ),
                  child: IntrinsicHeight(
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

                          SizedBox(height: 0.1.sh,),

                          WidgetsForm(
                              controller: authVM.usernameWrapper,
                              label: "Username",
                              hint: "Username",
                              helper: "Harap isi dengan username Anda.",
                              isObscure: false,
                              minLines: 1
                          ),

                          SizedBox(height: 0.02.sh,),

                          WidgetsForm(
                              controller: authVM.passwordWrapper,
                              label: "Password",
                              hint: "Password",
                              helper: "Harap isi dengan password Anda.",
                              isObscure: true,
                              minLines: 1
                          ),

                          SizedBox(height: 0.05.sh,),

                          ElevatedButton(
                            onPressed: () {
                              authVM.handleRequest(context);
                            },
                            style: ButtonStyle(
                              fixedSize: WidgetStatePropertyAll(
                                Size(
                                  1.sw,
                                  0.06.sh,
                                ),
                              ),
                              backgroundColor: WidgetStatePropertyAll(
                                Colors.amber,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (authVM.isLoading.value)
                                  SpinKitFadingCircle(
                                    color: Colors.white,
                                    size: 80.sp,
                                  )
                                else
                                  Text(
                                    "MASUK",
                                    style: GoogleFonts.poppins(
                                      color: AppThemes.whiteColor,
                                      fontSize: 60.sp,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                              ],
                            )
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}