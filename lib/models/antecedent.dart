class Antecedent {
  int? id;
  String? nomMaladie;

  Antecedent({this.id, this.nomMaladie});

  factory Antecedent.fromMap(Map<String, dynamic> map) {
    return Antecedent(
      id: map['id'],
      nomMaladie: map['nomMaladie'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomMaladie': nomMaladie,
    };
  }
}
