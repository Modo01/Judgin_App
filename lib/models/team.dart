// class Team {
//   String teamId;
//   String teamName;
//   String trainerId;
//   List<String> athletes;

//   Team({
//     required this.teamId,
//     required this.teamName,
//     required this.trainerId,
//     required this.athletes,
//   });

//   // Method to convert a Team instance to a Map, for easy use with databases
//   Map<String, dynamic> toMap() {
//     return {
//       'teamId': teamId,
//       'teamName': teamName,
//       'trainerId': trainerId,
//       'athleteIds': athletes,
//     };
//   }

//   // Factory method to create a Team from a Map, useful when retrieving data from a database
//   factory Team.fromMap(Map<String, dynamic> map) {
//     return Team(
//       teamId: map['teamId'] ?? '',
//       teamName: map['teamName'] ?? '',
//       trainerId: map['trainerId'] ?? '',
//       athletes: List<String>.from(map['athletes'] ?? []),
//     );
//   }

//   // Optionally, add a method to update team details
//   void updateDetails({String? name, List<String>? newAthleteIds}) {
//     if (name != null) teamName = name;
//     if (newAthleteIds != null) athletes = newAthleteIds;
//   }
// }
