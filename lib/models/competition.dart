import 'package:cloud_firestore/cloud_firestore.dart';

class Competition {
  final String competitionId;
  final String name;
  final List<String> ageGroup;
  final String location;
  final List<String> categories;
  final List<String> judges;
  final DateTime startDate;

  Competition({
    required this.competitionId,
    required this.name,
    required this.ageGroup,
    required this.location,
    required this.categories,
    required this.judges,
    required this.startDate,
  });

  factory Competition.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data()!;

    return Competition(
      competitionId: doc.id,
      name: data['name'] ?? '',
      ageGroup:
          data['ageGroup'] is List ? List<String>.from(data['ageGroup']) : [],
      location: data['location'] ?? '',
      categories: data['categories'] is List
          ? List<String>.from(data['categories'])
          : [],
      judges: data['judges'] is List ? List<String>.from(data['judges']) : [],
      startDate: DateTime.parse(data['startDate'] ?? DateTime.now().toString()),
    );
  }
}
