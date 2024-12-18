import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:medstory/service/consultation_service.dart';

class ConsultationMotifPage extends StatefulWidget {
  const ConsultationMotifPage({super.key});

  @override
  _ConsultationMotifPageState createState() => _ConsultationMotifPageState();
}

class _ConsultationMotifPageState extends State<ConsultationMotifPage> {
  final ConsultationService _consultationService = ConsultationService();
  DateTimeRange selectedRange = DateTimeRange(
    start: DateTime.now().subtract(Duration(days: 30)),
    end: DateTime.now().add(Duration(days: 2)),
  );

  Map<String, List<Map<String, dynamic>>> dataByMotif = {};
  Map<String, int> totalByMotif = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchConsultations();
  }

  Future<void> _fetchConsultations() async {
    setState(() => isLoading = true);

    try {
      final data = await _consultationService.fetchConsultationsByMotif(
        startDate: selectedRange.start,
        endDate: selectedRange.end,
      );

      // Conversion explicite
      Map<String, List<Map<String, dynamic>>> formattedDataByMotif = {};
      data['dataByMotif'].forEach((key, value) {
        formattedDataByMotif[key] = List<Map<String, dynamic>>.from(
            value.map((item) => Map<String, dynamic>.from(item)));
      });

      Map<String, int> formattedTotalByMotif =
          Map<String, int>.from(data['totalByMotif']);

      setState(() {
        dataByMotif = formattedDataByMotif;
        totalByMotif = formattedTotalByMotif;
        isLoading = false;
      });
    } catch (e) {
      print('Erreur: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: selectedRange,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedRange = picked;
      });
      _fetchConsultations();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Répartition des Consultations'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: _selectDateRange,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: LineChartWidget(dataByMotif: dataByMotif),
                ),
                Container(
                  height: 80,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: totalByMotif.entries.map((entry) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                entry.key,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('${entry.value} consultations'),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
    );
  }
}

class LineChartWidget extends StatelessWidget {
  final Map<String, List<Map<String, dynamic>>> dataByMotif;

  LineChartWidget({required this.dataByMotif});

  // List<LineChartBarData> _buildLineBarsData(List<Color> colors) {
  //   int index = 0;

  //   return dataByMotif.entries.map((entry) {
  //     List<FlSpot> spots = entry.value.map((point) {
  //       DateTime date = DateTime.parse(point['date']);
  //       double y = (point['count'] as int).toDouble();
  //       return FlSpot(date.millisecondsSinceEpoch.toDouble(), y);
  //     }).toList();

  //     return LineChartBarData(
  //       spots: spots,
  //       isCurved: true,
  //       barWidth: 3,
  //       color: colors[index++ % colors.length],
  //       belowBarData: BarAreaData(show: false),
  //       dotData: FlDotData(show: false),
  //     );
  //   }).toList();
  // }

  List<LineChartBarData> _buildLineBarsData(List<Color> colors) {
    int index = 0;

    return dataByMotif.entries.map((entry) {
      List<FlSpot> spots = entry.value.map((point) {
        DateTime date;

        // Vérifier le type de point['date'] et le convertir correctement
        if (point['date'] is int) {
          date = DateTime.fromMillisecondsSinceEpoch(point['date']);
        } else if (point['date'] is String) {
          date = DateTime.parse(point['date']);
        } else {
          throw Exception("Format de date inattendu : ${point['date']}");
        }

        double y = (point['count'] as int).toDouble();
        return FlSpot(date.millisecondsSinceEpoch.toDouble(), y);
      }).toList();

      return LineChartBarData(
        spots: spots,
        isCurved: true,
        barWidth: 3,
        color: colors[index++ % colors.length],
        belowBarData: BarAreaData(show: false),
        dotData: FlDotData(show: false),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LineChart(
        LineChartData(
          lineBarsData: _buildLineBarsData(colors),
          titlesData: FlTitlesData(
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, TitleMeta meta) {
                    DateTime date =
                        DateTime.fromMillisecondsSinceEpoch(value.toInt());
                    return Text("${date.day}/${date.month}");
                  },
                ),
              )),
        ),
      ),
    );
  }
}
