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
  final TextEditingController userNameController =
      TextEditingController(text: '-----');
  final TextEditingController userSirNameController =
      TextEditingController(text: '-----');
  final TextEditingController registryNumberContoller = TextEditingController();
  final TextEditingController emailController =
      TextEditingController(text: '-----');
  final TextEditingController educationController =
      TextEditingController(text: '-----');
  final TextEditingController professionController =
      TextEditingController(text: '-----');
  final TextEditingController academicDegreeController =
      TextEditingController(text: '-----');

  late User userDetails;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  Future<User?> fetchCitizenInfo(String registryNumberContoller) async {
    try {
      final response = await http.post(
        getApiUrl('/User/Staff/Signup/Validating'),
        body: json.encode({'registryNumber': registryNumberContoller}),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson = jsonDecode(response.body);

        if (responseJson.containsKey('user_json')) {
          final Map<String, dynamic> userJson = responseJson['user_json'];
          final user = User.fromJson(userJson);
          userDetails = user;
          userNameController.text = user.userName;
          userSirNameController.text = user.userSirname;
          emailController.text = user.email;
          educationController.text = user.education!;
          professionController.text = user.profession!;
          academicDegreeController.text = user.academicDegree!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                user.profession != null
                    ? '${user.userSirname}, ${user.userName}, ${user.profession} - г амжилттай татлаа!'
                    : 'Регистрийн дугаар буруу эсвэл бүртгэл байхгүй байна!',
              ),
            ),
          );
          return user;
        } else {
          logger.d('Error: No "user_json" in the response');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Регистрийн дугаар буруу эсвэл бүртгэл байхгүй байна!')),
          );
          return null;
        }
      } else {
        logger.d('Error: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Регистрийн дугаар буруу эсвэл бүртгэл байхгүй байна!')),
        );
        return null;
      }
    } catch (e) {
      logger.d('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Алдаа гарлаа, түр хүлээгээд дахин оролдоно уу.')),
      );
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text(
          'Холбоо барих',
          style: TextStyle(
              color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
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
                        hintText: 'Мэдээллээ татна уу.',
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
                    // Submit Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(250, 50),
                        backgroundColor: Colors.blue,
                        padding:
                            EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Түр хүлээнэ үү!'),
                              duration: Duration(seconds: 2),
                            ),
                          );

                          try {
                            final result = await fetchCitizenInfo(
                                registryNumberContoller.text);

                            if (result != null) {
                              logger.d('User fetched successfully: $result');
                            } else {
                              logger.d('No user found');
                            }
                          } catch (e) {
                            logger.d('Error during API call: $e');
                          }
                        }
                      },
                      child: Text('Мэдээлэл авах',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                    Padding(padding: EdgeInsets.all(12.0)),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            readOnly: true,
                            controller: userNameController,
                            decoration: InputDecoration(
                              labelText: 'Нэр',
                              prefixIcon: Icon(Icons.person),
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 3.0)),
                        Expanded(
                          child: TextField(
                            readOnly: true,
                            controller: userSirNameController,
                            decoration: InputDecoration(
                              labelText: 'Овог',
                              prefixIcon: Image.asset(
                                  'assets/images/icons/userSirNameIcon.png',
                                  scale: 2,
                                  color: const Color.fromARGB(255, 56, 53, 62)),
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ],
                    ),

                    Padding(padding: EdgeInsets.all(12.0)),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            readOnly: true,
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'И-мэйл',
                              prefixIcon: Icon(Icons.mail),
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 3.0)),
                        Expanded(
                          child: TextField(
                            readOnly: true,
                            controller: educationController,
                            decoration: InputDecoration(
                              labelText: 'Боловсрол',
                              prefixIcon: Icon(Icons.school),
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ],
                    ),

                    Padding(padding: EdgeInsets.all(12.0)),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            readOnly: true,
                            controller: professionController,
                            decoration: InputDecoration(
                              labelText: 'Мэргэжил',
                              prefixIcon: Icon(Icons.work),
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 3.0)),
                        Expanded(
                          child: TextField(
                            readOnly: true,
                            controller: academicDegreeController,
                            decoration: InputDecoration(
                              labelText: 'Эрдмийн зэрэг',
                              prefixIcon: Icon(Icons.work),
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(320, 50),
                        backgroundColor: Colors.blue,
                        padding:
                            EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        logger.d(userDetails);
                        Navigator.pushNamed(
                          context,
                          '/personal_info',
                          arguments: {
                            'user': userDetails,
                            'major': null,
                            'userRoleSpecification':
                                widget.userRoleSpecification
                          },
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Хувийн мэдээлэл бөглөх',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.arrow_forward_ios,
                              color: Colors.white, size: 18),
                        ],
                      ),
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
