import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api/get_api_url.dart';
import 'package:studentsystem/widgets/student_dashboard.dart';
import 'package:studentsystem/widgets/teacher_dashboard.dart';
import 'package:studentsystem/models/auth_user.dart';
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
  bool _isPasswordVisible = false;
  final _loginNameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  // Login function
  Future<String> _login() async {
    if (_formKey.currentState!.validate()) {
      final loginName = _loginNameController.text.trim();
      final passwordHash = _passwordController.text.trim();

      final Map<String, String> data = {
        'login_name': loginName,
        'password_hash': passwordHash,
      };

      setState(() {
        _isLoading = true;
      });

      try {
        final response = await http.post(
          getApiUrl('/login'),
          body: json.encode(data),
          headers: {'Content-Type': 'application/json'},
        ).timeout(Duration(seconds: 30));

        if (response.statusCode == 200) {
          logger.d('Login successful!');
          final decodedJson = json.decode(response.body);
          logger.d(decodedJson);
          final user = AuthUser.fromJsonAuthUser(decodedJson['user']);

          if (_rememberMe) {
            _saveCredentials(loginName, passwordHash);
          }

          if (user.userRole == 'Оюутан') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => StudentDashboard(userId: user.userId),
              ),
            );
          } else if (user.userRole == 'Багш') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TeacherDashboard(userId: user.userId),
              ),
            );
          }
          return '';
        } else if (response.statusCode == 401) {
          final decodedJson = json.decode(response.body);
          logger.d(decodedJson);
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Буруу нэр эсвэл нууц үг байна')));

          return 'Буруу нэр эсвэл нууц үг байна';
        }
      } catch (e) {
        // Handle error (e.g., network issues)
        logger.d('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred. Please try again.')),
        );
        return '';
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
    return '';
  }

  Future<void> _saveCredentials(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
    prefs.setString('password', password);
  }

  Future<void> _loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final password = prefs.getString('password');

    if (username != null && password != null) {
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
        title: Center(
          child: const Text(
            'Нэвтрэх цонх',
            style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.blue[50],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Card(
                  elevation: 12.0,
                  shadowColor: Colors.blue.shade900,
                  color: const Color(0xFFFFFFFF),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 450,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Column(
                                  children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 20),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 150,
                                                child: TextFormField(
                                                  controller:
                                                      _loginNameController,
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: 'Нэвтрэх нэр : ',
                                                    labelStyle:
                                                        TextStyle(fontSize: 16),
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                  keyboardType:
                                                      TextInputType.text,
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter your login name';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        Padding(
                                          padding: EdgeInsets.only(left: 20),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 150,
                                                child: TextFormField(
                                                  controller:
                                                      _passwordController,
                                                  obscureText:
                                                      !_isPasswordVisible,
                                                  decoration: InputDecoration(
                                                    labelText: 'Нууц код : ',
                                                    labelStyle:
                                                        TextStyle(fontSize: 16),
                                                    border:
                                                        const OutlineInputBorder(),
                                                    suffixIcon: IconButton(
                                                      icon: Icon(
                                                        _isPasswordVisible
                                                            ? Icons
                                                                .visibility_off
                                                            : Icons.visibility,
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          _isPasswordVisible =
                                                              !_isPasswordVisible;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Нууц үгээ оруулна уу!';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 50, top: 10, bottom: 10),
                                          child: Row(
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 50),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/icons/StudentSystemLoginScreenLogo.png',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.0),
                                ),
                                SizedBox(height: 12.0),
                                _isLoading
                                    ? CircularProgressIndicator()
                                    : ElevatedButton.icon(
                                        icon: Icon(Icons.login),
                                        label: Text(
                                          'Нэвтрэх',
                                          style: TextStyle(fontSize: 20.0),
                                        ),
                                        onPressed: _login,
                                      ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.0),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.0),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/contact_us');
                                  },
                                  icon: Icon(Icons.phone),
                                  label: Text(
                                    'Холбогдох',
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.0),
                                ),
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/admission_courses');
                                  },
                                  icon: Image.asset(
                                      'assets/images/icons/student_signup.png',
                                      width: 20,
                                      height: 20,
                                      color: const Color.fromRGBO(
                                          83, 58, 147, 0.9)),
                                  label: Text(
                                    'Хөтөлбөрт бүртгүүлэх',
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
