import 'package:medstory/models/analyse.dart';

class ExamenBiologique {
  int? id;
  List<Analyse>? analyses;

  ExamenBiologique({this.id, this.analyses});

  factory ExamenBiologique.fromMap(Map<String, dynamic> map) {
    return ExamenBiologique(
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
