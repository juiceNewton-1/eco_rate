import 'package:diplom/constants/enums.dart';

class EcoRateModel {
  final double ecoRateValue;
  final double IZA;
  final double noiseValue;
  final int treesQuantity;
  final UserAreaType userAreaType;

  const EcoRateModel(
      {required this.ecoRateValue,
      required this.IZA,
      required this.noiseValue,
      required this.treesQuantity,
      required this.userAreaType});
}
