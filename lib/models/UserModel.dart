class UserModel {
  String userId;
  String firstName;
  String lastName;
  String email;
  String role;
  String profilePic;
  String phoneNumber;
  String? clubName; // Optional: specific to trainers
  String? trainerPhone;
  String? nationalId;
  String? gender;
  int? age; // Optional: specific to athletes

  UserModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    required this.profilePic,
    required this.phoneNumber,
    this.clubName,
    this.trainerPhone,
    this.nationalId,
    this.gender,
    this.age,
  });

  Map<String, dynamic> toMap() {
    var map = {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'role': role,
      'profilePic': profilePic,
      'phoneNumber': phoneNumber,
      'clubName': clubName, // Serialize if not null
      'trainerPhone': trainerPhone,
      'nationalId': nationalId,
      'gender': gender,
      'age': age,
    };
    map.removeWhere((key, value) => value == null); // Remove null entries
    return map;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? '',
      profilePic: map['profilePic'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      clubName: map['clubName'],
      trainerPhone: map['trainerPhone'],
      nationalId: map['nationalId'],
      gender: map['gender'],
      age: map['age'],

    );
  }
}
