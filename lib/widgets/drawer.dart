import 'package:flutter/material.dart';
import 'package:studentsystem/login_screen.dart';
import 'package:studentsystem/widgets/teacher_dashboard.dart';
import 'package:studentsystem/widgets/user_profile.dart';
import 'package:studentsystem/models/user_details.dart';

Widget buildDrawer(
    BuildContext context, Future<UserDetails> futureUserDetails) {
  return Drawer(
    child: FutureBuilder<UserDetails>(
      future: futureUserDetails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          UserDetails userDetails = snapshot.data!;
          return _buildDrawerList(context, userDetails, futureUserDetails);
        } else {
          return Center(child: Text('No data available'));
        }
      },
    ),
  );
}

Widget _buildDrawerList(
    BuildContext context, UserDetails userDetails, futureUserDetails) {
  return ListView(
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
                  ProfileScreen(userDetails: futureUserDetails),
            ),
          );
        },
      ),
      ListTile(
        title: Text('Багшийн самбар луу буцах'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  TeacherDashboard(userId: userDetails.user.userId),
            ),
          );
        },
      ),
      ListTile(
        title: Text('Хичээлийн хуваарь сонгох'),
        subtitle: Text(userDetails.departmentOfEducation!.edDepartmentName),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/teacher_courses_scheduler',
            arguments: userDetails,
          );
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
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        },
      ),
    ],
  );
}
