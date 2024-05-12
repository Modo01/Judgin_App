import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:judging_app/provider/auth_provider.dart';
import 'package:judging_app/models/UserModel.dart';
import 'package:judging_app/screens/welcomeScreen.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;
  late UserModel _userModel;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final ap = Provider.of<AuthProvider>(context, listen: false);
    _userModel = ap.userModel;
    _initializeFields();
  }

  void _initializeFields() {
    _firstNameController.text = _userModel.firstName;
    _lastNameController.text = _userModel.lastName;
    _emailController.text = _userModel.email;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _selectImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      _userModel.firstName = _firstNameController.text;
      _userModel.lastName = _lastNameController.text;
      _userModel.email = _emailController.text;

      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_userModel.userId)
            .update(_userModel.toMap());

        print("Хувийн мэдээлэл хадгалагдлаа.");
        setState(() {
          _isEditing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Хувийн мэдээлэл амжилттай засагдлаа!")));
      } catch (e) {
        print("Error updating profile: $e");
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to update profile: $e")));
      }
    }
  }

  Widget _editButton() {
    return IconButton(
      icon: Icon(_isEditing ? Icons.check : Icons.edit),
      onPressed: () {
        if (_isEditing) {
          _saveProfile();
        } else {
          setState(() {
            _isEditing = true;
          });
        }
      },
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, bool enable) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
          ),
          fillColor: enable
              ? Colors.black12
              : Colors.grey[300], 
          filled: true, 
          labelStyle: TextStyle(
              color: enable
                  ? Colors.black
                  : Colors.grey 
              )),
      enabled: enable,
      style: TextStyle(color: Colors.black), // Text color
      validator: (value) =>
          value == null || value.isEmpty ? 'Please enter $label' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Хувийн мэдээлэл"),
        actions: [
          _editButton(),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _isEditing ? _selectImage : null,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.black,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : (_userModel.profilePic.isNotEmpty
                              ? NetworkImage(_userModel.profilePic)
                              : AssetImage("assets/profile_placeholder.png"))
                          as ImageProvider,
                  child: _isEditing
                      ? Icon(Icons.camera_alt, size: 30, color: Colors.white)
                      : null,
                ),
              ),
              SizedBox(height: 20),
              _buildTextField(_firstNameController, 'Нэр', _isEditing),
              SizedBox(height: 10),
              _buildTextField(_lastNameController, 'Овог', _isEditing),
              SizedBox(height: 10),
              _buildTextField(_emailController, 'Цахим хаяг', _isEditing),
              SizedBox(height: 20),
              if (_isEditing)
                ElevatedButton(
                  onPressed: _saveProfile,
                  child: Text("Хадгалах"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.lightBlue, // Background color
                    onPrimary: Colors.white, // Text color
                    padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15), // Button padding for bigger size
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                  ),
                ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  ap.userSignOut().then(
                        (value) => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WelcomeScreen()),
                        ),
                      );
                },
                child: Text("Системээс гарах"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.lightBlue, 
                  onPrimary: Colors.white, 
                  padding: EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), 
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
