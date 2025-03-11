import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:studentsystem/models/auth_user.dart';
import 'package:studentsystem/login_screen.dart';
import 'package:studentsystem/api/get_api_url.dart'; // Import the login screen
import 'package:logger/logger.dart';
import 'package:studentsystem/models/department.dart';
import 'package:studentsystem/models/student_user.dart';
import 'package:studentsystem/models/major.dart';
import 'package:studentsystem/models/teacher.dart';
import 'package:studentsystem/models/user_details.dart';
import 'package:studentsystem/widgets/courses_screen.dart';
import 'package:studentsystem/widgets/user_profile.dart';

var logger = Logger();

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({required this.userId, Key? key}) : super(key: key);

  final int userId;

  @override
  _TeacherDashboardState createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  late Future<UserDetails> userDetails;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Widget> _screens = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    userDetails = fetchUserDetails();
    _screens = [
      _buildSettingsScreen(),
      _buildNotificationsScreen(),
      _buildLogoutScreen(),
    ];
  }

  Future<UserDetails> fetchUserDetails() async {
    try {
      final response = await http.post(
        getApiUrl('/User/Login/Teacher'),
        body: json.encode({'user_id': widget.userId}),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 30));

      logger.d('Response status: ${response.statusCode}');
      logger.d('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);
        AuthUser user = AuthUser.fromJsonAuthUser(decodedJson['user']);
        TeacherUser teacher =
            TeacherUser.fromJsonTeacher(decodedJson['teacher']);
        Department department =
            Department.fromJsonDepartment(decodedJson['department']);

        logger.d('User fetched: $user');
        logger.d('Teacher fetched: $teacher');
        logger.d('Department fetched: $department');

        return UserDetails(
            user: user,
            teacher: teacher,
            student: null,
            department: department);
      } else {
        logger.d('Error: ${response.statusCode}');
        throw Exception('User does not exist!');
      }
    } catch (e) {
      logger.d('Error: $e');
      throw Exception('An error occurred. Please try again.');
    }
  }

  /**
   
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 3) {
        _logout();
      }
    });
  }

  // Logout function
  void _logout() {
    setState(() {
      // Reset user details or clear state, if necessary
      userDetails = Future.value(UserDetails(
          user: null,
          student: null,
          major: null)); // Resetting userDetails to a null state

      // Clear any persistent data (SharedPreferences, tokens, etc.)
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.clear();

      // Navigate to the login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LoginScreen()), // Navigate to login screen
      );
    });
  }

   */

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
      key: _scaffoldKey,
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
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      backgroundColor: Colors.blue[50],
      drawer: _buildDrawer(context, userDetails),
      body: _buildBody(userDetails),
    );
  }
}

Widget _buildBody(userDetails) {
  return Placeholder();
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
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ProfileScreen(userDetails: userDetails)),
            );
          },
        ),
        /*
        ListTile(
          title: Text('Хөтөлбөрийн хичээлүүд'),
          onTap: () {
            userDetails.then((details) {
              Navigator.pushNamed(
                context,
                '/courses_screen',
                arguments: details,
              );
            });
          },
        ),*/
        ListTile(
          title: Text('Багшийн заах хичээлүүд'),
          onTap: () {
            userDetails.then((details) {
              Navigator.pushNamed(
                context,
                '/teachers_courses',
                arguments: details,
              );
            });
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
