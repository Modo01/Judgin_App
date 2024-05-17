import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:judging_app/models/UserModel.dart';
import 'package:judging_app/provider/auth_provider.dart';
import 'package:judging_app/screens/homeScreen.dart';
import 'package:judging_app/utils/utils.dart';
import 'package:judging_app/widgets/custom_button.dart';

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
      showSnackBar(context, "Өөрийн зургийг оруулна уу.");
      return;
    }

    String? formattedTrainerPhone =
        selectedRole == 'Athlete' && trainerPhoneController.text.isNotEmpty
            ? "+976${trainerPhoneController.text.trim()}"
            : null;

    UserModel userModel = UserModel(
      userId: "",
      firstName: firstnameController.text.trim(),
      lastName: lastnameController.text.trim(),
      email: emailController.text.trim(),
      role: selectedRole ?? "Not set",
      profilePic: "",
      phoneNumber: "",
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
      appBar: AppBar(
        title: Text(
          "Хэрэглэгчийн мэдээлэл",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF00072D),
      ),
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
                    ? const Icon(Icons.add_a_photo,
                        size: 50, color: Colors.white)
                    : null,
                backgroundColor: Color(0xFF0E6BA8),
              ),
            ),
            const SizedBox(height: 20),
            buildTextField(
                "Нэр", Icons.person, TextInputType.name, firstnameController),
            const SizedBox(height: 10),
            buildTextField("Овог", Icons.person_outline, TextInputType.name,
                lastnameController),
            const SizedBox(height: 10),
            buildTextField("Цахим хаяг", Icons.email,
                TextInputType.emailAddress, emailController),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedRole,
              decoration: InputDecoration(
                labelText: 'Нэвтрэх эрхээ сонгоно уу',
                border: OutlineInputBorder(),
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
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: buildTextField("Клубын нэр", Icons.signal_cellular_0_bar,
                    TextInputType.text, clubNameController),
              ),
            if (selectedRole == 'Athlete') ...[
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: buildTextField("Дасгалжуулагчийн утасны дугаар",
                    Icons.phone, TextInputType.phone, trainerPhoneController),
              ),
              const SizedBox(height: 10),
              buildTextField("Регистрийн дугаар", Icons.perm_identity,
                  TextInputType.number, nationalIdController),
              const SizedBox(height: 10),
              buildTextField("Нас", Icons.calendar_today, TextInputType.number,
                  ageController),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedGender,
                decoration: InputDecoration(
                  labelText: 'Хүйсээ сонгоно уу',
                  border: OutlineInputBorder(),
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
            ],
            const SizedBox(height: 20),
            CustomButton(
              text: "Үргэлжлүүлэх",
              onPressed: () => saveUserData(context),
              color: Color(0xFF0E6BA8),
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xFFE1F5FE),
    );
  }

  Widget buildTextField(String hintText, IconData icon, TextInputType inputType,
      TextEditingController controller) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: hintText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF0E6BA8)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF0A2472)),
        ),
      ),
      controller: controller,
      keyboardType: inputType,
    );
  }
}
