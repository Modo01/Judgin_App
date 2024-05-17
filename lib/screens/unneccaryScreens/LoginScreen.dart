// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl_phone_number_input/intl_phone_number_input.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _phoneController = TextEditingController();
//   String _phoneNumber = ''; // State to hold the phone number
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final TextEditingController _otpController = TextEditingController();
//   String _verificationId = '';
//   bool isOtpRequested = false;

//   void checkUserAndAuthenticate(String phoneNumber) async {
//     final normalizedPhoneNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');
//     try {
//       var userDoc =
//           await _firestore.collection('users').doc(normalizedPhoneNumber).get();

//       if (userDoc.exists) {
//         _verifyPhone(phoneNumber);
//       } else {
//         print("User not found, redirecting to signup...");
//         Navigator.pushNamed(context, '/signup');
//       }
//     } catch (e) {
//       print("Error fetching user from Firestore: $e");
//       _showSnackBar("Failed to check user existence: ${e.toString()}");
//     }
//   }

//   void _verifyPhone(String phoneNumber) {
//     _auth.verifyPhoneNumber(
//       phoneNumber: phoneNumber,
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         await _auth.signInWithCredential(credential);
//         Navigator.pushReplacementNamed(context, '/home');
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         _showSnackBar("Failed to verify phone number: ${e.message}");
//       },
//       codeSent: (String verificationId, int? resendToken) {
//         setState(() {
//           _verificationId = verificationId;
//           isOtpRequested = true;
//         });
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {
//         setState(() {
//           _verificationId = verificationId;
//         });
//       },
//     );
//   }

//   void _signInWithPhoneNumber(String smsCode) async {
//     try {
//       final AuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: _verificationId,
//         smsCode: smsCode,
//       );

//       final User? user = (await _auth.signInWithCredential(credential)).user;
//       _showSnackBar("Successfully signed in UID: ${user?.uid}");
//       Navigator.pushReplacementNamed(context, '/home');
//     } catch (e) {
//       _showSnackBar("Failed to sign in: ${e.toString()}");
//     }
//   }

//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(message)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Login")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             InternationalPhoneNumberInput(
//               onInputChanged: (PhoneNumber number) {
//                 setState(() {
//                   _phoneNumber = number
//                       .phoneNumber!; // Update the state with the new number
//                 });
//               },
//               textFieldController: _phoneController,
//               formatInput: false,
//               selectorConfig: SelectorConfig(
//                 selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
//               ),
//               inputDecoration: InputDecoration(
//                 labelText: 'Phone Number',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 20),
//             if (isOtpRequested) _otpTextField(),
//             if (isOtpRequested) _verifyButton(),
//             if (!isOtpRequested) _sendOtpButton(),
//             SizedBox(
//               height: 20,
//             ),
//             _registerButton(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _registerButton() {
//     return ElevatedButton(
//       onPressed: () {
//         Navigator.pushNamed(context, '/signup');
//       },
//       child: Text('Sign Up'),
//     );
//   }

//   Widget _otpTextField() {
//     return TextField(
//       controller: _otpController,
//       keyboardType: TextInputType.number,
//       decoration: InputDecoration(
//         labelText: 'Enter OTP',
//         border: OutlineInputBorder(),
//       ),
//     );
//   }

//   Widget _verifyButton() {
//     return ElevatedButton(
//       onPressed: () => _signInWithPhoneNumber(_otpController.text.trim()),
//       child: Text('Verify OTP'),
//     );
//   }

//   Widget _sendOtpButton() {
//     return ElevatedButton(
//       onPressed: () =>
//           checkUserAndAuthenticate(_phoneNumber), // Use the state variable
//       child: Text('Send OTP'),
//     );
//   }
// }
