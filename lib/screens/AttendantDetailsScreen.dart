import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tuple/tuple.dart';
import 'package:judging_app/models/UserModel.dart';
import 'package:judging_app/models/score.dart';
import 'package:judging_app/screens/judgeScreen/ArtistryJudgeScreen.dart';
import 'package:judging_app/screens/judgeScreen/ChairJudgeScreen.dart';
import 'package:judging_app/screens/judgeScreen/DifficultyJudgeScreen.dart';
import 'package:judging_app/screens/judgeScreen/ExecutionJudgeScreen.dart';

class AttendantDetailsScreen extends StatefulWidget {
  final String attendantId;
  final String competitionId;

  AttendantDetailsScreen(
      {Key? key, required this.attendantId, required this.competitionId})
      : super(key: key);

  @override
  _AttendantDetailsScreenState createState() => _AttendantDetailsScreenState();
}

class _AttendantDetailsScreenState extends State<AttendantDetailsScreen> {
  List<Tuple2<UserModel, String>> judges = [];
  List<UserModel> athletes = [];
  List<Score> scores = [];
  UserModel? currentUser;
  bool isLoading = true;
  String competitionId = '';
  String attendantCategory = '';

  @override
  void initState() {
    super.initState();
    fetchCurrentUser().then((_) {
      fetchAttendantAndCompetitionDetails();
    });
  }

  Future<void> fetchCurrentUser() async {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();
      if (userDoc.exists && userDoc.data() != null) {
        setState(() {
          currentUser = UserModel.fromMap(userDoc.data()!);
        });
      }
    }
  }

  Future<void> fetchAttendantAndCompetitionDetails() async {
    setState(() => isLoading = true);
    try {
      DocumentSnapshot<Map<String, dynamic>> attendantData =
          await FirebaseFirestore.instance
              .collection('attendants')
              .doc(widget.attendantId)
              .get();
      if (attendantData.exists && attendantData.data() != null) {
        competitionId = attendantData.data()!['competitionId'];
        attendantCategory = attendantData.data()!['category'];
        await Future.wait([
          fetchCompetitionDetails(competitionId),
          fetchAthletes(attendantData.data()!['athletes'] as List<dynamic>),
          fetchScores(widget.attendantId, competitionId),
        ]);
      }
    } catch (e) {}
    setState(() => isLoading = false);
  }

  Future<void> fetchCompetitionDetails(String competitionId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> competitionData =
          await FirebaseFirestore.instance
              .collection('competitions')
              .doc(competitionId)
              .get();
      if (competitionData.exists && competitionData.data() != null) {
        Map<String, dynamic> judgesMap = competitionData.data()!['judges'];
        await fetchJudges(judgesMap);
      }
    } catch (e) {}
  }

  Future<void> fetchJudges(Map<String, dynamic> judgesMap) async {
    List<Tuple2<UserModel, String>> fetchedJudges = [];
    try {
      await Future.wait(judgesMap.entries.map((entry) async {
        String judgeType = entry.key;
        List<dynamic> judgePhoneNumbers = entry.value;
        QuerySnapshot users = await FirebaseFirestore.instance
            .collection('users')
            .where('phoneNumber', whereIn: judgePhoneNumbers)
            .where('role', isEqualTo: 'Judge')
            .get();
        for (var doc in users.docs) {
          UserModel judge =
              UserModel.fromMap(doc.data() as Map<String, dynamic>);
          fetchedJudges.add(Tuple2(judge, judgeType));
        }
      }));
    } catch (e) {}
    setState(() {
      judges = fetchedJudges;
    });
  }

  Future<void> fetchAthletes(List<dynamic> athletePhoneNumbers) async {
    List<UserModel> fetchedAthletes = [];
    try {
      QuerySnapshot users = await FirebaseFirestore.instance
          .collection('users')
          .where('phoneNumber', whereIn: athletePhoneNumbers)
          .where('role', isEqualTo: 'Athlete')
          .get();
      for (var doc in users.docs) {
        UserModel athlete =
            UserModel.fromMap(doc.data() as Map<String, dynamic>);
        fetchedAthletes.add(athlete);
      }
    } catch (e) {}
    setState(() {
      athletes = fetchedAthletes;
    });
  }

  Future<void> fetchScores(String attendantId, String competitionId) async {
    List<Score> fetchedScores = [];
    try {
      QuerySnapshot scoreSnapshot = await FirebaseFirestore.instance
          .collection('scores')
          .where('attendantId', isEqualTo: attendantId)
          .where('competitionId', isEqualTo: competitionId)
          .get();
      for (var doc in scoreSnapshot.docs) {
        Score score = Score.fromMap(doc.data() as Map<String, dynamic>);
        fetchedScores.add(score);
      }
    } catch (e) {}
    setState(() {
      scores = fetchedScores;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Оролцогч",
          style: TextStyle(
              fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF001C55),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                sectionTitle("Оролцогч"),
                ...athletes.map((athlete) => Container(
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: Color(0xFF0A2472),
                          width: 1.0,
                        ),
                      ),
                      child: ListTile(
                        title: Text('${athlete.firstName} ${athlete.lastName}',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF001C55))),
                        subtitle: Text(
                            'Нас: ${athlete.age}  Хүйс: ${athlete.gender}',
                            style: TextStyle(color: Color(0xFF0A2472))),
                      ),
                    )),
                sectionTitle("Шүүгчид"),
                ...judges.map((tuple) {
                  final judge = tuple.item1;
                  final judgeType = tuple.item2;
                  final judgeScores = scores.where((score) =>
                      score.judgeId == judge.userId &&
                      score.judgeType == judgeType);

                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (judgeScores.isNotEmpty) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Сэтгэгдэл',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF001C55))),
                                  content: Text(judgeScores.first.comment,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF0A2472))),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('OK',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF001C55))),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else if (currentUser?.phoneNumber ==
                              judge.phoneNumber) {
                            final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => getJudgeScreen(
                                        judge,
                                        competitionId,
                                        widget.attendantId,
                                        attendantCategory,
                                        judgeType)));

                            if (result == true) {
                              fetchAttendantAndCompetitionDetails();
                            }
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: Color(0xFF0A2472),
                              width: 1.0,
                            ),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(judge.profilePic),
                              radius: 25,
                            ),
                            title: Text('${judge.firstName} ${judge.lastName}',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF001C55))),
                            subtitle: Text('Шүүгчийн төрөл: $judgeType',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF0A2472))),
                            trailing: judgeScores.isNotEmpty
                                ? Text('Оноо: ${judgeScores.first.scoreValue}',
                                    style: TextStyle(
                                        fontSize: 14, color: Color(0xFF0A2472)))
                                : null,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(title,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF001C55))),
    );
  }

  Widget getJudgeScreen(UserModel judge, String competitionId,
      String attendantId, String attendantCategory, String judgeType) {
    switch (judgeType) {
      case 'artistic':
        return ArtistryJudgeScreen(
            judge: judge,
            competitionId: competitionId,
            attendantId: attendantId,
            category: attendantCategory);
      case 'difficulty':
        return DifficultyJudgeScreen(
            judge: judge,
            competitionId: competitionId,
            attendantId: attendantId,
            category: attendantCategory);
      case 'execution':
        return ExecutionJudgeScreen(
            judge: judge,
            competitionId: competitionId,
            attendantId: attendantId,
            category: attendantCategory);
      case 'chair':
        return ChairJudgeScreen(
          judge: judge,
          competitionId: competitionId,
          attendantId: attendantId,
          category: attendantCategory,
        );
      default:
        return Container();
    }
  }
}
