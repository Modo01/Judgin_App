class Score {
  final String competitionId;
  final String attendantId; 
  final String judgeId;
  final String category;
  final double scoreValue;
  final String comment;
  final String judgeType;

  Score({
    required this.competitionId,
    required this.attendantId, 
    required this.judgeId,
    required this.category,
    required this.scoreValue,
    required this.comment,
    required this.judgeType,
  });

  factory Score.fromMap(Map<String, dynamic> data) {
    return Score(
      competitionId: data['competitionId'],
      attendantId: data['attendantId'], 
      judgeId: data['judgeId'],
      category: data['category'],
      scoreValue: data['scoreValue'],
      comment: data['comment'],
      judgeType: data['judgeType'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'competitionId': competitionId,
      'attendantId': attendantId, 
      'judgeId': judgeId,
      'category': category,
      'scoreValue': scoreValue,
      'comment': comment,
      'judgeType': judgeType,
    };
  }
}
