import 'dart:convert';
import 'package:absensi_cifo_v2/core/constants/app.constants.dart';
import 'package:absensi_cifo_v2/core/services/app.api.services.dart';
import 'package:absensi_cifo_v2/core/services/app.storage.services.dart';
import 'package:absensi_cifo_v2/features/essentials/attendances/checklate/check.late.ui.dart';
import 'package:absensi_cifo_v2/features/essentials/attendances/checklate/check.late.vm.dart';
import 'package:absensi_cifo_v2/features/essentials/attendances/checkout/check.out.ui.dart';
import 'package:absensi_cifo_v2/features/essentials/attendances/checkout/check.out.vm.dart';
import 'package:absensi_cifo_v2/features/essentials/init/init.ui.dart';
import 'package:absensi_cifo_v2/features/essentials/init/init.vm.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

class AppRequestServices
{
    final _apiServices = AppApiServices();

    // LOGIN REQUEST
    Future<bool> requestLogin(dynamic requestData) async
    {
        try
        {
            const url = AppConstants.loginUrl;

            final response = await _apiServices.post(url, requestData);

            if (response.statusCode == 200)
            {
                var responses = response.data;

                final saveToken = await AppStorageServices().saveData('token', responses['data']['access_token']);
                if (saveToken)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            else
            {
                return false;
            }
        }
        catch (e)
        {
            Logger().e(e);
            return false;
        }
    }

    // LOGOUT REQUEST
    Future<bool> requestLogout() async
    {
        try
        {
            const url = AppConstants.logoutUrl;

            final response = await _apiServices.post(url, null);
            if (response.statusCode == 200)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        catch (e)
        {
            return false;
        }
    }

    // GET PROFILE IDENTITY
    Future<bool> requestProfile() async
    {
        try
        {
            const url = AppConstants.profileUrl;

            final response = await _apiServices.post(url, null);
            if (response.statusCode == 200)
            {
                var responses = response.data;

                var saveIdentity = await AppStorageServices()
                    .saveData("identity", jsonEncode(responses));

                if (saveIdentity)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            else
            {
                return false;
            }
        }
        catch (e)
        {
            return false;
        }
    }

    // REFRESH TOKEN
    Future<bool> requestRetoken() async
    {
        try
        {
            const url = AppConstants.retokenUrl;

            final response = await _apiServices.post(url, null);

            if (response.statusCode == 200)
            {
                var responses = response.data;

                var saveToken = await AppStorageServices()
                    .saveData("token", responses['data']['token']);

                if (saveToken)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            else
            {
                return false;
            }
        }
        catch (e)
        {
            return false;
        }
    }

    // ABSENT IN
    Future<void> requestCheckIn(dynamic requestData) async
    {
        try
        {
            const url = AppConstants.checkInUrl;

            final response = await _apiServices.post(url, requestData);

            if (response.statusCode == 200 || response.statusCode == 201)
            {
                var responses = response.data;
                var statusAbsent = responses['success'];

                if (statusAbsent)
                {
                    await AppStorageServices().saveData(
                        "absent",
                        jsonEncode(responses)
                    );

                    if (responses['late'])
                    {
                        Get.delete<CheckLateVM>();
                        Get.to(() => CheckLateUi());
                    }
                    else
                    {
                        Get.delete<CheckOutVM>();
                        Get.to(() => CheckOutUi());
                    }
                }
                else
                {
                    Get.delete<InitVM>();
                    Get.to(() => InitUi());
                }
            }
            else
            {
                Get.delete<InitVM>();
                Get.to(() => InitUi());
            }
        }
        catch (e)
        {
            Get.delete<InitVM>();
            Get.to(() => InitUi());
        }
    }

    // ABSENT OUT
    Future<bool> requestCheckOut(dynamic requestData) async
    {
        try
        {
            const url = AppConstants.checkOutUrl;

            final response = await _apiServices.post(url, requestData);

            if (response.statusCode == 200)
            {
                var responses = response.data;

                var status = responses['success'];

                var early = responses['late'];

                if (status && early == 0)
                {
                    return true;
                }
                else if (status && early == 1)
                {
                    return false;
                }
                else
                {
                    return false;
                }
            }
            else
            {
                return false;
            }
        }
        catch (e)
        {
            return false;
        }
    }

    // REQUEST LATE MESSAGE
    Future<bool> requestLate(dynamic requestData) async
    {
        try
        {
            const url = AppConstants.checkReasonUrl;

            final response = await _apiServices.post(url, requestData);

            if (response.statusCode == 200)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        catch (e)
        {
            return false;
        }
    }

    // REQUEST ABSENT CHECK
    Future<int> requestAbsentCheck() async
    {
        try
        {
            const url = AppConstants.checkStatusUrl;

            final response = await _apiServices.post(url, null);

            if (response.statusCode == 200)
            {
                var responses = response.data;

                var isAbsent = responses['success'];

                if (isAbsent)
                {
                    await AppStorageServices()
                        .saveData("absentCheck", jsonEncode(responses['data']));

                    var status = responses['data']['hasntOut'];
                    var statusComplete = responses['data']['today_has_absent'];

                    if (!status && statusComplete)
                    {
                        return 2;
                    }
                    else if (!status && !statusComplete)
                    {
                        return 0;
                    }
                    else if (status && statusComplete)
                    {
                        return 1;
                    }
                    else
                    {
                        return 1;
                    }
                }
                else
                {
                    return 0;
                }
            }
            else
            {
                return 0;
            }
        }
        catch (e)
        {
            return 0;
        }
    }

    // REQUEST LOCATION
    Future<bool> requestLocation() async
    {
        try
        {
            LocationSettings locationSettings = LocationSettings(
                accuracy: LocationAccuracy.high,
                distanceFilter: 1
            );

            Position position = await Geolocator.getCurrentPosition(
                locationSettings: locationSettings);

            DateTime now = DateTime.now().toUtc();

            DateTime jakartaTime = now.add(const Duration(hours: 7));

            String formattedTimestamp =
                DateFormat('yyyy-MM-ddTHH:mm:ss').format(jakartaTime);

            var batteryData = await Battery().batteryLevel;

            var data =
                {
                    'latitude': "${position.latitude}",
                    'longitude': "${position.longitude}",
                    'battery': batteryData,
                    'timestamp': formattedTimestamp
                };

            await AppStorageServices().saveData('location', jsonEncode(data));
            return true;
        }
        catch (e)
        {
            Logger().e(e);
            return false;
        }
    }

    // REQUEST LOCATION
    Future<bool> requestLocationBackground() async
    {
        try
        {
            const url = AppConstants.sendLocationUrl;

            LocationSettings locationSettings = LocationSettings(
                accuracy: LocationAccuracy.high,
                distanceFilter: 1
            );

            Position position = await Geolocator.getCurrentPosition(
                locationSettings: locationSettings);

            DateTime now = DateTime.now().toUtc();

            DateTime jakartaTime = now.add(const Duration(hours: 7));

            String formattedTimestamp =
                DateFormat('yyyy-MM-ddTHH:mm:ss').format(jakartaTime);

            var batteryData = await Battery().batteryLevel;

            var idRawData = await AppStorageServices().getData("identity");

            var idData = "unknown";

            if (idRawData != null)
            {
                idData = (jsonDecode(idRawData)['kar_id']).toString();
            }

            var requestData =
                {
                    'id': idData,
                    'latitude': position.latitude,
                    'longitude': position.longitude,
                    'battery': batteryData,
                    'timestamp': formattedTimestamp
                };

            Logger().d(requestData);

            final response = await _apiServices.postCDC(url, requestData);

            if (response.statusCode == 200)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        catch (e)
        {
            Logger().e(e);
            return false;
        }
    }

    // NOTIFICATION LOCATION
    Future<bool> requestNotificationAccess() async
    {
        PermissionStatus permission = await Permission.notification.request();
        if (permission.isGranted)
        {
            return true;
        }
        else if (permission.isDenied)
        {
            return false;
        }
        else if (permission.isPermanentlyDenied)
        {
            openAppSettings();
            return false;
        }
        else
        {
            return true;
        }
    }
}
