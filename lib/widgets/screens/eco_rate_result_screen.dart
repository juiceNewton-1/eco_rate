import 'package:diplom/controllers/logic_controller.dart';
import 'package:diplom/models/air_pollution_model.dart';
import 'package:diplom/models/eco_rate_model.dart';
import 'package:diplom/widgets/components/circle_indicator.dart';
import 'package:diplom/widgets/components/line_chart.dart';
import 'package:fl_chart/fl_chart.dart' show FlSpot;
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

  String getEcoRateCharacteristic(double ecoRateValue) {
    if (ecoRateValue < 0.2) {
      return ' Очень плохо';
    }
    if (ecoRateValue >= 0.2 && ecoRateValue <= 0.37) {
      return 'Плохо';
    }
    if (ecoRateValue > 0.37 && ecoRateValue <= 0.63) {
      return 'Удовлетворительно';
    }
    if (ecoRateValue > 0.63 && ecoRateValue <= 0.8) {
      return 'Хорошо';
    }
    return 'Очень хорошо';
  }

  List<String> terrirtoryConditionCharacteristics = [
    'Очень плохое состояние: менее 0.20',
    'Плохое состояние: 0.37-0.20',
    'Удовлетворительное состояние: 0.63-0.38',
    'Хорошее состояние: 0.80-0.63',
    'Очень хорошее состояние: 1.00-0.80'
  ];

  List<FlSpot> getSpots(List<double?> airPollutant) => List.generate(
        airPollutant.length,
        (index) => FlSpot(
          index + 1,
          airPollutant[index]!,
        ),
      );

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
    final ecoRateModel = arguments['ecoRateModel'] as EcoRateModel;
    final airPollutionModel =
        arguments['airPollutionModel'] as AirPollutionModel;

    final fillColor =
        Color.lerp(Colors.red, Colors.green, ecoRateModel.ecoRateValue);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          PositionedTransition(
            rect: RelativeRectTween(
              begin: const RelativeRect.fromLTRB(0, 0, 0, 0),
              end: const RelativeRect.fromLTRB(0, -600, 0, 0),
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
                            terrirtoryConditionCharacteristics[index],
                            textAlign: TextAlign.center,
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
                  Text(ecoRateModel.ecoRateValue.toString().substring(0, 4))
                ],
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: _textOpacity,
            duration: const Duration(milliseconds: 700),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Общее состояние территории: ${getEcoRateCharacteristic(ecoRateModel.ecoRateValue)}',
                    style: TextStyle(color: fillColor),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Text('ИЗА - ${ecoRateModel.IZA.toString().substring(0, 5)}'),
                  const SizedBox(height: 5),
                  Text(
                      'Количество зеленых насаждений - ${ecoRateModel.treesQuantity}%'),
                  const SizedBox(height: 5),
                  Text(
                      'Общий уровень шума - ${ecoRateModel.noiseValue.toStringAsFixed(2)} dB'),
                  const SizedBox(height: 10),
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20)),
                    height: 120,
                    width: double.infinity,
                    child: GridView.builder(
                        itemCount: 6,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 5, crossAxisCount: 3),
                        itemBuilder: (context, index) {
                          final colors = [
                            Colors.green,
                            Colors.purple,
                            Colors.cyan,
                            Colors.blue,
                            Colors.yellow,
                            Colors.pink
                          ];
                          final names = [
                            'CO',
                            'SO2',
                            'NO2',
                            'O3',
                            'PM2.5',
                            'PM10',
                          ];
                          return _ColorWitnNameLegend(
                            color: colors[index],
                            name: names[index],
                          );
                        }),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 300,
                    child: LineChartWidget(
                      coSpots: getSpots(airPollutionModel.co),
                      so2Spots: getSpots(airPollutionModel.so2),
                      no2Spots: getSpots(airPollutionModel.no2),
                      o3Spots: getSpots(airPollutionModel.o3),
                      pm25Spots: getSpots(airPollutionModel.pm25),
                      pm10Spots: getSpots(airPollutionModel.pm10),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
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
          ),
        ],
      ),
    );
  }
}

class _ColorWitnNameLegend extends StatelessWidget {
  final Color color;
  final String name;
  const _ColorWitnNameLegend(
      {required this.color, required this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(name),
        const SizedBox(width: 5),
        Container(
          width: 10,
          height: 3,
          color: color,
        ),
      ],
    );
  }
}
