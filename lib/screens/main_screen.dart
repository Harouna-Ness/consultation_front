import 'package:flutter/material.dart';
import 'package:medstory/components/add_user_formdialog%20.dart';
import 'package:medstory/components/header.dart';
import 'package:medstory/components/side_menu.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/controllers/controller.dart';
import 'package:medstory/controllers/resposive.dart';
import 'package:medstory/models/my_data.dart';
import 'package:medstory/screens/consultation.dart';
import 'package:medstory/screens/dashboard.dart';
import 'package:medstory/screens/pathologie.dart';
import 'package:medstory/screens/patients.dart';
import 'package:medstory/screens/rendez_vous.dart';
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
    context.read<MyData>().getNombreConsultation();
    currentPages = context.watch<MyMenuController>().index;
    
    return (size.width <= 272)
        ? const ErreurTaille()
        : Scaffold(
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
                             Expanded(
                              // child: AddUserFormDialog(),
                              child: Patients(),
                            ),
                          if (currentPages == 2)
                            const Expanded(
                              child: Consultation(),
                            ),
                          if (currentPages == 3)
                            const Expanded(
                              child: RendezVous(),
                            ),
                          if (currentPages == 4)
                            const Expanded(
                              child: Pathologie(),
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
