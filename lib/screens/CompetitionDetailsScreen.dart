import 'package:flutter/material.dart';
import 'package:judging_app/models/competition.dart';
import 'package:judging_app/screens/AttendantsListScreen.dart';
import 'package:judging_app/screens/RankingScreen.dart';

class CompetitionDetailsScreen extends StatefulWidget {
  final String competitionId;
  final Competition competition;

  const CompetitionDetailsScreen({
    Key? key,
    required this.competitionId,
    required this.competition,
  }) : super(key: key);

  @override
  _CompetitionDetailsScreenState createState() =>
      _CompetitionDetailsScreenState();
}

class _CompetitionDetailsScreenState extends State<CompetitionDetailsScreen> {
  int _currentIndex = 0;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      AttendantsListScreen(competitionId: widget.competitionId),
      RankingScreen(competitionId: widget.competitionId),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 0
          ? AppBar(
              title: Text(
                '${widget.competition.name}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Color(0xFF00072D),
            )
          : null,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF001C55),
        selectedItemColor: Color(0xFFA6E1FA),
        unselectedItemColor: Color(0xFF0E6BA8),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Оролцогчид',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.score),
            label: 'Үр дүн',
          ),
        ],
      ),
    );
  }
}
