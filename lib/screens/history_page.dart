import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'welcome_screen.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Stream<QuerySnapshot> applicationStream;

  @override
  void initState() {
    super.initState();
    applicationStream = FirebaseFirestore.instance
        .collection('applications')
        .snapshots(); // top-level applications
  }

  void logoutAdmin(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => WelcomeScreen()),
          (route) => false,
    );
  }

  Future<void> deleteApplication(String docId) async {
    await FirebaseFirestore.instance
        .collection('applications')
        .doc(docId)
        .delete();
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
            onPressed: () => logoutAdmin(context),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: applicationStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading data."));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                "No applications submitted yet.",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final app = doc.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("📚 Scholarship: ${app['scholarshipName'] ?? ''}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 10),
                      Text("👤 Name: ${app['fullName'] ?? ''}"),
                      Text("🎂 DOB: ${app['dob'] ?? ''}"),
                      Text("🚻 Gender: ${app['gender'] ?? ''}"),
                      Text("📞 Contact: ${app['contact'] ?? ''}"),
                      Text("✉️ Email: ${app['email'] ?? ''}"),
                      const Divider(),
                      Text("🎓 Course: ${app['course'] ?? ''}"),
                      Text("🏫 Institution: ${app['institution'] ?? ''}"),
                      Text("📅 Year: ${app['year'] ?? ''}"),
                      Text("📈 CGPA: ${app['cgpa'] ?? ''}"),
                      const Divider(),
                      Text("💰 Income: ${app['income'] ?? ''}"),
                      Text("👨‍👩‍👦 Earners: ${app['earners'] ?? ''}"),
                      Text("🗂 Category: ${app['category'] ?? ''}"),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          label: const Text("Delete", style: TextStyle(color: Colors.red)),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text("Confirm Delete"),
                                content: const Text("Are you sure you want to delete this application?"),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: const Text("Cancel")),
                                  TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: const Text("Delete")),
                                ],
                              ),
                            );
                            if (confirm ?? false) {
                              await deleteApplication(doc.id);
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
