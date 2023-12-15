import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

import '../utils/render/ui_render.dart';

class MapService {
  static Future<Position> getUserCurrentLocation(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      UiRender.showDialog(
        context,
        '',
        'Please enable your device location service!',
      );

      return Future.error('Location services are disabled.');
    }

    debugPrint('Requesting location permission');

    LocationPermission permission = await Geolocator.requestPermission();
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      if (permission == LocationPermission.denied) {
        UiRender.showDialog(context, '', 'Location permissions are denied');

        return Future.error('Location permissions are denied');
      } else if (permission == LocationPermission.deniedForever) {
        UiRender.showDialog(
          context,
          '',
          'Location permissions are permanently denied, we cannot request permissions',
        );

        return Future.error(
          'Location permissions are permanently denied, we cannot request permissions',
        );
      }
    }

    return await Geolocator.getCurrentPosition();
  }
}
