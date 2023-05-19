import 'package:diplom/constants/enums.dart';

class AirPollutionModel {
  final List<String> time;
  final List<double?> co;
  final List<double?> so2;
  final List<double?> no2;
  final List<double?> o3;
  final List<double?> pm25;
  final List<double?> pm10;

  const AirPollutionModel(
      this.co, this.so2, this.no2, this.o3, this.pm25, this.pm10, this.time);

  AirPollutionModel.fromJson(Map<String, dynamic> json)
      : time = (json['time'] as List<dynamic>).map((e) => e as String).toList(),
        co = (json[AirPollutants.carbon_monoxide.name] as List<dynamic>)
            .map((e) => e as double)
            .toList(),
        so2 = (json[AirPollutants.sulphur_dioxide.name] as List<dynamic>)
            .map((e) => e as double)
            .toList(),
        no2 = (json[AirPollutants.nitrogen_dioxide.name] as List<dynamic>)
            .map((e) => e as double)
            .toList(),
        o3 = (json[AirPollutants.ozone.name] as List<dynamic>)
            .map((e) => e as double)
            .toList(),
        pm25 = (json[AirPollutants.pm2_5.name] as List<dynamic>)
            .map((e) => e as double)
            .toList(),
        pm10 = (json[AirPollutants.pm10.name] as List<dynamic>)
            .map((e) => e as double)
            .toList();
}
