import 'dart:developer';

import 'package:geolocator/geolocator.dart';

class GeolocatorService {
  static final instance = GeolocatorService._();
  GeolocatorService._();
  Stream<Position> get userPositionStream =>
      Geolocator.getPositionStream().asBroadcastStream();

  Future<Position?> getUserPosition() async {
    final permission = await Geolocator.checkPermission();
    try {
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        final position = await Geolocator.getCurrentPosition();
        return position;
      } else if (permission == LocationPermission.deniedForever) {
        return null;
      } else {
        await Geolocator.requestPermission();
        return await getUserPosition();
      }
    } catch (e) {
      log('GeolocatorService || $e');
      rethrow;
    }
  }
}
