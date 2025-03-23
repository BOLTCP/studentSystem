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
          return _buildDrawer(
              context, futureUserDetails, userDetails.user.userId);
        } else {
          return Center(child: Text('No data available'));
        }
      },
    ),
  );
}

Widget _buildDrawer(context, userDetails, userId) {
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
          title: Text('Багшийн хянах самбар'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TeacherDashboard(userId: userId),
              ),
            );
          },
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
        FutureBuilder(
          future: userDetails,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListTile(
                title: Text('Loading...'),
              );
            } else if (snapshot.hasError) {
              return ListTile(
                title: Text('Error: ${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              var details = snapshot.data;
              return ListTile(
                title: Text('Хөтөлбөр сонгох'),
                subtitle: Text(details.departmentOfEducation!.edDepartmentName),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/teachers_courses',
                    arguments: details,
                  );
                },
              );
            } else {
              return ListTile(
                title: Text('No data available'),
              );
            }
          },
        ),
        FutureBuilder(
          future: userDetails,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListTile(
                title: Text('Loading...'),
              );
            } else if (snapshot.hasError) {
              return ListTile(
                title: Text('Error: ${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              var details = snapshot.data;
              return ListTile(
                title: Text('Хөтөлбөрийн хичээлийг сонгох'),
                subtitle: Text(
                  (details.teachersMajorPlanning ?? [])
                      .map((item) => item.majorName)
                      .join(', '),
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/teacher_courses_scheduler',
                    arguments: details,
                  );
                },
              );
            } else {
              return ListTile(
                title: Text('No data available'),
              );
            }
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
