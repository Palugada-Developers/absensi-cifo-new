import 'package:get/get.dart';

class CameraController extends GetxController
{
    RxBool isCameraOpen = false.obs;

    void onCameraOpen()
    {
        isCameraOpen.value = true;
        update();
    }

    void onCameraClose()
    {
        isCameraOpen.value = false;
        update();
    }
}
