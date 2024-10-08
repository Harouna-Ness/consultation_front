class AntecedentFamilial {
  int? id;
  String? nomMaladie;

  AntecedentFamilial({this.id, this.nomMaladie});

  factory AntecedentFamilial.fromMap(Map<String, dynamic> map) {
    return AntecedentFamilial(
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
