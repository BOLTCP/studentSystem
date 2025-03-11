import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:studentsystem/api/get_api_url.dart';
import 'package:studentsystem/models/courses.dart';
import 'package:logger/logger.dart';
import 'package:studentsystem/models/user_details.dart';
import 'package:studentsystem/widgets/student_dashboard.dart';

var logger = Logger();

class CoursesScreen extends StatefulWidget {
  final UserDetails userDetails;

  const CoursesScreen({super.key, required this.userDetails});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  late Future<Courses> courseDetails;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    courseDetails = fetchCourseDetails();
    fetchCourseDetails();
  }

  Future<Courses> fetchCourseDetails() async {
    try {
      final response = await http.post(
        getApiUrl('/Get/Student/Major/Courses/'),
        body: json.encode({'major_id': widget.userDetails.major?.majorId}),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 30));
      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);

        List<dynamic> coursesList = decodedJson['majors_courses'];
        Courses courses = Courses.fromJson(coursesList);
        logger.d(courses);

        return courses;
      } else {
        throw Exception('Хичээлүүд байхгүй байна');
      }
    } catch (e) {
      logger.d('Error: $e');
      throw Exception('An error occurred. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Сургалтын төлөвлөгөө',
          textAlign: TextAlign.start,
          style: TextStyle(
              color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState
                ?.openDrawer(); // Open the drawer using the key
          },
        ),
      ),
      backgroundColor: Colors.blue[50],
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: FutureBuilder<Courses>(
          future: courseDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.courses.isEmpty) {
              return Center(child: Text('No courses available.'));
            } else {
              final courses = snapshot.data!.courses;

              return Center(
                child: SizedBox(
                  width: 550,
                  child: Center(
                    child: ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        final course = courses[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 4.0,
                          child: ListTile(
                            title: Text(
                                '${course.courseName} ${course.courseYear}'),
                            subtitle: Text(
                                '${course.courseCode} - ${course.courseType}'),
                            trailing: Text('${course.totalCredits} credits'),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: ListTile(
                title: Text(
                  'Суралцагчийн хөтөлбөр:',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                subtitle: Text(
                  widget.userDetails.major!.majorName,
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            ListTile(
              title: Text('Сургалтын суурь төлөвлөгөө'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/courses_default',
                  arguments: widget.userDetails,
                );
              },
            ),
            ListTile(
              title: Text('Хянах самбар луу буцах'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentDashboard(
                        userId: widget.userDetails.user.userId),
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
        ],
      ),
    );
  }
}
