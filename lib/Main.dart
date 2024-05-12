import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:judging_app/provider/auth_provider.dart';
import 'package:judging_app/screens/AdminScreen.dart';
import 'package:judging_app/screens/CompetitionCreationScreen.dart';
import 'package:judging_app/screens/CompetitionScreen.dart';
import 'package:judging_app/screens/JudgeCompetitionDetailsScreen.dart';
import 'package:judging_app/screens/JudgeScreen.dart';
import 'package:judging_app/screens/UserInformationScreen.dart';
import 'package:judging_app/screens/welcomeScreen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MaterialApp(
        home: WelcomeScreen(),
        title: "FlutterPhoneAuth",
        
      ),
    );
  }
}

// import 'package:judging_app/models/UserModel.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:judging_app/screens/AdminScreen.dart';
// import 'package:judging_app/screens/CompetitionCreationScreen.dart';
// import 'package:judging_app/screens/CompetitionListScreen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         title: 'Competition App',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//         ),
//         home: AdminScreen(),
//         initialRoute: '/',
//         routes: {
//           // '/': (context) => WelcomeScreen(),
//           // '/home': (context) => HomeScreen(),
//           '/competitionList': (context) => CompetitionListScreen(),
//           // '/createCompetition': (context) => CompetitionCreationScreen(),
//           // '/judgeScreen': (context) => JudgeScreen(),
//         });
//   }
// }