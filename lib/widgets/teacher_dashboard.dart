import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:studentsystem/models/auth_user.dart';
import 'package:studentsystem/api/get_api_url.dart'; // Import the login screen
import 'package:logger/logger.dart';
import 'package:studentsystem/models/department.dart';
import 'package:studentsystem/models/teacher.dart';
import 'package:studentsystem/models/teacherscourseplanning.dart';
import 'package:studentsystem/models/user_details.dart';
import 'package:studentsystem/models/departments_of_education.dart';
import 'package:studentsystem/constants/teacher_drawer.dart';
import 'package:studentsystem/models/teachersmajorplanning.dart';
import 'package:studentsystem/models/teacherscourseplanning.dart';

var logger = Logger();

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({required this.userId, Key? key}) : super(key: key);
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();
  static final GlobalKey<_TeacherDashboardState> dashboardKey =
      GlobalKey<_TeacherDashboardState>(); // For refreshing data

  final int userId;

  @override
  _TeacherDashboardState createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  late Future<UserDetails> userDetails;
  late String departmentName = '';

  List<Widget> _screens = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    userDetails = fetchUserDetails(widget.userId);
    _screens = [
      _buildSettingsScreen(),
      _buildNotificationsScreen(),
      _buildLogoutScreen(),
    ];
  }

  void refreshUserDetails() {
    setState(() {
      userDetails = fetchUserDetails(widget.userId);
    });
  }

  Future<UserDetails> fetchUserDetails(int userId) async {
    try {
      final response = await http.post(
        getApiUrl('/User/Login/Teacher'),
        body: json.encode({
          'user_id': widget.userId,
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
                decodedJson['dept_of_edu']);
        Department department =
            Department.fromJsonDepartment(decodedJson['dep']);
        departmentName = departmentOdEducation.edDepartmentName;
        List<TeachersMajorPlanning> teachersmajorplanning =
            (decodedJson['teachers_major'] as List)
                .map((teachersmajorplanning) =>
                    TeachersMajorPlanning.fromJsonTeachersMajorPlanning(
                        teachersmajorplanning))
                .toList();
        List<TeachersCoursePlanning> teacherscourseplanning =
            (decodedJson['selected_major_courses'] as List)
                .map((teacherscourseplanning) =>
                    TeachersCoursePlanning.fromJsonTeachersCoursePlanning(
                        teacherscourseplanning))
                .toList();
        return UserDetails(
          user: user,
          teacher: teacher,
          student: null,
          department: department,
          departmentOfEducation: departmentOdEducation,
          teachersMajorPlanning: teachersmajorplanning,
          teachersCoursePlanning: teacherscourseplanning,
        );
      } else {
        logger.d('Error: ${response.statusCode}');
        throw Exception('User does not exist!');
      }
    } catch (e) {
      logger.d('Error: $e');
      throw Exception('An error occurred. Please try again.');
    }
  }

  Widget _buildProfileCard(String label, String value) {
    return Card(
      elevation: 5.0,
      margin: EdgeInsets.all(12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: Text(label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(value, style: TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buildSettingsScreen() {
    return Center(child: Text('Settings Screen'));
  }

  Widget _buildNotificationsScreen() {
    return Center(child: Text('Notifications Screen'));
  }

  Widget _buildLogoutScreen() {
    return Center(child: Text('Logging out...'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: TeacherDashboard.scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Багшийн Хянах Самбар',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            TeacherDashboard.scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      backgroundColor: Colors.blue[50],
      drawer: buildDrawer(context, userDetails),
      body: _buildBody(userDetails),
    );
  }
}

Widget _buildBody(userDetails) {
  return Placeholder();
}
