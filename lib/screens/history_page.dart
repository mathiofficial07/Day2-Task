import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'welcome_screen.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> applications = [];

  @override
  void initState() {
    super.initState();
    loadApplications();
  }

  Future<void> loadApplications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? appList = prefs.getStringList('applications');

    if (appList != null) {
      setState(() {
        applications = appList
            .map((e) => jsonDecode(e))
            .cast<Map<String, dynamic>>()
            .toList();
      });
    }
  }

  void logoutAdmin(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => WelcomeScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8EB2AF),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Application History',
            style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: "Logout",
            onPressed: () => logoutAdmin(context),
          )
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: applications.isEmpty
          ? const Center(
        child: Text(
          "No applications submitted yet.",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      )
          : ListView.builder(
        itemCount: applications.length,
        itemBuilder: (context, index) {
          final app = applications[index];
          return Card(
            margin:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("📚 Scholarship: ${app['scholarshipName']}",
                      style:
                      const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text("👤 Name: ${app['name']} ${app['surname']}"),
                  Text("✉️ Email: ${app['email']}"),
                  Text("📝 Message: ${app['message']}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
