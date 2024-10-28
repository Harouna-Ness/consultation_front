import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medstory/components/edit_patient_model.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/controllers/controller.dart';
import 'package:medstory/models/my_data.dart';
import 'package:medstory/models/patient.dart';
import 'package:medstory/service/patient_service.dart';
import 'package:medstory/utils/lodder.dart';
import 'package:provider/provider.dart';

class CustomTableMedPortail extends StatefulWidget {
  final void Function(Patient patient) changeView;
  const CustomTableMedPortail({super.key, required this.changeView});

  @override
  State<CustomTableMedPortail> createState() => _CustomTableMedPortailState();
}

class _CustomTableMedPortailState extends State<CustomTableMedPortail> {
  String searchText = '';
  String? selectedFilter;
  List<String> filters = [
    "Aucun Filtre",
    "Direction",
    "Site de Travail",
    "Profession"
  ];
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    //
    List<Patient> filteredPatients =
        context.watch<MyData>().patients.where((patient) {
      bool matchesSearch = patient.prenom
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              patient.nom.toLowerCase().contains(searchText.toLowerCase()) ||
              patient.proffession!
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              patient.sitedetravail!.nom
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ??
          false;
      bool matchesFilter = true;
      if (selectedFilter != null) {
        switch (selectedFilter) {
          case "Direction":
            matchesFilter = patient.direction?.nom != null &&
                patient.direction!.nom.toLowerCase().contains(searchText);
            break;
          case "Site de Travail":
            matchesFilter = patient.sitedetravail?.nom != null &&
                patient.sitedetravail!.nom.toLowerCase().contains(searchText);
            break;
          case "profession":
            matchesFilter = patient.proffession != null &&
                patient.proffession!.toLowerCase().contains(searchText);
            break;
        }
      }
      return matchesSearch && matchesFilter;
    }).toList();

    //

    return Column(
      children: [
        // En-tête
        Row(
          children: [
            Text(
              "Liste des patients",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.black87,
                    fontSize: 18,
                  ),
            ),
            const Spacer(),
            // les filtres
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  width: 200,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                  ),
                  child: Center(
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {
                          searchText = value;
                        });
                      },
                      decoration: InputDecoration(
                        icon: SizedBox(
                          height: 20,
                          width: 20,
                          child: SvgPicture.asset(
                            "assets/icons/search_icon.svg", // Icône SVG pour le bouton
                          ),
                        ),
                        hintText: "Prénom, nom, profession...",
                        contentPadding: const EdgeInsets.only(
                          bottom: 10,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                  ),
                  child: Center(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedFilter,
                        icon: SvgPicture.asset(
                          "assets/icons/filter_alt.svg",
                          height: 25,
                          width: 25,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedFilter = newValue!;
                          });
                        },
                        selectedItemBuilder: (BuildContext context) {
                          return filters.map<Widget>((String value) {
                            return Container(); // On cache complètement le texte
                          }).toList();
                        },
                        menuWidth: 200,
                        items: filters
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 50,
            ),
          ],
        ),
        Container(
          child: size.width > 1000
              ? SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    headingTextStyle:
                        const TextStyle(fontWeight: FontWeight.bold),
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
                      filteredPatients.length,
                      (index) => customDataRow(
                        context,
                        filteredPatients[index],
                        () => widget.changeView(filteredPatients[index]),
                      ),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
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
        ),
      ],
    );
  }
}

void showEditPatientModal(BuildContext context, Patient patient) {
  final patientService = PatientService();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ChangeNotifierProvider.value(
        value: Provider.of<MyData>(context),
        child: EditPatientModal(
          patient: patient,
          onSubmit: (onSubmit) async {
            context.showLoader();
            await patientService.updatePatient(onSubmit).then((onValue) {
              context.hideLoader();
            }).catchError((onError) {
              context.showError(onError.toString());
            }).whenComplete(() {
              context.showSuccess("Le patient a été modifié avec succès.");
              context.read<MyMenuController>().changePage(1);
            });
          },
          contexte: context,
        ),
      );
    },
  );
}

DataRow customDataRow(
  // parametre ou donnée à passer
  BuildContext contexte,
  Patient patient,
  Function() voirDossierLogique,
) {
  return DataRow(
    cells: [
      DataCell(
        Container(
          width: 150,
          child: Text(
            patient.prenom,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      DataCell(
        Container(
          width: 150,
          child: Text(patient.nom),
        ),
      ),
      DataCell(Text(patient.dateDeNaissance!.day.toString())),
      DataCell(Text(patient.telephone)),
      DataCell(patient.proffession != null
          ? Text(patient.proffession!)
          : const Text("Néant")),
      DataCell(patient.direction != null
          ? Text(patient.direction!.nom)
          : const Text("Néant")),
      DataCell(patient.sitedetravail != null
          ? Text(patient.sitedetravail!.nom)
          : const Text("Néant")),
      DataCell(
        Row(
          children: [
            
            InkWell(
              // Logique pour voir le dossier patient
              onTap: voirDossierLogique,
              child: SvgPicture.asset(
                "assets/icons/folderView.svg",
                height: 25,
                width: 25,
              ),
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
