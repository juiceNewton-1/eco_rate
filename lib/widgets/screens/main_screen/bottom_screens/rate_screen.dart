import 'package:diplom/constants/area_type.dart';
import 'package:diplom/constants/enums.dart';
import 'package:diplom/controllers/logic_controller.dart';
import 'package:diplom/models/air_pollution_model.dart';
import 'package:diplom/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RateScreen extends StatefulWidget {
  const RateScreen({super.key});

  @override
  State<RateScreen> createState() => _RateScreenState();
}

class _RateScreenState extends State<RateScreen> {
  UserAreaType userAreaType = UserAreaType.residential;
  String? treesQuantity;
  double? noiseValue;
  AirPollutionModel? airPollutionModel;

  @override
  Widget build(BuildContext context) {
    final _logicController = context.read<LogicController>();
    return Center(
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FutureBuilder(
                    future: _logicController.getCommonData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        airPollutionModel = snapshot.data!['airPollutionModel'];

                        return const Text(
                          '✅ Данные по загрязнению воздуха получены',
                          textAlign: TextAlign.center,
                        );
                      } else {
                        return const Text('Получение данных по загрязнению...');
                      }
                    },
                  ),
                  FutureBuilder(
                    future: _logicController.getMeanNoiseValueFromLimit(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        noiseValue = snapshot.data;
                        print(noiseValue);
                        return Text(
                            '✅ Уровень шума получен: ${noiseValue!.ceil()} dB');
                      } else {
                        return const Text('Получение уровня шума...');
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text('Тип территории'),
                  const SizedBox(height: 10),
                  DropdownButtonFormField(
                    value: AreaType.areaTypeNames[userAreaType],
                    items: List.generate(
                      AreaType.areaTypeNames.length,
                      (index) {
                        final areaValue =
                            AreaType.areaTypeNames.values.toList()[index];
                        return DropdownMenuItem(
                          value: areaValue,
                          child: Text(areaValue),
                        );
                      },
                    ),
                    onChanged: (value) {
                      if (value != null) {
                        userAreaType = AreaType.areaTypeNames.entries
                            .where((element) => element.value == value)
                            .first
                            .key;
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Обеспеченность зелеными насаждениями, %',
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (value) {
                        if (value != treesQuantity) {
                          setState(() {
                            treesQuantity = value;
                          });
                        }
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (treesQuantity != null &&
                          airPollutionModel != null &&
                          noiseValue != null) {
                        final treesQuantityInt = int.parse(treesQuantity!);
                        Navigator.of(context).pop();
                        final ecoRateModel = _logicController.calculateEcoRate(
                            noiseValue!,
                            treesQuantityInt,
                            airPollutionModel!,
                            userAreaType);
                        Navigator.of(context).pushNamed(
                          Paths.ecoRateResult,
                          arguments: {
                            'airPollutionModel': airPollutionModel,
                            'ecoRateModel': ecoRateModel,
                          },
                        );
                      }
                    },
                    child: const Text('Расчет'),
                  )
                ],
              ),
            ),
          );
        },
        child: const Text('Начать расчет'),
      ),
    );
  }
}
