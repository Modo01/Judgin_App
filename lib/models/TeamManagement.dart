// import 'package:judging_app/models/athlete.dart';
// import 'package:judging_app/models/team.dart';

// class TeamManagement {
//   static bool validateTeamSize(String category, List<Athlete> athletes) {
//     const Map<String, int> requiredAthletesPerCategory = {
//       'IM': 1,
//       'IW': 1,
//       'MP': 2,
//       'TR': 3,
//       'GR': 5,
//       'AS': 8,
//       'AD': 8,
//     };

//     int requiredSize = requiredAthletesPerCategory[category] ?? 0;
//     return athletes.length == requiredSize;
//   }

//   static Future<bool> createTeam(String competitionId, List<Athlete> athletes, String category) async {
//     if (validateTeamSize(category, athletes)) {
//       Team newTeam = Team(
//         competitionId: competitionId,
//         athletes: athletes,
//         category: category,
//       );
//       await newTeam.save();
//       return true;
//     } else {
//       return false;
//     }
//   }
// }
