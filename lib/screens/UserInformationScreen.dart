import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Ensure this package is included in your pubspec.yaml
import 'package:provider/provider.dart';
import 'package:judging_app/models/UserModel.dart';
import 'package:judging_app/provider/auth_provider.dart';
import 'package:judging_app/screens/homeScreen.dart';
import 'package:judging_app/utils/utils.dart'; // Contains utility functions like `showSnackBar`
import 'package:judging_app/widgets/custom_button.dart'; // Your custom button widget

class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({Key? key}) : super(key: key);

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  File? image;
  final ImagePicker _picker = ImagePicker();
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final nationalIdController = TextEditingController();
  final ageController = TextEditingController();
  final trainerPhoneController = TextEditingController();
  final clubNameController = TextEditingController();
  String? selectedRole;
  String? selectedGender;

  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    nationalIdController.dispose();
    ageController.dispose();
    trainerPhoneController.dispose();
    clubNameController.dispose();
    super.dispose();
  }

  void selectImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  void saveUserData(BuildContext context) {
    if (image == null) {
      showSnackBar(context, "Please upload your profile photo.");
      return;
    }

    // Check if the role is 'Athlete' and if the trainerPhone field is not empty
    String? formattedTrainerPhone =
        selectedRole == 'Athlete' && trainerPhoneController.text.isNotEmpty
            ? "+976${trainerPhoneController.text.trim()}"
            : null;

    UserModel userModel = UserModel(
      userId: "", // This will be set by Firebase Auth upon user creation
      firstName: firstnameController.text.trim(),
      lastName: lastnameController.text.trim(),
      email: emailController.text.trim(),
      role: selectedRole ?? "Not set",
      profilePic: "", // This will be updated after image upload
      phoneNumber: "", // This should be set by previous authentication steps
      clubName: clubNameController.text.trim(),
      nationalId: nationalIdController.text.trim(),
      gender: selectedGender ?? "",
      age: int.tryParse(ageController.text.trim()) ?? 0,
      trainerPhone: formattedTrainerPhone,
    );

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.saveUserDataToFirebase(
      context: context,
      userModel: userModel,
      profilePic: image!,
      onSuccess: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Information")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: selectImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: image != null ? FileImage(image!) : null,
                child: image == null
                    ? const Icon(Icons.add_a_photo, size: 50)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            buildTextField("First Name", Icons.person, TextInputType.name,
                firstnameController),
            buildTextField("Last Name", Icons.person_outline,
                TextInputType.name, lastnameController),
            buildTextField("Email", Icons.email, TextInputType.emailAddress,
                emailController),
            DropdownButtonFormField<String>(
              value: selectedRole,
              decoration: InputDecoration(
                icon: Icon(Icons.supervisor_account),
                labelText: 'Select Role',
              ),
              onChanged: (newValue) {
                setState(() {
                  selectedRole = newValue;
                });
              },
              items: <String>['Admin', 'Judge', 'Trainer', 'Athlete']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            if (selectedRole == 'Trainer')
              buildTextField("Club Name", Icons.signal_cellular_0_bar,
                  TextInputType.text, clubNameController),
            if (selectedRole == 'Athlete')
              buildTextField("Trainer's Phone Number", Icons.phone,
                  TextInputType.phone, trainerPhoneController),
            if (selectedRole == 'Athlete')
              buildTextField("National ID", Icons.perm_identity,
                  TextInputType.number, nationalIdController),
            if (selectedRole == 'Athlete')
              buildTextField("Age", Icons.calendar_today, TextInputType.number,
                  ageController),
            if (selectedRole == 'Athlete')
              DropdownButtonFormField<String>(
                value: selectedGender,
                decoration: InputDecoration(
                  icon: Icon(Icons.transgender),
                  labelText: 'Select Gender',
                ),
                onChanged: (newValue) {
                  setState(() {
                    selectedGender = newValue;
                  });
                },
                items: <String>['Male', 'Female', 'Other']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            const SizedBox(height: 20),
            CustomButton(
              text: "Continue",
              onPressed: () => saveUserData(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String hintText, IconData icon, TextInputType inputType,
      TextEditingController controller) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: hintText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
      controller: controller,
      keyboardType: inputType,
    );
  }
}
