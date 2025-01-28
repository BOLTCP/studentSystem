import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onemissystem/api/get_api_url.dart';
import 'package:logger/logger.dart';
import 'package:onemissystem/models/exam_json.dart';
import 'package:onemissystem/models/major.dart';

var logger = Logger();

class StudentSignup extends StatefulWidget {
  final List<Major> major;

  const StudentSignup({required this.major, Key? key}) : super(key: key);

  @override
  _StudentSignupState createState() => _StudentSignupState();
}

class _StudentSignupState extends State<StudentSignup> {
  String confirmPassword = '';
  String email = '';
  late Future<Student> student;
  String password = '';
  bool areExamsValid = false;

  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = true;

  @override
  void initState() {
    super.initState();
    student = fetchExam(email, password);
  }

  Future<Student> fetchExam(String email, String password) async {
    try {
      final response = await http.post(
        getApiUrl('/Student/Signup/Validating'),
        body: json.encode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        // Parse response if successful
        final Map<String, dynamic> responseJson = jsonDecode(response.body);
        final Map<String, dynamic> examJson = responseJson['exam_json'];
        final student = Student.fromJson(examJson);
        logger.d(student.toString());
        return student;
      } else {
        logger.d('Error: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Сурагч шалгалт өгөөгүй байна!')),
        );
        return student;
      }
    } catch (e) {
      logger.d('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Алдаа гарлаа, түр хүлээгээд дахин оролдоно уу.')),
      );
      return student;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50], // Blue background for the screen
      appBar: AppBar(
        title: Text('Элсэлтийн бүртгэл'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'EEC.mn бүртгэлийн и-мэйл нууц болон үгээ оруулна уу',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    // Email field
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'И-мэйл',
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Зөвхөн И-мэйл оруулна уу!';
                        }
                        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return 'Буруу И-мэйл оруулсан байна.';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    // Password field
                    TextFormField(
                      obscureText: _isPasswordVisible,
                      decoration: InputDecoration(
                          labelText: 'Нууц үг',
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(_isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible =
                                    !_isPasswordVisible; // Toggle visibility
                              });
                            },
                          )),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Нууц үгээ дахин оруулна уу.';
                        }
                        if (value.length < 10) {
                          return '10н оронтой байх ёстой.';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    // Re-enter Password field
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Нууц үгээ дахин оруулна уу.',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Нууц үгээ дахин оруулна уу.';
                        }
                        if (value != password) {
                          return 'Нууц үг таарахгүй байна.';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          confirmPassword = value;
                        });
                      },
                    ),
                    SizedBox(height: 30),
                    // Submit Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Button color
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          // If form is valid, proceed
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Түр хүлээнэ үү!')),
                          );
                        }
                        final result = await fetchExam(email, password);

                        if (result != null && result is Student) {
                          if (widget.major[0].exam1 <= result.exams[0].score &&
                              widget.major[0].exam2 <= result.exams[1].score) {
                            Navigator.pushNamed(context, '/personal_info',
                                arguments: {
                                  'student': result,
                                  'major': widget.major
                                } // Pass the 'majors' list to the next screen
                                );
                          } else {
                            print('no');
                          }
                        }
                      },
                      child: Text('Бүртгүүлэх', style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
