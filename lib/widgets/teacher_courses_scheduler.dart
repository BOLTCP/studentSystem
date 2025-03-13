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

  final int rows = 5;
  final int columns = 5;

  // This stores the list of draggable items (simple text here for demo purposes)
  List<String> draggableItems = [
    'Circle',
    'Square',
    'Triangle',
    'Rectangle',
    'Star'
  ];

  // Define the positions of the items (initially not placed in any cell)
  List<int?> itemPositions = [null, null, null, null, null];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Scheduler with Draggable Items'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Draggable objects section
            Container(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: draggableItems.length,
                itemBuilder: (context, index) {
                  return Draggable<String>(
                    data: draggableItems[index],
                    child: _buildDraggableWidget(draggableItems[index]),
                    feedback: Material(
                      color: Colors.transparent,
                      child: _buildDraggableWidget(draggableItems[index]),
                    ),
                    childWhenDragging: Container(),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            // Grid of cells for dropping items
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: rows * columns,
                itemBuilder: (context, index) {
                  return DragTarget<String>(
                    onAccept: (receivedItem) {
                      setState(() {
                        // Find the index of the received item and update its position
                        int itemIndex = draggableItems.indexOf(receivedItem);
                        itemPositions[itemIndex] =
                            index; // Snap item into the cell
                      });
                    },
                    builder: (context, candidateData, rejectedData) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black38,
                            width: 1,
                          ),
                          color: itemPositions.contains(index)
                              ? Colors.lightGreen
                              : Colors.white,
                        ),
                        child: Center(
                          child: itemPositions.indexOf(index) != -1
                              ? Text(
                                  draggableItems[itemPositions.indexOf(index)!])
                              : null,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create draggable widgets
  Widget _buildDraggableWidget(String label) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
