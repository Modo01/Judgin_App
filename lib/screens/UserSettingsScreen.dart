import 'package:flutter/material.dart';
import 'package:judging_app/provider/auth_provider.dart';
import 'package:judging_app/screens/ProfileScreen.dart';
import 'package:provider/provider.dart';

class UserSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("User Settings"),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[200],
              backgroundImage: authProvider.userModel.profilePic.isNotEmpty
                  ? NetworkImage(authProvider.userModel.profilePic)
                  : AssetImage("assets/profile_placeholder.png")
                      as ImageProvider,
            ),
            SizedBox(height: 20),
            Text(
                "Welcome, ${authProvider.userModel.firstName} ${authProvider.userModel.lastName}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("Email: ${authProvider.userModel.email}",
                style: TextStyle(color: Colors.grey[700], fontSize: 16)),
            Text("Phone: ${authProvider.userModel.phoneNumber}",
                style: TextStyle(color: Colors.grey[700], fontSize: 16)),
            ElevatedButton(
              onPressed: () {
                authProvider.userSignOut().then((_) {
                  Navigator.of(context).pushReplacementNamed('/login');
                });
              },
              child: Text("Log Out"),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                onPrimary: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
