// import 'package:flutter/material.dart';
// import 'package:judging_app/models/Athlete.dart';
// import 'package:judging_app/widgets/AthleteInfo.dart';

// class ChairJudgeScreen extends StatelessWidget {
//   final Athlete athlete;

//   ChairJudgeScreen({Key? key, required this.athlete}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Chair of Judges")),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             AthleteInfo(athlete: athlete),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   // Implement your specific UI for scoring
//                   Text("General Deduction Interface Here"),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () {},
//                     child: Text("Send Deductions"),
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
