import 'package:medstory/models/allergie.dart';
import 'package:medstory/models/antecedantfamilial.dart';
import 'package:medstory/models/antecedent.dart';
import 'package:medstory/models/consultation.dart';

class DossierMedical {
  int? id;
  List<Consultation>? consultations;
  List<Allergie>? allergies;
  List<Antecedent>? antecedents;
  List<AntecedentFamilial>? antecedentFamiliaux;

  DossierMedical({
    this.id,
    this.consultations,
    this.allergies,
    this.antecedents,
    this.antecedentFamiliaux,
  });

  factory DossierMedical.fromMap(Map<String, dynamic> map) {
    return DossierMedical(
      id: map['id'],
      consultations: map['consultations'] != null
          ? List<Consultation>.from(
              map['consultations'].map((x) => Consultation.fromMap(x)))
          : [],
      allergies: map['allergies'] != null
          ? List<Allergie>.from(
              map['allergies'].map((x) => Allergie.fromMap(x)))
          : [],
      antecedents: map['antecedents'] != null
          ? List<Antecedent>.from(
              map['antecedents'].map((x) => Antecedent.fromMap(x)))
          : [],
      antecedentFamiliaux: map['antecedentFamiliaux'] != null
          ? List<AntecedentFamilial>.from(map['antecedentFamiliaux']
              .map((x) => AntecedentFamilial.fromMap(x)))
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'consultations': consultations?.map((e) => e.toMap()).toList(),
      'allergies': allergies?.map((e) => e.toMap()).toList(),
      'antecedents': antecedents?.map((e) => e.toMap()).toList(),
      'antecedentFamiliaux':
          antecedentFamiliaux?.map((e) => e.toMap()).toList(),
    };
  }
}
