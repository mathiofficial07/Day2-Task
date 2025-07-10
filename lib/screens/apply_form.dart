import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplicationFormPage extends StatefulWidget {
  final String scholarshipName;

  const ApplicationFormPage({required this.scholarshipName});

  @override
  State<ApplicationFormPage> createState() => _ApplicationFormPageState();
}

class _ApplicationFormPageState extends State<ApplicationFormPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();

  Future<void> _storeApplication(Map<String, String> data) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList('applications') ?? [];
    existing.add(jsonEncode(data));
    await prefs.setStringList('applications', existing);
  }

  @override
  Widget build(BuildContext context) {
    final details = _scholarshipDetails[widget.scholarshipName];

    return Scaffold(
      backgroundColor: const Color(0xFF8EB2AF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8EB2AF),
        title: Text(widget.scholarshipName),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "🎉 Welcome to the ${widget.scholarshipName} application portal!",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 20),

              if (details != null) ...[
                const Text("📋 Eligibility Criteria:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...details['eligibility'].map<Widget>((e) => _bulletPoint(e)),

                const SizedBox(height: 20),
                const Text("✨ Scholarship Benefits:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...details['features'].map<Widget>((f) => _bulletPoint(f)),
                const SizedBox(height: 30),
              ],

              _buildInputField("Name", nameController),
              const SizedBox(height: 15),
              _buildInputField("Surname", surnameController),
              const SizedBox(height: 15),
              _buildInputField("Email", emailController, isEmail: true),
              const SizedBox(height: 15),
              _buildInputField("Message", messageController, maxLines: 4),

              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final appData = {
                        "scholarshipName": widget.scholarshipName,
                        "name": nameController.text.trim(),
                        "surname": surnameController.text.trim(),
                        "email": emailController.text.trim(),
                        "message": messageController.text.trim(),
                      };
                      await _storeApplication(appData);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Application submitted for ${widget.scholarshipName}")),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text("Submit", style: TextStyle(color: Colors.deepPurple)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller,
      {int maxLines = 1, bool isEmail = false}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label is required';
        }
        if (isEmail && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Enter a valid email';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _bulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 16)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  final Map<String, Map<String, dynamic>> _scholarshipDetails = {
    "HDFC Scholarship": {
      "eligibility": [
        "Annual income less than ₹2.5 lakhs",
        "Minimum 60% in previous exam",
        "Indian citizenship"
      ],
      "features": [
        "Financial aid up to ₹75,000",
        "Covers tuition and book expenses",
        "Renewable every academic year"
      ]
    },
    "TATA Trust Scholarship": {
      "eligibility": [
        "Undergraduate student",
        "Studying in a recognized institution",
        "Minimum 70% aggregate"
      ],
      "features": [
        "Full tuition coverage",
        "One-time research grant",
        "Mentorship by TATA scholars"
      ]
    },
    "Reliance Foundation": {
      "eligibility": [
        "Indian nationals only",
        "Must be pursuing UG/PG course",
        "Family income under ₹3 lakhs"
      ],
      "features": [
        "Merit-based selection",
        "Career counseling support",
        "Access to Reliance alumni network"
      ]
    },
    "ONGC Scholarship": {
      "eligibility": [
        "SC/ST/OBC category",
        "Final year students",
        "Minimum 60% score"
      ],
      "features": [
        "₹48,000 per year",
        "For engineering, medicine & law",
        "Selection via written test"
      ]
    },
    "Aditya Birla Scholar": {
      "eligibility": [
        "Top rankers in CAT/XAT/IIT-JEE",
        "Students from selected institutes",
        "Must attend interview round"
      ],
      "features": [
        "₹1,80,000 per year",
        "Scholarly development programs",
        "Prestige & recognition"
      ]
    },
    "NSP Central Scheme": {
      "eligibility": [
        "Pre-matric & post-matric students",
        "Minority community (as defined)",
        "Income below ₹2 lakhs"
      ],
      "features": [
        "Government-backed scheme",
        "Covers fees & maintenance allowance",
        "Renewable on merit"
      ]
    },
  };
}
