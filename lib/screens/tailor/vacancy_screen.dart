import 'package:flutter/material.dart';
import 'dart:convert'; // For decoding JSON responses
import 'package:http/http.dart' as http;
import 'package:tailor_app/constants.dart';

import '../../utility.dart'; // For making HTTP requests

class Vacancy extends StatefulWidget {
  @override
  _VacancyState createState() => _VacancyState();
}

class _VacancyState extends State<Vacancy> {
  List<Map<String, dynamic>> vacancies = [];

  @override
  void initState() {
    super.initState();
    fetchVacancies();
  }

  // Function to fetch vacancies from the API
  Future<void> fetchVacancies() async {
    final response = await http.get(Uri.parse('$apiUrl/vacancy/all'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Debugging output
      print('Fetched vacancies: ${data['vacancies']}');

      setState(() {
        vacancies = List<Map<String, dynamic>>.from(data['vacancies']);
      });
    } else {
      // Handle error
      print('Failed to load vacancies');
    }
  }

  // Function to apply for the vacancy
  Future<void> applyForVacancy(String email, String vacancyId) async {
    final response = await http.post(
      Uri.parse('$apiUrl/application/apply'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'Vacancy_id': vacancyId,
      }),
    );

    if (response.statusCode == 201) {
      // Application submitted successfully
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(data['message']),
        backgroundColor: Colors.green,
      ));
    } else {
      // Handle error
      final errorData = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorData['message']),
        backgroundColor: Colors.red,
      ));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Vacancies'),
            Icon(Icons.exit_to_app),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search Vacancy here',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 20),

            // List of Vacancies
            Expanded(
              child: vacancies.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: vacancies.length,
                itemBuilder: (context, index) {
                  return buildVacancyItem(vacancies[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build a single vacancy item with an Apply button
  Widget buildVacancyItem(Map<String, dynamic> vacancy) {
    // Debugging output for each vacancy
    print('Vacancy: $vacancy');

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vacancy ID
            Text(
              'Vacancy ID: ${vacancy['Vacancy_id'] ?? ''}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 8),

            // Address
            Text(
              vacancy['address'] ?? '',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 12),

            // Working Hours
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.orangeAccent),
                SizedBox(width: 8),
                Text(
                  'Working Hours: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Expanded(
                  child: Text(
                    vacancy['working_hours'] ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),

            // Salary Offered
            Row(
              children: [
                Icon(Icons.attach_money, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'Salary Offered: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Expanded(
                  child: Text(
                    '${vacancy['salary_offered'] ?? ''} Rs./month',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),

            // Contact Number
            Row(
              children: [
                Icon(Icons.phone, color: Colors.blueAccent),
                SizedBox(width: 8),
                Text(
                  'Contact: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Expanded(
                  child: Text(
                    vacancy['phone_number'] ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Apply Button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  // Assuming you have a way to access the current user's email
                  String email = CurrentState.email; // Replace with your email state
                  String vacancyId = vacancy['Vacancy_id'].toString(); // Fetch the Vacancy ID as a String
                  applyForVacancy(email, vacancyId); // Call the apply function
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Capsule shape
                  ),
                ),
                child: Text(
                  'Apply',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
