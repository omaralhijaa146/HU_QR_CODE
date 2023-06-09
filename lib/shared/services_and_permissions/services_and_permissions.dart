import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:graduation_project/shared/constatnts/constants.dart';

Future<bool> checkLocationService(context) async {
  return await Geolocator.isLocationServiceEnabled();
}

Future<void> checkUserPermission(context) async {
  bool locService = await checkLocationService(context);
  if (locService == true) {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('SERVICE DENIEDDDDD');
        /*showToast(
            text: 'SERVICE DENIED', state: ToastStates.ERROR, context: context);*/
      }
    } else if (permission == LocationPermission.deniedForever) {
      print(
          'Location permissions are permanently denied, we cannot request permissions.');
      /* showToast(
          text:
              'Location permissions are permanently denied, we cannot request permissions.',
          state: ToastStates.ERROR,
          context: context);*/
    }
  }
}

void setLocationSettings() {
  if (defaultTargetPlatform == TargetPlatform.android) {
    locationSettings = AndroidSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 0,
      forceLocationManager: true,
      intervalDuration: Duration(milliseconds: 750),
    );
  } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    locationSettings = AppleSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      activityType: ActivityType.fitness,
      distanceFilter: 0,
      pauseLocationUpdatesAutomatically: true,
// Only set to true if our app will be started up in the background.
      showBackgroundLocationIndicator: false,
    );
  } else {
    locationSettings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 0,
    );
  }
}
