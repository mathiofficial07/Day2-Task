import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dashboard.dart'; // Ensure this file and class exist

class ApplicationFormPage extends StatefulWidget {
  final String scholarshipName;

  const ApplicationFormPage({super.key, required this.scholarshipName});

  @override
  State<ApplicationFormPage> createState() => _ApplicationFormPageState();
}

class _ApplicationFormPageState extends State<ApplicationFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final genderOptions = ['Male', 'Female', 'Other'];
  String? selectedGender;
  final contactController = TextEditingController();
  final emailController = TextEditingController();

  final courseController = TextEditingController();
  final institutionController = TextEditingController();
  final yearController = TextEditingController();
  final cgpaController = TextEditingController();

  final incomeController = TextEditingController();
  final earnersController = TextEditingController();
  final categoryOptions = ['General', 'OBC', 'SC', 'ST'];
  String? selectedCategory;
  bool declarationAccepted = false;

  Future<void> _storeApplication(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection('applications').add(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8EB2AF),
      appBar: AppBar(
        title: Text('Apply for ${widget.scholarshipName}'),
        backgroundColor: const Color(0xFF8EB2AF),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(children: [
            _sectionTitle("👤 Personal Information"),
            _buildInput("Full Name", nameController),
            _buildDatePicker("Date of Birth", dobController),
            _buildDropdown("Gender", genderOptions, (value) {
              setState(() => selectedGender = value);
            }, selectedGender),
            _buildInput("Contact Number", contactController, isNumber: true, maxLength: 10),
            _buildInput("Email", emailController, isEmail: true),

            const SizedBox(height: 20),
            _sectionTitle("📘 Academic Information"),
            _buildInput("Course/Degree", courseController),
            _buildInput("Institution", institutionController),
            _buildInput("Year of Study", yearController),
            _buildInput("CGPA/Percentage", cgpaController),

            const SizedBox(height: 20),
            _sectionTitle("💸 Financial Information"),
            _buildInput("Annual Family Income", incomeController, isNumber: true),
            _buildInput("No. of Earning Members", earnersController, isNumber: true),
            _buildDropdown("Category", categoryOptions, (value) {
              setState(() => selectedCategory = value);
            }, selectedCategory),

            const SizedBox(height: 20),
            _sectionTitle("📝 Declaration"),
            Row(children: [
              Checkbox(
                value: declarationAccepted,
                onChanged: (value) => setState(() => declarationAccepted = value!),
              ),
              const Expanded(
                child: Text("I confirm that all the information is correct."),
              ),
            ]),

            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  if (!declarationAccepted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please accept the declaration.")),
                    );
                    return;
                  }

                  final data = {
                    "scholarshipName": widget.scholarshipName,
                    "fullName": nameController.text.trim(),
                    "dob": dobController.text.trim(),
                    "gender": selectedGender,
                    "contact": contactController.text.trim(),
                    "email": emailController.text.trim(),
                    "course": courseController.text.trim(),
                    "institution": institutionController.text.trim(),
                    "year": yearController.text.trim(),
                    "cgpa": cgpaController.text.trim(),
                    "income": incomeController.text.trim(),
                    "earners": earnersController.text.trim(),
                    "category": selectedCategory,
                    "timestamp": FieldValue.serverTimestamp(),
                  };

                  try {
                    await _storeApplication(data);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Application Submitted")),
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => DashboardPage()),
                    );
                  } catch (e) {
                    print("Error submitting application: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Failed to submit: $e")),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text("Submit", style: TextStyle(color: Colors.deepPurple)),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller,
      {bool isEmail = false, bool isNumber = false, int? maxLength}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: isEmail
            ? TextInputType.emailAddress
            : isNumber
            ? TextInputType.number
            : TextInputType.text,
        maxLength: maxLength,
        validator: (value) {
          if (value == null || value.isEmpty) return '$label is required';
          if (isEmail && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value.trim())) {
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
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> options,
      Function(String?) onChanged, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
        validator: (value) => value == null ? 'Please select your $label' : null,
      ),
    );
  }

  Widget _buildDatePicker(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          suffixIcon: const Icon(Icons.calendar_today),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime(2005),
            firstDate: DateTime(1980),
            lastDate: DateTime.now(),
          );
          if (picked != null) {
            controller.text = "${picked.toLocal()}".split(' ')[0];
          }
        },
        validator: (value) =>
        value == null || value.isEmpty ? '$label is required' : null,
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}
