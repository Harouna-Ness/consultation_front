import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medstory/components/box.dart';
import 'package:medstory/components/time_slot_selector.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/models/medecin.dart';
import 'package:medstory/models/my_data.dart';
import 'package:medstory/models/rendez_vous.dart';
import 'package:medstory/service/rendez_vous_service.dart';
import 'package:medstory/utils/lodder.dart';
import 'package:provider/provider.dart';

class RdvReprog extends StatefulWidget {
  final RendezVous rdv;
  const RdvReprog({
    super.key,
    required this.rdv,
  });

  @override
  State<RdvReprog> createState() => _RdvReprogState();
}

class _RdvReprogState extends State<RdvReprog> {
  final rendezVousService = RendezVousService();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? heureRdv;
  bool showSlot = false;

  // Obtenir les heures de début et de fin en fonction d'un jour spécifique
  Map<String, String>? heuresIntervention;

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

    setState(() {
      _selectedDate = selectedDate;
      _selectedTime = null;
    });
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

  Map<String, String> getHeuresPourJourM(Medecin medecin, DateTime date) {
    String dayOfWeek = DateFormat('EEEE').format(date).toUpperCase();
    var intervention = medecin.joursIntervention.firstWhere(
      (e) => e['jour'] == dayOfWeek,
      orElse: () => {},
    );
    if (intervention.isEmpty) {
      return {'heureDebut': '00:00', 'heureFin': '23:59'};
    }
    return {
      'heureDebut':
          '${intervention['heureDebut'][0].toString().padLeft(2, '0')}:${intervention['heureDebut'][1].toString().padLeft(2, '0')}',
      'heureFin':
          '${intervention['heureFin'][0].toString().padLeft(2, '0')}:${intervention['heureFin'][1].toString().padLeft(2, '0')}',
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedDate != null) {
      heuresIntervention =
          getHeuresPourJourM(widget.rdv.medecin, _selectedDate!);
    }

    return Box(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("Nouvelle programmation", style: TextStyle(fontSize: 18)),
        const SizedBox(height: 16),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text("Medecin: "),
                    Text(
                      "Dr ${widget.rdv.medecin.nom} ${widget.rdv.medecin.prenom}",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.black,
                            // fontSize: 18,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text("Patient: "),
                    Text(
                      "${widget.rdv.patient.nom} ${widget.rdv.patient.prenom}",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.black,
                            // fontSize: 18,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text("Motif: "),
                    Text(
                      widget.rdv.motif,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.black,
                            // fontSize: 18,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text("Date: "),
                    Text(
                      DateFormat('dd/MM/yyyy').format(widget.rdv.date),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.black,
                            // fontSize: 18,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text("Heure: "),
                    Text(
                      widget.rdv.heure,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.black,
                            // fontSize: 18,
                          ),
                    ),
                  ],
                ),

                // Date de rendez-vous
                Row(
                  children: [
                    Column(
                      children: [
                        // const Text("Date de rendez-vous"),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            _selectDate(
                              context,
                              widget.rdv.medecin,
                            );
                            print(widget.rdv.medecin.joursIntervention);
                            print(_selectedDate.toString());
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
                                : "Modifier la date",
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
                        // const Text("Heure de rendez-vous"),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            if (_selectedDate == null) {
                              _selectedDate = widget.rdv.date;
                              heuresIntervention = getHeuresPourJourM(
                                  widget.rdv.medecin, _selectedDate!);
                            }
                            setState(() {
                              showSlot = true;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: tertiaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Text(
                            _selectedTime != null
                                ? _selectedTime!.format(context)
                                : "Modifier l'heure",
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(width: 16),
                if (showSlot && heuresIntervention != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TimeSlotSelector(
                      medecinId: widget.rdv.medecin.id!,
                      selectedDate: _selectedDate!,
                      heureDebut: heuresIntervention!['heureDebut']!,
                      heureFin: heuresIntervention!['heureFin']!,
                      intervalMinutes: 10,
                      onTimeSelected: (TimeOfDay slot) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            _selectedTime = slot;
                            heureRdv = formatTimeOfDay24(slot);
                            print(heureRdv);
                          });
                        });
                      },
                    ),
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

                          try {
                            rendezVousService
                                .modifierDateRdv(
                              rdv: widget.rdv,
                              date: _selectedDate ?? widget.rdv.date,
                              heure: heureRdv!,
                            )
                                .then((onValue) {
                              context.read<MyData>().fetchRendezVous();
                              context.hideLoader();
                              Navigator.of(context).pop();
                              context.showSuccess(
                                  "Le rendez-vous a été reprogrammé avec succès !");
                            });
                          } catch (e) {
                            print(e);
                            context.hideLoader();
                            throw throw Exception(
                                'Erreur lors de la mise à jour du rendez-vous: $e');
                          }
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
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
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
    ));
  }
}
