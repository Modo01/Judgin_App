import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:judging_app/models/UserModel.dart';
import 'package:judging_app/models/Competition.dart';

class AddAthleteToCompetitionForm extends StatefulWidget {
  final String competitionId;

  AddAthleteToCompetitionForm({Key? key, required this.competitionId})
      : super(key: key);

  @override
  _AddAthleteToCompetitionFormState createState() =>
      _AddAthleteToCompetitionFormState();
}

class _AddAthleteToCompetitionFormState
    extends State<AddAthleteToCompetitionForm> {
  Competition? competition;
  List<UserModel> allAthletes = [];
  List<String> selectedAthletes = [];
  List<UserModel> displayedAthletes = [];
  String? selectedCategory;
  String? selectedAgeGroup;
  String? teamName;
  TextEditingController searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCompetitionDetails();
    fetchAthletes();
  }

  void fetchCompetitionDetails() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('competitions')
          .doc(widget.competitionId)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        setState(() {
          competition = Competition.fromFirestore(snapshot);
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching competition details: $e');
      setState(() => isLoading = false);
    }
  }

  void fetchAthletes() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String currentUserPhone = user.phoneNumber ?? '';
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'Athlete')
            .where('trainerPhone', isEqualTo: currentUserPhone)
            .get();
        List<UserModel> athletesFetched = snapshot.docs
            .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
        setState(() {
          allAthletes = athletesFetched;
          displayedAthletes = List.from(athletesFetched);
          applyFilters();
        });
      }
    } catch (e) {
      print('Error fetching athletes: $e');
      setState(() => isLoading = false);
    }
  }

  void filterAthletes(String query) {
    List<UserModel> filtered = allAthletes.where((athlete) {
      return athlete.firstName.toLowerCase().contains(query.toLowerCase()) ||
          athlete.lastName.toLowerCase().contains(query.toLowerCase());
    }).toList();
    setState(() {
      displayedAthletes = filtered;
      applyFilters(); // Make sure to apply other filters like category or age group if already selected.
    });
  }

  void applyFilters() {
    List<UserModel> filtered = displayedAthletes.where((athlete) {
      bool ageGroupMatch = true;
      if (selectedAgeGroup != null) {
        switch (selectedAgeGroup) {
          case 'SR':
            ageGroupMatch = athlete.age != null && athlete.age! >= 18;
            break;
          case 'JR':
            ageGroupMatch =
                athlete.age != null && athlete.age! >= 13 && athlete.age! <= 17;
            break;
          case 'AG':
            ageGroupMatch = athlete.age != null && athlete.age! <= 12;
            break;
        }
      }

      bool categoryMatch = true;
      if (selectedCategory == 'IM') {
        categoryMatch = athlete.gender == 'Male';
      } else if (selectedCategory == 'IW') {
        categoryMatch = athlete.gender == 'Female';
      }

      return ageGroupMatch && categoryMatch;
    }).toList();

    setState(() {
      displayedAthletes = filtered;
    });
  }

  Widget buildFilterChips(List<String>? items, String? selectedItem,
      Function(String?) onSelect, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: items!.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: FilterChip(
                  label: Text(item),
                  selected: selectedItem == item,
                  onSelected: (selected) {
                    onSelect(selected ? item : null);
                    applyFilters();
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          labelText: 'Search by Name',
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
      appBar: AppBar(title: Text("Add Athlete to Competition")),
      body: isLoading
          ? CircularProgressIndicator()
          : Column(
              children: [
                buildSearchBar(),
                if (competition != null) ...[
                  buildFilterChips(
                      competition!.categories,
                      selectedCategory,
                      (value) => setState(() => selectedCategory = value),
                      "Category"),
                  buildFilterChips(
                      competition!.ageGroup,
                      selectedAgeGroup,
                      (value) => setState(() => selectedAgeGroup = value),
                      "Age Group"),
                ],
                if (['MP', 'TR', 'GR', 'AD', 'AS'].contains(selectedCategory))
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Team Name',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) => teamName = value,
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: displayedAthletes.length,
                    itemBuilder: (context, index) {
                      final athlete = displayedAthletes[index];
                      return CheckboxListTile(
                        title: Text('${athlete.firstName} ${athlete.lastName}'),
                        subtitle: Text(
                            'Age: ${athlete.age} - Gender: ${athlete.gender}'),
                        value: selectedAthletes.contains(athlete.userId),
                        onChanged: (bool? selected) {
                          setState(() {
                            if (selected ?? false) {
                              if (!selectedAthletes.contains(athlete.userId)) {
                                selectedAthletes.add(athlete.userId);
                              }
                            } else {
                              selectedAthletes.remove(athlete.userId);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedCategory != null &&
                        selectedAthletes.isNotEmpty) {
                      FirebaseFirestore.instance
                          .collection('attendants')
                          .add({
                            'competitionId': widget.competitionId,
                            'category': selectedCategory,
                            'ageGroup': selectedAgeGroup,
                            'athletes': selectedAthletes,
                            'attendantName': teamName ?? 'Individual',
                          })
                          .then((value) => ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                                  content:
                                      Text('Athletes added successfully!'))))
                          .catchError((error) => ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                                  content:
                                      Text('Error adding athletes: $error'))));
                    }
                  },
                  child: Text("Add to Competition"),
                ),
              ],
            ),
    );
  }
}
