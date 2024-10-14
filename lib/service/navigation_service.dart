import 'package:flutter/material.dart';
import 'package:motu/view/home/home_page.dart';
import 'package:motu/view/profile/profile_page.dart';
import 'package:motu/view/scenario/scenario_page.dart';
import '../view/learning/learning_contents.dart';

class NavigationService with ChangeNotifier {
  String? uid;

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  final List<Widget> _screens = [
    const HomePage(),
    const LearningContentscreen(),
    const ScenarioPage(),
    const ProfilePage(),
  ];

  List<Widget> get screens => _screens;

  void goToHome() => setSelectedIndex(0);
  void goToLearning() => setSelectedIndex(1);
  void goToScenario() => setSelectedIndex(2);
  void goToProfile() => setSelectedIndex(3);
}