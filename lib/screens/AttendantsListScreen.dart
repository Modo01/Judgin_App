import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:judging_app/models/Attendant.dart';
import 'package:judging_app/screens/AttendantDetailsScreen.dart';
import 'package:judging_app/screens/AddAthleteToCompetitionForm.dart';

class AttendantsListScreen extends StatefulWidget {
  final String competitionId;

  AttendantsListScreen({Key? key, required this.competitionId})
      : super(key: key);

  @override
  _AttendantsListScreenState createState() => _AttendantsListScreenState();
}

class _AttendantsListScreenState extends State<AttendantsListScreen> {
  List<Attendant> allAttendants = [];
  List<Attendant> filteredAttendants = [];
  bool isLoading = true;
  String? selectedCategory;
  String? selectedAgeGroup;
  TextEditingController searchController = TextEditingController();
  bool isTrainer = false;

  @override
  void initState() {
    super.initState();
    fetchCurrentUserRole();
    fetchAttendants();
  }

  Future<void> fetchCurrentUserRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        setState(() {
          isTrainer = userDoc.data()!['role'] == 'Trainer';
        });
      }
    }
  }

  Future<void> fetchAttendants() async {
    setState(() => isLoading = true);
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('attendants')
          .where('competitionId', isEqualTo: widget.competitionId)
          .get();

      List<Attendant> attendants = snapshot.docs
          .map((doc) => Attendant.fromFirestore(
              doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();

      setState(() {
        allAttendants = attendants;
        isLoading = false;
      });
      applyFilters();
    } catch (e) {
      print('Error fetching attendants: $e');
      setState(() => isLoading = false);
    }
  }

  void applyFilters() {
    List<Attendant> filtered = allAttendants.where((attendant) {
      bool categoryMatch =
          selectedCategory == null || attendant.category == selectedCategory;
      bool ageGroupMatch =
          selectedAgeGroup == null || attendant.ageGroup == selectedAgeGroup;
      bool nameMatch = searchController.text.isEmpty ||
          attendant.attendantName
              .toLowerCase()
              .contains(searchController.text.toLowerCase());
      return categoryMatch && ageGroupMatch && nameMatch;
    }).toList();

    filtered.sort((a, b) => a.attendantName.compareTo(b.attendantName));

    setState(() {
      filteredAttendants = filtered;
    });
  }

  Future<void> deleteAttendant(String attendantId) async {
    try {
      await FirebaseFirestore.instance
          .collection('attendants')
          .doc(attendantId)
          .delete();
      QuerySnapshot scoresSnapshot = await FirebaseFirestore.instance
          .collection('scores')
          .where('attendantId', isEqualTo: attendantId)
          .get();
      for (var doc in scoresSnapshot.docs) {
        await doc.reference.delete();
      }
      QuerySnapshot resultsSnapshot = await FirebaseFirestore.instance
          .collection('results')
          .where('attendantId', isEqualTo: attendantId)
          .get();
      for (var doc in resultsSnapshot.docs) {
        await doc.reference.delete();
      }
      fetchAttendants();
    } catch (e) {
      print('Error deleting attendant: $e');
    }
  }

  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            labelText: 'Оролцогч хайх',
            labelStyle: TextStyle(
                color: Color(0xFF001C55), fontWeight: FontWeight.bold),
            prefixIcon: Icon(Icons.search, color: Color(0xFF0E6BA8)),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF001C55)),
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF001C55), width: 2.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onChanged: (value) => applyFilters(),
          style: TextStyle(color: Color(0xFF001C55)),
        ),
      ),
    );
  }

  Widget buildFilterChips(String label, List<String> options, String? selected,
      Function(String?) onSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: options.map((option) {
                bool isSelected = option == selected;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(option),
                    labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black),
                    selectedColor: Colors.blue,
                    backgroundColor: Colors.lightBlue[100],
                    selected: isSelected,
                    onSelected: (selected) {
                      onSelected(selected ? option : null);
                      applyFilters();
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                buildSearchBar(),
                buildFilterChips(
                  'Төрөл',
                  ['IM', 'IW', 'MP', 'TR', 'GR', 'AD', 'AS'],
                  selectedCategory,
                  (value) {
                    setState(() {
                      selectedCategory = value;
                      applyFilters();
                    });
                  },
                ),
                buildFilterChips(
                  'Насны ангилал',
                  ['SR', 'JR', 'AG'],
                  selectedAgeGroup,
                  (value) {
                    setState(() {
                      selectedAgeGroup = value;
                      applyFilters();
                    });
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredAttendants.length,
                    itemBuilder: (context, index) {
                      final attendant = filteredAttendants[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index == 0 ||
                              attendant.category !=
                                  filteredAttendants[index - 1].category)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              child: Text(
                                attendant.category,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                          Dismissible(
                            key: Key(attendant.attendantId),
                            direction: isTrainer
                                ? DismissDirection.endToStart
                                : DismissDirection.none,
                            onDismissed: (direction) async {
                              await deleteAttendant(attendant.attendantId);
                            },
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                            child: Card(
                              color: Color(0xFFA6E1FA),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 4.0),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ListTile(
                                title: Text(
                                  attendant.attendantName,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AttendantDetailsScreen(
                                      competitionId: widget.competitionId,
                                      attendantId: attendant.attendantId,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: isTrainer
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddAthleteToCompetitionForm(
                        competitionId: widget.competitionId),
                  ),
                );
                fetchAttendants();
              },
              child: Icon(Icons.add, color: Colors.white),
              backgroundColor: Colors.blue,
              tooltip: 'Add Athlete to Competition',
            )
          : null,
    );
  }
}
