import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medstory/components/box.dart';
import 'package:medstory/components/empty_content.dart';
import 'package:medstory/components/rendez_vous_form.dart';
import 'package:medstory/components/rendez_vous_table.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/models/my_data.dart';
import 'package:medstory/models/rendez_vous.dart';
import 'package:provider/provider.dart';

class RendezVousScreen extends StatefulWidget {
  const RendezVousScreen({super.key});

  @override
  State<RendezVousScreen> createState() => _RendezVousScreenState();
}

class _RendezVousScreenState extends State<RendezVousScreen> {
  bool showForm = false;
  String searchText = '';
  String? selectedFilter;
  List<String> filters = [
    "Aucun Filtre",
    "Motif",
    "Statut",
    "Date",
    "Médecin",
    "Patient"
  ];
  TextEditingController searchController = TextEditingController();
  List<RendezVous> _rendezVous = [];
  @override
  Widget build(BuildContext context) {
    _rendezVous = context.watch<MyData>().rendezVous;

    List<RendezVous> filteredRendezVous = _rendezVous.where((rendezVous) {
      bool matchesSearch =
          rendezVous.motif.toLowerCase().contains(searchText.toLowerCase()) ||
              rendezVous.statut.libelle
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              rendezVous.date.toString().contains(searchText) ||
              rendezVous.medecin.nom
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              rendezVous.medecin.prenom
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              rendezVous.patient.nom
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              rendezVous.patient.prenom
                  .toLowerCase()
                  .contains(searchText.toLowerCase());

      bool matchesFilter = true;
      if (selectedFilter != null) {
        switch (selectedFilter) {
          case "Motif":
            matchesFilter = rendezVous.motif.toLowerCase().contains(searchText);
            break;
          case "Statut":
            matchesFilter =
                rendezVous.statut.libelle.toLowerCase().contains(searchText);
            break;
          case "Date":
            matchesFilter = rendezVous.date.toString().contains(searchText);
            break;
          case "Médecin":
            matchesFilter = rendezVous.medecin.nom
                    .toLowerCase()
                    .contains(searchText) ||
                rendezVous.medecin.prenom.toLowerCase().contains(searchText);
            break;
          case "Patient":
            matchesFilter = rendezVous.patient.nom
                    .toLowerCase()
                    .contains(searchText) ||
                rendezVous.patient.prenom.toLowerCase().contains(searchText);
            break;
        }
      }
      return matchesSearch && matchesFilter;
    }).toList();

    return SafeArea(
      child: !showForm
          ? SingleChildScrollView(
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
                            "Liste des Rendez-vous",
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
                              //TODO: logique de création de rendez-vous.
                              //   context.showLoader();
                              //   final rendezVousService = RendezVousService();
                              //   RendezVous rdv = RendezVous(
                              //       id: 0,
                              //       motif: "motif",
                              //       date: DateTime(2024, 11, 23),
                              //       heure: "18:10",
                              //       statut: Statut(id: 1, libelle: "libelle"),
                              //       medecin: Medecin(
                              //         id: 1,
                              //         nom: "nom",
                              //         prenom: "prenom",
                              //         role: Role(id: 0, libelle: "libelle"),
                              //         adresse: "adresse",
                              //         email: "email",
                              //         telephone: "telephone",
                              //         motDePasse: "motDePasse",
                              //         sexe: "sexe",
                              //         specialite: "specialite",
                              //         joursIntervention: [],
                              //         matricule: '',
                              //       ),
                              //       patient: Patient(
                              //           id: 2,
                              //           nom: "nom",
                              //           prenom: "prenom",
                              //           role: Role(id: 0, libelle: "libelle"),
                              //           adresse: "adresse",
                              //           email: "email",
                              //           telephone: "telephone",
                              //           motDePasse: "motDePasse",
                              //           sexe: "sexe",
                              //           dateDeNaissance: DateTime.now(),
                              //           proffession: "proffession",
                              //           sitedetravail: Sitedetravail(id: 0, nom: "nom"),
                              //           direction: Direction(id: 0, nom: "nom"),
                              //           statut:
                              //               StatutPatient(id: 0, libelle: "libelle")));
                              //   await rendezVousService
                              //       .createRendezVous(rdv)
                              //       .then((value) {
                              //   context.read<MyData>().fetchRendezVous();
                              //   context.hideLoader();
                              //   context.showSuccess(
                              //       "Le rendez-vous a été ajouté avec succès.");
                              // }).catchError((onError) {
                              //   context.hideLoader();
                              //   context.showError(onError.toString());
                              // });

                              ////
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: const Text(
                              "Planifier un rendez-vous",
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
                                      hintText: "Motif, statut, date...",
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
                      (_rendezVous.isEmpty)
                          ? const EmptyContent()
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: RendezVousTable(
                                rendezVousList: filteredRendezVous,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            )
          : RendezVousForm(
              changeView: () {
                setState(() {
                  showForm = false;
                });
              },
            ),
      // ): const AddRendezVousForm(),
    );
  }
}
