import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medstory/components/box.dart';
import 'package:medstory/components/champs_texte.dart';
import 'package:medstory/constantes.dart';
import 'package:medstory/models/direction.dart';
import 'package:medstory/models/dossier_medical.dart';
import 'package:medstory/models/medecin.dart';
import 'package:medstory/models/my_data.dart';
import 'package:medstory/models/patient.dart';
import 'package:medstory/models/rendez_vous.dart';
import 'package:medstory/models/role.dart';
import 'package:medstory/models/site_de_tavail.dart';
import 'package:medstory/models/statut.dart';
import 'package:medstory/models/statut_patient.dart';
import 'package:medstory/service/rendez_vous_service.dart';
import 'package:medstory/utils/lodder.dart';
import 'package:provider/provider.dart';

class RdvDialog extends StatefulWidget {
  final Medecin medecin;
  final Patient patient;

  const RdvDialog({super.key, required this.medecin, required this.patient});

  @override
  State<RdvDialog> createState() => _RdvDialogState();
}

class _RdvDialogState extends State<RdvDialog> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _motif = '';
  String? heureRdv;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text('Patient : ${widget.patient.nom} ${widget.patient.prenom}'),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Date',
              style: TextStyle(
                color: Colors.black,
                // fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              _selectDate(context);
            },
            child: IgnorePointer(
              child: TextFormField(
                controller: TextEditingController(
                  text: _selectedDate != null
                      ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                      : '',
                ),
                decoration: const InputDecoration(
                    // labelText: 'Date',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)))),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Heure',
              style: TextStyle(
                color: Colors.black,
                // fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              _selectTime(context);
            },
            child: IgnorePointer(
              child: TextFormField(
                controller: TextEditingController(
                  text: _selectedTime != null
                      ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
                      : '',
                ),
                decoration: const InputDecoration(
                    // labelText: 'Heure',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)))),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Motif',
              style: TextStyle(
                color: Colors.black,
                // fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextFormField(
            maxLines: 3,
            onChanged: (value) => setState(() => _motif = value),
            decoration: const InputDecoration(
                // labelText: 'Motif',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)))),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    context.showLoader();
                    final rendezVousService = RendezVousService();
                    if (_selectedDate != null && _selectedTime != null) {
                      DateTime rdvDateTime = DateTime(
                          _selectedDate!.year,
                          _selectedDate!.month,
                          _selectedDate!.day,
                          _selectedTime!.hour,
                          _selectedTime!.minute);
                      RendezVous rdv = RendezVous(
                        id: 0,
                        motif: _motif,
                        date: _selectedDate!,
                        heure:
                            heureRdv!,
                        statut: Statut(id: 1, libelle: ""),
                        medecin: widget.medecin,
                        patient:widget.patient,
                      );
                      // Logique d'enregistrement du rendez-vous
                      //Soumission de rdv
                      await rendezVousService
                          .createRendezVous(rdv)
                          .then((value) {
                        context.hideLoader();
                        context.showSuccess(
                            "Le rendez-vous a été ajouté avec succès.");
                      }).catchError((onError) {
                        context.hideLoader();
                        context.showError("créneau non disponible !");
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Veuillez sélectionner une date et une heure.'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'Confirmer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
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

  void _selectDate(BuildContext context) async {
    DateTime initialDate = getNextAvailableDate(widget.medecin);

    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: initialDate,
      lastDate: initialDate.add(const Duration(days: 365)),
      selectableDayPredicate: (DateTime day) {
        String dayOfWeek = DateFormat('EEEE').format(day).toUpperCase();
        return widget.medecin.joursIntervention
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

  void _selectTime(BuildContext context) async {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez d'abord sélectionner une date."),
        ),
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
            "Veuillez sélectionner une heure dans l'intervalle disponible.",
          ),
        ),
      );
    }
  }

  Map<String, String> getHeuresPourJour(String jour) {
    var intervention = widget.medecin.joursIntervention.firstWhere(
      (e) => e['jour'] == jour,
      orElse: () => {},
    );

    return {
      'heureDebut': intervention['heureDebut'] ?? '00:00',
      'heureFin': intervention['heureFin'] ?? '23:59',
    };
  }
}
