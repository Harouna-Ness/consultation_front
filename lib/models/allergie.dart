class Allergie {
  int? id;
  String? nom;

  Allergie({this.id, this.nom});

  factory Allergie.fromMap(Map<String, dynamic> map) {
    return Allergie(
      id: map['id'],
      nom: map['nom'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
    };
  }
}
