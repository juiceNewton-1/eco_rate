import 'dart:math';

import 'package:diplom/constants/enums.dart';
import 'package:diplom/controllers/logic_controller.dart';
import 'package:diplom/models/air_pollution_model.dart';
import 'package:diplom/widgets/components/circle_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EcoRateResultScreen extends StatefulWidget {
  const EcoRateResultScreen({Key? key}) : super(key: key);

  @override
  State<EcoRateResultScreen> createState() => _EcoRateResultScreenState();
}

class _EcoRateResultScreenState extends State<EcoRateResultScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _logicController = context.read<LogicController>();
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final noiseValue = arguments['noiseValue'] as double;
    final airPollutionModel =
        arguments['airPollutionModel'] as AirPollutionModel;
    final treesQuantity = arguments['treesQuantity'] as int;
    final userAreaType = arguments['userAreaType'] as UserAreaType;

    return Scaffold(
      body: Center(
        child: FutureBuilder<double>(
          future: Future(
            () => _logicController.calculateEcoRate(
              noiseValue,
              treesQuantity,
              airPollutionModel,
              userAreaType,
            ),
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {

              final color =
                  Color.lerp(Colors.red, Colors.green, snapshot.data!);
              return Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) => CustomPaint(
                      painter: CircleIndicator(
                        fillColor: color!,
                        fillValue: _animation.value,
                      ),
                      size: const Size(100, 100),
                    ),
                  ),
                  Text(snapshot.data!.toString().substring(0,4))
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
