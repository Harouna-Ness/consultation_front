class Sitedetravail {

  final int id;
  final String nom;

  Sitedetravail({required this.id, required this.nom,});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
    };
  }

  factory Sitedetravail.fromMap(Map<String, dynamic> map) {
    return Sitedetravail(
      id: map['id'],
      nom: map['nom'],
    );
  }

  @override
  String toString() {
    return 'Sitedetravail{id: $id, nom: $nom}';
  }
}