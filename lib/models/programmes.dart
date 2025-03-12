
class Programme {
  final int? id;
  final double squatPR;
  final double benchPR;
  final double deadliftPR;

  Programme({
    this.id,
    required this.squatPR,
    required this.benchPR,
    required this.deadliftPR,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'squatPR': squatPR,
      'benchPR': benchPR,
      'deadliftPR': deadliftPR,
    };
  }

  factory Programme.fromMap(Map<String, dynamic> map) {
    return Programme(
      id: map['id'],
      squatPR: map['squatPR'],
      benchPR: map['benchPR'],
      deadliftPR: map['deadliftPR']
    );
  }
}