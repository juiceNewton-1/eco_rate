import 'dart:async';
import 'dart:developer';

import 'package:diplom/constants/api_keys.dart';
import 'package:diplom/models/air_pollution_model.dart';
import 'package:diplom/models/user_position_model.dart';
import 'package:diplom/services/api_service.dart';
import 'package:diplom/services/geolocator_service.dart';
import 'package:diplom/services/noise_meter_service.dart';
import 'package:flutter/foundation.dart';
import 'package:noise_meter/noise_meter.dart';

class LogicController extends ChangeNotifier {
  final _geolocatorService = GeolocatorService();
  final _noiseMeterService = NoiseMeterService();
  final _apiService = ApiService();

  Stream<NoiseReading> get noiseStream =>
      _noiseMeterService.getNoiseStream().asBroadcastStream();

  Future<double> getMeanNoiseValueFromLimit() async {
    final limitNoiseValues = (await noiseStream.take(10).toList())
        .map((noiseReading) => noiseReading.meanDecibel);
    return limitNoiseValues.reduce((value, element) => value + element) /
        limitNoiseValues.length;
  }

  Future<UserPositionModel?> getUserPosition() async {
    try {
      final userPosition = await _geolocatorService.getUserPosition();

      if (userPosition != null) {
        final json = (await _apiService.getDataFromUrl(
                url:
                    'http://api.openweathermap.org/geo/1.0/reverse?lat=${userPosition.latitude}&lon=${userPosition.longitude}&limit=1&appid=',
                apiKey: ApiKeys.openWeatherApiKey) as List<dynamic>)
            .first;
        final userPositionModel = UserPositionModel.fromJson(json);
        return userPositionModel;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<AirPollutionModel?> getAirPollutants(double lat, double lon) async {
    try {
      final json = await _apiService.getDataFromUrl(
          url:
              'https://air-quality-api.open-meteo.com/v1/air-quality?latitude=$lat&longitude=$lon&hourly=pm10,pm2_5,carbon_monoxide,nitrogen_dioxide,sulphur_dioxide,ozone&timezone=Europe%2FMoscow&start_date=2023-05-16&end_date=2023-05-16');
      final airPollutionModel = AirPollutionModel.fromJson(json['hourly']);
      return airPollutionModel;
    } catch (e) {
      log('$e');
    }
  }

  Future<Map<String, dynamic>?> getCommonData() async {
    try {
      final userPositionModel = await getUserPosition();
      if (userPositionModel != null) {
        final airPollitionModel = await getAirPollutants(
            userPositionModel.latitude, userPositionModel.longitude);
        return {
          'userPosition': userPositionModel,
          'airPollutionModel': airPollitionModel,
        };
      } else {
        return null;
      }
    } catch (e) {
      log('LogicController || $e');
      return null;
    }
  }
}
