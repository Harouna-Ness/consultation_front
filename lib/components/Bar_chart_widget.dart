import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:medstory/components/box.dart';
import 'package:medstory/constantes.dart';

class BarChartWidget extends StatelessWidget {
  final String title;
  final Map<String, int> data;
  final List<BarChartGroupData> Function() buildBarGroups;
  final Widget Function(double, TitleMeta) getBottomTitles;

  const BarChartWidget({
    super.key,
    required this.title,
    required this.data,
    required this.buildBarGroups,
    required this.getBottomTitles,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Box(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            Expanded(
              child: data.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : BarChart(
                      BarChartData(
                        maxY: data.values
                                .reduce((a, b) => a > b ? a : b)
                                .toDouble() +
                            10,
                        barGroups: buildBarGroups(),
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          rightTitles: const AxisTitles(),
                          topTitles: const AxisTitles(),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              reservedSize: 30,
                              showTitles: true,
                              getTitlesWidget: (value, meta) => Text(
                                value.toString(),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              reservedSize: 23,
                              showTitles: true,
                              getTitlesWidget: getBottomTitles,
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
