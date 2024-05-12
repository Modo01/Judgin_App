// import 'package:flutter/material.dart';
// import 'package:judging_app/models/athlete.dart';  // Ensure this import points to the correct Athlete model

// class ScoreInputScreen extends StatefulWidget {
//   final Athlete athlete;

//   ScoreInputScreen({required this.athlete});

//   @override
//   _ScoreInputScreenState createState() => _ScoreInputScreenState();
// }

// class _ScoreInputScreenState extends State<ScoreInputScreen> {
//   final TextEditingController _scoreController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Score Input for ${widget.athlete.firstName}"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: <Widget>[
//             TextField(
//               controller: _scoreController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 labelText: 'Enter Score',
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
           
//                 print("Score for ${widget.athlete.firstName}: ${_scoreController.text}");
//                 Navigator.pop(context);
//               },
//               child: Text('Submit Score'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
