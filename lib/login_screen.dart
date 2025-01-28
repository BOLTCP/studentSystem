import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api/get_api_url.dart';
import 'package:onemissystem/widgets/student_dashboard.dart';
import 'package:onemissystem/models/auth_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false; // To toggle password visibility
  final _loginNameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false; // To track if user wants to save their credentials
  bool _isLoading = false; // To track loading state

  @override
  void initState() {
    super.initState();
    _loadCredentials(); // Load saved credentials when the screen loads
  }

  // Login function
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final loginName = _loginNameController.text.trim();
      final passwordHash = _passwordController.text.trim();

      final Map<String, String> data = {
        'login_name': loginName,
        'password_hash': passwordHash,
      };

      setState(() {
        _isLoading = true; // Show loading indicator
      });

      try {
        final response = await http.post(
          getApiUrl('/login'), // Use platform-specific API URL with endpoint
          body: json.encode(data), // Send the data as JSON
          headers: {
            'Content-Type': 'application/json'
          }, // Ensure the correct content type
        ).timeout(Duration(seconds: 30)); // Set timeout for the request

        if (response.statusCode == 200) {
          // Parse response if login is successful
          logger.d('Login successful!');
          final decodedJson = json.decode(response.body);
          logger.d(decodedJson);
          final user = AuthUser.fromJson(decodedJson['user']);

          if (_rememberMe) {
            // Save the login credentials if "Remember me" is checked
            _saveCredentials(loginName, passwordHash);
          }

          if (user.userRole == 'student') {
            // Navigate to the student dashboard
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const StudentDashboard()),
            );
          }
        } else {
          // Handle login failure
          logger.d('Login failed: ${response.body}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login failed. Please try again.')),
          );
        }
      } catch (e) {
        // Handle error (e.g., network issues)
        logger.d('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred. Please try again.')),
        );
      } finally {
        setState(() {
          _isLoading = false; // Stop loading indicator
        });
      }
    }
  }

  // Save credentials to SharedPreferences
  Future<void> _saveCredentials(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
    prefs.setString('password', password);
  }

  // Load saved credentials from SharedPreferences
  Future<void> _loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final password = prefs.getString('password');

    if (username != null && password != null) {
      // If credentials are saved, autofill the login form
      _loginNameController.text = username;
      _passwordController.text = password;
      setState(() {
        _rememberMe = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Нэвтрэх цонх',
          style: TextStyle(
              color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.blue[50],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                elevation: 12.0,
                shadowColor: Colors.blue.shade900,
                color: const Color(0xFFFFFFFF),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _loginNameController,
                        decoration: const InputDecoration(
                          labelText: 'Нэвтрэх нэр : ',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your login name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText:
                            !_isPasswordVisible, // Toggle password visibility
                        decoration: InputDecoration(
                          labelText: 'Нууц код : ',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Нууц үгээ оруулна уу!';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: <Widget>[
                  Checkbox(
                    checkColor: Colors.white,
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value!;
                      });
                    },
                  ),
                  const Text(
                    'Намайг санах',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      child: const Text(
                        'Нэвтрэх',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/admission_courses');
                },
                child: const Text(
                  'Хөтөлбөрт бүртгүүлэх',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
