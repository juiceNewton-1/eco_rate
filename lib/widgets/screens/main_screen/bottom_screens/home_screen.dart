import 'package:diplom/controllers/logic_controller.dart';
import 'package:diplom/widgets/components/circle_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final LogicController _logicController;
  late final AnimationController _animationController;
  Animation<double>? _animation;
  double _currentNoiseLevel = 0.0;
  @override
  void initState() {
    _logicController = context.read<LogicController>();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _animation = Tween(begin: 0.0, end: 120.0).animate(_animationController);

    _animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder(
          stream: _logicController.noiseStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _currentNoiseLevel = snapshot.data!.meanDecibel;
              _animationController.animateTo(_currentNoiseLevel / 120);
              return Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: CircleIndicator(
                            fillColor: Color.lerp(
                              Colors.green,
                              Colors.red,
                              _currentNoiseLevel / 120,
                            )!,
                            fillValue: _currentNoiseLevel,
                            divisionValue: 120,
                          ),
                        );
                      },
                    ),
                  ),
                  Text('${_currentNoiseLevel.ceil()} dB')
                ],
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ],
    );
  }
}
