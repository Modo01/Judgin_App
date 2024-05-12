import 'package:flutter/material.dart';
import 'package:judging_app/screens/CompetitionListScreen.dart'; 
import 'package:judging_app/screens/ProfileScreen.dart'; 

class JudgeScreen extends StatefulWidget {
  const JudgeScreen({super.key});

  @override
  _JudgeScreenState createState() => _JudgeScreenState();
}

class _JudgeScreenState extends State<JudgeScreen> {
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
        title: Text('Шүүгч'),
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
