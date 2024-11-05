class Statut {
  final int id;
  final String libelle;

  Statut({required this.id, required this.libelle});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'libelle': libelle,
    };
  }

  factory Statut.fromMap(Map<String, dynamic> map) {
    return Statut(
      id: map['id'],
      libelle: map['libelle'],
    );
  }

  @override
  String toString() {
    return 'Statut{id: $id, libelle: $libelle}';
  }
}