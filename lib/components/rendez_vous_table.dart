import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:medstory/components/box.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/models/medecin.dart';
import 'package:medstory/models/my_data.dart';
import 'package:medstory/models/rendez_vous.dart';
import 'package:medstory/service/rendez_vous_service.dart';
import 'package:medstory/utils/lodder.dart';
import 'package:provider/provider.dart';

class RendezVousTable extends StatefulWidget {
  final List<RendezVous> rendezVousList;

  const RendezVousTable({super.key, required this.rendezVousList});

  @override
  State<RendezVousTable> createState() => _RendezVousTableState();
}

class _RendezVousTableState extends State<RendezVousTable> {
  final rendezVousService = RendezVousService();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? heureRdv;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DataTable(
          columns: const [
            DataColumn(
                label: Text(
              'Actions',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            DataColumn(
                label: Text(
              'Patient',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            DataColumn(
                label: Text(
              'Médecin',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            DataColumn(
                label: Text(
              'Date',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            DataColumn(
                label: Text(
              'Heure',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            DataColumn(
                label: Text(
              'Motif',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            DataColumn(
                label: Text(
              'Statut',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
          ],
          rows: widget.rendezVousList.map((rendezVous) {
            return DataRow(cells: [
              DataCell(Row(
                children: [
                  rendezVous.statut.libelle.contains("confirmé")
                      ? const Icon(Icons.check, color: Colors.grey)
                      : IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () async {
                            // Action pour accepter le rendez-vous
                            context.showLoader();

                            await rendezVousService.changeRendezVousStatut(
                                rendezVous.id,
                                {"id": 3, "libelle": "confirmé"}).then((value) {
                              context.read<MyData>().fetchRendezVous();
                              context.hideLoader();
                              context.showSuccess(
                                  "Le rendez-vous a été confirmé avec succès.");
                            }).catchError((onError) {
                              context.hideLoader();
                              context.showError("Oups !");
                            });
                          },
                        ),
                  rendezVous.statut.libelle.contains("annulé")
                      ? const Icon(Icons.cancel, color: Colors.grey)
                      : IconButton(
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.orange,
                          ),
                          onPressed: () async {
                            // TODO: Implementer la logique de reprogrammation ici.
                            customRdvModal(
                              context,
                              rendezVous,
                            );
                            // // Action pour annuler le rendez-vous
                            // context.showLoader();

                            // await rendezVousService.changeRendezVousStatut(
                            //     rendezVous.id,
                            //     {"id": 2, "libelle": "annulé"}).then((value) {
                            //   context.read<MyData>().fetchRendezVous();
                            //   context.hideLoader();
                            //   context.showSuccess(
                            //       "Le rendez-vous a été annulé avec succès.");
                            // }).catchError((onError) {
                            //   context.hideLoader();
                            //   context.showError("Oups !");
                            // });
                          },
                        ),
                  IconButton(
                    icon: SvgPicture.asset(
                      "assets/icons/supp.svg",
                      height: 25,
                      width: 25,
                    ),
                    onPressed: () async {
                      // Action pour supprimer le médecin
                      context.showLoader();
                      final rendezVousService = RendezVousService();
                      await rendezVousService
                          .deleteRendezVous(rendezVous.id)
                          .then((value) {
                        context
                            .read<MyData>()
                            .fetchRendezVous(); //TODO: Remplacer la logique (fetch only for current user)
                        context.hideLoader();
                        context.showSuccess(
                            "Le rendez-vous a été supprimé avec succès.");
                      }).catchError((onError) {
                        context.hideLoader();
                        context.showError(onError.toString());
                      });
                    },
                  ),
                ],
              )),
              DataCell(Text(
                  '${rendezVous.patient.prenom} ${rendezVous.patient.nom}')),
              DataCell(Text(
                  '${rendezVous.medecin.prenom} ${rendezVous.medecin.nom}')),
              DataCell(Text(
                  '${rendezVous.date.day}/${rendezVous.date.month}/${rendezVous.date.year}')),
              DataCell(Text(rendezVous.heure)),
              DataCell(Text(rendezVous.motif)),
              DataCell(Text(rendezVous.statut.libelle)),
            ]);
          }).toList(),
        ),
      ],
    );
  }

  Future<dynamic> customRdvModal(BuildContext contexte, RendezVous rdv) {
    return showDialog(
        context: contexte,
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.85,
            widthFactor: 0.8,
            child: Box(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Nouvelle programmation",
                    style: TextStyle(fontSize: 18)),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          "Medecin: Dr ${rdv.medecin.nom} ${rdv.medecin.prenom}",
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: Colors.black,
                                    // fontSize: 18,
                                  ),
                        ),
                        Text(
                          "Patient: ${rdv.patient.nom} ${rdv.patient.prenom}",
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: Colors.black,
                                    // fontSize: 18,
                                  ),
                        ),
                        Text(
                          "Motif: ${rdv.motif}",
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: Colors.black,
                                    // fontSize: 18,
                                  ),
                        ),

                        // Date de rendez-vous
                        Row(
                          children: [
                            Column(
                              children: [
                                const Text("Date de rendez-vous"),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    _selectDate(
                                      context,
                                      rdv.medecin,
                                    );
                                    print(rdv.medecin.joursIntervention);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  child: Text(
                                    _selectedDate != null
                                        ? DateFormat('dd/MM/yyyy')
                                            .format(_selectedDate!)
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
                                  onPressed: () => _selectTime(
                                    contexte,
                                    rdv.medecin,
                                  ),
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
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  // context.showLoader();
                                  // final rendezVousService = RendezVousService();

                                  // RendezVous rdv = RendezVous(
                                  //     id: 0,
                                  //     motif: motifController.text,
                                  //     date: _selectedDate!,
                                  //     heure: heureRdv!,
                                  //     statut: Statut(id: 0, libelle: "en attente"),
                                  //     medecin: selectedMedecin!,
                                  //     patient: selectedPatient!);

                                  // // TODO: à des fin de vidéo utiliser cette logige
                                  // Future.delayed(const Duration(milliseconds: 300), () {
                                  //   context.read<MyData>().addRendezVous(rdv);
                                  //   context.hideLoader();
                                  //   context.showSuccess(
                                  //       "Le rendez-vous a été ajouté avec succès.");
                                  //   widget.changeView();
                                  // });
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
                                onPressed: () {}, // TODO: Logique cancel ici.
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
              ],
            )),
          );
        });
  }

  void _selectDate(BuildContext context, Medecin? selectedMedecin) async {
    if (selectedMedecin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez d'abord sélectionner un médecin."),
        ),
      );
      return;
    }

    DateTime initialDate = getNextAvailableDate(selectedMedecin);

    DateTime today = initialDate;
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
      selectableDayPredicate: (DateTime day) {
        String dayOfWeek = DateFormat('EEEE').format(day).toUpperCase();
        return selectedMedecin.joursIntervention
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

  void _selectTime(BuildContext context, Medecin? selectedMedecin) async {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez d'abord sélectionner une date."),
        ),
      );
      return;
    }

    String dayOfWeek = DateFormat('EEEE').format(_selectedDate!).toUpperCase();
    Map<String, String> heuresIntervention =
        getHeuresPourJour(dayOfWeek, selectedMedecin);

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
            "Veuillez sélectionner une heure dans l'intervalle disponible.",
          ),
        ),
      );
    }
  }

  Map<String, String> getHeuresPourJour(String jour, Medecin? selectedMedecin) {
    if (selectedMedecin == null) {
      return {'heureDebut': '00:00', 'heureFin': '23:59'};
    }

    Map<String, dynamic> intervention =
        selectedMedecin.joursIntervention.firstWhere(
      (e) => e['jour'] == jour,
      orElse: () => {},
    );

    print(intervention);

    // return {
    //   'heureDebut': '00:00',
    //   'heureFin': '23:59',
    // };
    return {
      'heureDebut': intervention['heureDebut'] ?? '00:00',
      'heureFin': intervention['heureFin'] ?? '23:59',
    };
  }

  DateTime getNextAvailableDate(Medecin medecin) {
    DateTime today = DateTime.now();
    for (int i = 0; i < 7; i++) {
      DateTime dateToCheck = today.add(Duration(days: i));
      String dayOfWeek = DateFormat('EEEE').format(dateToCheck).toUpperCase();
      bool isInterventionDay = medecin.joursIntervention
          .map((e) => e['jour'] as String)
          .contains(dayOfWeek);
      if (isInterventionDay) {
        return dateToCheck;
      }
    }
    return today; // Retourne la date d'aujourd'hui si aucun jour d'intervention n'est trouvé
  }
}
