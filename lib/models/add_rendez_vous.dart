import 'package:flutter/material.dart';
import 'package:medstory/components/add_user_form.dart';
import 'package:medstory/models/medecin.dart';
import 'package:medstory/models/my_data.dart';
import 'package:medstory/models/patient.dart';
import 'package:provider/provider.dart';

class AddRendezVousForm extends StatefulWidget {
  const AddRendezVousForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddRendezVousFormState createState() => _AddRendezVousFormState();
}

class _AddRendezVousFormState extends State<AddRendezVousForm> {
  Patient? selectedPatient;
  Medecin? selectedMedecin;
  String? specialite;
  DateTime? selectedDate;
  String? selectedTimeSlot;
  String? motif;
  bool isForFamilyMember = false;
  bool isChild = false;

  final TextEditingController motifController = TextEditingController();

  List<Patient> patients = [/* Liste des patients ici */];
  List<String> specialites = [/* Liste des spécialités */ "spécialité"];
  List<Medecin> medecins = [
    /* Liste des médecins en fonction de la spécialité */
  ];
  List<String> availableTimeSlots = [];

  @override
  Widget build(BuildContext context) {
    patients = context.watch<MyData>().patients;
    medecins = context.watch<MyData>().medecins;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sélection du patient
          DropdownButtonFormField<Patient>(
            decoration: InputDecoration(labelText: 'Patient'),
            value: selectedPatient,
            items: patients.map((Patient patient) {
              return DropdownMenuItem<Patient>(
                value: patient,
                child: Text('${patient.nom} ${patient.prenom}'),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedPatient = value;
              });
            },
          ),
          Row(
            children: [
              Text('Pour un membre de la famille ?'),
              Switch(
                value: isForFamilyMember,
                onChanged: (value) {
                  setState(() {
                    isForFamilyMember = value;
                    isChild = false; // Reset enfant switch
                  });
                },
              ),
            ],
          ),
          if (isForFamilyMember)
            Row(
              children: [
                Text('Enfant ?'),
                Switch(
                  value: isChild,
                  onChanged: (value) {
                    setState(() {
                      isChild = value;
                    });
                  },
                ),
              ],
            ),
          // Sélection de la spécialité
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: 'Spécialité'),
            value: specialite,
            items: specialites.map((String spec) {
              return DropdownMenuItem<String>(
                value: spec,
                child: Text(spec),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                specialite = value;
                // Filtrer les médecins par spécialité
                selectedMedecin = null;
              });
            },
          ),
          // Sélection du médecin
          if (specialite != null)
            DropdownButtonFormField<Medecin>(
              decoration: InputDecoration(labelText: 'Médecin'),
              value: selectedMedecin,
              items: medecins.map((Medecin medecin) {
                return DropdownMenuItem<Medecin>(
                  value: medecin,
                  child: Text('${medecin.nom} ${medecin.prenom}'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedMedecin = value;
                });
              },
            ),
          // Sélection de la date
          if (selectedMedecin != null)
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text(selectedDate != null
                  ? selectedDate.toString()
                  : 'Sélectionner la date'),
            ),

          // Sélection des créneaux horaires disponibles
          if (selectedDate != null && availableTimeSlots.isNotEmpty)
            Wrap(
              spacing: 8.0,
              children: availableTimeSlots.map((slot) {
                return ChoiceChip(
                  label: Text(slot),
                  selected: selectedTimeSlot == slot,
                  onSelected: (selected) {
                    setState(() {
                      selectedTimeSlot = selected ? slot : null;
                    });
                  },
                );
              }).toList(),
            ),
          // Champ pour le motif
          TextField(
            controller: motifController,
            decoration: InputDecoration(labelText: 'Motif'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Enregistrer le rendez-vous
              if (selectedPatient != null &&
                  selectedMedecin != null &&
                  selectedDate != null &&
                  selectedTimeSlot != null) {
                // Logique d'enregistrement ici
              }
            },
            child: Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  List<String> getAvailableTimeSlotsForDate(Medecin medecin, DateTime date) {
    // Simuler des créneaux horaires pour l'exemple
    return ['09:00', '09:15', '09:30', '10:00', '10:15', '10:30'];
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      selectableDayPredicate: (DateTime date) {
        // Remplace `joursIntervention` par la liste de jours d'intervention du médecin
        List<int> joursIntervention = [
          1,
          3,
          5
        ]; // Ex. Lundi, Mercredi, Vendredi
        return joursIntervention.contains(date.weekday);
      },
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        // Mettre à jour les créneaux horaires disponibles en fonction de la date choisie
        availableTimeSlots =
            getAvailableTimeSlotsForDate(selectedMedecin!, pickedDate);
      });
    }
  }
}
