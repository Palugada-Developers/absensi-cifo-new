import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';

class AppGeoServices {
  final Location location = Location();

  bool isServiceRunning = false;

  Stream<LatLng> get locationStream => location.onLocationChanged
      .map((event) => LatLng(event.latitude!, event.longitude!));

  Future<void> init() async {
    final serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      await location.requestService();
    }

    var permissionStatus = await location.hasPermission();

    if (permissionStatus == PermissionStatus.denied){
      permissionStatus = await location.requestPermission();
    }

    if (permissionStatus == PermissionStatus.granted) {
        await location.enableBackgroundMode(enable: false);
    }
  }

  void listenLocation() async {
    if (await isServiceEnabled()) {
      isServiceRunning = true;
      locationStream.listen((event) {
        Logger().d("Current device location: $event");
      });
    } else {
      isServiceRunning = false;
    }
  }

  Future<bool> isServiceEnabled() async {
    return location.serviceEnabled();
  }
}