import 'package:diplom/controllers/logic_controller.dart';
import 'package:diplom/routes/app_routes.dart';
import 'package:flutter/material.dart';
import "package:provider/provider.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final routes = AppRoutes.getRoutes(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LogicController>(
            create: (_) => LogicController())
      ],
      child: MaterialApp(
        theme: ThemeData(useMaterial3: true),
        debugShowCheckedModeBanner: false,
        routes: routes,
        onGenerateRoute: (settings) => PageRouteBuilder(
            settings: settings,
            pageBuilder: (context, animation, secondaryAnimation) {
              final RouteNaming pageContentBuilder = routes[settings.name]!;
              return pageContentBuilder(context);
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 500)),
      ),
    );
  }
}
