import 'package:medstory/models/analyse.dart';

class Radiographie {
  int? id;
  List<Analyse>? analyses;

  Radiographie({this.id, this.analyses});

  factory Radiographie.fromMap(Map<String, dynamic> map) {
    return Radiographie(
      id: map['id'],
      analyses: map['analyses'] != null
          ? (map['analyses'] as List)
              .map((analyseMap) => Analyse.fromMap(analyseMap))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'analyses': analyses?.map((analyse) => analyse.toMap()).toList(),
    };
  }
}
