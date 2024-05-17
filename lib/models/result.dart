class Result {
  final String resultId;
  final String competitionId;
  final String attendantId;
  final String attendantName;
  final String category;
  final double finalScore;
  final int rank;
  final String ageGroup; 

  Result({
    required this.resultId,
    required this.competitionId,
    required this.attendantId,
    required this.attendantName,
    required this.category,
    required this.finalScore,
    required this.rank,
    required this.ageGroup,
  });

  factory Result.fromMap(Map<String, dynamic> data) {
    return Result(
      resultId: data['resultId'],
      competitionId: data['competitionId'],
      attendantId: data['attendantId'],
      attendantName: data['attendantName'],
      category: data['category'],
      finalScore: data['finalScore'],
      rank: data['rank'],
      ageGroup: data['ageGroup'], 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'resultId': resultId,
      'competitionId': competitionId,
      'attendantId': attendantId,
      'attendantName': attendantName,
      'category': category,
      'finalScore': finalScore,
      'rank': rank,
      'ageGroup': ageGroup, 
    };
  }

  Result copyWith({
    String? resultId,
    String? competitionId,
    String? attendantId,
    String? attendantName,
    String? category,
    double? finalScore,
    int? rank,
    String? ageGroup,
  }) {
    return Result(
      resultId: resultId ?? this.resultId,
      competitionId: competitionId ?? this.competitionId,
      attendantId: attendantId ?? this.attendantId,
      attendantName: attendantName ?? this.attendantName,
      category: category ?? this.category,
      finalScore: finalScore ?? this.finalScore,
      rank: rank ?? this.rank,
      ageGroup: ageGroup ?? this.ageGroup,
    );
  }
}
