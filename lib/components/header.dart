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
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

String pageTitle(int currentPages) {
  if (currentPages == 0) {
    return "Dashboard";
  } else if (currentPages == 1) {
    return "Patients";
  } else if (currentPages == 2) {
    return "Consultation";
  } else if (currentPages == 3) {
    return "RendezVous";
  } else if (currentPages == 4) {
    return "Pathologie";
  } else {
    return "";
  }
}
