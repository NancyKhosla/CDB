import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IsLoggedIn extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<IsLoggedIn> {
  String _username = "";

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _username = (prefs.getString('username') ?? "");
    if (_username == "") {
      Navigator.pushNamedAndRemoveUntil(
          context, '/login', ModalRoute.withName('/login'));
    } else {
      // change to /home when previous code needed
      // change to mainMenuPage when dynamic code needed
      Navigator.pushNamedAndRemoveUntil(
          context, '/MainMenuPage', ModalRoute.withName('/MainMenuPage'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
