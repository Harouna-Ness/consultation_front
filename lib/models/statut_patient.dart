class StatutPatient {
  final int id;
  final String libelle;

  StatutPatient({required this.id, required this.libelle});

  factory StatutPatient.fromMap(Map<String, dynamic> map) {
    return StatutPatient(
      id: map['id'],
      libelle: map['libelle'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'libelle': libelle,
    };
  }
}
