// ignore_for_file: use_build_context_synchronously

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medstory/components/add_user_form.dart';
import 'package:medstory/components/box.dart';
import 'package:medstory/components/customGrid.dart';
import 'package:medstory/components/customTable.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/controllers/controller.dart';
import 'package:medstory/controllers/resposive.dart';
import 'package:medstory/models/my_data.dart';
import 'package:medstory/models/patient.dart';
import 'package:medstory/screens/dossier_patient.dart';
import 'package:medstory/service/patient_service.dart';
import 'package:medstory/utils/lodder.dart';
import 'package:provider/provider.dart';

class Patients extends StatefulWidget {
  const Patients({super.key});

  @override
  State<Patients> createState() => _PatientsState();
}

class _PatientsState extends State<Patients> {
  Patient? selectedPatient;
  final patientService = PatientService();
  bool showDossier = false;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    List<PieChartSectionData> pieChartSectionData = [
      PieChartSectionData(
        value: 25,
        color: primaryColor,
        showTitle: false,
        radius: 25,
      ),
      PieChartSectionData(
        value: 20,
        color: Color(0xFF26E5FF),
        showTitle: false,
        radius: 22,
      ),
      PieChartSectionData(
        value: 10,
        color: Color(0xFFFFCF26),
        showTitle: false,
        radius: 19,
      ),
      PieChartSectionData(
        value: 15,
        color: Color(0xFFEE2727),
        showTitle: false,
        radius: 16,
      ),
      PieChartSectionData(
        value: 25,
        color: primaryColor.withOpacity(0.1),
        showTitle: false,
        radius: 13,
      ),
    ];

