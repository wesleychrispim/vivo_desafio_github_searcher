import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class UserRepositoriesChart extends StatelessWidget {
  final List<int> repositoryCounts;
  final List<String> repositoryNames;

  const UserRepositoriesChart({
    super.key,
    required this.repositoryCounts,
    required this.repositoryNames,
  });

  @override
  Widget build(BuildContext context) {
    if (repositoryCounts.isEmpty) {
      return const Center(child: Text('Sem dados de commits.'));
    }

    return AspectRatio(
      aspectRatio: 1.5,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < repositoryNames.length) {
                    final name = repositoryNames[index];
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(
                        name.length > 6 ? '${name.substring(0, 6)}...' : name,
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
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
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
