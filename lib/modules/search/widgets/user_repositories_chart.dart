import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class UserRepositoriesChart extends StatelessWidget {
  final List<int> repositoryCounts;

  const UserRepositoriesChart({super.key, required this.repositoryCounts});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 24),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(show: false),
              barGroups: repositoryCounts.asMap().entries.map((entry) {
                return BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: entry.value.toDouble(),
                      width: 16,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
