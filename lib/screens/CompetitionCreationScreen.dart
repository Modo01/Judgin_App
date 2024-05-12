import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class CompetitionCreationScreen extends StatefulWidget {
  @override
  _CompetitionCreationScreenState createState() =>
      _CompetitionCreationScreenState();
}

class _CompetitionCreationScreenState extends State<CompetitionCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _startDateController = TextEditingController();
  final _locationController = TextEditingController();

  List<String> _selectedAgeGroups = [];
  List<String> _selectedCategories = [];
  Map<String, List<String>> judges = {
    'chair': [],
    'execution': [],
    'artistry': [],
    'difficulty': [],
  };

  List _ageGroups = [
    {"display": "Senior", "value": "SR"},
    {"display": "Junior", "value": "JR"},
    {"display": "Age Group", "value": "AG"},
  ];

  List _categories = [
    {"display": "Individual Men", "value": "IM"},
    {"display": "Individual Women", "value": "IW"},
    {"display": "Mixed Pairs", "value": "MP"},
    {"display": "Trio", "value": "TR"},
    {"display": "Group", "value": "GR"},
    {"display": "Aerobic Dance", "value": "AD"},
    {"display": "Aerobicl Step", "value": "AS"},
  ];

  void showJudgeSelectionDialog(String type) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Judges for $type"),
          content: Container(
            width: double.maxFinite,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('role', isEqualTo: 'Judge')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return LinearProgressIndicator();
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    bool isSelected =
                        judges[type]!.contains(document['firstName']);
                    return ListTile(
                      title: Text(document['firstName']),
                      leading: Icon(isSelected
                          ? Icons.check_box
                          : Icons.check_box_outline_blank),
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            judges[type]?.remove(document['firstName']);
                          } else {
                            if (judges[type]!.length < 4) {
                              judges[type]?.add(document['firstName']);
                            }
                          }
                        });
                        Navigator.of(context).pop();
                      },
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget buildJudgeSection(String title, String type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        Wrap(
          children: judges[type]!
              .map((name) => Chip(
                    label: Text(name),
                    onDeleted: () {
                      setState(() {
                        judges[type]?.remove(name);
                      });
                    },
                  ))
              .toList(),
        ),
        SizedBox(height: 8),
        OutlinedButton(
          onPressed: () => showJudgeSelectionDialog(type),
          child: Text('Add $type Judges'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Тэмцээн үүсгэх"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Нэр",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Нэрийг оруулна уу';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _startDateController,
                  decoration: InputDecoration(
                    labelText: "Эхлэх өдөр",
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      _startDateController.text =
                          "${pickedDate.toLocal()}".split(' ')[0];
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Тэмцээн эхлэх өдрийг оруулна уу';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: "Location",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                MultiSelectFormField(
                  autovalidate: AutovalidateMode.onUserInteraction,
                  chipLabelStyle: TextStyle(color: Colors.black),
                  dialogTextStyle: TextStyle(color: Colors.black),
                  checkBoxActiveColor: Colors.blue,
                  checkBoxCheckColor: Colors.white,
                  dialogShapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  title: Text(
                    "Age Groups",
                    style: TextStyle(fontSize: 16),
                  ),
                  dataSource: _ageGroups,
                  textField: 'display',
                  valueField: 'value',
                  okButtonLabel: 'OK',
                  cancelButtonLabel: 'CANCEL',
                  hintWidget: Text('Please choose one or more'),
                  initialValue: _selectedAgeGroups,
                  onSaved: (value) {
                    if (value == null) return;
                    _selectedAgeGroups = List.from(value);
                  },
                ),
                SizedBox(height: 20),
                MultiSelectFormField(
                  autovalidate: AutovalidateMode.onUserInteraction,
                  chipLabelStyle: TextStyle(color: Colors.black),
                  dialogTextStyle: TextStyle(color: Colors.black),
                  checkBoxActiveColor: Colors.blue,
                  checkBoxCheckColor: Colors.white,
                  dialogShapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  title: Text(
                    "Categories",
                    style: TextStyle(fontSize: 16),
                  ),
                  dataSource: _categories,
                  textField: 'display',
                  valueField: 'value',
                  okButtonLabel: 'OK',
                  cancelButtonLabel: 'CANCEL',
                  hintWidget: Text('Please select one or more options'),
                  initialValue: _selectedCategories,
                  onSaved: (value) {
                    if (value == null) return;
                    _selectedCategories = List.from(value);
                  },
                ),
                buildJudgeSection('Chair Judges', 'chair'),
                buildJudgeSection('Execution Judges', 'execution'),
                buildJudgeSection('Artistry Judges', 'artistry'),
                buildJudgeSection('Difficulty Judges', 'difficulty'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Map<String, dynamic> competitionData = {
                        'name': _nameController.text,
                        'startDate': _startDateController.text,
                        'location': _locationController.text,
                        'ageGroup': _selectedAgeGroups,
                        'categories': _selectedCategories,
                        'judges': judges
                      };

                      FirebaseFirestore.instance
                          .collection('competitions')
                          .add(competitionData)
                          .then((result) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Competition Created Successfully")));
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pushReplacementNamed(
                              context, '/competitionList');
                        }
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text("Failed to create competition: $error")));
                      });
                    }
                  },
                  child: Text('Create Competition'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