    var screens = [
      InkWell(
        onTap: () {
          final parentContext = context;
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: FractionallySizedBox(
                  widthFactor:
                      0.8, // Ajuster la largeur pour que le dialog soit responsive
                  child: Padding(
                    padding: const EdgeInsets.all(16.0 * 2),
                    child: AddUserForm(
                      onSubmit: (formData) async {
                        context.showLoader();
                        // Afficher les données soumises
                        await patientService.addPatient(formData).then((value) {
                          parentContext.read<MyData>().getNombrePatient();
                          context.hideLoader();
                        }).catchError((onError) {
                          context.showError(onError.toString());
                        }).whenComplete(() {
                          context.showSuccess(
                              "Le patient a été ajouté avec succès.");
                          parentContext.read<MyMenuController>().changePage(1);
                        });
                      },
                      contexte: parentContext,
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: Container(
          decoration: const BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: .1,
                spreadRadius: .1,
                offset: Offset(0, 1),
                blurStyle: BlurStyle.outer,
                color: Colors.grey,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: size.width >= 310
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!(size.width >= 650 && size.width < 715))
                        SvgPicture.asset(
                          "assets/icons/personAdd.svg",
                          height: size.width < 880 ? 20 : null,
                        ),
                      if (size.width >= 340)
                        const SizedBox(
                          width: defaultPadding,
                        ),
                      Text(
                        "Ajouter",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: size.width < 880 ? 20 : null,
                            ),
                      ),
                    ],
                  )
                : SvgPicture.asset("assets/icons/personAdd.svg"),
          ),
        ),
      ),
      Box(
        padding: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Moyenne d'age",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
            ),
            Text(
              "27,2",
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
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
              "Moyenne d'age",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
            ),
            Row(
              children: [
                Text(
                  "34",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                ),
                Text(
                  "/ce mois",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                ),
              ],
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
              "Moyenne d'age",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
            ),
            Text(
              "348",
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
    return !showDossier
        ? SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                children: [
                  Responsive(
                    mobile: CustomGridView(
                      crossAxisCount: size.width < 650 ? 2 : 4,
                      childAspectRatio: size.width < 320 ? 1.1 : 1.8,
                      // childAspectRatio: size.width < 320 ? 1.1 : 1.8,
                      screens: screens,
                    ),
                    tablet: CustomGridView(
                      childAspectRatio: size.width < 920 ? 2.3 : 2.9,
                      screens: screens,
                    ),
                    desktop: CustomGridView(
                      childAspectRatio: size.width < 1200 ? 2.8 : 2.9,
                      // childAspectRatio: size.width < 1400 ? 1.1 : 1.4,
                      screens: screens,
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
                        Box(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Patients par direction",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(
                                height: defaultPadding,
                              ),
                              Expanded(
                                child: BarChart(
                                  BarChartData(
                                    maxY: 100,
                                    barGroups: [
                                      BarChartGroupData(
                                        x: 1,
                                        barRods: [
                                          BarChartRodData(
                                            toY: 80,
                                            width: 30,
                                            color: tertiaryColor,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          // BarChartRodData(toY: 40, color: secondaryColor),
                                        ],
                                      ),
                                      BarChartGroupData(
                                        x: 2,
                                        barRods: [
                                          BarChartRodData(
                                            toY: 70,
                                            width: 30,
                                            color: secondaryColor,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ],
                                      ),
                                      BarChartGroupData(
                                        x: 3,
                                        barRods: [
                                          BarChartRodData(
                                            toY: 70,
                                            width: 30,
                                            color: tertiaryColor,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ],
                                      ),
                                      BarChartGroupData(
                                        x: 4,
                                        barRods: [
                                          BarChartRodData(
                                            toY: 70,
                                            width: 30,
                                            color: secondaryColor,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ],
                                      ),
                                      BarChartGroupData(
                                        x: 5,
                                        barRods: [
                                          BarChartRodData(
                                            toY: 70,
                                            width: 30,
                                            color: tertiaryColor,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ],
                                      ),
                                      BarChartGroupData(
                                        x: 6,
                                        barRods: [
                                          BarChartRodData(
                                            toY: 70,
                                            width: 30,
                                            color: secondaryColor,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ],
                                      ),
                                    ],
                                    borderData: FlBorderData(show: false),
                                    titlesData: FlTitlesData(
                                      rightTitles: const AxisTitles(),
                                      topTitles: const AxisTitles(),
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          reservedSize: 30,
                                          showTitles: true,
                                          getTitlesWidget: (value, meta) =>
                                              Text(
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
                                          getTitlesWidget: getBottomTile,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Box(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Patients par site de travail",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    // const SizedBox(height: defaultPadding),
                                    SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: PieChart(
                                        PieChartData(
                                          sectionsSpace: 0,
                                          centerSpaceRadius: 30,
                                          startDegreeOffset: -90,
                                          sections: pieChartSectionData,
                                        ),
                                      ),
                                    ),
                                    // const SizedBox(height: defaultPadding),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            const CircleAvatar(
                                              radius: 3,
                                              backgroundColor: primaryColor,
                                            ),
                                            const SizedBox(
                                              width: 7,
                                            ),
                                            Text(
                                              "Bamako",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                    color: Colors.black,
                                                  ),
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  Box(
                    padding: 10,
                    child: Customtable(
                      changeView: (Patient patient) {
                        setState(() {
                          selectedPatient = patient;
                        });
                        if (selectedPatient != null) {
                          showDossier = true;
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        : DossierPatient(
            patient: selectedPatient!,
            changeView: () {
              setState(() {
                showDossier = false;
              });
            },
          );
  }

  Widget getBottomTile(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text(
          "Jan.",
          style: style,
        );
        break;
      case 2:
        text = const Text(
          "Fév.",
          style: style,
        );
        break;
      case 3:
        text = const Text(
          "Mar.",
          style: style,
        );
        break;
      case 4:
        text = const Text(
          "Avr.",
          style: style,
        );
        break;
      case 5:
        text = const Text(
          "Mai",
          style: style,
        );
        break;
      case 6:
        text = const Text(
          "Jui.",
          style: style,
        );
        break;
      case 7:
        text = const Text(
          "Jui.",
          style: style,
        );
        break;
      case 8:
        text = const Text(
          "Aou.",
          style: style,
        );
        break;
      case 9:
        text = const Text(
          "Sep.",
          style: style,
        );
        break;
      case 10:
        text = const Text(
          "Oct.",
          style: style,
        );
        break;
      case 11:
        text = const Text(
          "Nov.",
          style: style,
        );
        break;
      case 12:
        text = const Text(
          "Déc.",
          style: style,
        );
        break;
      default:
        text = const Text(
          ".",
          style: style,
        );
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      angle: MediaQuery.of(context).size.width < 500 ? -45 : 0,
      child: text,
    );
  }
}
