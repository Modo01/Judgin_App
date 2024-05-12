import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:judging_app/models/UserModel.dart';

class TeamScreen extends StatefulWidget {
  @override
  _TeamScreenState createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  List<UserModel> athletes = [];
  List<UserModel> filteredAthletes = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = true;
  String selectedGender = 'Бүгд';
  String selectedAgeGroup = 'Бүгд';

  final List<String> genders = ['Бүгд', 'Male', 'Female'];
  final List<String> ageGroups = ['Бүгд', 'SR', 'JR', 'AG'];

  @override
  void initState() {
    super.initState();
    fetchAthletes();
  }

  Future<void> fetchAthletes() async {
    setState(() => isLoading = true);
    String trainerPhoneNumber = await getCurrentTrainerPhoneNumber();
    if (trainerPhoneNumber.isEmpty) {
      setState(() {
        isLoading = false;
        print("No trainer phone number found.");
      });
      return;
    }

    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'Athlete')
        .where('trainerPhone', isEqualTo: trainerPhoneNumber)
        .get();

    setState(() {
      athletes = snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      applyFilters();
      isLoading = false;
    });
  }

  Future<String> getCurrentTrainerPhoneNumber() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        return userData['phoneNumber'] ?? '';
      }
    }
    return '';
  }

  void filterAthletes(String query) {
    var filtered = athletes.where((athlete) {
      return athlete.firstName.toLowerCase().contains(query.toLowerCase()) ||
          athlete.lastName.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredAthletes = filtered;
    });
  }

  void applyFilters() {
    setState(() {
      filteredAthletes = athletes.where((user) {
        final matchesGender =
            selectedGender == 'Бүгд' || user.gender == selectedGender;
        final matchesAgeGroup = selectedAgeGroup == 'Бүгд' ||
            (selectedAgeGroup == 'SR' && user.age! > 17) ||
            (selectedAgeGroup == 'JR' && user.age! > 15 && user.age! < 18) ||
            (selectedAgeGroup == 'AG' && user.age! < 16);
        return matchesGender && matchesAgeGroup;
      }).toList();
    });
  }

  Widget buildFilterChips(String label, List<String> options, String selected,
      Function(String) onSelected) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 8.0,
        children: List<Widget>.generate(
          options.length,
          (int index) {
            return ChoiceChip(
              label: Text(options[index]),
              selected: options[index] == selected,
              onSelected: (bool selected) {
                onSelected(options[index]);
              },
            );
          },
        ).toList(),
      ),
    );
  }

  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          labelText: 'Search Athletes',
          suffixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
        onChanged: filterAthletes,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Миний баг')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                buildSearchBar(),
                buildFilterChips('Gender', genders, selectedGender, (value) {
                  setState(() {
                    selectedGender = value;
                    applyFilters();
                  });
                }),
                buildFilterChips('Age Group', ageGroups, selectedAgeGroup,
                    (value) {
                  setState(() {
                    selectedAgeGroup = value;
                    applyFilters();
                  });
                }),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredAthletes.length,
                    itemBuilder: (context, index) {
                      UserModel athlete = filteredAthletes[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(athlete.profilePic),
                        ),
                        title: Text('${athlete.firstName} ${athlete.lastName}'),
                        subtitle: Text(
                            'Нас: ${athlete.age}    Хүйс: ${athlete.gender}'),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
