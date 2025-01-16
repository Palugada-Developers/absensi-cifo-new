import 'package:absensi_cifo_v2/core/services/app.request.services.dart';
import 'package:absensi_cifo_v2/features/essentials/init/init.ui.dart';
import 'package:absensi_cifo_v2/features/essentials/init/init.vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AuthVM extends GetxController
{
    // STATES
    RxBool isError = false.obs;
    RxBool isLoading = false.obs;
    RxString usernameWrapper = "".obs;
    RxString passwordWrapper = "".obs;

    // SERVICES
    final AppRequestServices requestServices = AppRequestServices();

    // HANDLER
    void handleRequest(context) async
    {
        // STATES UPDATE
        FocusScope.of(context).unfocus();
        String emailData = usernameWrapper.value;
        String passwordData = passwordWrapper.value;

        if (emailData.isEmpty || passwordData.isEmpty)
        {
            isError.value = true;
        }
        else
        {

            isLoading.value = true;

            var requestData =
                {
                    "user_name": emailData,
                    "password": passwordData
                };

            try
            {

                final bool requestLogin = await requestServices.requestLogin(requestData);

                if (requestLogin)
                {
                    Get.delete<InitVM>();
                    Get.to(() => InitUi());
                }
                else
                {
                    isError.value = true;
                }

            }
            catch (e)
            {

                isError.value = true;

            }
            finally
            {

                Future.delayed(const Duration(seconds: 3)).then((_)
                    {
                        isError.value = false;
                        isLoading.value = false;
                    }
                );

            }
        }

        update();
    }
}
