class Score {
  String scoreId;
  String competitionId;
  String athleteId;
  String judgeId;
  String category;
  double scoreValue;

  Score({
    required this.scoreId,
    required this.competitionId,
    required this.athleteId,
    required this.judgeId,
    required this.category,
    required this.scoreValue,
  });

  factory Score.fromMap(Map<String, dynamic> map) {
    return Score(
      scoreId: map['scoreId'] ?? '',
      competitionId: map['competitionId'] ?? '',
      athleteId: map['athleteId'] ?? '',
      judgeId: map['judgeId'] ?? '',
      category: map['category'] ?? '',
      scoreValue: map['scoreValue']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'scoreId': scoreId,
      'competitionId': competitionId,
      'athleteId': athleteId,
      'judgeId': judgeId,
      'category': category,
      'scoreValue': scoreValue,
    };
  }
}

