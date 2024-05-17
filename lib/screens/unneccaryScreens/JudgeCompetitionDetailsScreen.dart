// // lib/screens/judge_competition_details_screen.dart
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:judging_app/models/competition.dart';

// class JudgeCompetitionDetailsScreen extends StatelessWidget {
//   final Competition competition;

//   JudgeCompetitionDetailsScreen({required this.competition});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(competition.name),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text("Name: ${competition.name}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//               Text("Location: ${competition.location}", style: TextStyle(fontSize: 16)),
//               Text("Start Date: ${DateFormat('yyyy-MM-dd').format(competition.startDate)}", style: TextStyle(fontSize: 16)),
//               Text("Categories: ${competition.categories.join(', ')}", style: TextStyle(fontSize: 16)),
//               Text("Age Groups: ${competition.ageGroup}", style: TextStyle(fontSize: 16)),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
                 
//                 },
//                 child: Text('Register'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
