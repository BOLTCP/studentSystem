import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:studentsystem/widgets/student_signup.dart';
import 'admission_courses.dart';
import 'courses.dart';
import 'login_screen.dart';
import 'package:studentsystem/models/major.dart';
import 'package:studentsystem/widgets/personal_info.dart';
import 'package:studentsystem/models/exam_json.dart';
import 'package:studentsystem/widgets/pdf_viewer_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Navigation Example',
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
        '/admission_courses': (context) => AdmissionCourses(),
        '/pdf_viewer_screen': (context) => PdfViewerScreen(
              isAsset: true,
              canProceed: false,
            ),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/courses') {
          final int majorId =
              settings.arguments as int; // Retrieve the argument
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
        if (settings.name == '/personal_info') {
          final arguments = settings.arguments as Map<String, dynamic>?;

          if (arguments != null) {
            final Student student = arguments['student'] as Student;
            final Major major = arguments['major'] as Major;

            return MaterialPageRoute(
              builder: (context) => PersonalInfo(
                student: student,
                major: major,
              ),
            );
          } else {
            // If arguments are null, handle the error case
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(title: Text('Error')),
                body: Center(child: Text('No arguments received')),
              ),
            );
          }
        }

        return null; // Undefined route fallback
      },
    );
  }
}
