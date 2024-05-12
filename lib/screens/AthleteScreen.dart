import 'package:flutter/material.dart';
import 'package:judging_app/screens/CompetitionListScreen.dart'; // Assuming this exists
import 'package:judging_app/screens/ProfileScreen.dart'; // Assuming this exists

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
      appBar: AppBar(
        title: Text('Тамирчин'),
      ),
      body: _children[_currentIndex], 
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, 
        currentIndex: _currentIndex, 
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.list),
            label: 'Тэмцээнүүд',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.person),
            label: 'Хувийн хэрэг',
          ),
        ],
      ),
    );
  }
}
