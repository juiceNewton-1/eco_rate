import 'package:diplom/controllers/logic_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScren extends StatelessWidget {
  const MainScren({super.key});

  @override
  Widget build(BuildContext context) {
    final _logicController = context.read<LogicController>();
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: _logicController.getUserPosition(),
          builder: (context, snpashot) {
            if (snpashot.hasData) {
              return Text(snpashot.data!.latitude.toString());
            } else if (snpashot.hasError) {
              return GestureDetector();
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
