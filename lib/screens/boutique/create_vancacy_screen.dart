import 'package:flutter/material.dart';
import 'package:tailor_app/screens/my_accepted_applications.dart';
import 'package:tailor_app/utility.dart';
import '../../services/token_storage.dart';
import '../../services/vacancy_service.dart'; // Import the API service

class CreateVacancyScreen extends StatefulWidget {
  @override
  _CreateVacancyScreenState createState() => _CreateVacancyScreenState();
}

class _CreateVacancyScreenState extends State<CreateVacancyScreen> {
  String? selectedWorkingHours; // For storing the selected working hours
  final TextEditingController salaryController = TextEditingController(); // For salary input
  bool isLoading = false; // To manage loading state

  // Predefined working hours durations
  final List<String> workingHoursOptions = [
    '9 AM - 12 PM',
    '12 PM - 3 PM',
    '3 PM - 6 PM',
    '6 PM - 9 PM',
    '9 AM - 6 PM',
  ];

  // Function to handle API call for creating vacancy
  void _createVacancy() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    String email = await CurrentState.email; // Get email from token storage
    String workingHours = selectedWorkingHours ?? '';
    String salaryOffered = salaryController.text.trim();

    final result = await VacancyService.postVacancy(
      email: email,
      workingHours: workingHours,
      salaryOffered: salaryOffered,
    );

    setState(() {
      isLoading = false; // Hide loading indicator
    });

    if (result.containsKey('error')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${result['error']}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vacancy Created Successfully!')),
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
            Text('Create Vacancy'),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown for Working Hours
            Text(
              'Working Hours:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedWorkingHours,
              items: workingHoursOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedWorkingHours = newValue;
                });
              },
              hint: Text('Select Working Hours'),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Text Field for Salary Offered
            Text(
              'Salary Offered:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: salaryController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter salary',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 30),

            // Create Vacancy Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (selectedWorkingHours != null &&
                      salaryController.text.isNotEmpty) {
                    _createVacancy();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please fill all fields.'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: isLoading
                    ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
                    : Text(
                  'Create Vacancy',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
