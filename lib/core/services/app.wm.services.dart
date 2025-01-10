import 'package:absensi_cifo_v2/core/services/app.request.services.dart';
import 'package:absensi_cifo_v2/core/statics/app.static.dart';
import 'package:workmanager/workmanager.dart';

class AppWMServices {
  void initializeWorkManager(){
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
  }

 void registerPeriodicTask() {
    Workmanager().registerPeriodicTask(
      AppStatic.wmName,
      AppStatic.wmTask,
      frequency: const Duration(minutes: 15),
      constraints: Constraints(networkType: NetworkType.connected),
    );
 }
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await AppRequestServices().requestLocation();
    return Future.value(true);
  });
}