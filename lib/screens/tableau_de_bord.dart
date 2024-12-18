import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:medstory/components/Bar_chart_widget.dart';
import 'package:medstory/components/box.dart';
import 'package:medstory/components/customGrid.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/controllers/resposive.dart';
import 'package:medstory/models/consultation.dart';
import 'package:medstory/service/consultation_service.dart';
import 'package:medstory/service/dio_client.dart';
import 'package:medstory/service/patient_service.dart';

class TableauDeBord extends StatefulWidget {
  const TableauDeBord({super.key});

  @override
  State<TableauDeBord> createState() => _TableauDeBordState();
}

class _TableauDeBordState extends State<TableauDeBord> {
  final patientService = PatientService();
  final _consultationService = ConsultationService();
  List<Consultation> consultations = [];
  DateTimeRange? selectedRange;
  Map<String, List<int>> motifData = {};
  Map<String, int> motifTotals = {};

  int nbrPatient = -1;
  double moyenneAge = -1;
  int ageEleve = -1;
  int ageBas = -1;
  Map<String, int> data = {};
  Map<String, int> patientStatistics = {};
  Map<String, int> patientBySite = {};
  Map<String, int> patientByProfession = {};
  Map<String, int> patientByTypeDeContrat = {};
  final List<Color> colors = [
    primaryColor,
    tertiaryColor,
    Colors.red,
    Colors.blue,
    Colors.purple,
    Colors.cyan
  ];

  @override
  void initState() {
    super.initState();
    _loadDataNbrPatient();
    _loadDataMoyenneAge();
    _loadDataAgeEleveBas();
    _loadData();
    _loadDataSite();
    fetchPatientStatistics();
    _loadDataProfession();
    _loadDataTypeDeContrat();
    _fetchConsultations();
  }

  Future<void> _loadData() async {
    final fetchedData = await patientService.fetchStatistics();
    setState(() {
      data = fetchedData;
    });
  }

  Future<void> _loadDataNbrPatient() async {
    final fetchedData = await patientService.getPatientCount();
    setState(() {
      nbrPatient = fetchedData;
    });
  }

  Future<void> _loadDataMoyenneAge() async {
    final fetchedData = await patientService.getAllmoyenneAge();
    setState(() {
      moyenneAge = fetchedData;
    });
  }

  Future<void> _loadDataAgeEleveBas() async {
    final fetchedData = await patientService.getAgeRange();
    setState(() {
      ageEleve = fetchedData['maxAge'] ?? -1;
      ageBas = fetchedData['minAge'] ?? -1;
    });
  }

  Future<void> _loadDataSite() async {
    final fetchedData = await patientService.fetchPatientsBySite();
    setState(() {
      patientBySite = fetchedData;
    });
  }

  Future<void> _loadDataProfession() async {
    final fetchedData = await patientService.getPatientsByProfession();
    setState(() {
      patientByProfession = fetchedData;
    });
  }

  Future<void> _loadDataTypeDeContrat() async {
    final fetchedData = await patientService.getPatientsByTypeDeContrat();
    setState(() {
      patientByTypeDeContrat = fetchedData;
    });
  }

  List<PieChartSectionData> _buildPieSections() {
    final hommes = data['Masculin'] ?? 0;
    final femmes = data['Féminin'] ?? 0;

    return [
      PieChartSectionData(
        showTitle: true,
        color: primaryColor,
        value: hommes.toDouble(),
        title: 'Homme',
        radius: 40,
        titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
      ),
      PieChartSectionData(
        showTitle: true,
        color: tertiaryColor,
        value: femmes.toDouble(),
        title: 'Femme',
        radius: 40,
        titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
      ),
    ];
  }

