import 'package:flutter/material.dart';
import 'package:judging_app/provider/auth_provider.dart';
import 'package:judging_app/screens/AdminScreen.dart';
import 'package:judging_app/screens/AthleteScreen.dart';
import 'package:judging_app/screens/JudgeScreen.dart';
import 'package:judging_app/screens/TrainerScreen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    // On building the HomeScreen, we check the role and redirect accordingly.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ap.userModel.role.isNotEmpty) {
        navigateToRoleSpecificScreen(ap.userModel.role);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Center(
        child: CircularProgressIndicator(),  // Show loading while decision is being made
      ),
    );
  }

  void navigateToRoleSpecificScreen(String role) {
    switch (role) {
      case 'Admin':
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => AdminScreen()));
        break;
      case 'Judge':
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => JudgeScreen()));
        break;
      case 'Trainer':
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => TrainerScreen()));
        break;
      case 'Athlete':
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => AthleteScreen()));
        break;
      default:
        break;
    }
  }
}
