import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:judging_app/models/competition.dart';
import 'package:judging_app/screens/CompetitionDetailsScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CompetitionListScreen extends StatefulWidget {
  @override
  _CompetitionListScreenState createState() => _CompetitionListScreenState();
}

class _CompetitionListScreenState extends State<CompetitionListScreen> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  Future<String> getRandomPhotoUrl() async {
    ListResult result = await _storage.ref('competitionPhotos').listAll();
    List<Reference> allFiles = result.items;
    if (allFiles.isNotEmpty) {
      int randomIndex = DateTime.now().millisecondsSinceEpoch % allFiles.length;
      String photoUrl = await allFiles[randomIndex].getDownloadURL();
      return photoUrl;
    } else {
      return 'https://via.placeholder.com/150';
    }
  }

  String formatDateString(String dateString) {
    DateTime date = DateTime.parse(dateString);
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Тэмцээнүүд",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF001C55),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('competitions').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Competition competition = Competition.fromFirestore(
                  document as DocumentSnapshot<Map<String, dynamic>>);

              return FutureBuilder<String>(
                future: getRandomPhotoUrl(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return ListTile(
                      leading: CircularProgressIndicator(),
                      title: Text(
                        competition.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "Огноо: ${competition.startDate} \n Байршил: ${competition.location}",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                  return Card(
                    margin: EdgeInsets.all(10),
                    color: Color(0xFF0A2472),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(snapshot.data!,
                            width: 100, height: 100, fit: BoxFit.cover),
                      ),
                      title: Text(
                        competition.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Огноо: ${competition.startDate}\n"
                          "Байршил: ${competition.location}",
                          style: TextStyle(color: Color(0xFFA6E1FA)),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CompetitionDetailsScreen(
                              competition: competition,
                              competitionId: document.id,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
      backgroundColor: Colors.white,
    );
  }
}
