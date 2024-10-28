import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medstory/components/box.dart';
import 'package:medstory/components/doctor_forme.dart';
import 'package:medstory/components/doctor_table.dart';
import 'package:medstory/components/empty_content.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/models/medecin.dart';
import 'package:medstory/models/my_data.dart';
import 'package:provider/provider.dart';

class MedecinScreen extends StatefulWidget {
  const MedecinScreen({super.key});

  @override
  State<MedecinScreen> createState() => _MedecinScreenState();
}

class _MedecinScreenState extends State<MedecinScreen> {
  bool showForm = false;
  String searchText = '';
  String? selectedFilter;
  List<String> filters = ["Aucun Filtre", "Spécialité", "Matricule"];
  TextEditingController searchController = TextEditingController();
  List<Medecin> _medecins = [];
  @override
  Widget build(BuildContext context) {
    _medecins = context.watch<MyData>().medecins;
    List<Medecin> filteredMedecins = _medecins;

    filteredMedecins = context.watch<MyData>().medecins.where((medecin) {
      bool matchesSearch = medecin.prenom
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              medecin.nom.toLowerCase().contains(searchText.toLowerCase()) ||
              medecin.specialite
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              medecin.matricule!
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ??
          false;

      bool matchesFilter = true;
      if (selectedFilter != null) {
        switch (selectedFilter) {
          case "Spécialité":
            matchesFilter =
                medecin.specialite.toLowerCase().contains(searchText);
            break;
          case "Matricule":
            matchesFilter = medecin.matricule != null &&
                medecin.matricule.toLowerCase().contains(searchText);
            break;
        }
      }
      return matchesSearch && matchesFilter;
    }).toList();

    return showForm
        ? Box(child: DoctorForm(
            changeView: () {
              setState(() {
                showForm = false;
              });
            },
          ))
        : SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 16,
                ),
                child: Box(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Liste des Médecins",
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Colors.black87,
                                      fontSize: 18,
                                    ),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                showForm = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: const Text(
                              "Ajouter un docteur",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
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
                                      hintText: "Prénom, nom, spécialité...",
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
                                      selectedItemBuilder:
                                          (BuildContext context) {
                                        return filters
                                            .map<Widget>((String value) {
                                          return Container(); // On cache complètement le texte
                                        }).toList();
                                      },
                                      menuWidth: 200,
                                      items: filters
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
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
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      (_medecins.isEmpty)
                          ? const EmptyContent()
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DoctorTable(
                                medecinList: filteredMedecins,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
