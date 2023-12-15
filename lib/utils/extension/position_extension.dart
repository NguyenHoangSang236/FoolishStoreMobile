import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

extension PositionConverter on Position {
  LatLng get toLatLng => LatLng(latitude, longitude);
}
