// import 'package:flutter/material.dart';
// import 'package:judging_app/models/Athlete.dart';

// typedef AthleteSelectionCallback = void Function(Athlete athlete, String category);

// class AthleteSelector extends StatefulWidget {
//   final AthleteSelectionCallback onSelectAthlete;

//   AthleteSelector({Key? key, required this.onSelectAthlete}) : super(key: key);

//   @override
//   _AthleteSelectorState createState() => _AthleteSelectorState();
// }

// class _AthleteSelectorState extends State<AthleteSelector> {

//   List<Athlete> athletes = [
//     Athlete(firstName: "John", lastName: "Doe", nationalId: "111", gender: "Male", age: 20, phoneNumber: "1234567890", profilePic: "url", category: "IM"),

//   ];
//   String? selectedCategory;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           child: ListView.builder(
//             itemCount: athletes.length,
//             itemBuilder: (context, index) {
//               Athlete athlete = athletes[index];
//               return ListTile(
//                 title: Text('${athlete.firstName} ${athlete.lastName}'),
//                 subtitle: Text('ID: ${athlete.nationalId}'),
//                 onTap: () => widget.onSelectAthlete(athlete, selectedCategory ?? "Default"),
//               );
//             },
//           ),
//         ),
//         DropdownButtonFormField<String>(
//           value: selectedCategory,
//           onChanged: (newValue) {
//             setState(() {
//               selectedCategory = newValue;
//             });
//           },
//           items: <String>['IM', 'IW', 'MP', 'TR', 'GR', 'AS', 'AD']
//               .map<DropdownMenuItem<String>>((String value) {
//             return DropdownMenuItem<String>(
//               value: value,
//               child: Text(value),
//             );
//           }).toList(),
//           decoration: InputDecoration(labelText: 'Select Category'),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             if (selectedCategory != null) {
              
//               print("Category $selectedCategory selected.");
//             }
//           },
//           child: Text('Confirm Selection'),
//         ),
//       ],
//     );
//   }
// }
