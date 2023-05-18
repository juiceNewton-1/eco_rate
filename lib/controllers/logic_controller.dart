import 'dart:developer';

import 'package:diplom/models/user_position_model.dart';
import 'package:diplom/services/geolocator_service.dart';
import 'package:flutter/foundation.dart';

class LogicController extends ChangeNotifier {
  final _geolocatorService = GeolocatorService();

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
}
