import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:absensi_cifo_v2/core/services/app.camera.controller.dart';
import 'package:absensi_cifo_v2/core/services/app.request.services.dart';
import 'package:absensi_cifo_v2/core/services/app.storage.services.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class CheckInConfirmVM extends GetxController
{
    RxBool isError = false.obs;

    RxBool isLoading = false.obs;

    RxString usernameWrapper = "".obs;

    final ImagePicker imagePicker = ImagePicker();

    RxString shift = "Shift".obs;

    RxString shiftValue = "".obs;

    RxDouble latitude = 1.0.obs;

    RxDouble longitude = 1.0.obs;

    RxString imageBase64 = "".obs;

    RxString currentTime = "".obs;

    XFile? imageFile;

    Timer? timer;

    final CameraController cameraController = Get.put(CameraController());

    Future<void> requestData() async
    {

        final identityData = await AppStorageServices().getData('identity');

        final shiftData = await AppStorageServices().getData('selectedShift');

        final location = await AppStorageServices().getData('location');

        if (identityData != null)
        {
            String usernameWrapperData = (jsonDecode(identityData)['username']);

            usernameWrapper.value = StringUtils.capitalize(usernameWrapperData);
        }

        if (shiftData != null)
        {
            shift.value = jsonDecode(shiftData)['name'];
            shiftValue.value = jsonDecode(shiftData)['value'];
        }

        if (location != null)
        {
            final String latitudeData = jsonDecode(location)['latitude'];
            final String longitudeData = jsonDecode(location)['longitude'];
            latitude.value = double.parse(latitudeData);
            longitude.value = double.parse(longitudeData);
        }

        update();
    }

    Future<bool> checkCameraPermission() async
    {
        PermissionStatus status = await Permission.camera.request();
        return status.isGranted;
    }

    Future<XFile?> takeSelfie() async
    {
        cameraController.onCameraOpen();

        final image = await imagePicker.pickImage(
            source: ImageSource.camera,
            preferredCameraDevice: CameraDevice.front
        );

        if (image != null)
        {
            final bytes = await File(image.path).readAsBytes();
            imageBase64.value = "data:image/jpeg;base64,${base64Encode(bytes)}";
            update();
        }

        return image;
    }

    void handleRequest() async
    {
        try
        {
            var data = 
            {
                "jenis_shift": shiftValue.value,
                "longitude": longitude.value,
                "latitude": latitude.value,
                "image": imageBase64.value
            };

            cameraController.onCameraClose();

            Get.delete<CheckInConfirmVM>();
            await AppRequestServices().requestCheckIn(data);
        }
        catch (e)
        {
            isError.value = true;
        }
    }

    void updateTime()
    {
        final now = DateTime.now();
        final formatter = DateFormat('dd/MM/yyyy | HH:mm:ss');

        currentTime.value = "${formatter.format(now)} WIB";
    }

    Future<bool> checkPermissions() async
    {
        bool permissionGranted = await checkCameraPermission();
        return permissionGranted;
    }

    void initSelfie() async
    {
        imageFile = null;
        imageFile = await takeSelfie();
    }

    @override
    void onInit()
    {
        super.onInit();
        updateTime();
        timer = Timer.periodic(const Duration(seconds: 1), (timer)
            {
                updateTime();
            }
        );

        requestData();
        initSelfie();
    }

    @override
    void dispose()
    {
        timer?.cancel();
        super.dispose();
    }
}
