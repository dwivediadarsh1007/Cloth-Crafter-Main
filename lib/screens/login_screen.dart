// lib/screens/login_screen.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tailor_app/screens/boutique/controller_screen.dart';
import 'package:tailor_app/screens/controller_screen.dart';
import 'package:tailor_app/screens/home_screen.dart';
import 'package:tailor_app/screens/signup_screen.dart';
import 'package:tailor_app/screens/tailor/controller_screen.dart';
import 'package:tailor_app/utility.dart';
import '../services/auth_service.dart';
import '../services/token_storage.dart'; // Import the auth service

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }

}

class _LoginScreenState extends State<LoginScreen> {
  bool _passwordVisibility = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  initState(){
    super.initState();
    TokenStorage.clearAllSharedPreferences();
    print('Shared Preference Cleared.');
  }

  Future<void> _login() async {
    // // Check if a token already exists
    // final existingToken = await TokenStorage.getToken();
    // if (existingToken != null ) {
    //   if(CurrentState.userType=='User'){
    //     print('User getting logged in .');
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (_) => ControllerScreen()),
    //     );
    //   }
    //   else if(CurrentState.userType=='Tailor'){
    //     print('Tailor getting logged in .');
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (_) => ControllerScreenTailor()),
    //     );
    //   }
    //   else if(CurrentState.userType=='Boutique'){
    //     print('Boutique getting logged in .');
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (_) => ControllerScreenBoutique()),
    //     );
    //   }
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (_) => ControllerScreen()),
    //   );
    //   return;
    // }

    final email = _emailController.text;
    final password = _passwordController.text;

    // Show progress indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    // Start the login process
    try {
      final token = await loginUser(email, password);

      if (token != null) {

        // Close progress indicator
        Navigator.pop(context);

        // Show success message and navigate to HomeScreen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login Successful!'),
            backgroundColor: Colors.green,
          ),
        );
        print('User Type Now : ${CurrentState.userType}');

        if(CurrentState.userType=='User'){
          print('user logged in ');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => ControllerScreen()),
              (route) => false,
        );}
        else if(CurrentState.userType=='Tailor'){
          print('tailor logged in ');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => ControllerScreenTailor()),
              (route) => false,
        );}
        else if(CurrentState.userType=='Boutique'){
          print('boutique logged in ');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => ControllerScreenBoutique()),
              (route) => false,
        );}



      } else {
        // Close progress indicator
        Navigator.pop(context);

        _showErrorDialog('Login failed. Please check your credentials and try again.');
      }
    } catch (error) {
      // Close progress indicator
      Navigator.pop(context);

      // Show detailed error message
      _showErrorDialog('An error occurred: ${error.toString()}');
    }
  }


  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildUI(context),
    );
  }

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
                "Login",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  fontSize: 35,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Glad to see you again !",
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
                TextField(
                  controller: _emailController,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 1,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email, color: Colors.black),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: 'Email Address',
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      letterSpacing: 0,
                    ),
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(color: Colors.black12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  style: const TextStyle(
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
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      letterSpacing: 0,
                    ),
                    hintText: 'Enter your password',
                    hintStyle: TextStyle(color: Colors.black12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                  obscureText: !_passwordVisibility,
                ),
                SizedBox(height: 7),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text("Forgot Password ?", style: TextStyle(color: Colors.red)),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _login,
                    child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text("or"),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // login logic
                      print("Google Sign in Pressed");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'assets/images/google.png',
                          width: 24,
                          height: 24,
                        ),
                        Text(
                          "Sign in with Google",
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 50),
                RichText(
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    children: [
                      TextSpan(
                        text: 'Register',
                        style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.normal),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            print("Register clicked");
                            Navigator.push(context,MaterialPageRoute(builder: (_){
                              return SignupScreen();
                            }));
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
