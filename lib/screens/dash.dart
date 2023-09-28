import 'package:calkuta/models/contributor.dart';
import 'package:calkuta/screens/all_contributors.dart';
import 'package:calkuta/screens/dashboard_screen.dart';
import 'package:calkuta/screens/registration_screen.dart';
import 'package:calkuta/screens/trans.dart';
import 'package:calkuta/util/my_color.dart';
import 'package:flutter/material.dart';

class DashScreen extends StatefulWidget {
  @override
  State<DashScreen> createState() => _DashScreenState();
}

class _DashScreenState extends State<DashScreen> {
  int current = 0;
  Contributor? contributor;

  final screens = [
    DashboardScreen(),
    const TransactionList(),
    AllContributors(),
    RegistrationScreen(appBarTitle: 'REGISTRATION', contributor: Contributor())
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[current],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: current,
        onTap: (value) => setState(() => current = value),
        showUnselectedLabels: false,
        backgroundColor: Colors.white,
        selectedItemColor: MyColor.mytheme,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Transaction',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle),
            label: 'All Member',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'New Member',
          ),
        ],
      ),
    );
  }
}
