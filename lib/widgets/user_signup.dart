import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:studentsystem/api/get_api_url.dart';
import 'package:logger/logger.dart';
import 'package:studentsystem/models/user.dart';
import 'package:studentsystem/models/major.dart';

var logger = Logger();

class UserSignUp extends StatefulWidget {
  final String userRoleSpecification;
  const UserSignUp({
    super.key,
    required this.userRoleSpecification,
  });

  @override
  _UserSignUpState createState() => _UserSignUpState();
}

class _UserSignUpState extends State<UserSignUp> {
  String confirmPassword = '';
  final TextEditingController registryNumberContoller = TextEditingController();
  late Future<User> user;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    user = fetchExam(registryNumberContoller.text);
  }

  Future<User> fetchExam(String registryNumberContoller) async {
    try {
      final response = await http.post(
        getApiUrl('/User/Staff/Signup/Validating'),
        body: json.encode({'registryNumber': registryNumberContoller}),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson = jsonDecode(response.body);
        logger.d(response.body);

        if (responseJson.containsKey('user_json')) {
          final Map<String, dynamic> userJson = responseJson['user_json'];
          user = User.fromJson(userJson) as Future<User>;
        } else {
          logger.d('Error: No "user_json" in the response');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Тамхи өгөгдлийг буруу авсан!')),
          );
        }

        logger.d(user.toString());
        return user;
      } else {
        logger.d('Error: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Сурагч шалгалт өгөөгүй байна!')),
        );
        return user; // Returning the default user object in case of error
      }
    } catch (e) {
      logger.d('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Алдаа гарлаа, түр хүлээгээд дахин оролдоно уу.'),
        ),
      );
      return user; // Return the default user object in case of error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50], // Blue background for the screen
      appBar: AppBar(
        title: Text('Ажилтны бүртгэл'),
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
                      'Иргэний бүртгэлийн газраас мэдээлэл татах',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    // Email field
                    TextFormField(
                      controller: registryNumberContoller,
                      decoration: InputDecoration(
                        labelText: 'Регистрийн дугаар',
                        prefixIcon: Icon(Icons.numbers),
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Зөвхөн регистрийн дугаар оруулна уу!';
                        }
                        if (!RegExp(r'^[А-Яа-я]{2}\d{8}$').hasMatch(value)) {
                          return 'Регистрийн дугаар буруу байна';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    // Password field
                    /*
                    
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

                     */
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
                        final result =
                            await fetchExam(registryNumberContoller.text);
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
