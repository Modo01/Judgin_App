import 'package:cloud_firestore/cloud_firestore.dart';

class Attendant {
  String attendantId;
  String attendantName;
  String ageGroup;
  String category;
  List<String> athletes;  // List of athlete IDs
  String competitionId;

  Attendant({
    required this.attendantId,
    required this.attendantName,
    required this.ageGroup,
    required this.category,
    required this.athletes,
    required this.competitionId,
  });

  // Converts a Firestore document to an Attendant object
  factory Attendant.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data()!;
    return Attendant(
      attendantId: doc.id,
      attendantName: data['attendantName'] ?? '',
      ageGroup: data['ageGroup'] ?? '',
      category: data['category'] ?? '',
      athletes: List<String>.from(data['athletes']),
      competitionId: data['competitionId'] ?? '',
    );
  }

  // Converts the Attendant object to a Map
  Map<String, dynamic> toMap() {
    return {
      'attendantId': attendantId,
      'attendantName': attendantName,
      'ageGroup': ageGroup,
      'category': category,
      'athletes': athletes,
      'competitionId': competitionId,
    };
  }
}
