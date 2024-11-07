import 'package:flutter/material.dart';
import 'package:medstory/components/header.dart';
import 'package:medstory/components/side_menu_medecin.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/controllers/controller.dart';
import 'package:medstory/controllers/resposive.dart';
import 'package:medstory/models/my_data.dart';
import 'package:medstory/screens/consultation.dart';
import 'package:medstory/screens/patient_med_portail.dart';
import 'package:medstory/screens/rdv_med_portail.dart';
import 'package:provider/provider.dart';

class MedecinPortail extends StatefulWidget {
  const MedecinPortail({super.key});

  @override
  State<MedecinPortail> createState() => _MedecinPortailState();
}

class _MedecinPortailState extends State<MedecinPortail> {
  int currentPages = 8;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    context.read<MyData>().fetchPatients();
    context.read<MyData>().fetchAnalyse();
     // TODO: Remplacer par celles faites uniquement par le médecin connecté
    context.read<MyData>().fetchStatut();
    context.read<MyData>().fetchRendezVous();
    context.read<MyData>().fetchMotifDeConsultion();
    context.read<MyData>().fetchTypeDeConsultation();
    currentPages = context.watch<MyMenuController>().index;

    return (size.width <= 272)
        ? const ErreurTaille()
        : Scaffold(
            backgroundColor: const Color.fromARGB(255, 245, 254, 255),
            key: context.read<MyMenuController>().scaffoldKey,
            drawer: const SideMenuMedecin(),
            body: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (Responsive.isDesktop(context))
                    const Expanded(
                      child: SideMenuMedecin(),
                    ),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width < 650 ? 12 : 42),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(
                              top: defaultPadding,
                              left: defaultPadding,
                            ),
                            child: Header(),
                          ),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          if (currentPages == 7)
                            const Expanded(
                              child: PatientMedPortail(),
                            ),
                          if (currentPages == 8)
                            const Expanded(
                              child: RdvMedPortail(),
                            ),
                          if (currentPages == 2)
                            const Expanded(
                              child: ConsultationScreen(),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
