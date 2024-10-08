class Analyse {
  int? id;
  String? libelle;

  Analyse({
    this.id,
    this.libelle,
  });

  factory Analyse.fromMap(Map<String, dynamic> map) {
    return Analyse(
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
