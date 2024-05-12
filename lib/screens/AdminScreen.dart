import 'package:flutter/material.dart';
import 'package:judging_app/screens/CompetitionListScreen.dart';
import 'package:judging_app/screens/ProfileScreen.dart';
import 'package:judging_app/screens/CompetitionCreationScreen.dart'; // Import the competition creation screen

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
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
      appBar: AppBar(
        title: Text('Admin'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Competitions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: _navigateToCompetitionCreation,
              child: Icon(Icons.add),
              tooltip: 'Add Competition',
            )
          : null, // Only show the FAB when the competitions list is displayed
    );
  }
}
