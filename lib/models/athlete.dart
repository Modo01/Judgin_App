// import 'package:cloud_firestore/cloud_firestore.dart';

// class Athlete {
//   String id;
//   String firstName;
//   String lastName;
//   String nationalId;
//   String gender;
//   int age;
//   String phoneNumber;
//   String profilePic;
//   String trainerPhone; // Adding trainer's phone number field

//   Athlete({
//     required this.id,
//     required this.firstName,
//     required this.lastName,
//     required this.nationalId,
//     required this.gender,
//     required this.age,
//     required this.phoneNumber,
//     required this.profilePic,
//     required this.trainerPhone,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'firstName': firstName,
//       'lastName': lastName,
//       'nationalId': nationalId,
//       'gender': gender,
//       'age': age,
//       'phoneNumber': phoneNumber,
//       'profilePic': profilePic,
//       'trainerPhoneNumber':
//           trainerPhone, // Include this in Firestore document
//     };
//   }

//   static Athlete fromMap(Map<String, dynamic> map, String id) {
//     return Athlete(
//       id: id,
//       firstName: map['firstName'] ?? '',
//       lastName: map['lastName'] ?? '',
//       nationalId: map['nationalId'] ?? '',
//       gender: map['gender'] ?? '',
//       age: map['age'] ?? 0,
//       phoneNumber: map['phoneNumber'] ?? '',
//       profilePic: map['profilePic'] ?? '',
//       trainerPhone: map['trainerPhoneNumber'] ?? '',
//     );
//   }

//   static Athlete fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
//     return Athlete.fromMap(doc.data() as Map<String, dynamic>, doc.id);
//   }
// }
