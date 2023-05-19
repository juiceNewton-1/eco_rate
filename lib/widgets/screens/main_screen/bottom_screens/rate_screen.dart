import 'package:diplom/controllers/logic_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RateScreen extends StatelessWidget {
  const RateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _logicController = context.read<LogicController>();
    return Center(
      child: FutureBuilder(
          future: _logicController.getMeanNoiseValueFromLimit(),
          builder: (context, snapshot) {
            return Text(snapshot.data.toString());
          }),
    );
  }
}
