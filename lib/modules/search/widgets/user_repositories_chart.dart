import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class UserRepositoriesChart extends StatelessWidget {
  final List<int> repositoryCounts;

  const UserRepositoriesChart({
    super.key,
    required this.repositoryCounts,
  });

  @override
  Widget build(BuildContext context) {
    if (repositoryCounts.isEmpty) {
      return const Center(child: Text('Nenhum dado de commits para exibir.'));
    }

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceEvenly,
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index >= 0 && index < repositoryCounts.length) {
                    return Text('${index + 1}');
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: repositoryCounts.asMap().entries.map((entry) {
            final index = entry.key;
            final count = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: count.toDouble(),
                  width: 16,
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
