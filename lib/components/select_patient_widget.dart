import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/models/patient.dart';
import 'package:medstory/service/patient_service.dart';
import 'package:medstory/utils/lodder.dart';

class SelectPatientWidget extends StatefulWidget {
  final Function(Patient patient) onSelect;
  const SelectPatientWidget({super.key, required this.onSelect});

  @override
  State<SelectPatientWidget> createState() => _SelectPatientWidgetState();
}

class _SelectPatientWidgetState extends State<SelectPatientWidget> {
  final patientService = PatientService();

  String searchText = '';
  String? selectedFilter;
  bool rechercherAvancee = false; // Indicateur de recherche API
  Timer? _debounce;
  List<String> filters = [
    "Aucun Filtre",
    "Direction",
    "Site de Travail",
    "Profession"
  ];
  TextEditingController searchController = TextEditingController();

  List<Patient> _patients = [];

  int _currentPage = 0;
  int _totalPages = 1;
  bool _isLoading = false;

  Future<void> fetchPatients({int page = 0}) async {
    if (_isLoading || (page >= _totalPages)) return;

    setState(() {
      _isLoading = true;
    });

    try {
      var result = await patientService.getAllPatients(page: page);
      setState(() {
        _patients = result['patients'];
        _totalPages = result['totalPages'];
        _currentPage = page;
      });
    } catch (e) {
      print("Erreur lors du chargement des patients: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void goToPage(int page) {
    if (page < 0 || page >= _totalPages) return;
    _currentPage = page;
    fetchPatients(page: page);
  }

  void _onSearchChanged(String query, List<Patient> patients) {
    setState(() {
      searchText = query;
    });

    // Annuler le précédent debounce si actif
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      List<Patient> filteredPatients = _filterPatients(patients);

      // Si aucun patient trouvé, envoyer une requête API
      if (filteredPatients.isEmpty && query.isNotEmpty) {
        setState(() async {
          rechercherAvancee = true;
          _patients = await patientService.fetchPatientsFromServer(
            query,
            selectedFilter,
          );
        });

        setState(() {
          rechercherAvancee = false;
        });
      }

      if (query.isEmpty) {
        goToPage(_currentPage);
      }
    });
  }

  List<Patient> _filterPatients(List<Patient> patients) {
    return patients.where((patient) {
      bool matchesSearch = patient.prenom
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              patient.nom.toLowerCase().contains(searchText.toLowerCase()) ||
              patient.proffession!
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              patient.direction!.nom
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
                patient.direction!.nom
                    .toLowerCase()
                    .contains(searchText.toLowerCase());
            break;
          case "Site de Travail":
            matchesFilter = patient.sitedetravail?.nom != null &&
                patient.sitedetravail!.nom
                    .toLowerCase()
                    .contains(searchText.toLowerCase());
            break;
          case "profession":
            matchesFilter = patient.proffession != null &&
                patient.proffession!
                    .toLowerCase()
                    .contains(searchText.toLowerCase());
            break;
        }
      }
      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: patientService.getAllPatients(page: _currentPage),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _patients = _filterPatients(snapshot.data!['patients']);
                _totalPages = snapshot.data!['totalPages'];
              });
            });

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Sélection de patient",
                    style: TextStyle(fontSize: 18)),
                const SizedBox(height: 16),
                Row(
                  children: [
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
                              onChanged: (value) =>
                                  _onSearchChanged(value, _patients),
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
                                items: filters.map<DropdownMenuItem<String>>(
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
                    const SizedBox(
                      width: 50,
                    ),
                  ],
                ),
                Expanded(
                  child: _patients.isEmpty
                      ? const Center(
                          child: Text("Aucun patient !"),
                        )
                      : SingleChildScrollView(
                          child: _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Column(
                                  children: [
                                    DataTable(
                                      headingTextStyle: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                      columns: const [
                                        DataColumn(label: Text("Prénom")),
                                        DataColumn(label: Text("Nom")),
                                        DataColumn(label: Text("Matricule")),
                                        DataColumn(label: Text("Proffession")),
                                        DataColumn(
                                            label: Text("Site de Travail")),
                                        DataColumn(label: Text("Actions")),
                                      ],
                                      rows: List.generate(
                                        _patients.length,
                                        (index) => DataRow(
                                          cells: [
                                            DataCell(
                                                Text(_patients[index].prenom)),
                                            DataCell(
                                                Text(_patients[index].nom)),
                                            DataCell(Text(
                                                _patients[index].telephone)),
                                            DataCell(
                                                _patients[index].proffession !=
                                                        null
                                                    ? Text(_patients[index]
                                                        .proffession!)
                                                    : const Text("Néant")),
                                            DataCell(_patients[index]
                                                        .sitedetravail !=
                                                    null
                                                ? Text(_patients[index]
                                                    .sitedetravail!
                                                    .nom)
                                                : const Text("Néant")),
                                            DataCell(
                                              ElevatedButton(
                                                onPressed: () {
                                                  // Remplir les champs du formulaire avec les infos du patient sélectionné
                                                  setState(() {
                                                    widget.onSelect(
                                                        _patients[index]);
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: primaryColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                ),
                                                child: const Text(
                                                  'Sélectionner',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Pagination
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.arrow_back),
                                          onPressed: _currentPage > 0
                                              ? () => goToPage(_currentPage - 1)
                                              : null,
                                        ),
                                        Text(
                                            "Page ${_currentPage + 1} / $_totalPages"),
                                        IconButton(
                                          icon: const Icon(Icons.arrow_forward),
                                          onPressed: _currentPage + 1 <
                                                  _totalPages
                                              ? () => goToPage(_currentPage + 1)
                                              : null,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                        ),
                ),
              ],
            );
          }
          if (snapshot.hasError) {
            context.showError(
                "Une erreur s'est produite: ${snapshot.error.toString()}");
            return const SizedBox();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
