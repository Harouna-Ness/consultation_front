import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medstory/constantes.dart';

class Customtable extends StatelessWidget {
  const Customtable({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      child: size.width > 1000
          ? SizedBox(
              width: double.infinity,
              child: DataTable(
                headingTextStyle: const TextStyle(fontWeight: FontWeight.bold),
                horizontalMargin: 0,
                columnSpacing: defaultPadding,
                columns: const [
                  DataColumn(label: Text("Prénom")),
                  DataColumn(label: Text("Nom")),
                  DataColumn(label: Text("Age")),
                  DataColumn(label: Text("Matricule")),
                  DataColumn(label: Text("Proffession")),
                  DataColumn(label: Text("Direction")),
                  DataColumn(label: Text("Site de Travail")),
                  DataColumn(label: Text("Actions")),
                ],
                rows: List.generate(
                  10,
                  (index) => customDataRow(),
                ),
              ),
            )
          : SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: [
                          customtableHeader(),
                          const Divider(
                            height: 1,
                            thickness: 5,
                            indent: 2,
                            endIndent: 0,
                            color: Colors.black,
                          ),
                          Column(
                            children: List.generate(
                              10,
                              (index) => customDataRow1(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 40,
                          child: const Text(
                            "Actions",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Column(
                          children: List.generate(
                            10,
                            (index) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  height: 56,
                                  child: SvgPicture.asset(
                                    "assets/icons/Report.svg",
                                    height: 25,
                                    width: 25,
                                  ),
                                ),
                                Container(
                                  height: 56,
                                  child: SvgPicture.asset(
                                    "assets/icons/Report.svg",
                                    height: 25,
                                    width: 25,
                                  ),
                                ),
                                Container(
                                  height: 56,
                                  child: SvgPicture.asset(
                                    "assets/icons/Report.svg",
                                    height: 25,
                                    width: 25,
                                  ),
                                ),
                              ],
                            ),
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
}

DataRow customDataRow(
    // parametre ou donnée à passer
    ) {
  return DataRow(
    cells: [
      DataCell(
        Container(
          width: 150,
          child: Text(
            "Nessy Nessy Nessy Nessy Nessy Nessy Nessy Nessy",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      DataCell(
        Container(
          width: 150,
          child: Text("Nessy"),
        ),
      ),
      DataCell(Text("Nessy")),
      DataCell(Text("Nessy")),
      DataCell(Text("Nessy Nessy")),
      DataCell(Text("Nessy Nessy")),
      DataCell(Text("Nessy Nessy Nessy")),
      DataCell(
        Row(
          children: [
            SvgPicture.asset(
              "assets/icons/Report.svg",
              height: 25,
              width: 25,
            ),
            const SizedBox(
              width: 5,
            ),
            SvgPicture.asset(
              "assets/icons/Report.svg",
              height: 25,
              width: 25,
            ),
            const SizedBox(
              width: 5,
            ),
            SvgPicture.asset(
              "assets/icons/Report.svg",
              height: 25,
              width: 25,
            ),
          ],
        ),
      ),
    ],
  );
}

Row customtableHeader() {
  return Row(
    children: [
      Container(
        width: 100,
        height: 40,
        child: const Text(
          "Prénom",
          style: TextStyle(fontWeight: FontWeight.bold),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      const SizedBox(
        width: defaultPadding,
      ),
      Container(
        width: 100,
        height: 40,
        child: const Text(
          "Nom",
          style: TextStyle(fontWeight: FontWeight.bold),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      const SizedBox(
        width: defaultPadding,
      ),
      Container(
        width: 50,
        height: 40,
        child: const Text(
          "Age",
          style: TextStyle(fontWeight: FontWeight.bold),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      const SizedBox(
        width: defaultPadding,
      ),
      Container(
        width: 100,
        height: 40,
        child: const Text(
          "Matricule",
          style: TextStyle(fontWeight: FontWeight.bold),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      const SizedBox(
        width: defaultPadding,
      ),
      Container(
        width: 100,
        height: 40,
        child: const Text(
          "Proffession",
          style: TextStyle(fontWeight: FontWeight.bold),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      const SizedBox(
        width: defaultPadding,
      ),
      Container(
        width: 100,
        height: 40,
        child: const Text(
          "Direction",
          style: TextStyle(fontWeight: FontWeight.bold),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      const SizedBox(
        width: defaultPadding,
      ),
      Container(
        width: 100,
        height: 40,
        child: const Text(
          "Site de travail",
          style: TextStyle(fontWeight: FontWeight.bold),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}

Row customDataRow1(
    // une liste comme parametre.
    ) {
  return Row(
    children: [
      Container(
        width: 100,
        height: 56,
        child: const Text(
          "Nessy Nessy Nessy Nessy Nessy Nessy Nessy Nessy",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      const SizedBox(
        width: defaultPadding,
      ),
      Container(
        width: 100,
        height: 56,
        child: const Text(
          "Nessy Nessy Nessy Nessy Nessy Nessy Nessy Nessy",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      const SizedBox(
        width: defaultPadding,
      ),
      Container(
        width: 50,
        height: 56,
        child: const Text(
          "15",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      const SizedBox(
        width: defaultPadding,
      ),
      Container(
        width: 100,
        height: 56,
        child: const Text(
          "Nessy Nessy Nessy Nessy Nessy Nessy Nessy Nessy",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      const SizedBox(
        width: defaultPadding,
      ),
      Container(
        width: 100,
        height: 56,
        child: const Text(
          "Nessy Nessy Nessy Nessy Nessy Nessy Nessy Nessy",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      const SizedBox(
        width: defaultPadding,
      ),
      Container(
        width: 100,
        height: 56,
        child: const Text(
          "Nessy Nessy Nessy Nessy Nessy Nessy Nessy Nessy",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      const SizedBox(
        width: defaultPadding,
      ),
      Container(
        width: 100,
        height: 56,
        child: const Text(
          "Nessy Nessy Nessy Nessy Nessy Nessy Nessy Nessy",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}
