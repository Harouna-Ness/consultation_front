import 'package:medstory/models/bilan.dart';
import 'package:medstory/models/medecin.dart';
import 'package:medstory/models/motif_de_consultation.dart';
import 'package:medstory/models/type_de_consultation.dart';

class Consultation {
  int? id;
  String? hypotheseDiagnostic;
  String? diagnosticRetenu;
  String? examenPhysique;
  String? histoireDeLaMaladie;
  String? symptome;
  DateTime? creationDate;
  Medecin? medecin;
  TypeDeConsultation? typeDeConsultation;
  MotifDeConsultation? motifDeConsultation;
  Bilan? bilan;
  List<String>? prescriptions;
  String? patientFullName;

  Consultation({
    this.id,
    this.hypotheseDiagnostic,
    this.diagnosticRetenu,
    this.examenPhysique,
    this.histoireDeLaMaladie,
    this.symptome,
    this.creationDate,
    this.medecin,
    this.typeDeConsultation,
    this.motifDeConsultation,
    this.bilan,
    this.prescriptions,
    this.patientFullName,
  });

  factory Consultation.fromMap(Map<String, dynamic> map) {
    return Consultation(
      id: map['id'],
      hypotheseDiagnostic: map['hypotheseDiagnostic'],
      diagnosticRetenu: map['diagnosticRetenu'],
      examenPhysique: map['examenPhysique'],
      histoireDeLaMaladie: map['histoireDeLaMaladie'],
      symptome: map['symptome'],
      creationDate: map['creationDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['creationDate'])
          : null,
      medecin: map['medecin'] != null ? Medecin.fromMap(map['medecin']) : null,
      typeDeConsultation: map['typeDeConsultation'] != null
          ? TypeDeConsultation.fromMap(map['typeDeConsultation'])
          : null,
      motifDeConsultation: map['motifDeConsultation'] != null
          ? MotifDeConsultation.fromMap(map['motifDeConsultation'])
          : null,
      bilan: map['bilan'] != null ? Bilan.fromMap(map['bilan']) : null,
      prescriptions:
          map['prescriptions'] != null ? List.from(map['prescriptions']) : [],
      patientFullName: map['patientFullName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'hypotheseDiagnostic': hypotheseDiagnostic,
      'diagnosticRetenu': diagnosticRetenu,
      'examenPhysique': examenPhysique,
      'histoireDeLaMaladie': histoireDeLaMaladie,
      'symptome': symptome,
      'creationDate': creationDate?.toIso8601String(),
      'medecin': medecin?.toMap(),
      'typeDeConsultation': typeDeConsultation?.toMap(),
      'motifDeConsultation': motifDeConsultation?.toMap(),
      'bilan': bilan?.toMap(),
      'prescriptions': prescriptions?.map((item) => item).toList(),
      'patientFullName': patientFullName,
    };
  }
}
