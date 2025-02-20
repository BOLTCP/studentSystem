import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:studentsystem/api/get_api_url.dart';
import 'package:studentsystem/models/major.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class CoursesIntroduction extends StatefulWidget {
  final int majorId;

  const CoursesIntroduction({required this.majorId, Key? key})
      : super(key: key);

  @override
  _CoursesIntroductionState createState() => _CoursesIntroductionState();
}

class _CoursesIntroductionState extends State<CoursesIntroduction> {
  late Future<Major> major;

  @override
  void initState() {
    super.initState();
    major = fetchMajor();
  }

  Future<Major> fetchMajor() async {
    try {
      logger.d('Fetching majors...');
      final response = await http.post(
        getApiUrl('/admission/Courses/Introduction'),
        body: json.encode({'major_id': widget.majorId}),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 30));

      logger.d('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);
        Major majors = Major.fromJson(decodedJson['major']);

        return majors;
      } else {
        logger.d('Error: ${response.statusCode}');
        throw Exception('Course type does not exist!');
      }
    } catch (e) {
      logger.d('Error: $e');
      throw Exception('An error occurred. Please try again.');
    }
  }

  Future<void> _onRefresh() async {
    setState(() {
      major = fetchMajor();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Хөтөлбөрийн Танилцуулга',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.blue[50],
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                child: FutureBuilder<Major>(
                  future: major,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final majors = snapshot.data!;

                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ..._buildCourseDetails(majors),
                            SizedBox(height: 20),
                            ElevatedButton(
                              style: majors.signUps == 'бүртгэл нээлттэй'
                                  ? ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 30),
                                      backgroundColor: Colors.blue,
                                      textStyle: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : null,
                              onPressed: majors.signUps == 'бүртгэл нээлттэй'
                                  ? () {
                                      Navigator.pushNamed(
                                        context,
                                        '/student_signup',
                                        arguments: majors,
                                      );
                                    }
                                  : null,
                              child: majors.signUps == 'бүртгэл нээлттэй'
                                  ? Text(
                                      'Хөтөлбөрт бүртгүүлэх',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black),
                                    )
                                  : Text(
                                      'Хөтөлбөрт хаагдсан',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black),
                                    ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
            backgroundColor: Colors.blueAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            backgroundColor: Colors.blueAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
            backgroundColor: Colors.blueAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app),
            label: 'Logout',
            backgroundColor: Colors.blueAccent,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCourseDetails(Major major) {
    return [
      _buildCourseDetailCard('Хөтөлбөрийн нэр:', major.majorName),
      _buildCourseDetailCard('Хичээлийн жил:', major.majorsYear),
      _buildCourseDetailCard('Хөтөлбөрийн төрөл:', major.majorsType),
      _buildCourseDetailCard(
          '1 ширхэг кредитийн төлбөр: \u20AE', major.creditUnitRate),
      _buildCourseDetailCard(
          'Нийт 1 жилийн төлбөр: \u20AE', major.majorTuition),
      _buildCourseDetailCard('Суралцах эрдмийн зэрэг:', major.academicDegree),
      _buildCourseDetailCard('Нийт суралцах жил:', major.totalYears),
      _buildCourseDetailCard(
          '1 жилд суралцах кредит цаг:', major.totalCreditsPerYear),
      _buildCourseDetailCard('ЭЕШ шалгалтын оноо (1):', major.exam1),
      _buildCourseDetailCard('ЭЕШ шалгалтын оноо (2):', major.exam2),
      _buildExpandableCard('Хөтөлбөрийн танилцуулга:',
          major.majorsDescription ?? 'Танилцуулга байхгүй'),
      _buildExpandableCard(
          'Хэрэгжиж эхэлсэн он:', major.descriptionBrief ?? 'Мэдээлэл байхгүй'),
    ];
  }

  Widget _buildCourseDetailCard(String label, var value) {
    String displayValue;

    if (value is DateTime) {
      displayValue = DateFormat('yyyy-MM-dd').format(value);
    } else {
      displayValue = value.toString();
    }

    return Card(
      elevation: 6.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Text(
              label,
              softWrap: true,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                displayValue,
                style: TextStyle(fontSize: 16, color: Colors.black87),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableCard(String title, String content) {
    return Card(
      elevation: 6.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ExpansionTile(
        title: Text(
          title,
          softWrap: true,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent),
        ),
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              content,
              style: TextStyle(fontSize: 16),
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
}
