import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:judging_app/models/competition.dart';
import 'package:judging_app/screens/CompetitionDetailsScreen.dart';

class CompetitionListScreen extends StatefulWidget {
  @override
  _CompetitionListScreenState createState() => _CompetitionListScreenState();
}

class _CompetitionListScreenState extends State<CompetitionListScreen> {
  final FirebaseStorage _storage = FirebaseStorage.instance;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Тэмцээнүүд"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('competitions').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
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
                      title: Text(competition.name),
                      subtitle: Text(
                          "${competition.startDate.toLocal()} - ${competition.location}"),
                    );
                  }
                  return ListTile(
                    leading: Image.network(snapshot.data!,
                        width: 100, height: 100, fit: BoxFit.cover),
                    title: Text(competition.name),
                    subtitle: Text(
                        "${competition.startDate.toLocal()} - ${competition.location}"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CompetitionDetailsScreen(
                              competition: competition,
                              competitionId: document.id),
                        ),
                      );
                    },
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
