import 'package:flutter/material.dart';
import 'package:judging_app/screens/CompetitionListScreen.dart'; // Assuming this exists
import 'package:judging_app/screens/ProfileScreen.dart'; // Assuming this exists
import 'package:judging_app/screens/TeamScreen.dart'; // Assuming this exists

class TrainerScreen extends StatefulWidget {
  const TrainerScreen({super.key});

  @override
  _TrainerScreenState createState() => _TrainerScreenState();
}

class _TrainerScreenState extends State<TrainerScreen> {
  int _currentIndex = 0;

  
  final List<Widget> _children = [
    CompetitionListScreen(), 
    TeamScreen(), 
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
        title: Text('Дасгалжуулагч'),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, 
        currentIndex: _currentIndex, 
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Тэмцээнүүд',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Баг',
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
