import 'package:flutter/material.dart';
import 'package:judging_app/screens/CompetitionListScreen.dart'; 
import 'package:judging_app/screens/ProfileScreen.dart'; 

class AthleteScreen extends StatefulWidget {
  const AthleteScreen({super.key});

  @override
  _AthleteScreenState createState() => _AthleteScreenState();
}

class _AthleteScreenState extends State<AthleteScreen> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    CompetitionListScreen(),
    ProfileScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF001C55),
        selectedItemColor: Color(0xFFA6E1FA),
        unselectedItemColor:
            Color(0xFF0E6BA8), 
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Тэмцээнүүд',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Хувийн хэрэг',
          ),
        ],
      ),
    );
  }
}
