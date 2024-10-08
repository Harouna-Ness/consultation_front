class Role {
  final int id;
  final String libelle;

  Role({required this.id, required this.libelle});

  factory Role.fromMap(Map<String, dynamic> map) {
    return Role(
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
