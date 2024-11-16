import 'package:flutter/material.dart';
import 'package:medstory/components/box.dart';
import 'package:medstory/components/champs_texte.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/models/medecin.dart';
import 'package:medstory/models/my_data.dart';
import 'package:medstory/models/patient.dart';
import 'package:medstory/models/rendez_vous.dart';
import 'package:medstory/models/statut.dart';
import 'package:medstory/service/rendez_vous_service.dart';
import 'package:medstory/utils/lodder.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';

class RendezVousForm extends StatefulWidget {
  final void Function() changeView;
  const RendezVousForm({super.key, required this.changeView});

  @override
  State<RendezVousForm> createState() => _RendezVousFormState();
}

class _RendezVousFormState extends State<RendezVousForm> {
  Patient? selectedPatient;
  Medecin? selectedMedecin;
  String? specialite;
  String? selectedTimeSlot;
  String? motif;
  String? heureRdv;
  bool? isForFamilyMember = false;
  bool? isChild = false;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final TextEditingController motifController = TextEditingController();

  List<Patient> patients = [];
  List<String> specialites = [];
  List<Medecin> medecins = [];

  @override
  Widget build(BuildContext context) {
    context.read<MyData>().fetchPatients();
    context.read<MyData>().fetchMedecins();

    patients = context.watch<MyData>().patients;
    medecins = context.watch<MyData>().medecins;

    // Liste des jours d'intervention en fonction du médecin sélectionné
    List<String> joursDisponibles = selectedMedecin != null
        ? selectedMedecin!.joursIntervention
            .map((e) => e['jour'] as String)
            .toList()
        : [];

// Obtenir les heures de début et de fin en fonction d'un jour spécifique
    Map<String, String> getHeuresPourJour(String jour) {
      if (selectedMedecin == null)
        return {'heureDebut': '00:00', 'heureFin': '23:59'};

      var intervention = selectedMedecin!.joursIntervention.firstWhere(
        (e) => e['jour'] == jour,
        orElse: () => {},
      );

      return {
        'heureDebut': intervention['heureDebut'] ?? '00:00',
        'heureFin': intervention['heureFin'] ?? '23:59',
      };
    }

    return SingleChildScrollView(
      child: Form(
        child: Box(
          child: Column(
            children: [
              // Titre
              const Text("Planification rendez-vous",
                  style: TextStyle(fontSize: 18)),
              // Champ patient
              TextFormField(
                onTap: () {
                  selectionModal(context, patients);
                },
                controller: selectedPatient != null
                    ? TextEditingController(
                        text:
                            "${selectedPatient!.prenom} ${selectedPatient!.nom}")
                    : null,
                decoration: const InputDecoration(
                  labelText: "Patient",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Champ requis';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              // Champ selection de l'interressé
              DropdownButtonFormField<bool>(
                decoration: const InputDecoration(
                  labelText: "Rendez-vous pour",
                  // border: OutlineInputBorder(),
                ),
                value: isForFamilyMember,
                items: const [
                  DropdownMenuItem(
                    value: false,
                    child: Text("Pour lui-même"),
                  ),
                  DropdownMenuItem(
                    value: true,
                    child: Text("Pour quelqu'un d'autre"),
                  ),
                ],
                onChanged: (bool? value) {
                  setState(() {
                    isForFamilyMember = value;
                  });
                },
              ),
              isForFamilyMember!
                  ? Column(
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        // Champ pour savoir si enfant
                        DropdownButtonFormField<bool>(
                          decoration: const InputDecoration(
                            labelText: "Type de personne",
                          ),
                          value: isChild,
                          items: const [
                            DropdownMenuItem(
                              value: false,
                              child: Text("Adulte"),
                            ),
                            DropdownMenuItem(
                              value: true,
                              child: Text("Enfant"),
                            ),
                          ],
                          onChanged: (bool? value) {
                            setState(() {
                              isChild = value;
                            });
                          },
                        ),
                      ],
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 16,
              ),
              // Champ médecin
              TextFormField(
                onTap: () {
                  selectionMedecinModal(context, medecins);
                },
                controller: selectedMedecin != null
                    ? TextEditingController(
                        text:
                            "${selectedMedecin!.prenom} ${selectedMedecin!.nom}")
                    : null,
                decoration: const InputDecoration(
                  labelText: "Médecin",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Champ requis';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              // Date de rendez-vous
              Row(
                children: [
                  Column(
                    children: [
                      const Text("Date de rendez-vous"),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => _selectDate(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Text(
                          _selectedDate != null
                              ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                              : "Sélectionner une date",
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  // Heure
                  Column(
                    children: [
                      const Text("Heure de rendez-vous"),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => _selectTime(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tertiaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Text(
                          _selectedTime != null
                              ? _selectedTime!.format(context)
                              : "Sélectionner une heure",
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Champ Motif
              ChampsTexte.buildTextField("Motif", motifController),
              const SizedBox(
                width: 16,
              ),

              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        context.showLoader();
                        final rendezVousService = RendezVousService();

                        RendezVous rdv = RendezVous(
                            id: 0,
                            motif: motifController.text,
                            date: _selectedDate!,
                            heure: heureRdv!,
                            statut: Statut(id: 0, libelle: "en attente"),
                            medecin: selectedMedecin!,
                            patient: selectedPatient!);

                        //Soumission de rdv
                        await rendezVousService
                            .createRendezVous(rdv)
                            .then((value) {
                          context.read<MyData>().fetchRendezVous();
                          context.hideLoader();
                          context.showSuccess(
                              "Le rendez-vous a été ajouté avec succès.");
                          widget.changeView();
                        }).catchError((onError) {
                          context.hideLoader();
                          context.showError("créneau non disponible !");
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text(
                        "Confirmer le rendez-vous",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: widget.changeView,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text(
                        "Annuler",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, String> getHeuresPourJour(String jour) {
    if (selectedMedecin == null)
      return {'heureDebut': '00:00', 'heureFin': '23:59'};

    var intervention = selectedMedecin!.joursIntervention.firstWhere(
      (e) => e['jour'] == jour,
      orElse: () => {},
    );

    return {
      'heureDebut': intervention['heureDebut'] ?? '00:00',
      'heureFin': intervention['heureFin'] ?? '23:59',
    };
  }

  void _selectTime(BuildContext context) async {
    if (_selectedDate == null || selectedMedecin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text("Veuillez sélectionner un médecin et une date d'abord.")),
      );
      return;
    }

    String dayOfWeek = DateFormat('EEEE').format(_selectedDate!).toUpperCase();
    Map<String, String> heuresIntervention = getHeuresPourJour(dayOfWeek);

    List<String> debutSplit = heuresIntervention['heureDebut']!.split(":");
    List<String> finSplit = heuresIntervention['heureFin']!.split(":");
    TimeOfDay heureDebut = TimeOfDay(
        hour: int.parse(debutSplit[0]), minute: int.parse(debutSplit[1]));
    TimeOfDay heureFin =
        TimeOfDay(hour: int.parse(finSplit[0]), minute: int.parse(finSplit[1]));

    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: heureDebut,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (selectedTime != null &&
        (selectedTime.hour >= heureDebut.hour &&
            selectedTime.hour <= heureFin.hour)) {
      setState(() {
        _selectedTime = selectedTime;
        heureRdv =
            '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                "Veuillez sélectionner une heure dans l'intervalle disponible.")),
      );
    }
  }

  void _selectDate(BuildContext context) async {
    if (selectedMedecin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Veuillez d'abord sélectionner un médecin.")),
      );
      return;
    }

    DateTime today = DateTime.now();
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
      selectableDayPredicate: (DateTime day) {
        String dayOfWeek = DateFormat('EEEE').format(day).toUpperCase();
        return selectedMedecin!.joursIntervention
            .map((e) => e['jour'] as String)
            .contains(dayOfWeek);
      },
    );

    if (selectedDate != null) {
      setState(() {
        _selectedDate = selectedDate;
      });
    }
  }

  Future<dynamic> selectionModal(
      BuildContext contexte, List<Patient> patients) {
    return showDialog(
      context: contexte,
      builder: (contexte) {
        return Dialog(
          child: FractionallySizedBox(
            heightFactor: 0.85,
            // widthFactor:
            //     0.8, // Ajuster la largeur pour que le dialog soit responsive
            child: Box(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Sélection de patient",
                      style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: DataTable(
                        headingTextStyle:
                            const TextStyle(fontWeight: FontWeight.bold),
                        columns: const [
                          DataColumn(label: Text("Prénom")),
                          DataColumn(label: Text("Nom")),
                          DataColumn(label: Text("Matricule")),
                          DataColumn(label: Text("Proffession")),
                          DataColumn(label: Text("Site de Travail")),
                          DataColumn(label: Text("Actions")),
                        ],
                        rows: List.generate(
                          patients.length,
                          (index) => DataRow(
                            cells: [
                              DataCell(Text(patients[index].prenom)),
                              DataCell(Text(patients[index].nom)),
                              DataCell(Text(patients[index].telephone)),
                              DataCell(patients[index].proffession != null
                                  ? Text(patients[index].proffession!)
                                  : const Text("Néant")),
                              DataCell(patients[index].sitedetravail != null
                                  ? Text(patients[index].sitedetravail!.nom)
                                  : const Text("Néant")),
                              DataCell(
                                ElevatedButton(
                                  onPressed: () {
                                    // Remplir les champs du formulaire avec les infos du patient sélectionné
                                    setState(() {
                                      selectedPatient = patients[index];
                                      print(
                                          "::::: le patient: ${selectedPatient!.email}.");
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> selectionMedecinModal(
      BuildContext contexte, List<Medecin> medecinList) {
    return showDialog(
      context: contexte,
      builder: (contexte) {
        return Dialog(
          child: FractionallySizedBox(
            heightFactor: 0.85,
            // widthFactor:
            //     0.8, // Ajuster la largeur pour que le dialog soit responsive
            child: Box(
                child: Column(
              children: [
                const Text("Sélection de médecin",
                    style: TextStyle(fontSize: 18)),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: DataTable(
                      columns: const [
                        DataColumn(
                            label: Text(
                          'Nom',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        DataColumn(
                            label: Text(
                          'Prénom',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        DataColumn(
                            label: Text(
                          'Matricule',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        DataColumn(
                            label: Text(
                          'Téléphone',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        DataColumn(
                            label: Text(
                          'Spécialité',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        DataColumn(
                            label: Text(
                          'Actions',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                      ],
                      rows: medecinList.map((medecin) {
                        return DataRow(cells: [
                          DataCell(SizedBox(
                              width: 100, child: Text(medecin.prenom))),
                          DataCell(
                              SizedBox(width: 100, child: Text(medecin.nom))),
                          DataCell(Text(medecin.matricule)),
                          DataCell(SizedBox(
                              width: 100, child: Text(medecin.telephone))),
                          DataCell(Text(medecin.specialite)),
                          DataCell(Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Remplir les champs du formulaire avec les infos du patient sélectionné
                                  setState(() {
                                    selectedMedecin = medecin;
                                    print(
                                        "::::: le selectedMedecin: ${selectedMedecin!.email}.");
                                  });
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: const Text(
                                  'Sélectionner',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          )),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ],
            )),
          ),
        );
      },
    );
  }
}
