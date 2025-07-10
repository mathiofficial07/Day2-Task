import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/splash_screen.dart';
import 'screens/dashboard.dart';
import 'screens/login_user.dart';

void main() => runApp(ScholarshipApp());

class ScholarshipApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scholarship App',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: checkLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen(); // Show splash while loading
          } else {
            return snapshot.data == true ? DashboardPage() : SplashScreen();
          }
        },
      ),
    );
  }

  Future<bool> checkLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }
}
