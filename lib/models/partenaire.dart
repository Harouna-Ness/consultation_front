class Partenaire {
  final int id;
  final String nom;
  final String type;
  final String adresse;
  final String telephone;
  final String? image;

  Partenaire({
    required this.id,
    required this.nom,
    required this.type,
    required this.adresse,
    required this.telephone,
    this.image,
  });

  factory Partenaire.fromJson(Map<String, dynamic> json) {
    return Partenaire(
      id: json['id'],
      nom: json['nom'],
      type: json['type'],
      adresse: json['adresse'],
      telephone: json['telephone'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'type': type,
      'adresse': adresse,
      'telephone': telephone,
      'image': image,
    };
  }
}