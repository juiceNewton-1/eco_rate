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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LogicController>(
            create: (_) => LogicController())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: AppRoutes.getRoutes(context),
      ),
    );
  }
}
