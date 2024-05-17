// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:judging_app/models/competition.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class CompetitionEditScreen extends StatefulWidget {
//   final String competitionId;
//   final Competition competition;

//   const CompetitionEditScreen({
//     Key? key,
//     required this.competitionId,
//     required this.competition,
//   }) : super(key: key);

//   @override
//   _CompetitionEditScreenState createState() => _CompetitionEditScreenState();
// }

// class _CompetitionEditScreenState extends State<CompetitionEditScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _startDateController = TextEditingController();
//   final _locationController = TextEditingController();
//   User? currentUser;

//   @override
//   void initState() {
//     super.initState();
//     _nameController.text = widget.competition.name;
//     _startDateController.text = widget.competition.startDate.split(' ')[0];
//     _locationController.text = widget.competition.location;
//     currentUser = FirebaseAuth.instance.currentUser;
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _startDateController.dispose();
//     _locationController.dispose();
//     super.dispose();
//   }

//   void _saveChanges() async {
//     if (_formKey.currentState!.validate()) {
//       FirebaseFirestore.instance
//           .collection('competitions')
//           .doc(widget.competitionId)
//           .update({
//         'name': _nameController.text,
//         'startDate': _startDateController.text,
//         'location': _locationController.text,
//       }).then((_) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Competition updated successfully')));
//         Navigator.pop(context);
//       }).catchError((error) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update competition: $error')));
//       });
//     }
//   }

//   void _deleteCompetition() async {
//     FirebaseFirestore.instance
//         .collection('competitions')
//         .doc(widget.competitionId)
//         .delete()
//         .then((_) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Competition deleted successfully')));
//       Navigator.pop(context);
//     }).catchError((error) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete competition: $error')));
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Edit Competition',
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         iconTheme: IconThemeData(color: Colors.white),
//         backgroundColor: Color(0xFF001C55),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.delete, color: Colors.white),
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 builder: (context) {
//                   return AlertDialog(
//                     title: Text('Delete Competition'),
//                     content: Text('Are you sure you want to delete this competition?'),
//                     actions: [
//                       TextButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         child: Text('Cancel'),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                           _deleteCompetition();
//                         },
//                         child: Text('Delete', style: TextStyle(color: Colors.red)),
//                       ),
//                     ],
//                   );
//                 },
//               );
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextFormField(
//                 controller: _nameController,
//                 decoration: InputDecoration(
//                   labelText: 'Name',
//                   border: OutlineInputBorder(),
//                   labelStyle: TextStyle(color: Colors.black),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a name';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16.0),
//               TextFormField(
//                 controller: _startDateController,
//                 decoration: InputDecoration(
//                   labelText: 'Start Date',
//                   border: OutlineInputBorder(),
//                   labelStyle: TextStyle(color: Colors.black),
//                 ),
//                 onTap: () async {
//                   DateTime? pickedDate = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime(2000),
//                     lastDate: DateTime(2100),
//                   );
//                   if (pickedDate != null) {
//                     _startDateController.text = "${pickedDate.toLocal()}".split(' ')[0];
//                   }
//                 },
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a start date';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16.0),
//               TextFormField(
//                 controller: _locationController,
//                 decoration: InputDecoration(
//                   labelText: 'Location',
//                   border: OutlineInputBorder(),
//                   labelStyle: TextStyle(color: Colors.black),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a location';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 20.0),
//               ElevatedButton(
//                 onPressed: _saveChanges,
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.white,
//                   backgroundColor: Color(0xFF0E6BA8),
//                   padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: Text('Save Changes'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
