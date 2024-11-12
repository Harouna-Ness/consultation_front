import 'package:medstory/models/medecin.dart';
import 'package:medstory/models/patient.dart';
import 'package:medstory/models/statut.dart';

class RendezVous {
  final int id;
  final String motif;
  final DateTime date;
  final String heure;
  final Statut statut;
  final Medecin medecin;
  final Patient patient;

  RendezVous({
    required this.id,
    required this.motif,
    required this.date,
    required this.heure,
    required this.statut,
    required this.medecin,
    required this.patient,
  });

  factory RendezVous.fromMap(Map<String, dynamic> map) {
    return RendezVous(
      id: map['id'],
      motif: map['motif'],
      date: DateTime.parse("2020-02-02"), //DateTime.parse(map['date']),
      heure: "00:00", //map['heure'],
      statut: Statut.fromMap(map['statut']),
      medecin: Medecin.fromMap(map['medecin']),
      patient: Patient.fromMap(map['patient']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'motif': motif,
      'date': date.toIso8601String(),
      'heure': heure,
      'statut': statut.toMap(),
      'medecin': medecin.toMap(),
      'patient': patient.toMap(),
    };
  }
}
