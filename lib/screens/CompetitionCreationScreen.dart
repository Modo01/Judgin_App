import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:judging_app/models/UserModel.dart';
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
  Map<String, List<UserModel>> judges = {
    'chair': [],
    'execution': [],
    'artistic': [],
    'difficulty': [],
  };

  List _ageGroups = [
    {"display": "Насанд хүрэгч", "value": "SR"},
    {"display": "Дунд нас", "value": "JR"},
    {"display": "Бага нас", "value": "AG"},
  ];

  List _categories = [
    {"display": "Ганцаарчилсан эрэгтэй", "value": "IM"},
    {"display": "Ганцаарчилсан эмэгтэй", "value": "IW"},
    {"display": "Хос", "value": "MP"},
    {"display": "Гурвалсан", "value": "TR"},
    {"display": "Баг", "value": "GR"},
    {"display": "Аэробик бүжиг", "value": "AD"},
    {"display": "Аэробик алхалт", "value": "AS"},
  ];

  Future<List<UserModel>> fetchJudges() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'Judge')
        .get();

    return snapshot.docs
        .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  void showJudgeSelectionModal(BuildContext context, String type) async {
    List<UserModel> allJudges = await fetchJudges();
    UserModel? selectedJudge;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: [
            ListTile(
              title: Text(
                'Шүүгч сонгох',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00072D),
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: allJudges.length,
                itemBuilder: (context, index) {
                  UserModel judge = allJudges[index];
                  return ListTile(
                    title: Text("${judge.lastName} ${judge.firstName}"),
                    onTap: () {
                      selectedJudge = judge;
                      setState(() {
                        if (selectedJudge != null &&
                            !judges[type]!.contains(selectedJudge!)) {
                          if (type == 'chair' && judges[type]!.isNotEmpty) {
                            judges[type] = [selectedJudge!];
                          } else {
                            judges[type]!.add(selectedJudge!);
                          }
                        }
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () {
            showJudgeSelectionModal(context, type);
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Color(0xFF0E6BA8),
          ),
          child: Text('Шүүгч нэмэх'),
        ),
        Wrap(
          children: judges[type]!
              .map((judge) => Chip(
                    label: Text(
                      "${judge.lastName} ${judge.firstName}",
                      style: TextStyle(color: Colors.black),
                    ),
                    deleteIconColor: Colors.black,
                    onDeleted: () {
                      setState(() {
                        judges[type]?.remove(judge);
                      });
                    },
                  ))
              .toList(),
        ),
      ],
    );
  }

  bool validateJudgeCounts() {
    return judges['chair']!.length == 1 &&
        judges['execution']!.length == 4 &&
        judges['artistic']!.length == 4 &&
        judges['difficulty']!.length == 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Тэмцээн үүсгэх",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF001C55),
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
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Нэрээ бичнэ үү';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _startDateController,
                  decoration: InputDecoration(
                    labelText: "Эхлэх огноо",
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.black),
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
                      return 'Эхлэх огноог бичнэ үү';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: "Байрлал",
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(height: 20),
                MultiSelectFormField(
                  chipLabelStyle: TextStyle(color: Colors.black),
                  dialogTextStyle: TextStyle(color: Colors.black),
                  checkBoxActiveColor: Color(0xFF0E6BA8),
                  checkBoxCheckColor: Colors.white,
                  dialogShapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  title: Text("Насны ангилал",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  dataSource: _ageGroups,
                  textField: 'display',
                  valueField: 'value',
                  okButtonLabel: 'OK',
                  cancelButtonLabel: 'CANCEL',
                  hintWidget: Text('Насны ангилал нэмэх'),
                  initialValue: _selectedAgeGroups,
                  onSaved: (value) {
                    if (value == null) return;
                    setState(() {
                      _selectedAgeGroups = List.from(value);
                    });
                  },
                ),
                SizedBox(height: 20),
                MultiSelectFormField(
                  chipLabelStyle: TextStyle(color: Colors.black),
                  dialogTextStyle: TextStyle(color: Colors.black),
                  checkBoxActiveColor: Color(0xFF0E6BA8),
                  checkBoxCheckColor: Colors.white,
                  dialogShapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  title: Text("Төрөл",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  dataSource: _categories,
                  textField: 'display',
                  valueField: 'value',
                  okButtonLabel: 'OK',
                  cancelButtonLabel: 'CANCEL',
                  hintWidget: Text('Төрөл нэмэх'),
                  initialValue: _selectedCategories,
                  onSaved: (value) {
                    if (value == null) return;
                    setState(() {
                      _selectedCategories = List.from(value);
                    });
                  },
                ),
                buildJudgeSection('Ерөнхий шүүгч', 'chair'),
                buildJudgeSection('Гүйцэтгэлийн шүүгч', 'execution'),
                buildJudgeSection('Жүжиглэлтийн шүүгч', 'artistic'),
                buildJudgeSection('Хүндрэлийн шүүгч', 'difficulty'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        validateJudgeCounts()) {
                      _formKey.currentState!.save();
                      Map<String, dynamic> competitionData = {
                        'name': _nameController.text,
                        'startDate': Timestamp.fromDate(
                            DateTime.parse(_startDateController.text)),
                        'location': _locationController.text,
                        'ageGroup': _selectedAgeGroups,
                        'categories': _selectedCategories,
                        'judges': judges.map((key, value) => MapEntry(key,
                            value.map((judge) => judge.phoneNumber).toList())),
                      };

                      FirebaseFirestore.instance
                          .collection('competitions')
                          .add(competitionData)
                          .then((result) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Тэмцээн амжилттай үүслээ")));
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pushReplacementNamed(
                              context, '/competitionList');
                        }
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text("Тэмцээн үүсэхэд алдаа гарлаа: $error")));
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "Ерөнхий 1 шүүгч, Гүйцэтгэлийн 4 шүүгч, Жүжиглэлтийн 4 шүүгч, Хүндрэлийн 2 шүүгч байх ёстой анхаарна уу"),
                      ));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xFF0E6BA8),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Тэмцээн үүсгэх'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
