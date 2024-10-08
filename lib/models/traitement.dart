import 'package:medstory/models/patient.dart';

class Traitement {
  final int id;
  final String nom;
  final List<Patient> patientAssocies;

  Traitement({
    required this.id,
    required this.nom,
    required this.patientAssocies,
  });

  factory Traitement.fromMap(Map<String, dynamic> map) {
    return Traitement(
      id: map['id'],
      nom: map['nom'],
      patientAssocies: List<Patient>.from(map['patientAssocies'].map((x) => Patient.fromMap(x))),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'patientAssocies': patientAssocies.map((x) => x.toMap()).toList(),
    };
  }
}
