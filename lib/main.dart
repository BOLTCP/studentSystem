import 'package:flutter/material.dart';
import 'package:studentsystem/widgets/student_signup.dart';
import 'package:studentsystem/widgets/teacher_dashboard.dart';
import 'package:studentsystem/widgets/teachers_majors.dart';
import 'package:studentsystem/widgets/user_profile.dart';
import 'admission_courses.dart';
import 'courses.dart';
import 'login_screen.dart';
import 'package:studentsystem/models/major.dart';
import 'package:studentsystem/widgets/personal_info.dart';
import 'package:studentsystem/models/user.dart';
import 'package:studentsystem/widgets/courses_screen.dart';
import 'package:studentsystem/widgets/courses_default.dart';
import 'package:studentsystem/models/user_details.dart';
import 'package:studentsystem/widgets/contact_us.dart';
import 'package:studentsystem/widgets/user_signup.dart';
import 'package:studentsystem/widgets/teachers_courses.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Оюутан Систем',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
      ),
      home: LoginScreen(),
      routes: {
        '/login_screen': (context) => LoginScreen(),
        '/contact_us': (context) => ContactUsScreen(),
        '/admission_courses': (context) => AdmissionCourses(),
        '/user_signup': (context) => UserSignUp(
              userRoleSpecification: 'Багш',
            ),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/courses') {
          final int majorId = settings.arguments as int;
          return MaterialPageRoute(
            builder: (context) => CoursesIntroduction(majorId: majorId),
          );
        }
        if (settings.name == '/student_signup') {
          final Major major = settings.arguments as Major;

          return MaterialPageRoute(
            builder: (context) => StudentSignup(major: major),
          );
        }
        if (settings.name == '/user_profile') {
          final Future<UserDetails> userDetails =
              settings.arguments as Future<UserDetails>;
          return MaterialPageRoute(
            builder: (context) => ProfileScreen(userDetails: userDetails),
          );
        }
        if (settings.name == '/courses_screen') {
          final UserDetails userDetails = settings.arguments as UserDetails;
          return MaterialPageRoute(
            builder: (context) => CoursesScreen(userDetails: userDetails),
          );
        }
        if (settings.name == '/teacher_dashboard') {
          final UserDetails userDetails = settings.arguments as UserDetails;
          return MaterialPageRoute(
            builder: (context) =>
                TeacherDashboard(userId: userDetails.user.userId),
          );
        }
        if (settings.name == '/teacher_courses') {
          final UserDetails userDetails = settings.arguments as UserDetails;
          return MaterialPageRoute(
            builder: (context) => TeachersCourses(userDetails: userDetails),
          );
        }
        if (settings.name == '/teachers_majors') {
          final UserDetails userDetails = settings.arguments as UserDetails;
          return MaterialPageRoute(
            builder: (context) => TeachersMajors(userDetails: userDetails),
          );
        }
        if (settings.name == '/courses_default') {
          final UserDetails userDetails = settings.arguments as UserDetails;
          return MaterialPageRoute(
            builder: (context) => CoursesDefault(userDetails: userDetails),
          );
        }
        if (settings.name == '/personal_info') {
          final arguments = settings.arguments as Map<String, dynamic>?;

          if (arguments != null) {
            User user = arguments['user'] as User;
            Major? major = arguments['major'] as Major?;
            final String userRoleSpecification =
                arguments['userRoleSpecification'];

            return MaterialPageRoute(
              builder: (context) => PersonalInfo(
                user: user,
                major: major,
                userRoleSpecification: userRoleSpecification,
              ),
            );
          } else {
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(title: Text('Error')),
                body: Center(child: Text('No arguments received')),
              ),
            );
          }
        }

        return null;
      },
    );
  }
}
