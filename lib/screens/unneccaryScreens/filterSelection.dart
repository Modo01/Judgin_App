// import 'package:flutter/material.dart';

// class FilterSection extends StatelessWidget {
//   final String selectedGender;
//   final String selectedAgeGroup;
//   final void Function(String) onGenderChanged;
//   final void Function(String) onAgeGroupChanged;

//   const FilterSection({
//     Key? key,
//     required this.selectedGender,
//     required this.selectedAgeGroup,
//     required this.onGenderChanged,
//     required this.onAgeGroupChanged,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: DropdownButton<String>(
//             value: selectedGender,
//             onChanged: (value) {
//               if (value != null) {
//                 onGenderChanged(value);
//               }
//             },
//             items: <String>['Бүгд', 'Эрэгтэй', 'Эмэгтэй']
//                 .map<DropdownMenuItem<String>>((String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(value),
//               );
//             }).toList(),
//           ),
//         ),
//         Expanded(
//           child: DropdownButton<String>(
//             value: selectedAgeGroup,
//             onChanged: (value) {
//               if (value != null) {
//                 onAgeGroupChanged(value);
//               }
//             },
//             items: <String>['Бүгд', 'НХ', 'ДН', 'БН']
//                 .map<DropdownMenuItem<String>>((String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(value),
//               );
//             }).toList(),
//           ),
//         ),
//       ],
//     );
//   }
// }
