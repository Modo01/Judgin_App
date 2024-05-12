class Result {
  String resultId;
  String competitionId;
  String participantId;
  double finalScore;
  int rank;

  Result({
    required this.resultId,
    required this.competitionId,
    required this.participantId,
    required this.finalScore,
    required this.rank,
  });

  Map<String, dynamic> toMap() {
    return {
      'resultId': resultId,
      'competitionId': competitionId,
      'participantId': participantId,
      'finalScore': finalScore,
      'rank': rank,
    };
  }

  factory Result.fromMap(Map<String, dynamic> map) {
    return Result(
      resultId: map['resultId'] ?? '',
      competitionId: map['competitionId'] ?? '',
      participantId: map['participantId'] ?? '',
      finalScore: map['finalScore']?.toDouble() ?? 0.0,
      rank: map['rank'] ?? 0,
    );
  }
}
