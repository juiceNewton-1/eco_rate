import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartWidget extends StatelessWidget {
  final List<FlSpot> coSpots;
  final List<FlSpot> so2Spots;
  final List<FlSpot> no2Spots;
  final List<FlSpot> o3Spots;
  final List<FlSpot> pm25Spots;
  final List<FlSpot> pm10Spots;
  const LineChartWidget({
    super.key,
    required this.coSpots,
    required this.so2Spots,
    required this.no2Spots,
    required this.o3Spots,
    required this.pm25Spots,
    required this.pm10Spots,
  });

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        backgroundColor: Colors.grey[200],
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            
            tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
          ),
        ),
        lineBarsData: [
                    LineChartBarData(
            isCurved: true,
            color: Colors.green,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),

            spots: coSpots,
            // Толщина линии
          ),
                  LineChartBarData(
            isCurved: true,
            color: Colors.purple,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),

            spots: so2Spots,
            // Толщина линии
          ),
         LineChartBarData(
            isCurved: true,
            color: Colors.cyan,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),

            spots: no2Spots,
            // Толщина линии
          ),
       LineChartBarData(
            isCurved: true,
            color: Colors.blue,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),

            spots: o3Spots,
            // Толщина линии
          ),
          LineChartBarData(
            isCurved: true,
            color: Colors.yellow,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),

            spots: pm25Spots,
            // Толщина линии
          ),
          LineChartBarData(
            isCurved: true,
            color: Colors.pink,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),

            spots: pm10Spots,
            // Толщина линии
          ),
        ],
        minX: 1, // Минимальное значение по оси x
        maxX: 24, // Максимальное значение по оси x
        minY: 0, // Минимальное значение по оси y
        maxY: 450, // Максимальное значение по оси y
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            axisNameWidget: const Text('Время'),
          ),
          leftTitles: AxisTitles(
              axisNameWidget: const Text('Концентрация ЗВ, мкг/м3'),
              axisNameSize: 30),
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(color: Colors.black, width: 4),
            left: BorderSide(color: Colors.black, width: 4),
            right: BorderSide(color: Colors.black, width: 4),
            top: BorderSide(color: Colors.black, width: 4),
          ),
        ),
        gridData: FlGridData(
          show: false,
        ),
      ),
    );
  }
}


