import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import HTTP package
import 'dart:convert'; // For converting responses

import '../../constants.dart';
import '../../services/token_storage.dart';
import '../my_accepted_applications.dart';

class ApplicationsReceivedScreen extends StatefulWidget {
  @override
  _ApplicationsReceivedScreenState createState() => _ApplicationsReceivedScreenState();
}

class _ApplicationsReceivedScreenState extends State<ApplicationsReceivedScreen> {
  // Change the type to dynamic to accommodate various types returned from API
  List<Map<String, dynamic>> applications = [];

  @override
  void initState() {
    super.initState();
    fetchApplications(); // Fetch applications on screen load
  }

  // Function to fetch all applications
  Future<void> fetchApplications() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/applications'));

      if (response.statusCode == 200) {
        final List<dynamic> applicationList = json.decode(response.body);
        setState(() {
          applications = applicationList.map((application) {
            return {
              'tailorName': application['name'] ?? '', // Safely access with fallback
              'tailorAddress': application['address'] ?? '',
              'tailorContact': application['phone_number'] ?? '',
              'vacancyId': application['Vacancy_id']?.toString() ?? '', // Convert to String with fallback
              'email': application['email']?.toString() ?? '', // Convert to String with fallback
            };
          }).toList();
        });
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to fetch applications: ${json.decode(response.body)['message']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Handle network errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching applications: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Function to update the status of an application
  Future<void> updateApplicationStatus(String vacancyId, String email, String status) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/applications/status'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'Vacancy_id': vacancyId, 'email': email, 'status': status}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Application status updated to $status'),
            backgroundColor: status == 'Accepted' ? Colors.green : Colors.red,
          ),
        );
        fetchApplications(); // Refresh the application list
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update application: ${json.decode(response.body)['message']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Handle network errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating application: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Applications Received'),
            Row(
              children: [
                InkWell(onTap:(){
                  Navigator.push(context, MaterialPageRoute(builder: (_){
                    return MyAcceptedApplicationsScreen();
                  }));
                },child: Icon(Icons.content_paste_search)),
                SizedBox(width: 20.0,),
                InkWell(
                  child: Icon(Icons.exit_to_app),
                  onTap: () {
                    print("logout button pressed");
                    var result = TokenStorage.clearToken();
                    if (result != null) {
                      Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // List of Applications
            Expanded(
              child: ListView.builder(
                itemCount: applications.length,
                itemBuilder: (context, index) {
                  return buildApplicationItem(applications[index], context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build a single application item
  Widget buildApplicationItem(Map<String, dynamic> application, BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              application['tailorName'] ?? '',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.blueGrey, size: 20),
                SizedBox(width: 8),
                Expanded(child: Text(application['tailorAddress'] ?? '')),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone, color: Colors.blueGrey, size: 20),
                SizedBox(width: 8),
                Expanded(child: Text(application['tailorContact'] ?? '')),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.assignment, color: Colors.blueGrey, size: 20),
                SizedBox(width: 8),
                Expanded(child: Text('Vacancy ID: ${application['vacancyId']}')),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Reject Button
                ElevatedButton(
                  onPressed: () {
                    updateApplicationStatus(application['vacancyId']!, application['email']!, 'Rejected'); // Update application status to Rejected
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Reject',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
                SizedBox(width: 10),
                // Accept Button
                ElevatedButton(
                  onPressed: () {
                    updateApplicationStatus(application['vacancyId']!, application['email']!, 'Accepted'); // Update application status to Accepted
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Accept',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
