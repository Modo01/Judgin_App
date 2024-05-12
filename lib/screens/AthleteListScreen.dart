import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:judging_app/models/UserModel.dart';

class AthleteListScreen extends StatefulWidget {
  final String competitionId;

  AthleteListScreen({Key? key, required this.competitionId}) : super(key: key);

  @override
  _AthleteListScreenState createState() => _AthleteListScreenState();
}

class _AthleteListScreenState extends State<AthleteListScreen> {
  List<UserModel> athletes = [];

  @override
  void initState() {
    super.initState();
    fetchCompetitionAthletes();
  }

  void fetchCompetitionAthletes() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('competitionId', isEqualTo: widget.competitionId)
        .where('role', isEqualTo: 'Athlete')
        .get();

    setState(() {
      athletes = snapshot.docs.map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Athletes in Competition'),
      ),
      body: ListView.builder(
        itemCount: athletes.length,
        itemBuilder: (context, index) {
          UserModel athlete = athletes[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(athlete.profilePic),
            ),
            title: Text('${athlete.firstName} ${athlete.lastName}'),
            subtitle: Text('Age: ${athlete.age}, Gender: ${athlete.gender}'),
          );
        },
      ),
    );
  }
}
