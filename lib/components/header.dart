import 'package:flutter/material.dart';
import 'package:medstory/controllers/controller.dart';
import 'package:medstory/controllers/resposive.dart';
import 'package:provider/provider.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            onPressed: () {
              context.read<MyMenuController>().controlMenu();
            },
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
            ),
          ),
        const Text(
          "page / ",
          style: TextStyle(color: Colors.grey),
        ),
        Text(
          pageTitle(context.watch<MyMenuController>().index),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }
}

String pageTitle(int currentPages) {
  if (currentPages == 0) {
    return "Tableau de bord";
  } else if (currentPages == 1) {
    return "Patients";
  } else if (currentPages == 2) {
    return "Consultation";
  } else if (currentPages == 3) {
    return "Rendez-vous";
  } else if (currentPages == 4) {
    return "Pathologie";
  } else if (currentPages == 5) {
    return "Settings";
  } else if (currentPages == 6) {
    return "Docteurs";
  } else if (currentPages == 7) {
    return "Dossier Patient";
  } else if (currentPages == 8) {
    return "Rendez-vous";
  } else {
    return "";
  }
}
