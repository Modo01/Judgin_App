// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:judging_app/models/athlete.dart';

// class RankingsTab extends StatefulWidget {
//   final String competitionId;

//   RankingsTab({Key? key, required this.competitionId}) : super(key: key);

//   @override
//   _RankingsTabState createState() => _RankingsTabState();
// }

// class _RankingsTabState extends State<RankingsTab> {
//   late final Stream<QuerySnapshot> _rankingsStream;

//   @override
//   void initState() {
//     super.initState();
//     _rankingsStream = FirebaseFirestore.instance
//         .collection('competitions')
//         .doc(widget.competitionId)
//         .collection('athletes')
//         .orderBy('score', descending: true) // Assuming 'score' field exists
//         .snapshots();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: _rankingsStream,
//       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (snapshot.hasError) {
//           return Text('Something went wrong');
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }

//         Map<String, List<Athlete>> categoryMap = {};
//         snapshot.data!.docs.forEach((DocumentSnapshot document) {
//           Map<String, dynamic> data = document.data() as Map<String, dynamic>;
//           Athlete athlete = Athlete.fromMap(data, document.id);
//           String category = data['category'] as String;
//           categoryMap.putIfAbsent(category, () => []).add(athlete);
//         });

//         List<Widget> categoryWidgets = categoryMap.entries.map((entry) {
//           entry.value.sort((a, b) => b.score.compareTo(a.score)); // Assuming Athlete has a 'score' field
//           return ExpansionTile(
//             title: Text(entry.key),
//             children: entry.value.map((athlete) => ListTile(
//               title: Text(athlete.firstName + ' ' + athlete.lastName),
//               trailing: Text(athlete.score.toString()), // Displaying score
//             )).toList(),
//           );
//         }).toList();

//         return ListView(
//           children: categoryWidgets,
//         );
//       },
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RankingsTab extends StatelessWidget {
  final String competitionId;

  RankingsTab({Key? key, required this.competitionId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Implement functionality to fetch and display rankings
    return Center(
      child: Text('Rankings for each category will be displayed here.'),
    );
  }
}
