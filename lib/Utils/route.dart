
import 'package:centraldashboardversion4/DynamicFlow/HomePage.dart';
import 'package:flutter/material.dart';
import '../BarChart/demo.dart';
import '../DynamicFlow/MainMenuPage.dart';
import '../Login/checkLogin.dart';
import '../Home/homescreen.dart';
import '../Login/login.dart';

final routes = {
  '/': (BuildContext context) => new IsLoggedIn(),
  '/login': (BuildContext context) => new LoginPage(),
  '/home': (BuildContext context) => new Home(),
  '/homepage': (BuildContext context) => new HomePage(),
'/MainMenuPage': (BuildContext context) => new MainMenuPage(),


};
