import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // To parse JSON responses
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tailor_app/constants.dart';
import 'package:tailor_app/screens/account/terms_privacy_screen.dart'; // Import fluttertoast package

class SignupScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignupScreenState();
  }
}

class _SignupScreenState extends State<SignupScreen> {
  bool _passwordVisibility = false;
  bool _isChecked = false;
  String _selectedOption = "User";

  // Controllers for input fields
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  // Helper function for validating fields
  bool _validateFields() {
    if (_usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _addressController.text.isEmpty) {
      _showErrorDialog("All fields are required.");
      return false;
    }
    if (!_isChecked) {
      _showErrorDialog("You must agree to the Terms & Privacy.");
      return false;
    }
    return true;
  }

  // Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // API call for registration
  Future<void> _registerUser() async {
    if (_validateFields()) {
      String url = "$apiUrl:3000/register"; // Replace with your IP or localhost
      Map<String, dynamic> requestBody = {
        'username': _usernameController.text,
        'email': _emailController.text,
        'phone_number': _phoneController.text,
        'password': _passwordController.text,
        'user_type': _selectedOption,
        'address': _addressController.text,
      };

      try {
        var response = await http.post(
          Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(requestBody),
        );
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}'); // Print response body for debugging

        if (response.statusCode == 201) { // Check for status code 201 (Created)
          Fluttertoast.showToast(
            msg: "User registered successfully!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          Navigator.pop(context); // Go back to the previous screen
        } else {
          _showErrorDialog("Failed to register. Status Code: ${response.statusCode}\nResponse: ${response.body}");
        }
      } catch (e) {
        _showErrorDialog("An error occurred. Please try again later.\nError: $e");
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildUI(context),
    );
  }

  // Build UI
  Widget buildUI(BuildContext context) {
    return Stack(
      children: [
        Container(color: Colors.red[100]),
        const Positioned(
          top: 30,
          left: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Sign Up",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  fontSize: 35,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Create an account!",
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
            height: MediaQuery.of(context).size.height * 0.75,
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  buildTextField(
                    controller: _usernameController,
                    label: 'Username',
                    icon: Icons.person,
                  ),
                  SizedBox(height: 20),
                  buildTextField(
                    controller: _emailController,
                    label: 'Email Address',
                    icon: Icons.email,
                  ),
                  SizedBox(height: 20),
                  IntlPhoneField(
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    initialCountryCode: 'IN',
                    onChanged: (phone) {
                      _phoneController.text = phone.completeNumber;
                    },
                  ),
                  SizedBox(height: 20),
                  buildPasswordTextField(),
                  SizedBox(height: 20),
                  buildUserTypeOptions(),
                  SizedBox(height: 20),
                  buildTextField(
                    controller: _addressController,
                    label: 'Address',
                    icon: Icons.home,
                  ),
                  SizedBox(height: 20),
                  buildTermsAndConditions(),
                  SizedBox(height: 20),
                  buildSignupButton(),
                  SizedBox(height: 50),
                  buildLoginOption(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Helper to build text fields
  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.w300,
        letterSpacing: 1,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
      ),
    );
  }

  // Helper to build password text field
  Widget buildPasswordTextField() {
    return TextField(
      controller: _passwordController,
      maxLength: 8,
      style: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.w300,
        letterSpacing: 1,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock, color: Colors.black),
        suffixIcon: IconButton(
          icon: !_passwordVisibility
              ? Icon(Icons.visibility, color: Colors.black)
              : Icon(Icons.visibility_off, color: Colors.black),
          onPressed: () {
            setState(() {
              _passwordVisibility = !_passwordVisibility;
            });
          },
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelText: 'Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
      ),
      obscureText: !_passwordVisibility,
    );
  }

  // Helper to build user type options
  Widget buildUserTypeOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select User Type",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            letterSpacing: 0,
          ),
        ),
        SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildCheckOption('User', _selectedOption == 'User', (value) {
              setState(() {
                _selectedOption = 'User';
              });
            }),
            buildCheckOption('Tailor', _selectedOption == 'Tailor', (value) {
              setState(() {
                _selectedOption = 'Tailor';
              });
            }),
            buildCheckOption('Boutique', _selectedOption == 'Boutique', (value) {
              setState(() {
                _selectedOption = 'Boutique';
              });
            }),
          ],
        ),
      ],
    );
  }

  // Helper for radio buttons
  Widget buildCheckOption(String label, bool isSelected, Function(bool?) onChange) {
    return Row(
      children: [
        Radio(
          value: true,
          groupValue: isSelected,
          onChanged: onChange,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }

  // Helper to build terms and conditions
  Widget buildTermsAndConditions() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: _isChecked,
          onChanged: (value) {
            setState(() {
              _isChecked = value ?? false;
            });
          },
        ),
        Expanded(
          child: RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              text: "I agree to the ",
              style: TextStyle(color: Colors.black),
              children: [
                TextSpan(
                  text: "Terms & Privacy",
                  style: TextStyle(color: Colors.blue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // Navigate to Terms & Privacy page
                      Navigator.push(context, MaterialPageRoute(builder: (_){
                          return TermsPrivacyScreen();
                      }));
                    },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Helper to build signup button
  Widget buildSignupButton() {
    return ElevatedButton(
      onPressed: _registerUser,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
      ),
      child: const Text("Sign Up"),
    );
  }

  // Helper to build login option
  Widget buildLoginOption() {
    return RichText(
      text: TextSpan(
        text: "Already have an account? ",
        style: TextStyle(color: Colors.black),
        children: [
          TextSpan(
            text: "Login",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // Navigate to login page
                Navigator.pop(context);
              },
          ),
        ],
      ),
    );
  }
}
