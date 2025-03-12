import 'package:studentsystem/widgets/teacher_dashboard.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:studentsystem/models/auth_user.dart';
import 'package:studentsystem/login_screen.dart';
import 'package:studentsystem/api/get_api_url.dart'; // Import the login screen
import 'package:logger/logger.dart';
import 'package:studentsystem/models/department.dart';
import 'package:studentsystem/models/teacher.dart';
import 'package:studentsystem/models/user_details.dart';
import 'package:studentsystem/models/departments_of_education.dart';
import 'package:studentsystem/widgets/user_profile.dart';
import 'package:studentsystem/widgets/bottom_navigation.dart';

var logger = Logger();

class TeacherCoursesScheduler extends StatefulWidget {
  const TeacherCoursesScheduler({required this.userDetails, super.key});

  final UserDetails userDetails;

  @override
  _TeacherCoursesSchedulerState createState() =>
      _TeacherCoursesSchedulerState();
}

class _TeacherCoursesSchedulerState extends State<TeacherCoursesScheduler> {
  //late Future<UserDetails> userDetails;
  late String departmentName = '';
  late final Future<UserDetails> futureUserDetails;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Widget> _screens = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    _screens = [
      TeacherDashboard(userId: widget.userDetails.user.userId),
    ];
    futureUserDetails = Future.value(widget.userDetails);
  }

  void onItemTappedTeacherDashboard(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 0) {
      Navigator.pushNamed(
        context,
        '/teacher_dashboard',
        arguments: widget.userDetails,
      );
    }
  }

  Future<UserDetails> fetchUserDetails() async {
    try {
      final response = await http.post(
        getApiUrl('Get/allMajor/Of/Course/Teacher'),
        body: json.encode({
          'user_id':
              widget.userDetails.departmentOfEducation!.departmentsOfEducationId
        }),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 30));

      logger.d('Response status: ${response.statusCode}');
      logger.d('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);
        AuthUser user = AuthUser.fromJsonAuthUser(decodedJson['user']);
        TeacherUser teacher =
            TeacherUser.fromJsonTeacher(decodedJson['teacher']);
        DepartmentOfEducation departmentOdEducation =
            DepartmentOfEducation.fromJsonDepartmentOfEducation(
                decodedJson['department_of_edu_query']);
        departmentName = departmentOdEducation.edDepartmentName;

        logger.d('User fetched: $user');
        logger.d('Teacher fetched: $teacher');
        logger.d('Department fetched: $departmentOdEducation');

        return UserDetails(
            user: user,
            teacher: teacher,
            student: null,
            department: null,
            departmentOfEducation: departmentOdEducation);
      } else {
        logger.d('Error: ${response.statusCode}');
        throw Exception('User does not exist!');
      }
    } catch (e) {
      logger.d('Error: $e');
      throw Exception('An error occurred. Please try again.');
    }
  }

  final List<String> _events = ['Meeting', 'Lunch', 'Workout'];
  final List<String> _days = ['Да', 'Мя', 'Лха', 'Пү', 'Ба', 'Бя', 'Ням'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Багшийн Хичээлүүд',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.blue[50],
      drawer: _buildDrawer(context, widget.userDetails),
      body: _buildSingleChildScrollView(),
      bottomNavigationBar:
          buildBottomNavigation(_selectedIndex, onItemTappedTeacherDashboard),
    );
  }

  Widget _buildSingleChildScrollView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
        child: Center(
          child: SizedBox(
            width: 550,
            child: Column(
              children: [
                // Week view with draggable events
                Expanded(
                  child: Row(
                    children: List.generate(7, (index) {
                      return Expanded(
                        child: DragTarget<String>(
                          builder: (context, candidateData, rejectedData) {
                            return Container(
                              margin: EdgeInsets.all(4),
                              padding: EdgeInsets.all(8),
                              color: Colors.blue[100],
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    _days[index],
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ),
                ),
                // Bottom section with draggable events
                Container(
                  height: 60,
                  color: Colors.blue[100],
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: _events.map((event) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Draggable<String>(
                          data: event,
                          feedback: Material(
                            color: Colors.transparent,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              color: Colors.orange,
                              child: Text(event),
                            ),
                          ),
                          childWhenDragging: Container(),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            color: Colors.orange,
                            child: Text(event),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(context, userDetails) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Profile',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            title: Text('Багшийн бүртгэл'),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/user_profile',
                arguments: futureUserDetails,
              );
            },
          ),
          ListTile(
            title: Text('Багшийн хянах самбар'),
            subtitle: Text(
              widget.userDetails.departmentOfEducation!.edDepartmentName,
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/teacher_dashboard',
                arguments: widget.userDetails,
              );
            },
          ),
          ListTile(
            title: Text('Календарь'),
            onTap: () {
              userDetails.then((details) {
                Navigator.pushNamed(
                  context,
                  '/courses_screen',
                  arguments: details,
                );
              });
            },
          ),
          ListTile(
            title: Text('Клубууд'),
            onTap: () {
              userDetails.then((details) {
                Navigator.pushNamed(
                  context,
                  '/courses_screen',
                  arguments: details,
                );
              });
            },
          ),
          ListTile(
            title: Text('Сонордуулага'),
            onTap: () {
              userDetails.then((details) {
                Navigator.pushNamed(
                  context,
                  '/courses_screen',
                  arguments: details,
                );
              });
            },
          ),
          ListTile(
            title: Text('Мессежүүд'),
            onTap: () {
              userDetails.then((details) {
                Navigator.pushNamed(
                  context,
                  '/courses_screen',
                  arguments: details,
                );
              });
            },
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () {
              // Navigate to Settings
            },
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(), // Passing AuthUser here
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
