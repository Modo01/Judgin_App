import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:judging_app/models/result.dart';
import 'package:judging_app/service/score_service.dart';

class RankingScreen extends StatefulWidget {
  final String competitionId;

  RankingScreen({required this.competitionId});

  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  String searchQuery = '';
  String selectedCategory = 'All';
  String selectedAgeGroup = 'All';
  List<Result> results = [];
  List<Result> allResults = [];
  Timer? _timer;
  final ScoreService _scoreService = ScoreService();

  @override
  void initState() {
    super.initState();
    initializeResults();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      fetchResults();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> initializeResults() async {
    await _scoreService.calculateAndSaveFinalScores(widget.competitionId);
    await fetchResults();
  }

  Future<void> fetchResults() async {
    QuerySnapshot resultSnapshot = await FirebaseFirestore.instance
        .collection('results')
        .where('competitionId', isEqualTo: widget.competitionId)
        .orderBy('finalScore', descending: true)
        .get();

    List<Result> fetchedResults = resultSnapshot.docs
        .map((doc) => Result.fromMap(doc.data() as Map<String, dynamic>))
        .toList();

    setState(() {
      allResults = fetchedResults;
      results = fetchedResults;
      filterResults();
    });
  }

  void filterResults() {
    setState(() {
      results = allResults.where((result) {
        final matchesSearchQuery = result.attendantName
            .toLowerCase()
            .contains(searchQuery.toLowerCase());
        final matchesCategory =
            selectedCategory == 'All' || result.category == selectedCategory;
        final matchesAgeGroup =
            selectedAgeGroup == 'All' || result.ageGroup == selectedAgeGroup;

        return matchesSearchQuery && matchesCategory && matchesAgeGroup;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Үр дүн',
          style: TextStyle(
              fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF001C55),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      buildFilterSection(
                        "Төрөл",
                        ['All', 'IM', 'IW', 'MP', 'TR', 'GR', 'AD', 'AS'],
                        selectedCategory,
                        (value) {
                          setState(() {
                            selectedCategory = value;
                            filterResults();
                          });
                        },
                      ),
                      buildFilterSection(
                        "Насны ангилал",
                        ['All', 'SR', 'JR', 'AG'],
                        selectedAgeGroup,
                        (value) {
                          setState(() {
                            selectedAgeGroup = value;
                            filterResults();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4.0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Оролцогч хайх',
                    labelStyle: TextStyle(
                      color: Color(0xFF001C55),
                      fontWeight: FontWeight.bold,
                    ),
                    prefixIcon: Icon(Icons.search, color: Color(0xFF0E6BA8)),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF001C55)),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF001C55), width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                      filterResults();
                    });
                  },
                  style: TextStyle(color: Color(0xFF001C55)),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final result = results[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (index == 0 ||
                          result.category != results[index - 1].category)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            result.category,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF001C55)),
                          ),
                        ),
                      Card(
                        color: Color(0xFFA6E1FA),
                        margin: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                          title: Text(result.attendantName,
                              style: TextStyle(
                                  color: Color(0xFF001C55),
                                  fontWeight: FontWeight.bold)),
                          subtitle: Text(
                              'Ранк: ${result.rank}, Насны ангилал: ${result.ageGroup}, Оноо: ${result.finalScore}',
                              style: TextStyle(color: Color(0xFF0A2472))),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFilterSection(String label, List<String> items,
      String selectedItem, Function(String) onSelect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF001C55)),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: items.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ChoiceChip(
                  label: Text(item),
                  selected: selectedItem == item,
                  selectedColor: Color(0xFF0E6BA8),
                  labelStyle: TextStyle(
                      color:
                          selectedItem == item ? Colors.white : Colors.black),
                  onSelected: (selected) {
                    onSelect(selected ? item : 'All');
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
