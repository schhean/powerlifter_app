
class Record {
  final int? id;
  final String exercice;
  final double charge;
  final String date;
  final String commentaire;


  Record({
    this.id,
    required this.exercice,
    required this.charge,
    required this.date,
    required this.commentaire,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'exercice': exercice,
      'charge': charge,
      'date': date,
      'commentaire': commentaire,
    };
  }

  factory Record.fromMap(Map<String, dynamic> map) {
    return Record(
      id: map['id'],
      exercice: map['exercice'],
      charge: map['charge'],
      date: map['date'],
      commentaire: map['commentaire'],
    );
  }

}