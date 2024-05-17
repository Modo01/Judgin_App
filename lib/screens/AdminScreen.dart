import 'package:flutter/material.dart';
import 'package:judging_app/screens/CompetitionListScreen.dart'; 
import 'package:judging_app/screens/ProfileScreen.dart';
import 'package:judging_app/screens/CompetitionCreationScreen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    CompetitionListScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToCompetitionCreation() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CompetitionCreationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF001C55),
        selectedItemColor: Color(0xFFA6E1FA),
        unselectedItemColor: Color(0xFF0E6BA8),
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
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
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: _navigateToCompetitionCreation,
              child: Icon(Icons.add, color: Colors.white),
              backgroundColor: Color(0xFF0E6BA8),
              tooltip: 'Тэмцээн нэмэх',
            )
          : null,
    );
  }
}
