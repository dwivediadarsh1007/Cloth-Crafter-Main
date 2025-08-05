import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tailor_app/constants.dart';
import 'package:tailor_app/utility.dart';  // Make sure this file contains your 'apiUrl' // Import the file where CurrentState is defined

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Map<String, String>> userProfile;

  @override
  void initState() {
    super.initState();
    userProfile = fetchUserProfile();
  }

  Future<Map<String, String>> fetchUserProfile() async {
    // Retrieve the email from CurrentState.email
    final email = CurrentState.email;

    if (email == null || email.isEmpty) {
      throw Exception('Email is missing. Please ensure you are logged in.');
    }

    final response = await http.post(
      Uri.parse('$apiUrl/profile'),  // Replace with your API endpoint
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,  // Use the dynamic email from CurrentState.email
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return {
        'username': data['username'] ?? 'N/A',
        'email': data['email'] ?? 'N/A',
        'phone_number': data['phone_number'] ?? 'N/A',
        'address': data['address'] ?? 'N/A',
      };
    } else {
      throw Exception('Failed to load profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: Colors.red[100]),
          FutureBuilder<Map<String, String>>(
            future: userProfile,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final data = snapshot.data!;
                final username = data['username'] ?? 'User';  // Default to 'User' if the username is null

                return Stack(
                  children: [
                    Positioned(
                      top: 30,
                      left: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hi $username!",  // Dynamically display the fetched username
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                              fontSize: 35,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Have a look at your profile",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Container(
                        padding: const EdgeInsets.only(left: 16, right: 16, top: 28, bottom: 50),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 3,
                              spreadRadius: 3,
                              offset: Offset(0, -5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage('assets/images/person.webp'),
                              radius: 60,
                            ),
                            SizedBox(height: 20),
                            buildUIItem(Icons.person, data['username']!),
                            SizedBox(height: 20),
                            buildUIItem(Icons.email, data['email']!),
                            SizedBox(height: 20),
                            buildUIItem(Icons.phone, data['phone_number']!),
                            SizedBox(height: 20),
                            buildUIItem(Icons.location_on, data['address']!),
                            SizedBox(height: 30),
                            Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/profile_edit');
                                  print("Edit Profile Pressed");
                                },
                                child: Text(
                                  "Edit Profile",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildUIItem(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
            spreadRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      width: double.infinity,
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.red,
            size: 24,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
