import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class ConsultationStatPathoGraph extends StatefulWidget {
  final Map<String, Map<String, int>> stats;
  const ConsultationStatPathoGraph({super.key, required this.stats});

  @override
  State<ConsultationStatPathoGraph> createState() =>
      _ConsultationStatPathoGraphState();
}

class _ConsultationStatPathoGraphState
    extends State<ConsultationStatPathoGraph> {
  late List<String> dates;
  late List<String> motifs; // Liste des motifs de consultation

  @override
  void initState() {
    super.initState();
    _calculateDatesAndMotifs();
  }

  @override
  void didUpdateWidget(covariant ConsultationStatPathoGraph oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stats != widget.stats) {
      _calculateDatesAndMotifs();
    }
  }

  void _calculateDatesAndMotifs() {
    // Récupérer toutes les dates présentes dans les statistiques
    Set<String> dateSet = {};
    widget.stats.forEach((motif, dateMap) {
      dateSet.addAll(dateMap.keys);
    });
    dates = dateSet.toList()..sort((a, b) => a.compareTo(b));

    // La liste des motifs est simplement la liste des clés
    motifs = widget.stats.keys.toList();
  }

  @override
  Widget build(BuildContext context) {
    // Générer une ligne pour chaque motif
    List<LineChartBarData> lineBarsData = widget.stats.entries.map((entry) {
      String motif = entry.key;
      // Pour chaque date dans la liste "dates", récupérer le nombre de consultations (0 si aucun)
      List<FlSpot> spots = dates.asMap().entries.map((e) {
        int index = e.key;
        String dateStr = e.value;
        double count = entry.value.containsKey(dateStr)
            ? entry.value[dateStr]!.toDouble()
            : 0;
        return FlSpot(index.toDouble(), count);
      }).toList();

      // Déterminer la couleur pour ce motif en fonction de son index
      int motifIndex = motifs.indexOf(motif);
      Color color =
          Colors.primaries[(motifIndex + 1) % Colors.primaries.length];

      return LineChartBarData(
        spots: spots,
        isCurved: true,
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
          borderData:
              FlBorderData(show: false), // Pas de border autour du graph
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
                  String motifName = motifs[touchedSpot.barIndex];
                  // Affiche le nom du motif et la valeur (nombre)
                  return LineTooltipItem(
                      "$motifName: ${touchedSpot.y.toInt()}", textStyle);
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
                    // On suppose que les dates sont au format ISO et on les convertit en "dd/MM"
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
