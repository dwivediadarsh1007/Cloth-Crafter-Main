import 'package:flutter/material.dart';
import 'package:tailor_app/dress_collection_screen.dart';
import 'package:tailor_app/screens/account/manual_measurement.dart';
import 'package:tailor_app/screens/account/measurement_controller.dart';
import 'package:tailor_app/screens/account/measurement_profile.dart';
import 'package:tailor_app/screens/account/order_history_screen.dart';
import 'package:tailor_app/screens/account/terms_privacy_screen.dart';
import 'package:tailor_app/screens/boutique/controller_screen.dart';
import 'package:tailor_app/screens/controller_screen.dart';
import 'package:tailor_app/screens/login_screen.dart';
import 'package:tailor_app/screens/my_accepted_applications.dart';
import 'package:tailor_app/screens/order_dress_screen.dart';
import 'package:tailor_app/screens/order_fabric_screen.dart';
import 'package:tailor_app/screens/profile/profile_edit_screen.dart';
import 'package:tailor_app/screens/profile/profile_screen.dart';
import 'package:tailor_app/screens/search_tailor_screen.dart';
import 'package:tailor_app/screens/signup_screen.dart';
import 'package:tailor_app/screens/tailor/controller_screen.dart';
import 'package:tailor_app/screens/tailor/vacancy_screen.dart';
import 'package:tailor_app/screens/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tailor App',
      theme: ThemeData(
        canvasColor: Colors.red,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        focusColor: Colors.blue,
        useMaterial3: true,
      ),
      home: WelcomeScreen(),
      routes: {
      '/login': (context) => LoginScreen(),
      '/signup': (context) => SignupScreen(),
      '/controller':(context) => ControllerScreen(),
      '/profile_edit':(context) => ProfileEditScreen(),
      '/profile':(context) => ProfileScreen(),
      '/order_history':(context) => OrderHistoryScreen(),
      '/terms_privacy':(context) => TermsPrivacyScreen(),
      '/measurement_profile':(context)=> MeasurementController(),
        '/dresscollection':(context)=> DressCollectionScreen(),

    },
    debugShowCheckedModeBanner: false,
    );
  }
}


