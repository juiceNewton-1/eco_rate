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
                        print(airPollutionModel);
                        return const Text(
                            'данные по загрязнению воздуха получены');
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                  FutureBuilder(
                    future: _logicController.getMeanNoiseValueFromLimit(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        noiseValue = snapshot.data;
                        print(noiseValue);
                        return Text('Уровень шума: ${noiseValue!.ceil()} dB');
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
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
                    'Обеспеченность зелеными насаждениями',
                    textAlign: TextAlign.center,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    onFieldSubmitted: (value) {
                      if (value != treesQuantity) {
                        setState(() {
                          treesQuantity = value;
                        });
                      }
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (treesQuantity != null &&
                          airPollutionModel != null &&
                          noiseValue != null) {
                        final treesQuantityInt = int.parse(treesQuantity!);
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed(
                          Paths.ecoRateResult,
                          arguments: {
                            'airPollutionModel': airPollutionModel,
                            'treesQuantity': treesQuantityInt,
                            'noiseValue': noiseValue,
                            'userAreaType': userAreaType
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
