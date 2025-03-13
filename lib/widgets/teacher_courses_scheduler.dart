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
  List<String> weekdays = [];
  late String currentDayOfWeek = '';
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
    _generateWeekdays();
  }

  void _generateWeekdays() {
    DateTime now = DateTime.now();
    int currentDay = now.weekday;

    List<String> allWeekdays = ['Да', 'Мя', 'Лха', 'Пү', 'Ба', 'Бя', 'Ням'];
    currentDayOfWeek = allWeekdays[currentDay];
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

  final List<String> _periods = [
    '1-р цаг',
    '2-р цаг',
    '3-р цаг',
    '4-р цаг',
    '5-р цаг',
    '6-р цаг',
    '7-р цаг',
    '8-р цаг',
    '9-р цаг',
    '10-р цаг'
  ];
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
      scrollDirection: Axis.vertical,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Table(
                border: TableBorder.all(),
                children: [
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Өдөр',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      ..._days.map((day) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(day,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        );
                      }),
                    ],
                  ),
                  for (var period in _periods)
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(period, textAlign: TextAlign.center),
                        ),
                        ..._days.map((day) {
                          return DragTarget<String>(
                            builder: (context, candidateData, rejectedData) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  color: day == currentDayOfWeek
                                      ? Colors.blueAccent
                                      : Colors.transparent,
                                  /*
                                  
                                  child: Center(
                                    child: Text(
                                      _periods[event] == day ? event : '',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),

                                   */
                                ),
                              );
                            },
                            onAcceptWithDetails: (receivedEvent) {
                              setState(() {
                                _periods[int.parse(receivedEvent.data)] = day;
                              });
                            },
                          );
                        }).toList(),
                      ],
                    ),
                ],
              ),
              SizedBox(height: 20),
              Column(
                children: _days.map((event) {
                  return Draggable<String>(
                    data: event,
                    feedback: Material(
                      color: Colors.transparent,
                      child: Text(event,
                          style: TextStyle(
                              fontSize: 18,
                              color: const Color.fromARGB(255, 222, 81, 81))),
                    ),
                    childWhenDragging: Container(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        color: Colors.blue,
                        child:
                            Text(event, style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
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
