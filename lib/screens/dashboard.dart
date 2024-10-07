import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:medstory/components/box.dart';
import 'package:medstory/components/customGrid.dart';
import 'package:medstory/components/date_btn_filter.dart';
import 'package:medstory/components/header.dart';
import 'package:medstory/components/revdash.dart';
import 'package:medstory/components/total_nbr_dashboard.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/controllers/resposive.dart';
import 'package:medstory/models/my_data.dart';
import 'package:provider/provider.dart';
// import 'package:medstory/service/consultation_service.dart';
// import 'package:medstory/service/patient_service.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    List<Widget> totaux = [
      TotalNbrDashboard(
        label: 'Nombre tolal de patients',
        total: context.watch<MyData>().nombrePatient,
        color: tertiaryColor,
        svgIc: "assets/icons/patients.svg",
      ),
      TotalNbrDashboard(
        label: 'Nombre tolal de consultation',
        total: context.watch<MyData>().nombreConsultation,
        color: Colors.blue,
        svgIc: "assets/icons/consultation.svg",
      )
    ];
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            if (size.width < 400) totaux[0],
            const SizedBox(
              height: 10,
            ),
            if (size.width < 400) totaux[1],
            if (!(size.width < 400))
              Responsive(
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
                  childAspectRatio: 4.1,
                  screens: totaux,
                ),
              ),
            const SizedBox(
              height: defaultPadding,
            ),
            Box(
              child: Container(
                color: Colors.transparent,
                height: 300,
                width: double.infinity,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Pathologies fréquentes",
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        if (size.width >= 550)
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 5,
                                backgroundColor: tertiaryColor,
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              Text(
                                "Diabète",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: Colors.black,
                                    ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const CircleAvatar(
                                radius: 5,
                                backgroundColor: secondaryColor,
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              Text(
                                "Diabète",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: Colors.black,
                                    ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              Container(
                                color: Colors.grey[100],
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 7,
                                    ),
                                    const Icon(
                                      Icons.date_range_outlined,
                                      color: primaryColor,
                                      size: 17,
                                    ),
                                    const SizedBox(
                                      width: 7,
                                    ),
                                    Text(
                                      "ce mois",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            color: Colors.black,
                                          ),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                      ],
                    ),
                    if (size.width < 550)
                      const SizedBox(
                        height: defaultPadding,
                      ),
                    if (size.width < 550)
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 5,
                            backgroundColor: tertiaryColor,
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          Text(
                            "Diabète",
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Colors.black,
                                    ),
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          const CircleAvatar(
                            radius: 5,
                            backgroundColor: secondaryColor,
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          Text(
                            "Diabète",
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Colors.black,
                                    ),
                          ),
                          const Spacer(),
                          if (size.width > 290) const DateBtnFilter(),
                        ],
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
                                BarChartRodData(toY: 80, color: tertiaryColor),
                                BarChartRodData(toY: 40, color: secondaryColor),
                              ],
                            ),
                            BarChartGroupData(
                              x: 2,
                              barRods: [
                                BarChartRodData(toY: 70, color: tertiaryColor),
                                BarChartRodData(toY: 50, color: secondaryColor),
                              ],
                            ),
                            BarChartGroupData(
                              x: 3,
                              barRods: [
                                BarChartRodData(toY: 70, color: tertiaryColor),
                                BarChartRodData(toY: 50, color: secondaryColor),
                              ],
                            ),
                            BarChartGroupData(
                              x: 4,
                              barRods: [
                                BarChartRodData(toY: 70, color: tertiaryColor),
                                BarChartRodData(toY: 50, color: secondaryColor),
                              ],
                            ),
                            BarChartGroupData(
                              x: 5,
                              barRods: [
                                BarChartRodData(toY: 70, color: tertiaryColor),
                                BarChartRodData(toY: 50, color: secondaryColor),
                              ],
                            ),
                            BarChartGroupData(
                              x: 6,
                              barRods: [
                                BarChartRodData(toY: 70, color: tertiaryColor),
                                BarChartRodData(toY: 50, color: secondaryColor),
                              ],
                            ),
                            BarChartGroupData(
                              x: 7,
                              barRods: [
                                BarChartRodData(toY: 70, color: tertiaryColor),
                                BarChartRodData(toY: 50, color: secondaryColor),
                              ],
                            ),
                            BarChartGroupData(
                              x: 8,
                              barRods: [
                                BarChartRodData(toY: 70, color: tertiaryColor),
                                BarChartRodData(toY: 50, color: secondaryColor),
                              ],
                            ),
                            BarChartGroupData(
                              x: 9,
                              barRods: [
                                BarChartRodData(toY: 70, color: tertiaryColor),
                                BarChartRodData(toY: 50, color: secondaryColor),
                              ],
                            ),
                            BarChartGroupData(
                              x: 10,
                              barRods: [
                                BarChartRodData(toY: 70, color: tertiaryColor),
                                BarChartRodData(toY: 50, color: secondaryColor),
                              ],
                            ),
                            BarChartGroupData(
                              x: 11,
                              barRods: [
                                BarChartRodData(toY: 70, color: tertiaryColor),
                                BarChartRodData(toY: 50, color: secondaryColor),
                              ],
                            ),
                            BarChartGroupData(
                              x: 12,
                              barRods: [
                                BarChartRodData(toY: 70, color: tertiaryColor),
                                BarChartRodData(toY: 50, color: secondaryColor),
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
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            Responsive(
              mobile: CustomGridView(
                crossAxisCount: 1,
                childAspectRatio: size.width < 650 ? 1.1 : 2.1,
                screens: [
                  Box(
                    child: RdvDash(),
                  ),
                  Container(
                    color: Colors.grey,
                  ),
                ],
              ),
              tablet: CustomGridView(
                crossAxisCount: 2,
                childAspectRatio: 1.7,
                screens: [
                  Box(
                    child: const RdvDash(),
                  ),
                  Container(
                    color: Colors.grey,
                  ),
                ],
              ),
              desktop: CustomGridView(
                crossAxisCount: 2,
                childAspectRatio: 1.8,
                screens: [
                  Box(
                    child: const RdvDash(),
                  ),
                  Box(
                    child: Container(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
