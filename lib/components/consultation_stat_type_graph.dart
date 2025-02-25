import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class ConsultationStatTypeGraph extends StatefulWidget {
  final Map<String, Map<String, int>> stats;

  const ConsultationStatTypeGraph({super.key, required this.stats});

  @override
  State<ConsultationStatTypeGraph> createState() =>
      _ConsultationStatTypeGraphState();
}

class _ConsultationStatTypeGraphState extends State<ConsultationStatTypeGraph> {
  late List<String> dates;
  late List<String> types; // Liste des types de consultation

  @override
  void initState() {
    super.initState();
    _calculateDates();
  }

  void _calculateDates() {
    // Récupérer toutes les dates présentes dans les statistiques
    Set<String> dateSet = {};
    widget.stats.forEach((type, dateMap) {
      dateSet.addAll(dateMap.keys);
    });
    dates = dateSet.toList()..sort((a, b) => a.compareTo(b));
    types = widget.stats.keys.toList();
  }

  // Cette méthode sera appelée quand le widget reçoit de nouvelles statistiques
  @override
  void didUpdateWidget(covariant ConsultationStatTypeGraph oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stats != widget.stats) {
      _calculateDates();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Générer une ligne pour chaque type
    List<LineChartBarData> lineBarsData = widget.stats.entries.map((entry) {
      String type = entry.key;
      // Pour chaque date dans dates, récupérer le count pour ce type (0 s'il n'y a pas de donnée)
      List<FlSpot> spots = dates.asMap().entries.map((e) {
        int index = e.key;
        String dateStr = e.value;
        double count = entry.value[dateStr]?.toDouble() ?? 0;
        // Utiliser l'index comme x
        return FlSpot(index.toDouble(), count);
      }).toList();

      // Utilisation d'une couleur basée sur l'index du type
      int typeIndex = widget.stats.keys.toList().indexOf(type);
      Color color = Colors.primaries[typeIndex + 1 % Colors.primaries.length];

      return LineChartBarData(
        spots: spots,
        isCurved: false,
        barWidth: 3,
        color: color,
        dotData: const FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: LineChart(
        LineChartData(
          borderData: FlBorderData(show: false), // Désactivation du border
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (touchedSpot) =>
                  Colors.grey.shade300.withOpacity(0.8),
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((touchedSpot) {
                  final textStyle = TextStyle(
                    color: touchedSpot.bar.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  );

                  String typeName = types[touchedSpot
                      .barIndex]; // Utilise l'index de la barre pour récupérer le type
                  return LineTooltipItem(
                      "$typeName: ${touchedSpot.y.toInt()}", textStyle);
                }).toList();
              },
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              axisNameSize: 30,
              sideTitles: SideTitles(
                reservedSize: 30,
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                reservedSize: 23,
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index >= 0 && index < dates.length) {
                    // Formater la date (par exemple, jour/mois)
                    DateTime date = DateTime.parse(dates[index]);
                    String label = DateFormat('dd/MM').format(date);
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(
                        label,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          minX: 0,
          maxX: dates.isNotEmpty ? (dates.length - 1).toDouble() : 0,
          lineBarsData: lineBarsData,
        ),
      ),
    );
  }
}
