import 'package:flutter/material.dart';
import 'package:judging_app/models/competition.dart';

class CompetitionScreen extends StatelessWidget {
  final List<Competition> competitions;

  const CompetitionScreen({required this.competitions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Competitions'),
      ),
      body: ListView.builder(
        itemCount: competitions.length,
        itemBuilder: (context, index) {
          return CompetitionCard(
            competition: competitions[index],
          );
        },
      ),
    );
  }
}

class CompetitionCard extends StatelessWidget {
  final Competition competition;

  const CompetitionCard({required this.competition});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              competition.name,
              style: TextStyle(fontSize: 18),
            ),
            Text('Categories: ${competition.categories.join(', ')}'),
            Text('Age Group: ${competition.ageGroup}'),
            Text('Start Date: ${competition.startDate.toString()}'),
            Text('Location: ${competition.location}'),
          ],
        ),
      ),
    );
  }
}