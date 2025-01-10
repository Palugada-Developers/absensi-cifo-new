import 'package:absensi_cifo_v2/core/services/app.camera.controller.dart';
import 'package:absensi_cifo_v2/core/services/app.wm.services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import 'features/essentials/init/init.ui.dart';
import 'features/essentials/init/init.vm.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppWMServices().initializeWorkManager();
  AppWMServices().registerPeriodicTask();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool _isAppInBackground = false;

  final CameraController cameraController = Get.put(CameraController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

      if (state == AppLifecycleState.paused) {
        setState(() {
          _isAppInBackground = true;
        });
      }
      else if (state == AppLifecycleState.resumed) {
        if (_isAppInBackground && cameraController.isCameraOpen.value) {
          Logger().d(cameraController.isCameraOpen.value);
          setState(() {
            _isAppInBackground = false;
          });
        } else if (_isAppInBackground && !cameraController.isCameraOpen.value){
          Get.delete<InitVM>();
          Get.to(() => InitUi());
        }
      }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: ScreenUtilInit(
        designSize: const Size(1920, 2040),
        minTextAdapt: true,
        splitScreenMode: false,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: InitUi(),
          );
        },
      ),
    );
  }
}
