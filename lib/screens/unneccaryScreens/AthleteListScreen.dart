// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:judging_app/models/Attendant.dart';
// import 'package:judging_app/models/competition.dart';
// import 'package:judging_app/screens/AttendantDetailsScreen.dart';
// import 'package:judging_app/screens/AddAthleteToCompetitionForm.dart';

// class AttendantsListScreen extends StatefulWidget {
//   final String competitionId;

//   AttendantsListScreen({Key? key, required this.competitionId})
//       : super(key: key);

//   @override
//   _AttendantsListScreenState createState() => _AttendantsListScreenState();
// }

// class _AttendantsListScreenState extends State<AttendantsListScreen> {
//   List<Attendant> allAttendants = [];
//   List<Attendant> filteredAttendants = [];
//   bool isLoading = true;
//   String? selectedCategory;
//   String? selectedAgeGroup;
//   TextEditingController searchController = TextEditingController();
//   bool isTrainer = false;

//   @override
//   void initState() {
//     super.initState();
//     fetchCurrentUserRole();
//     fetchAttendants();
//   }

//   Future<void> fetchCurrentUserRole() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
//           .instance
//           .collection('users')
//           .doc(user.uid)
//           .get();

//       if (userDoc.exists && userDoc.data() != null) {
//         setState(() {
//           isTrainer = userDoc.data()!['role'] == 'Trainer';
//         });
//       }
//     }
//   }

//   Future<void> fetchAttendants() async {
//     setState(() => isLoading = true);
//     try {
//       QuerySnapshot snapshot = await FirebaseFirestore.instance
//           .collection('attendants')
//           .where('competitionId', isEqualTo: widget.competitionId)
//           .get();

//       List<Attendant> attendants = snapshot.docs
//           .map((doc) => Attendant.fromFirestore(
//               doc as DocumentSnapshot<Map<String, dynamic>>))
//           .toList();

//       setState(() {
//         allAttendants = attendants;
//         filteredAttendants = attendants;
//         isLoading = false;
//       });
//       applyFilters();
//     } catch (e) {
//       print('Error fetching attendants: $e');
//       setState(() => isLoading = false);
//     }
//   }

//   void applyFilters() {
//     setState(() {
//       filteredAttendants = allAttendants.where((attendant) {
//         bool categoryMatch =
//             selectedCategory == null || attendant.category == selectedCategory;
//         bool ageGroupMatch =
//             selectedAgeGroup == null || attendant.ageGroup == selectedAgeGroup;
//         bool nameMatch = searchController.text.isEmpty ||
//             attendant.attendantName
//                 .toLowerCase()
//                 .contains(searchController.text.toLowerCase());
//         return categoryMatch && ageGroupMatch && nameMatch;
//       }).toList();
//     });
//   }

//   Future<void> deleteAttendant(String attendantId) async {
//     try {
//       // Delete attendant from attendants collection
//       await FirebaseFirestore.instance
//           .collection('attendants')
//           .doc(attendantId)
//           .delete();

//       // Delete attendant's scores
//       QuerySnapshot scoresSnapshot = await FirebaseFirestore.instance
//           .collection('scores')
//           .where('attendantId', isEqualTo: attendantId)
//           .get();
//       for (var doc in scoresSnapshot.docs) {
//         await doc.reference.delete();
//       }

//       // Delete attendant's results
//       QuerySnapshot resultsSnapshot = await FirebaseFirestore.instance
//           .collection('results')
//           .where('attendantId', isEqualTo: attendantId)
//           .get();
//       for (var doc in resultsSnapshot.docs) {
//         await doc.reference.delete();
//       }

//       // Refresh attendants list
//       fetchAttendants();
//     } catch (e) {
//       print('Error deleting attendant: $e');
//     }
//   }

//   Widget buildSearchBar() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: TextField(
//         controller: searchController,
//         decoration: InputDecoration(
//           labelText: 'Search Attendants',
//           suffixIcon: Icon(Icons.search),
//           border: OutlineInputBorder(),
//         ),
//         onChanged: (value) => applyFilters(),
//       ),
//     );
//   }

//   Widget buildFilterChips(List<String> items, String? selectedItem,
//       Function(String?) onSelect, String label) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
//         ),
//         SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             children: items.map((item) {
//               bool isSelected = selectedItem == item;
//               return Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                 child: ChoiceChip(
//                   label: Text(item),
//                   selected: isSelected,
//                   onSelected: (selected) {
//                     onSelect(selected ? item : null);
//                     applyFilters();
//                   },
//                 ),
//               );
//             }).toList(),
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 buildSearchBar(),
//                 buildFilterChips(['IM', 'IW', 'MP', 'TR', 'GR', 'AD', 'AS'],
//                     selectedCategory, (value) {
//                   setState(() {
//                     selectedCategory = value;
//                     applyFilters();
//                   });
//                 }, "Төрөл"),
//                 buildFilterChips(['SR', 'JR', 'AG'], selectedAgeGroup, (value) {
//                   setState(() {
//                     selectedAgeGroup = value;
//                     applyFilters();
//                   });
//                 }, "Насны ангилал"),
//                 Expanded(
//                   child: ListView(
//                     children: filteredAttendants
//                         .map((attendant) => Dismissible(
//                               key: Key(attendant.attendantId),
//                               direction: isTrainer
//                                   ? DismissDirection.endToStart
//                                   : DismissDirection.none,
//                               onDismissed: (direction) async {
//                                 await deleteAttendant(attendant.attendantId);
//                               },
//                               background: Container(
//                                 color: Colors.red,
//                                 alignment: Alignment.centerRight,
//                                 padding: EdgeInsets.symmetric(horizontal: 10),
//                                 child: Icon(Icons.delete, color: Colors.white),
//                               ),
//                               child: ListTile(
//                                 title: Text(attendant.attendantName),
//                                 subtitle: Text(
//                                     'Category: ${attendant.category} - Age Group: ${attendant.ageGroup}'),
//                                 onTap: () => Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) =>
//                                         AttendantDetailsScreen(
//                                             competitionId: widget.competitionId,
//                                             attendantId: attendant.attendantId),
//                                   ),
//                                 ),
//                               ),
//                             ))
//                         .toList(),
//                   ),
//                 ),
//               ],
//             ),
//       floatingActionButton: isTrainer
//           ? FloatingActionButton(
//               onPressed: () async {
//                 await Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => AddAthleteToCompetitionForm(
//                         competitionId: widget.competitionId),
//                   ),
//                 );
//                 fetchAttendants(); // Reload the attendants list after adding new athletes
//               },
//               child: Icon(Icons.add),
//               tooltip: 'Add Athlete to Competition',
//             )
//           : null,
//     );
//   }
// }
