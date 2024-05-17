import 'package:flutter/material.dart';
import 'package:judging_app/models/UserModel.dart';
import 'package:judging_app/models/score.dart';
import 'package:judging_app/service/score_service.dart';

class ChairJudgeScreen extends StatelessWidget {
  final UserModel judge;
  final String competitionId;
  final String attendantId;
  final String category;

  ChairJudgeScreen({
    required this.judge,
    required this.competitionId,
    required this.attendantId,
    required this.category,
  });

  final TextEditingController _scoreController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ерөнхий шүүлт',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF001C55),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _scoreController,
              decoration: InputDecoration(
                labelText: 'Хасалт',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF001C55), width: 2.0),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                labelText: 'Сэтгэгдэл',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF001C55), width: 2.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                double scoreValue = double.parse(_scoreController.text);
                String comment = _commentController.text;
                Score score = Score(
                  competitionId: competitionId,
                  attendantId: attendantId,
                  judgeId: judge.userId,
                  category: category,
                  scoreValue: scoreValue,
                  comment: comment,
                  judgeType: 'chair',
                );
                await ScoreService().saveScore(score, context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFF0E6BA8),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Хасалт илгээх'),
            ),
          ],
        ),
      ),
    );
  }
}
