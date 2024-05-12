import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:judging_app/models/UserModel.dart';
import 'package:judging_app/models/Attendant.dart';

class CompetitorsTab extends StatefulWidget {
  final String competitionId;

  CompetitorsTab({Key? key, required this.competitionId}) : super(key: key);

  @override
  _CompetitorsTabState createState() => _CompetitorsTabState();
}

class _CompetitorsTabState extends State<CompetitorsTab> {
  List<Attendant> attendants = [];
  Map<String, UserModel> athletes = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllAttendants();
  }

  Future<void> fetchAllAttendants() async {
    try {
      QuerySnapshot attendantSnapshot = await FirebaseFirestore.instance
          .collection('attendants')
          .where('competitionId', isEqualTo: widget.competitionId)
          .get();

      List<Future> athleteFetches = [];

      // Intermediate storage to avoid setState inside loop
      Map<String, UserModel> athleteMap = {};
      List<Attendant> fetchedAttendants = [];

      for (var doc in attendantSnapshot.docs) {
        var attendant = Attendant.fromFirestore(
            doc as DocumentSnapshot<Map<String, dynamic>>);
        fetchedAttendants.add(attendant);

        // Collect all athlete fetch operations
        for (var athleteId in attendant.athletes) {
          var fetch = FirebaseFirestore.instance
              .collection('users')
              .doc(athleteId)
              .get()
              .then((userData) {
            if (userData.exists) {
              athleteMap[athleteId] =
                  UserModel.fromMap(userData.data() as Map<String, dynamic>);
            }
          });
          athleteFetches.add(fetch);
        }
      }

      // Wait for all athlete data to be fetched
      await Future.wait(athleteFetches);

      // Now update the state once with all fetched data
      setState(() {
        attendants = fetchedAttendants;
        athletes = athleteMap;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: attendants.length,
              itemBuilder: (context, index) {
                var attendant = attendants[index];
                List<UserModel> attendantAthletes = attendant.athletes
                    .map((id) => athletes[id])
                    .where((athlete) => athlete != null)
                    .cast<UserModel>()
                    .toList();

                if (attendantAthletes.isEmpty) {
                  return ListTile(
                    title: Text(
                        'No athletes found for ${attendant.attendantName}'),
                  );
                }

                if (['MP', 'TR', 'GR', 'AD', 'AS']
                    .contains(attendant.category)) {
                  return ListTile(
                    title: Text(attendant.attendantName),
                    subtitle: Text(
                        'Athletes: ${attendantAthletes.map((a) => a.firstName + " " + a.lastName).join(", ")}'),
                  );
                } else {
                  // Single athlete in IM or IW category
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          attendantAthletes.first.profilePic ??
                              'https://via.placeholder.com/150'),
                    ),
                    title: Text(
                        '${attendantAthletes.first.firstName} ${attendantAthletes.first.lastName}'),
                    subtitle: Text(
                        'Age: ${attendantAthletes.first.age} - Gender: ${attendantAthletes.first.gender}'),
                  );
                }
              },
            ),
    );
  }
}
