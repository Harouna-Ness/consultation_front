class TypeDeConsultation {
  final int id;
  final String libelle;

  TypeDeConsultation({required this.id, required this.libelle});

  factory TypeDeConsultation.fromMap(Map<String, dynamic> map) {
    return TypeDeConsultation(
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
