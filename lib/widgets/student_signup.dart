import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:studentsystem/api/get_api_url.dart';
import 'package:logger/logger.dart';
import 'package:studentsystem/models/user.dart';
import 'package:studentsystem/models/major.dart';

var logger = Logger();

class StudentSignup extends StatefulWidget {
  final Major major;

  const StudentSignup({required this.major, Key? key}) : super(key: key);

  @override
  _StudentSignupState createState() => _StudentSignupState();
}

class _StudentSignupState extends State<StudentSignup> {
  String confirmPassword = '';
  String email = '';
  late Future<User> user;
  String password = '';
  bool areExamsValid = false;
  DateTime currectDateTime = DateTime.now();

  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = true;

  @override
  void initState() {
    super.initState();
    user = fetchExam(email, password);
  }

  Future<User> fetchExam(String email, String password) async {
    try {
      final response = await http.post(
        getApiUrl('/User/Signup/Validating'),
        body: json.encode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson = jsonDecode(response.body);
        logger.d(responseJson, 'responseJson');
        final Map<String, dynamic> examJson = responseJson['exam_json'];
        logger.d(examJson, 'examJson');
        final user = User.fromJson(examJson);
        logger.d(user.toString());
        return user;
      } else {
        logger.d('Error: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Сурагч шалгалт өгөөгүй байна!')),
        );
        return user;
      }
    } catch (e) {
      logger.d('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Алдаа гарлаа, түр хүлээгээд дахин оролдоно уу.')),
      );
      return user;
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
        child: SizedBox(
          width: 550,
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
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

                          if (currectDateTime.isBefore(result.validUntil)) {
                            if (widget.major.exam1 <= result.exams![0].score &&
                                widget.major.exam2 <= result.exams![1].score) {
                              Navigator.pushNamed(
                                context,
                                '/personal_info',
                                arguments: {
                                  'user': result,
                                  'major': widget.major,
                                  'userRoleSpecification': 'Оюутан'
                                },
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Уучлаарай, Таны ${result.examCode} дугаартай ЭЕШ - н хүчинтэй хугацаа дууссан байна. '
                                    'Шалгалт өгсөн огноо: ${result.createdAt}, Хүчинтэй хугацаа дуусах огноо: ${result.validUntil} байна!'),
                                duration: Duration(seconds: 10),
                              ),
                            );
                          }
                        },
                        child:
                            Text('Бүртгүүлэх', style: TextStyle(fontSize: 18)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
