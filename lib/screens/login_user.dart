import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard.dart';
import 'register_user.dart';

class UserLoginPage extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');

  void loginUser(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    final prefs = await SharedPreferences.getInstance();
    final storedEmail = prefs.getString('user_email');
    final storedPassword = prefs.getString('user_password');

    if (email.isEmpty || password.isEmpty) {
      showMsg(context, "Please fill all fields");
      return;
    }

    if (!emailRegex.hasMatch(email)) {
      showMsg(context, "Invalid email format");
      return;
    }

    if (email == storedEmail && password == storedPassword) {
      await prefs.setBool('is_logged_in', true);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardPage()));
    } else {
      showMsg(context, "Invalid credentials");
    }
  }

  void showMsg(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8EB2AF),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Text("User Login", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              buildTextField("Email", Icons.email, emailController),
              const SizedBox(height: 15),
              buildTextField("Password", Icons.lock, passwordController, isPassword: true),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => loginUser(context),
                child: const Text("Login"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => RegisterUserPage()),
                  );
                },
                child: const Text("Create Account?"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String hint, IconData icon, TextEditingController controller,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
