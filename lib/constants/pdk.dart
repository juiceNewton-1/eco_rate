import 'package:diplom/constants/enums.dart';

class PDK {
  static const pollutantsMRPDK = <String, double>{
    'co': 5.0,
    'no2': 0.085,
    'so2': 0.4,
    'o3': 0.16,
    'pm2_5': 0.16,
    'pm10': 0.3
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
