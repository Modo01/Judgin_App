// import 'package:flutter/material.dart';
// import 'package:judging_app/models/Athlete.dart'; 
// class AthleteInfo extends StatelessWidget {
//   final Athlete athlete;

//   AthleteInfo({Key? key, required this.athlete}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(10),
//       child: Row(
//         children: [
//           CircleAvatar(
//             backgroundImage: NetworkImage(athlete.profilePic),
//             radius: 30,
//           ),
//           SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   '${athlete.firstName} ${athlete.lastName}',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   'Age: ${athlete.age}, Gender: ${athlete.gender}',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
