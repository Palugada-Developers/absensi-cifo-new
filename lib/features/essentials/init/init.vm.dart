import 'package:absensi_cifo_v2/core/services/app.geo.services.dart';
import 'package:absensi_cifo_v2/core/services/app.request.services.dart';
import 'package:absensi_cifo_v2/core/services/app.storage.services.dart';
import 'package:absensi_cifo_v2/features/essentials/attendances/checkcomplete/check.complete.ui.dart';
import 'package:absensi_cifo_v2/features/essentials/attendances/checkcomplete/check.complete.vm.dart';
import 'package:absensi_cifo_v2/features/essentials/attendances/checkin/check.in.ui.dart';
import 'package:absensi_cifo_v2/features/essentials/attendances/checkin/check.in.vm.dart';
import 'package:absensi_cifo_v2/features/essentials/attendances/checkout/check.out.ui.dart';
import 'package:absensi_cifo_v2/features/essentials/attendances/checkout/check.out.vm.dart';
import 'package:absensi_cifo_v2/features/essentials/auth/auth.ui.dart';
import 'package:absensi_cifo_v2/features/essentials/init/init.ui.dart';
import 'package:get/get.dart';

class InitVM extends GetxController
{
    // STATES
    RxBool isError = false.obs;

    void initialServices() async
    {
        try
        {
            final token = await AppStorageServices().getData("token");
            if (token == null)
            {
                Get.to(() => AuthUi());
            }
            else
            {
                checkProfile();
                checkAbsentStatus();
            }
        }
        catch (e)
        {
            isError.value = true;
            update();
        }
    }

    void initialPermission() async
    {
        await AppGeoServices().init();
        AppRequestServices().requestLocation();
    }

    void checkProfile() async
    {
        await AppRequestServices().requestProfile();
    }

    void checkAbsentStatus() async
    {
        final checkAbsentState = await AppRequestServices().requestAbsentCheck();

        switch (checkAbsentState)
        {
            case 0:
                Get.delete<CheckInVM>();
                Get.to(() => CheckInUi());
            case 1:
                Get.delete<CheckOutVM>();
                Get.to(() => CheckOutUi());
            case 2:
                Get.delete<CheckCompleteVM>();
                Get.to(() => CheckCompleteUi());
            default:
            Get.delete<InitVM>();
            Get.to(() => InitUi());
        }
    }

    @override
    void onInit()
    {
        initialPermission();

        Future.delayed(const Duration(seconds: 3)).then((_)
            {
                initialServices();
            }
        );

        super.onInit();
    }

}
