import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:judging_app/models/score.dart';
import 'package:judging_app/models/result.dart';

class ScoreService {
  Future<bool> saveScore(Score score, BuildContext context) async {
    if (score.judgeType == 'artistic' || score.judgeType == 'execution') {
      if (score.scoreValue > 10) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Зөвшөөрөгдөөгүй оноо'),
              content: Text(
                  'Гүйцэтгэл болон жүжиглэлтийн шүүгчийн өгөх боломжтой дээд оноо 10!.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return false;
      }
    }

    QuerySnapshot existingScores = await FirebaseFirestore.instance
        .collection('scores')
        .where('competitionId', isEqualTo: score.competitionId)
        .where('attendantId', isEqualTo: score.attendantId)
        .where('judgeId', isEqualTo: score.judgeId)
        .where('category', isEqualTo: score.category)
        .where('judgeType', isEqualTo: score.judgeType)
        .get();

    if (existingScores.docs.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Шүүгдсэн'),
            content: Text('Та энэ оролцогчид оноо өгсөн байна.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return false;
    }

    await FirebaseFirestore.instance.collection('scores').add(score.toMap());
    Navigator.pop(context, true);
    return true;
  }

  Future<void> calculateAndSaveFinalScores(String competitionId) async {
    QuerySnapshot<Map<String, dynamic>> scoresSnapshot = await FirebaseFirestore
        .instance
        .collection('scores')
        .where('competitionId', isEqualTo: competitionId)
        .get();

    Map<String, Map<String, Map<String, List<Score>>>> scoresMap = {};
    for (var doc in scoresSnapshot.docs) {
      Score score = Score.fromMap(doc.data());
      scoresMap
          .putIfAbsent(score.attendantId, () => {})
          .putIfAbsent(score.category, () => {})
          .putIfAbsent(score.judgeType, () => [])
          .add(score);
    }

    for (var attendantEntry in scoresMap.entries) {
      String attendantId = attendantEntry.key;
      for (var categoryEntry in attendantEntry.value.entries) {
        String category = categoryEntry.key;
        Map<String, List<Score>> categoryScores = categoryEntry.value;

        double finalScore = calculateFinalScore(categoryScores);

        bool allJudgesScored = await allJudgesScoredForCategory(
            attendantId, category, competitionId);

        if (allJudgesScored) {
          await saveFinalResult(
              competitionId, attendantId, category, finalScore);
        }
      }
    }
  }

  Future<bool> allJudgesScoredForCategory(
      String attendantId, String category, String competitionId) async {
    QuerySnapshot judgeScoresSnapshot = await FirebaseFirestore.instance
        .collection('scores')
        .where('competitionId', isEqualTo: competitionId)
        .where('attendantId', isEqualTo: attendantId)
        .where('category', isEqualTo: category)
        .get();

    return judgeScoresSnapshot.docs.length == 11;
  }

  double calculateFinalScore(Map<String, List<Score>> categoryScores) {
    double artisticScore = 0.0;
    double executionScore = 0.0;
    double difficultyScore = 0.0;
    double chairDeduction = 0.0;

    if (categoryScores.containsKey('artistic')) {
      artisticScore = calculateAorEScore(categoryScores['artistic']!);
    }

    if (categoryScores.containsKey('execution')) {
      executionScore = calculateAorEScore(categoryScores['execution']!);
    }

    if (categoryScores.containsKey('difficulty')) {
      difficultyScore = categoryScores['difficulty']!
              .map((e) => e.scoreValue)
              .reduce((a, b) => a + b) /
          4.0;
    }

    if (categoryScores.containsKey('chair')) {
      chairDeduction = categoryScores['chair']!
          .map((e) => e.scoreValue)
          .reduce((a, b) => a + b);
    }

    return artisticScore + executionScore + difficultyScore - chairDeduction;
  }

  double calculateAorEScore(List<Score> scores) {
    scores.sort((a, b) => a.scoreValue.compareTo(b.scoreValue));

    double finalScore = 0.0;
    if (scores.length == 4) {
      finalScore = (scores[1].scoreValue + scores[2].scoreValue);
    }

    return finalScore / 2.0;
  }

  Future<void> saveFinalResult(String competitionId, String attendantId,
      String category, double finalScore) async {
    DocumentReference attendantRef =
        FirebaseFirestore.instance.collection('attendants').doc(attendantId);
    DocumentSnapshot attendantSnapshot = await attendantRef.get();
    String fetchedAttendantId = attendantSnapshot.id;
    String attendantName = attendantSnapshot.get('attendantName');
    String ageGroup = attendantSnapshot.get('ageGroup');

    QuerySnapshot existingResults = await FirebaseFirestore.instance
        .collection('results')
        .where('competitionId', isEqualTo: competitionId)
        .where('attendantId', isEqualTo: fetchedAttendantId)
        .where('category', isEqualTo: category)
        .get();

    if (existingResults.docs.isNotEmpty) {
      return;
    }

    Result result = Result(
      resultId: FirebaseFirestore.instance.collection('results').doc().id,
      competitionId: competitionId,
      attendantId: fetchedAttendantId,
      attendantName: attendantName,
      category: category,
      finalScore: finalScore,
      rank: 0,
      ageGroup: ageGroup,
    );

    await FirebaseFirestore.instance
        .collection('results')
        .doc(result.resultId)
        .set(result.toMap());
  }
}
