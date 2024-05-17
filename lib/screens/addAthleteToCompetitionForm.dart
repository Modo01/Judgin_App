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
      applyFilters();
    });
  }

  void applyFilters() {
    List<UserModel> filtered = allAthletes.where((athlete) {
      bool ageGroupMatch = true;
      if (selectedAgeGroup != null) {
        switch (selectedAgeGroup) {
          case 'SR':
            ageGroupMatch = athlete.age != null && athlete.age! >= 18;
            break;
          case 'JR':
            ageGroupMatch =
                athlete.age != null && athlete.age! >= 16 && athlete.age! <= 17;
            break;
          case 'AG':
            ageGroupMatch = athlete.age != null && athlete.age! <= 15;
            break;
          default:
            ageGroupMatch = true;
        }
      }

      bool categoryMatch = true;
      if (selectedCategory != null) {
        if (selectedCategory == 'IM') {
          categoryMatch = athlete.gender == 'Male';
        } else if (selectedCategory == 'IW') {
          categoryMatch = athlete.gender == 'Female';
        } else {
          categoryMatch = true;
        }
      }

      bool nameMatch = athlete.firstName
              .toLowerCase()
              .contains(searchController.text.toLowerCase()) ||
          athlete.lastName
              .toLowerCase()
              .contains(searchController.text.toLowerCase());

      return ageGroupMatch && categoryMatch && nameMatch;
    }).toList();

    setState(() {
      displayedAthletes = filtered;
    });
  }

  void clearForm() {
    setState(() {
      selectedCategory = null;
      selectedAgeGroup = null;
      teamName = null;
      searchController.clear();
      selectedAthletes.clear();
      displayedAthletes = List.from(allAthletes);
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
                  selectedColor: Colors.blue,
                  backgroundColor: Colors.lightBlue[100],
                  labelStyle: TextStyle(
                      color:
                          selectedItem == item ? Colors.white : Colors.black),
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
          labelText: 'Тамирчин хайх',
          suffixIcon: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(Icons.search, color: Colors.white),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.black26),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        onChanged: filterAthletes,
      ),
    );
  }

  void addAthletesToCompetition() async {
    if (selectedCategory == null || selectedAgeGroup == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ангилал болон насны ангиллаас заавал сонгоно уу!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (selectedAthletes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Та тамирчин сонгоогүй байна. Тамирчин сонгоно уу!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (['IM', 'IW'].contains(selectedCategory) &&
        selectedAthletes.length > 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Ганцаарчилсан эрэгтэй, эмэгтэй төрөл зөвхөн ганц тамирчин л оролцоно.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Map<String, dynamic> data = {
      'competitionId': widget.competitionId,
      'category': selectedCategory,
      'ageGroup': selectedAgeGroup,
      'athletes': selectedAthletes,
      'attendantName': teamName ??
          (selectedCategory == 'IM' || selectedCategory == 'IW'
              ? displayedAthletes
                      .firstWhere(
                          (athlete) => athlete.userId == selectedAthletes.first)
                      .lastName +
                  " " +
                  displayedAthletes
                      .firstWhere(
                          (athlete) => athlete.userId == selectedAthletes.first)
                      .firstName
              : 'Team/Group'),
    };

    await FirebaseFirestore.instance
        .collection('attendants')
        .add(data)
        .then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Оролцогч амжилттай нэмлээ!')));
      clearForm();
      // ignore: invalid_return_type_for_catch_error
    }).catchError((error) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error adding athletes: $error'))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Тэмцээнд Бүртгүүлэх",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF001C55),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                buildSearchBar(),
                if (competition != null) ...[
                  buildFilterChips(
                    competition!.categories,
                    selectedCategory,
                    (value) => setState(() => selectedCategory = value),
                    "Төрөл",
                  ),
                  buildFilterChips(
                    competition!.ageGroup,
                    selectedAgeGroup,
                    (value) => setState(() => selectedAgeGroup = value),
                    "Насны ангилал",
                  ),
                ],
                if (['MP', 'TR', 'GR', 'AD', 'AS'].contains(selectedCategory))
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Багийн нэр',
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
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: addAthletesToCompetition,
                    child: Text("Тэмцээнд нэмэх"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF0E6BA8),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
