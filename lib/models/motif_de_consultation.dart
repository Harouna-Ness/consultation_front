class MotifDeConsultation {
  int? id;
  String? motif;

  MotifDeConsultation({
    this.id,
    this.motif,
  });

  factory MotifDeConsultation.fromMap(Map<String, dynamic> map) {
    return MotifDeConsultation(
      id: map['id'],
      motif: map['motif'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'motif': motif,
    };
  }
}
