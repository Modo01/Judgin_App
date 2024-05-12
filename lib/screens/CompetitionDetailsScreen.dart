import 'package:flutter/material.dart';
import 'package:judging_app/models/competition.dart';
import 'package:judging_app/screens/addAthleteToCompetitionForm.dart';
import 'package:judging_app/screens/competitorstab.dart';
import 'package:judging_app/screens/rankingtab.dart';

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
  late final List<Widget> _screens;
  TextEditingController searchController = TextEditingController();
  String? selectedCategory;
  String? selectedAgeGroup;

  @override
  void initState() {
    super.initState();
    _screens = [
      CompetitorsTab(competitionId: widget.competitionId),
      RankingsTab(competitionId: widget.competitionId),
    ];
  }

  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          labelText: 'Search Athletes',
          suffixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          // Implement search functionality in CompetitorsTab
        },
      ),
    );
  }

  Widget buildFilterChips(List<String> items, String? selectedItem,
      Function(String?) onSelect, String label) {
    bool isSingle = items.length == 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: items.map((item) {
              bool isSelected = selectedItem == item || isSingle;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ChoiceChip(
                  label: Text(item),
                  selected: isSelected,
                  onSelected: isSingle
                      ? null
                      : (selected) {
                          onSelect(selected ? item : null);
                        },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void navigateToAddAthlete() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddAthleteToCompetitionForm(
          competitionId: widget.competitionId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.competition.name} Details'),
      ),
      body: Column(
        children: [
          buildSearchBar(),
          buildFilterChips(
              widget.competition.categories,
              selectedCategory,
              (category) => setState(() => selectedCategory = category),
              "Categories"),
          buildFilterChips(
              widget.competition.ageGroup,
              selectedAgeGroup,
              (ageGroup) => setState(() => selectedAgeGroup = ageGroup),
              "Age Groups"),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Competitors',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.score),
            label: 'Rankings',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddAthlete,
        child: Icon(Icons.add),
        tooltip: 'Add Athlete to Competition',
      ),
    );
  }
}
