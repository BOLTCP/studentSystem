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
import 'package:studentsystem/models/user_details.dart';
import 'package:studentsystem/widgets/courses_screen.dart';

var logger = Logger();

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({required this.userId, Key? key}) : super(key: key);

  final int userId;

  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  late Future<UserDetails> userDetails;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Widget> _screens = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    userDetails =
        fetchUserDetails(); // This will now fetch the data when the screen loads
    _screens = [
      _buildSettingsScreen(),
      _buildNotificationsScreen(),
      _buildLogoutScreen(),
    ];
  }

  Future<UserDetails> fetchUserDetails() async {
    try {
      final response = await http.post(
        getApiUrl('/User/Login'),
        body: json.encode({'user_id': widget.userId}),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 30));

      logger.d('Response status: ${response.statusCode}');
      logger.d('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);
        AuthUser user = AuthUser.fromJsonAuthUser(decodedJson['user']);
        StudentUser student =
            StudentUser.fromJsonStudentUser(decodedJson['student']);
        Major major = Major.fromJsonMajor(decodedJson['major']);
        major = major;
        Department department =
            Department.fromJsonDepartment(decodedJson['department']);

        logger.d('User fetchedr: $user');
        logger.d('Student fetched: $student');
        logger.d('Major fetched: $major');
        logger.d('Department fetched: $department');

        return UserDetails(
            user: user, student: student, major: major, department: department);
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

  List<Widget> _buildUserDetails(
      AuthUser user, StudentUser student, Major major, Department department) {
    return [
      _buildProfileCard('Нэр', '${user.fname} ${user.lname}'),
      _buildProfileCard('Хэрэглэгч нь: ', user.userRole),
      _buildProfileCard('Хэрэглэгч / Оюутны нэр: ', student.studentCode),
      _buildProfileCard('Хэрэглэгчийн И-мэйл', user.email),
      _buildProfileCard('Түвшин', student.yearClassification),
      _buildProfileCard('Салбар сургууль', department.departmentName),
      _buildProfileCard('Хөтөлбөр', major.majorName),
      _buildProfileCard('Хүйс', user.gender),
      _buildProfileCard('Регистрийн дугаар', user.registryNumber),
      _buildProfileCard(
          'Төрсөн өдөр', DateFormat('yyyy-MM-dd').format(user.birthday)),
      _buildProfileCard('Утасны дугаар', user.phoneNumber),
      _buildProfileCard('Суралцаж буй эрдмийн зэрэг', major.academicDegree),
      _buildProfileCard('Оюутны И-мэйл', student.studentEmail),
      _buildProfileCard('Оюутны төлөв', student.isActive.toString()),
      _buildProfileCard('Өмнөх боловсрол', user.education),
      _buildProfileCard('Created At', user.createdAt.toLocal().toString()),
    ];
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
      key: _scaffoldKey,
      appBar: AppBar(
        title: Center(
          child: Text(
            'Сурагчийн Хянах Самбар',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          ),
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
      body: FutureBuilder<UserDetails>(
        future: userDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data found.'));
          } else {
            final userDetails = snapshot.data!;

            return SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  width: 550,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: _buildUserDetails(
                      userDetails.user,
                      userDetails.student,
                      userDetails.major,
                      userDetails.department,
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Profile',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                        user: userDetails.then(
                            (value) => value.user)), // Passing AuthUser here
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Хөтөлбөрийн төлөвлөгөө'),
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
                // Add settings page navigation if required
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        LoginScreen(), // Passing AuthUser here
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
            backgroundColor: Colors.blue,
          ),
          /**
           BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app),
            label: 'Logout',
            backgroundColor: Colors.blue,
          ),
           */
        ],
        currentIndex: _selectedIndex,
        //onTap: _onItemTapped,
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.user});

  final Future<AuthUser> user;

  Widget _buildProfileCard(String label, String value) {
    return Card(
      elevation: 5.0,
      margin: EdgeInsets.all(8.0),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile Details")),
      body: FutureBuilder<AuthUser>(
        future: user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data found.'));
          } else {
            final user = snapshot.data!;
            return ListView(
              children: [
                _buildProfileCard('Name', '${user.fname} ${user.lname}'),
                _buildProfileCard('Email', user.email),
                _buildProfileCard('Gender', user.gender),
                _buildProfileCard(
                    'Birthday', DateFormat('yyyy-MM-dd').format(user.birthday)),
              ],
            );
          }
        },
      ),
    );
  }
}
