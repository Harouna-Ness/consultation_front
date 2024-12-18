import 'package:medstory/models/examen_biologique.dart';
import 'package:medstory/models/radiographie.dart';

class Bilan {
  int? id;
  ExamenBiologique? examensBiologique;
  Radiographie? radiographie;

  Bilan({this.id, this.examensBiologique, this.radiographie});

  factory Bilan.fromMap(Map<String, dynamic> map) {
    return Bilan(
      id: map['id'],
      examensBiologique: map['examensBiologique'] != null
          ? ExamenBiologique.fromMap(map['examensBiologique'])
          : null,
      radiographie: map['radiographie'] != null
          ? Radiographie.fromMap(map['radiographie'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'examensBiologique': examensBiologique?.toMap(),
      'radiographie': radiographie?.toMap(),
    };
  }
}
