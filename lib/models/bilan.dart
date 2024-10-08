import 'package:medstory/models/analyse.dart';

class Bilan {
  int? id;
  List<Analyse>? analyses;

  Bilan({
    this.id,
    this.analyses,
  });

  factory Bilan.fromMap(Map<String, dynamic> map) {
    return Bilan(
      id: map['id'],
      analyses: map['analyses'] != null
          ? List<Analyse>.from(map['analyses'].map((item) => Analyse.fromMap(item)))
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'analyses': analyses?.map((item) => item.toMap()).toList(),
    };
  }
}
