import 'package:flutter/material.dart';
import 'package:judging_app/provider/auth_provider.dart';
import 'package:judging_app/screens/homeScreen.dart';
import 'package:judging_app/screens/SignUpScreen.dart';
import 'package:judging_app/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isLoading = false;

  void _navigateBasedOnAuthState() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final ap = Provider.of<AuthProvider>(context, listen: false);
      if (ap.isSignedIn) {
        await ap.getDataFromSP();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignUpScreen()),
        );
      }
    } catch (e) {
      print('Error during authentication: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/image1.jpeg", height: 300),
                const SizedBox(height: 20),
                const Text(
                  "Эхэлцгээе",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Одоо л эхлэхэд хамгийн тохиромжтой цаг",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black38,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CustomButton(
                    onPressed: _navigateBasedOnAuthState,
                    text: "Эхлүүлэх",
                  ),
                ),
                if (_isLoading) CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
