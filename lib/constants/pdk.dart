import 'package:diplom/constants/enums.dart';

class PDK {
  static const pollutantsPDKSS = <AirPollutants, double>{
    AirPollutants.carbon_monoxide: 3.0,
    AirPollutants.nitrogen_dioxide: 0.1,
    AirPollutants.sulphur_dioxide: 0.05,
    AirPollutants.ozone: 0.1,
    AirPollutants.pm2_5: 0.035,
    AirPollutants.pm10: 0.06
  };

  static const nightNoisePDK = <UserAreaType, int>{
    UserAreaType.residential: 45,
    UserAreaType.industrial: 55,
    UserAreaType.recreation: 35,
    UserAreaType.agricultural: 45,
    UserAreaType.reserve: 30
  };

  static const dayNoisePDK = <UserAreaType, int>{
    UserAreaType.residential: 60,
    UserAreaType.industrial: 65,
    UserAreaType.recreation: 50,
    UserAreaType.agricultural: 50,
    UserAreaType.reserve: 35
  };
}
