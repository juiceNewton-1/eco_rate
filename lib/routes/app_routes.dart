import 'package:diplom/widgets/screens/eco_rate_result_screen.dart';
import 'package:diplom/widgets/screens/main_screen/main_screen.dart';
import 'package:diplom/widgets/screens/splash_screen.dart';
import 'package:flutter/material.dart' show Widget, BuildContext;

part 'paths.dart';

typedef RouteNaming = Widget Function(BuildContext context);

class AppRoutes {
  static Map<String, Widget Function(BuildContext)> getRoutes(
          BuildContext context) =>
      {
        Paths.splash: (context) => const SplashScreen(),
        Paths.main: (context) => const MainScren(),
        Paths.ecoRateResult: (context) => const EcoRateResultScreen()
      };
}
