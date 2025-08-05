import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tailor_app/screens/tailor/application_status_screen.dart';
import 'package:tailor_app/screens/tailor/vacancy_screen.dart';

import '../../services/token_storage.dart';

class ControllerScreenTailor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ControllerScreenState();
  }
}

class _ControllerScreenState extends State<ControllerScreenTailor> {
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
            selectedIcon: Icon(Icons.work, color: Colors.white),
            icon: Icon(Icons.work),
            label: 'Vacancy',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.check_circle, color: Colors.white),
            icon: Icon(Icons.check_circle),
            label: 'Application Status',
          ),
        ],
      ),
      body: <Widget>[
        Vacancy(), // Screen for the Vacancy tab
        ApplicationStatusScreen(), // Screen for the Application Status tab
      ][currentPageIndex],
    );
  }
}




