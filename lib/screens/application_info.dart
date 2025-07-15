import 'package:flutter/material.dart';
import 'application_form_page.dart';

class ApplicationInfoPage extends StatelessWidget {
  final String scholarshipName;

  ApplicationInfoPage({super.key, required this.scholarshipName});

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

  @override
  Widget build(BuildContext context) {
    final details = _scholarshipDetails[scholarshipName];

    return Scaffold(
      backgroundColor: const Color(0xFF8EB2AF),
      appBar: AppBar(
        title: Text(scholarshipName),
        backgroundColor: const Color(0xFF8EB2AF),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("🎉 Welcome to $scholarshipName Application Portal",
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple)),
            const SizedBox(height: 20),

            if (details != null) ...[
              const Text("📋 Eligibility Criteria:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...details['eligibility']
                  .map<Widget>((e) => _bulletPoint(e))
                  .toList(),

              const SizedBox(height: 20),
              const Text("✨ Benefits:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...details['features']
                  .map<Widget>((f) => _bulletPoint(f))
                  .toList(),
              const SizedBox(height: 30),
            ],

            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ApplicationFormPage(
                        scholarshipName: scholarshipName,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text("Start Your Application",
                    style: TextStyle(color: Colors.deepPurple)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
