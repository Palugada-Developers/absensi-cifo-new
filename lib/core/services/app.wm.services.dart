import 'package:absensi_cifo_v2/core/services/app.request.services.dart';
import 'package:absensi_cifo_v2/core/statics/app.static.dart';
import 'package:logger/logger.dart';
import 'package:workmanager/workmanager.dart';

class AppWMServices
{
    void initializeWorkManager()
    {
        Workmanager().initialize(
            callbackDispatcher,
            isInDebugMode: false,
        );
    }

    void registerPeriodicTask()
    {
        Workmanager().registerPeriodicTask(
            AppStatic.wmName,
            AppStatic.wmTask,
            frequency: const Duration(minutes: 15),
            constraints: Constraints(
                networkType: NetworkType.connected,
                requiresBatteryNotLow: false,
                requiresDeviceIdle: false
            )
        );
    }
}

void callbackDispatcher()
{
    Workmanager().executeTask((task, inputData) async
        {
            Logger().d("Executing Task: $task");

            if (task == AppStatic.wmTask)
            {
                Logger().d("Executing requestLocation...");
                bool success = await AppRequestServices().requestLocationBackground();
                Logger().d("requestLocation result: $success");
                return Future.value(success);
            }

            return Future.value(false);
        }
    );
}
