import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tailor_app/screens/boutique/applications_received_screen.dart';
import 'package:tailor_app/screens/boutique/create_vancacy_screen.dart';

import '../../services/token_storage.dart';

class ControllerScreenBoutique extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ControllerScreenState();
  }
}

class _ControllerScreenState extends State<ControllerScreenBoutique> {
  var currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return buildUI(context);
  }

  Widget buildUI(BuildContext context) {
    return Scaffold(

      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.redAccent,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.add_box, color: Colors.white), // Changed icon for Create Vacancy
            icon: Icon(Icons.add_box),
            label: 'Create Vacancy', // Changed label
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.inbox, color: Colors.white), // Changed icon for Applications Received
            icon: Icon(Icons.inbox),
            label: 'Applications Received', // Changed label
          ),
        ],
      ),
      body: <Widget>[
        CreateVacancyScreen(), // Screen for the Create Vacancy tab
        ApplicationsReceivedScreen(), // Screen for the Applications Received tab
      ][currentPageIndex],
    );
  }
}




