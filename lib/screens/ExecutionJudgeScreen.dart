// import 'package:flutter/material.dart';
// import 'package:judging_app/models/Athlete.dart';
// import 'package:judging_app/widgets/AthleteInfo.dart';

// class ExecutionJudgeScreen extends StatelessWidget {
//   final Athlete athlete;

//   ExecutionJudgeScreen({Key? key, required this.athlete}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Execution Scoring")),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             AthleteInfo(athlete: athlete),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   // Implement your specific UI for scoring
//                   Text("Execution Scoring Interface Here"),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () {},
//                     child: Text("Send Score"),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
