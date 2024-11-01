import 'package:flutter/material.dart';
import 'package:medstory/components/header.dart';
import 'package:medstory/components/side_menu.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/controllers/controller.dart';
import 'package:medstory/controllers/resposive.dart';
import 'package:medstory/models/my_data.dart';
import 'package:medstory/screens/dashboard.dart';
import 'package:medstory/screens/medecin_screen.dart';
import 'package:medstory/screens/pathologie.dart';
import 'package:medstory/screens/patients.dart';
import 'package:medstory/screens/rendez_vous.dart';
import 'package:medstory/screens/setting_screen.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentPages = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    context.read<MyData>().getNombrePatient();
    context.read<MyData>().getMoyenneAge();
    context.read<MyData>().getNombreConsultation();
    context.read<MyData>().fetchPatients();
    context.read<MyData>().fetchDirections();
    context.read<MyData>().fetchSiteDeTraivails();
    context.read<MyData>().fetchAnalyse();
    context.read<MyData>().fetchMotifDeConsultion();
    context.read<MyData>().fetchTypeDeConsultation();
    context.read<MyData>().fetchStatutPatient();
    context.read<MyData>().fetchStatut();
    context.read<MyData>().fetchRendezVous();
    context.read<MyData>().fetchMedecins();
    currentPages = context.watch<MyMenuController>().index;

    return (size.width <= 272)
        ? const ErreurTaille()
        : Scaffold(
          backgroundColor: const Color.fromARGB(255, 245, 254, 255),
            key: context.read<MyMenuController>().scaffoldKey,
            drawer: const SideMenu(),
            body: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (Responsive.isDesktop(context))
                    const Expanded(
                      child: SideMenu(),
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
                          if (currentPages == 0)
                            const Expanded(
                              child: Dashboard(),
                            ),
                          if (currentPages == 1)
                            const Expanded(
                              // child: AddUserFormDialog(),
                              child: Patients(),
                            ),
                          if (currentPages == 3)
                            const Expanded(
                              child: RendezVousScreen(),
                            ),
                          if (currentPages == 4)
                            const Expanded(
                              child: Pathologie(),
                            ),
                          if (currentPages == 5)
                            const Expanded(
                              child: SettingScreen(),
                            ),
                          if (currentPages == 6)
                            const Expanded(
                              child: MedecinScreen(),
                            ),
                          // if (currentPages == 7)
                          //   const Expanded(
                          //     child: DossierPatient(),
                          //   ),
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
