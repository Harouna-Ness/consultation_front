class Direction {
  final int id;
  final String nom;

  Direction({required this.id, required this.nom,});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
    };
  }

  factory Direction.fromMap(Map<String, dynamic> map) {
    return Direction(
      id: map['id'],
      nom: map['nom'],
    );
  }

  @override
  String toString() {
    return 'Direction{id: $id, nom: $nom}';
  }
}