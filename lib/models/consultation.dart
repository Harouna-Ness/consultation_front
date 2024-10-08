import 'package:medstory/models/bilan.dart';
import 'package:medstory/models/medecin';
import 'package:medstory/models/motif_de_consultation.dart';
import 'package:medstory/models/type_de_consultation.dart';

class Consultation {
  int? id;
  String? diagnostic;
  String? symptome;
  DateTime? creationDate;
  Medecin? medecin;
  TypeDeConsultation? typeDeConsultation;
  MotifDeConsultation? motifDeConsultation;
  Bilan? bilan;

  Consultation({
    this.id,
    this.diagnostic,
    this.symptome,
    this.creationDate,
    this.medecin,
    this.typeDeConsultation,
    this.motifDeConsultation,
    this.bilan,
  });

  factory Consultation.fromMap(Map<String, dynamic> map) {
    return Consultation(
      id: map['id'],
      diagnostic: map['diagnostic'],
      symptome: map['symptome'],
      creationDate: DateTime.parse(map['creationDate']),
      medecin: map['medecin'] != null ? Medecin.fromMap(map['medecin']) : null,
      typeDeConsultation: map['typeDeConsultation'] != null
          ? TypeDeConsultation.fromMap(map['typeDeConsultation'])
          : null,
      motifDeConsultation: map['motifDeConsultation'] != null
          ? MotifDeConsultation.fromMap(map['motifDeConsultation'])
          : null,
      bilan: map['bilan'] != null ? Bilan.fromMap(map['bilan']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'diagnostic': diagnostic,
      'symptome': symptome,
      'creationDate': creationDate?.toIso8601String(),
      'medecin': medecin?.toMap(),
      'typeDeConsultation': typeDeConsultation?.toMap(),
      'motifDeConsultation': motifDeConsultation?.toMap(),
      'bilan': bilan?.toMap(),
    };
  }
}
