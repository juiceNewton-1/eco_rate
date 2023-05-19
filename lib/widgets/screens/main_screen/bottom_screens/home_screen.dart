import 'dart:async' show StreamSubscription;

import 'package:diplom/controllers/logic_controller.dart';
import 'package:diplom/models/air_pollution_model.dart';
import 'package:diplom/models/user_position_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final LogicController _logicController;
  late final AnimationController _animationController;
  @override
  void initState() {
    _animationController = AnimationController(vsync: this);
    _logicController = context.read<LogicController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FutureBuilder(
            future: _logicController.getCommonData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final userPostition =
                    snapshot.data!['userPosition'] as UserPositionModel;
                final aitPollutionModel =
                    snapshot.data!['airPollutionModel'] as AirPollutionModel;
                return Column(
                  children: [
                    Text(userPostition.cityName),
                    Text(aitPollutionModel.co[0].toString())
                  ],
                );
              } else if (snapshot.hasError) {
                return const Text('Error');
              } else {
                return const CircularProgressIndicator();
              }
            }),
        StreamBuilder(
          stream: _logicController.noiseStream,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? Container(
                    width: 100,
                    height: 100,
                    color: Color.lerp(Colors.green, Colors.red,
                        snapshot.data!.meanDecibel / 120),
                  )
                : const CircularProgressIndicator();
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
