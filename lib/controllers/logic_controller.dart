import 'dart:developer';

import 'package:diplom/models/user_position_model.dart';
import 'package:diplom/services/geolocator_service.dart';
import 'package:diplom/services/noise_meter_service.dart';
import 'package:flutter/foundation.dart';
import 'package:noise_meter/noise_meter.dart';

class LogicController extends ChangeNotifier {
  final _geolocatorService = GeolocatorService();
  final _noiseMeterService = NoiseMeterService();

  Future<UserPositionModel?> getUserPosition() async {
    try {
      final userPosition = await _geolocatorService.getUserPosition();
      if (userPosition != null) {
        final userPositionModel =
            UserPositionModel(userPosition.latitude, userPosition.longitude);
        return userPositionModel;
      }
      return null;
    } catch (e) {
      log('LogicController || $e');
      rethrow;
    }
  }

  Stream<NoiseReading> getNoiseStream() => _noiseMeterService.getNoiseStream();
}
