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
    with TickerProviderStateMixin {
  late final AnimationController _fillColorAnimationController;
  late Animation<double> _fillColorAnimation;
  late final AnimationController _showTextController;
  late Animation<double> _showTextAnimation;
  late final AnimationController _moveUpController;
  late Animation<Offset> _moveUpAnimation;

  double? ecoRateValue;
  double _textOpacity = 0.0;
  late final Map<String, dynamic> args;

  @override
  void initState() {
    super.initState();
    _fillColorAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _fillColorAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _fillColorAnimationController,
      curve: Curves.easeInOut,
    ));
    _showTextController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _moveUpController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fillColorAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _textOpacity = 1.0;
        });
        _showTextAnimation =
            Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: _showTextController,
          curve: Curves.easeInOut,
        ));
        _moveUpController.forward();
      }
    });

    _fillColorAnimationController.forward();
  }

  String getEcoRateCharacteristic() {
    if (ecoRateValue! < 0.2) {
      return ' Очень плохо';
    }
    if (ecoRateValue! >= 0.2 && ecoRateValue! <= 0.37) {
      return 'Плохо';
    }
    if (ecoRateValue! > 0.37 && ecoRateValue! <= 0.63) {
      return 'Удовлетворительно';
    }
    if (ecoRateValue! > 0.63 && ecoRateValue! <= 0.8) {
      return 'Хорошо';
    }
    return 'Очень хорошо';
  }

  @override
  void dispose() {
    _fillColorAnimationController.dispose();
    _moveUpController.dispose();
    _showTextController.dispose();
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
    ecoRateValue = _logicController.calculateEcoRate(
        noiseValue, treesQuantity, airPollutionModel, userAreaType);
    final fillColor = Color.lerp(Colors.red, Colors.green, ecoRateValue!);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          PositionedTransition(
            rect: RelativeRectTween(
              begin: const RelativeRect.fromLTRB(0, 0, 0, 0),
              end: const RelativeRect.fromLTRB(0, -500, 0, 0),
            ).animate(_moveUpController),
            child: GestureDetector(
              onTap: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      5,
                      (index) => SizedBox(
                        height: 50,
                        child: ListTile(
                          title: Text(
                            'Состояние территории#${index + 1}',
                            style: TextStyle(
                              color: Color.lerp(
                                Colors.red,
                                Colors.green,
                                (index + 1) / 5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _fillColorAnimationController,
                    builder: (context, child) => CustomPaint(
                      painter: CircleIndicator(
                        fillColor: fillColor!,
                        fillValue: _fillColorAnimation.value,
                      ),
                      size: const Size(100, 100),
                    ),
                  ),
                  Text(ecoRateValue.toString().substring(0, 4))
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          AnimatedOpacity(
            opacity: _textOpacity,
            duration: const Duration(milliseconds: 700),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Общее состояние территории: ${getEcoRateCharacteristic()}',
                  style: TextStyle(color: fillColor),
                ),
                const SizedBox(height: 20),
                Text('Количество зеленых насаждений - $treesQuantity%'),
                const SizedBox(height: 20),
                Text('Общий уровень шума - ${noiseValue.toStringAsFixed(2)} dB'),
                const SizedBox(
                  height: 100,
                ),
                Container(
                  width: 300,
                  height: 300,
                  color: Colors.black,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(onPressed: () {}, child: const Text('Отчет')),
                    TextButton(
                      onPressed: Navigator.of(context).pop,
                      child: const Text('Закрыть'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