  Future<void> fetchPatientStatistics() async {
    final response =
        await DioClient.dio.get("statistics/patients-by-direction");

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data as Map<String, dynamic>;
      print("object::::::: ${response.data}");
      print("object:::::: $data");
      // Map<String, dynamic> data = json.decode(response.data);
      setState(() {
        patientStatistics = data.map((key, value) => MapEntry(
            key,
            value
                as int)); // data.map((key, value) => MapEntry(key, (value as num).toInt()));
      });
      print(patientStatistics);
    } else {
      throw Exception('Failed to load statistics');
    }
  }

  Future<void> _fetchConsultations() async {
    try {
      // Définir une plage par défaut si aucune n'est sélectionnée
      selectedRange ??= DateTimeRange(
        start: DateTime.now()
            .subtract(const Duration(days: 15)), // 15 derniers jours
        end: DateTime.now().add(const Duration(days: 15)),
      );

      // Récupération des données avec la plage sélectionnée ou par défaut
      List<Consultation> fetchedData =
          await _consultationService.fetchConsultations(range: selectedRange);

      setState(() {
        consultations = fetchedData;
        _processData();
      });
    } catch (e) {
      print("Erreur lors de la récupération des consultations : $e");
    }
  }

  void _processData() {
    DateTime startDate = selectedRange?.start ?? DateTime(2024, 1, 1);
    DateTime endDate = selectedRange?.end ?? DateTime(2024, 12, 31);

    for (var consultation in consultations) {
      String motif = consultation.motifDeConsultation!.motif ?? "Autre";
      DateTime date = consultation.creationDate ?? DateTime.now();

      if (date.isAfter(startDate) && date.isBefore(endDate)) {
        int month = date.month;
        motifData[motif] ??= List<int>.filled(12, 0);
        motifData[motif]![month - 1]++;
      }

      motifTotals[motif] = (motifTotals[motif] ?? 0) + 1;
    }
  }

  Future<void> _selectDateRange() async {
    DateTimeRange? pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: selectedRange,
    );

    if (pickedRange != null) {
      setState(() {
        selectedRange = pickedRange;
        _fetchConsultations();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size =
        MediaQuery.of(context).size; // Pour connaitre la taille de l'ecran.

    // Pour connaitre les totaux.
    List<Widget> totaux = [
      Box(
        padding: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nombre de patients",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
            ),
            Text(
              nbrPatient == -1 ? "-" : nbrPatient.toString(),
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
            ),
          ],
        ),
      ),
      Box(
        padding: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Moyenne d'âge",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
            ),
            Text(
              moyenneAge == -1 ? "-" : moyenneAge.toStringAsFixed(2),
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
            ),
          ],
        ),
      ),
      Box(
        padding: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Âge le plus bas",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
            ),
            Text(
              ageBas == -1 ? "-" : ageBas.toString(),
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
            ),
          ],
        ),
      ),
      Box(
        padding: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Âge le plus élevé",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
            ),
            Text(
              ageEleve == -1 ? "-" : ageEleve.toString(),
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
            ),
          ],
        ),
      ),
    ];

    // Section totaux et repartition par sex.
    List<Widget> sectionA = [
      Responsive(
        // Totaux
        mobile: CustomGridView(
          crossAxisCount: 1,
          childAspectRatio: size.width < 650 ? 4.1 : 4.9,
          screens: totaux,
        ),
        tablet: CustomGridView(
          crossAxisCount: 2,
          childAspectRatio: 4.1,
          screens: totaux,
        ),
        desktop: CustomGridView(
          crossAxisCount: 2,
          childAspectRatio: 3.1,
          screens: totaux,
        ),
      ),
      // Repartition par sexe.
      Box(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Patients par sexe",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: data.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // PieChart Section
                          SizedBox(
                            height: 200,
                            width: 200,
                            child: PieChart(
                              PieChartData(
                                sections: _buildPieSections(),
                                sectionsSpace: 2,
                                centerSpaceRadius: 30,
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const CircleAvatar(
                                        radius: 5,
                                        backgroundColor: tertiaryColor),
                                    const SizedBox(width: 8),
                                    Text(
                                      data['Féminin'].toString(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const CircleAvatar(
                                        radius: 5,
                                        backgroundColor: primaryColor),
                                    const SizedBox(width: 8),
                                    Text(
                                      data['Masculin'].toString(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    ];

    return SafeArea(
        child: SingleChildScrollView(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        children: [
          // Section totaux et repartion par sexe.
          Responsive(
            mobile: CustomGridView(
              crossAxisCount: 1,
              childAspectRatio: size.width < 650 ? 4.1 : 4.9,
              screens: sectionA,
            ),
            tablet: CustomGridView(
              crossAxisCount: 2,
              childAspectRatio: 4.1,
              screens: sectionA,
            ),
            desktop: CustomGridView(
              crossAxisCount: 2,
              childAspectRatio: 2.9,
              screens: sectionA,
            ),
          ),

          const SizedBox(
            height: defaultPadding,
          ),

          Responsive(
            mobile: CustomGridView(
              crossAxisCount: 1,
              childAspectRatio: size.width < 650 ? 1.7 : 2.1,
              screens: [
                Container(
                  color: Colors.grey,
                ),
                Container(
                  color: Colors.grey,
                ),
              ],
            ),
            tablet: CustomGridView(
              crossAxisCount: 2,
              childAspectRatio: 2.1,
              screens: [
                Container(
                  color: Colors.grey,
                ),
                Container(
                  color: Colors.grey,
                ),
              ],
            ),
            desktop: CustomGridView(
              crossAxisCount: 2,
              childAspectRatio: 2.1,
              screens: [
                // Section repartition par direction
                InkWell(
                  onTap: () => _showScrollableModal(
                    context: context,
                    data: patientStatistics,
                    title: "Patients par direction",
                  ),
                  child: BarChartWidget(
                    title: "Patients par direction",
                    data: patientStatistics,
                    buildBarGroups: _buildBarGroups1,
                    getBottomTitles: _getBottomTitles1,
                  ),
                ),

                // Section repartition par site
                InkWell(
                  onTap: () => _showScrollableModal(
                    context: context,
                    title: "Patients par site de travail",
                    data: patientBySite,
                  ),
                  child: BarChartWidget(
                    title: "Patients par site de travail",
                    data: patientBySite,
                    buildBarGroups: _buildSiteBarGroups1,
                    getBottomTitles: _getSiteBottomTitles1,
                  ),
                ),

                // Section repartition par profession
                InkWell(
                  onTap: () => _showScrollableModal(
                    context: context,
                    title: "Patients par fonction",
                    data: patientByProfession,
                  ),
                  child: BarChartWidget(
                    title: "Patients par fonction",
                    data: patientByProfession,
                    buildBarGroups: _buildProfessionBarGroups1,
                    getBottomTitles: _getProffessionBottomTitles1,
                  ),
                ),

                // Section repartition par type de contrat
                InkWell(
                  onTap: () => _showScrollableModal(
                    context: context,
                    title: "Patients par type de contrat",
                    data: patientByTypeDeContrat,
                  ),
                  child: BarChartWidget(
                    title: "Patients par type de contrat",
                    data: patientByTypeDeContrat,
                    buildBarGroups: _buildTypeDeContratBarGroups1,
                    getBottomTitles: _getTypeDeContratBottomTitles1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          // Graphe linear pour motif de consultation
          Box(
            child: SizedBox(
              height: 400,
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: LineChart(
                        LineChartData(
                          titlesData: const FlTitlesData(
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false,
                              ),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                              ),
                            ),
                            // bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true,),),
                          ),
                          lineBarsData: motifData.entries.map((entry) {
                            return LineChartBarData(
                              spots: entry.value
                                  .asMap()
                                  .entries
                                  .map((e) => FlSpot(
                                      e.key.toDouble() + 1, e.value.toDouble()))
                                  .toList(),
                              // isCurved: false,
                              // color: Colors.blue,
                              // barWidth: 4,
                              // dotData: const FlDotData(show: true),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: motifTotals.entries.map((entry) {
                        return Container(
                          padding: const EdgeInsets.all(8.0),
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: [
                              Text(entry.key,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Text(entry.value.toString(),
                                  style: const TextStyle(color: Colors.blue)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  // ::: groupe pour direction :::

  List<BarChartGroupData> _buildBarGroups1() {
    // Trier les entrées par valeur décroissante
    final sortedEntries = patientStatistics.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Séparer les 6 premiers et regrouper les autres
    final topEntries = sortedEntries.take(6).toList();
    final otherEntries = sortedEntries.skip(6).toList();

    // Calculer la somme des "Autres"
    if (otherEntries.isNotEmpty) {
      final otherCount =
          otherEntries.map((e) => e.value).reduce((a, b) => a + b);
      topEntries.add(MapEntry("Autres", otherCount));
    }

    // Construire les groupes de barres
    int index = 0;
    return topEntries.map((entry) {
      double count = entry.value.toDouble();
      Color color = colors[index % colors.length];
      index++;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: count,
            width: 30,
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }

  Widget _getBottomTitles1(double value, TitleMeta meta) {
    int index = value.toInt();

    // Trier les données et regrouper comme dans `_buildTypeDeContratBarGroups`
    final sortedEntries = patientStatistics.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topEntries = sortedEntries.take(6).toList();
    final otherEntries = sortedEntries.skip(6).toList();
    if (otherEntries.isNotEmpty) {
      final otherCount =
          otherEntries.map((e) => e.value).reduce((a, b) => a + b);
      topEntries.add(MapEntry("Autres", otherCount));
    }

    if (index >= 1 && index <= topEntries.length) {
      String fullName = topEntries[index - 1].key;
      String shortName =
          fullName.length > 10 ? '${fullName.substring(0, 10)}...' : fullName;

      return Transform.rotate(
        angle: -0.5, // Rotation de 45°
        child: Tooltip(
          message: fullName, // Infobulle pour le nom complet
          child: Text(
            shortName,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      );
    }
    return const Text('');
  }

  // ***

  // ::: groupe pour site :::
  List<BarChartGroupData> _buildSiteBarGroups1() {
    // Trier les entrées par valeur décroissante
    final sortedEntries = patientBySite.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Séparer les 6 premiers et regrouper les autres
    final topEntries = sortedEntries.take(6).toList();
    final otherEntries = sortedEntries.skip(6).toList();

    // Calculer la somme des "Autres"
    if (otherEntries.isNotEmpty) {
      final otherCount =
          otherEntries.map((e) => e.value).reduce((a, b) => a + b);
      topEntries.add(MapEntry("Autres", otherCount));
    }

    // Construire les groupes de barres
    int index = 0;
    return topEntries.map((entry) {
      double count = entry.value.toDouble();
      Color color = colors[index % colors.length];
      index++;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: count,
            width: 30,
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }

  Widget _getSiteBottomTitles1(double value, TitleMeta meta) {
    int index = value.toInt();

    // Trier les données et regrouper comme dans `_buildTypeDeContratBarGroups`
    final sortedEntries = patientBySite.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topEntries = sortedEntries.take(6).toList();
    final otherEntries = sortedEntries.skip(6).toList();
    if (otherEntries.isNotEmpty) {
      final otherCount =
          otherEntries.map((e) => e.value).reduce((a, b) => a + b);
      topEntries.add(MapEntry("Autres", otherCount));
    }

    if (index >= 1 && index <= topEntries.length) {
      String fullName = topEntries[index - 1].key;
      String shortName =
          fullName.length > 10 ? '${fullName.substring(0, 10)}...' : fullName;

      return Transform.rotate(
        angle: -0.5, // Rotation de 45°
        child: Tooltip(
          message: fullName, // Infobulle pour le nom complet
          child: Text(
            shortName,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      );
    }
    return const Text('');
  }

  // ***

  // ::: Groupe pour profession :::
  List<BarChartGroupData> _buildProfessionBarGroups1() {
    // Trier les entrées par valeur décroissante
    final sortedEntries = patientByProfession.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Séparer les 6 premiers et regrouper les autres
    final topEntries = sortedEntries.take(6).toList();
    final otherEntries = sortedEntries.skip(6).toList();

    // Calculer la somme des "Autres"
    if (otherEntries.isNotEmpty) {
      final otherCount =
          otherEntries.map((e) => e.value).reduce((a, b) => a + b);
      topEntries.add(MapEntry("Autres", otherCount));
    }

    // Construire les groupes de barres
    int index = 0;
    return topEntries.map((entry) {
      double count = entry.value.toDouble();
      Color color = colors[index % colors.length];
      index++;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: count,
            width: 30,
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }

  Widget _getProffessionBottomTitles1(double value, TitleMeta meta) {
    int index = value.toInt();

    // Trier les données et regrouper comme dans `_buildTypeDeContratBarGroups`
    final sortedEntries = patientByProfession.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topEntries = sortedEntries.take(6).toList();
    final otherEntries = sortedEntries.skip(6).toList();
    if (otherEntries.isNotEmpty) {
      final otherCount =
          otherEntries.map((e) => e.value).reduce((a, b) => a + b);
      topEntries.add(MapEntry("Autres", otherCount));
    }

    if (index >= 1 && index <= topEntries.length) {
      String fullName = topEntries[index - 1].key;
      String shortName =
          fullName.length > 10 ? '${fullName.substring(0, 10)}...' : fullName;

      return Transform.rotate(
        angle: -0.5, // Rotation de 45°
        child: Tooltip(
          message: fullName, // Infobulle pour le nom complet
          child: Text(
            shortName,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      );
    }
    return const Text('');
  }

  // ***

  // ::: Groupe pour type de contrat :::
  List<BarChartGroupData> _buildTypeDeContratBarGroups1() {
    // Trier les entrées par valeur décroissante
    final sortedEntries = patientByTypeDeContrat.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Séparer les 6 premiers et regrouper les autres
    final topEntries = sortedEntries.take(6).toList();
    final otherEntries = sortedEntries.skip(6).toList();

    // Calculer la somme des "Autres"
    if (otherEntries.isNotEmpty) {
      final otherCount =
          otherEntries.map((e) => e.value).reduce((a, b) => a + b);
      topEntries.add(MapEntry("Autres", otherCount));
    }

    // Construire les groupes de barres
    int index = 0;
    return topEntries.map((entry) {
      double count = entry.value.toDouble();
      Color color = colors[index % colors.length];
      index++;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: count,
            width: 30,
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }

  Widget _getTypeDeContratBottomTitles1(double value, TitleMeta meta) {
    int index = value.toInt();

    // Trier les données et regrouper comme dans `_buildTypeDeContratBarGroups`
    final sortedEntries = patientByTypeDeContrat.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topEntries = sortedEntries.take(6).toList();
    final otherEntries = sortedEntries.skip(6).toList();
    if (otherEntries.isNotEmpty) {
      final otherCount =
          otherEntries.map((e) => e.value).reduce((a, b) => a + b);
      topEntries.add(MapEntry("Autres", otherCount));
    }

    if (index >= 1 && index <= topEntries.length) {
      String fullName = topEntries[index - 1].key;
      String shortName =
          fullName.length > 10 ? '${fullName.substring(0, 10)}...' : fullName;

      return Transform.rotate(
        angle: -0.5, // Rotation de 45°
        child: Tooltip(
          message: fullName, // Infobulle pour le nom complet
          child: Text(
            shortName,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      );
    }
    return const Text('');
  }

  // ***

  // Modal pour afficher toutes les données
  Future<void> _showScrollableModal({
    BuildContext? context,
    required String title,
    required Map<String, int> data,
  }) {
    return showDialog(
      context: context!,
      builder: (context) {
        return Dialog(
          child: FractionallySizedBox(
            heightFactor: 0.85,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: data.length * 50, // Largeur dynamique
                        child: BarChart(
                          BarChartData(
                            maxY: data.values
                                    .reduce((a, b) => a > b ? a : b)
                                    .toDouble() +
                                10,
                            barGroups: _BuildBarGroups(
                                data), // Utilise toutes les données
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
                                  getTitlesWidget: (value, meta) {
                                    int index = value.toInt();
                                    if (index >= 1 && index <= data.length) {
                                      String fullName =
                                          data.keys.elementAt(index - 1);
                                      String shortName = fullName.length > 10
                                          ? '${fullName.substring(0, 10)}...'
                                          : fullName;

                                      return Transform.rotate(
                                        angle:
                                            -0.5, // Inclinaison des étiquettes
                                        child: Tooltip(
                                          message: fullName,
                                          child: Text(
                                            shortName,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    return const Text('');
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<BarChartGroupData> _BuildBarGroups(Map<String, int> _map) {
    int index = 0;
    return _map.entries.map((entry) {
      double count = entry.value.toDouble();
      Color color = colors[index % colors.length];
      index++;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: count,
            width: 30,
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }
}
