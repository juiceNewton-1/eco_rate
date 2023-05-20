import 'dart:async';
import 'dart:math';
import 'package:diplom/constants/api_keys.dart';
import 'package:diplom/constants/enums.dart';
import 'package:diplom/constants/pdk.dart';
import 'package:diplom/models/air_pollution_model.dart';
import 'package:diplom/models/user_position_model.dart';
import 'package:diplom/services/api_service.dart';
import 'package:diplom/services/geolocator_service.dart';
import 'package:diplom/services/noise_meter_service.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:noise_meter/noise_meter.dart';

class LogicController extends ChangeNotifier {
  final _geolocatorService = GeolocatorService();
  final _noiseMeterService = NoiseMeterService();
  final _apiService = ApiService();

  Stream<NoiseReading> get noiseStream =>
      _noiseMeterService.getNoiseStream().asBroadcastStream();

  Stream<Position> get userPositionStream =>
      _geolocatorService.userPositionStream;

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
    final date = DateTime.now().toIso8601String().substring(0, 10);

    try {
      final json = await _apiService.getDataFromUrl(
          url:
              'https://air-quality-api.open-meteo.com/v1/air-quality?latitude=$lat&longitude=$lon&hourly=pm10,pm2_5,carbon_monoxide,nitrogen_dioxide,sulphur_dioxide,ozone&timezone=Europe%2FMoscow&start_date=$date&end_date=$date');
      final airPollutionModel = AirPollutionModel.fromJson(json['hourly']);
      return airPollutionModel;
    } catch (e) {
      print(e);
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
      print(e);
      return null;
    }
  }

  double calculateEcoRate(double noiseValue, int treesQuantity,
      AirPollutionModel airPollutionModel, UserAreaType userAreaType) {
    final dateTime = DateTime.now().toIso8601String().substring(0, 13);
    print(dateTime);
    final currentTimeIndex = airPollutionModel.time
        .indexWhere((element) => element.startsWith(dateTime));

    final coValue = airPollutionModel.co[currentTimeIndex] ?? 0;
    final no2Value = airPollutionModel.no2[currentTimeIndex] ?? 0;
    final so2Value = airPollutionModel.so2[currentTimeIndex] ?? 0;
    final o3Value = airPollutionModel.o3[currentTimeIndex] ?? 0;
    final pm25Value = airPollutionModel.pm25[currentTimeIndex] ?? 0;
    final pm10Value = airPollutionModel.pm10[currentTimeIndex] ?? 0;
    final List<double> airPollutantsConcentration = [
      coValue,
      no2Value,
      so2Value,
      o3Value,
      pm25Value,
      pm10Value
    ];

    double airPollutionValue = 0;
    double noisePollutionValue = 0;
    final pollutantsPdk = PDK.pollutantsMRPDK.values.toList();
    for (var i = 0; i < airPollutantsConcentration.length; i++) {
      airPollutionValue +=
          (airPollutantsConcentration[i] / 1000) / pollutantsPdk[i];
    }

    noisePollutionValue = noiseValue / getNoisePDK(userAreaType);

    return (pow((airPollutionValue + 1), 0.4) +
                pow((noisePollutionValue + 1), 0.4) +
                pow((treesQuantity / 100), 0.2))
            .toDouble() -
        1;
  }

  int getNoisePDK(UserAreaType userAreaType) {
    if (DateTime.now().hour < 7) {
      return PDK.nightNoisePDK[userAreaType]!;
    }
    return PDK.dayNoisePDK[userAreaType]!;
  }
}
