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
  late Future<List<Major>> futureMajor;

  @override
  void initState() {
    super.initState();
    futureMajor = fetchMajor();
  }

  Future<List<Major>> fetchMajor() async {
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
        logger.d('Decoded JSON: $decodedJson');
        List<Major> majors = (decodedJson['major'] as List)
            .map((json) => Major.fromJson(json))
            .toList();
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
      futureMajor = fetchMajor();
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
        // SafeArea to avoid overlap with system UI
        child: Column(
          children: [
            // Pull-to-refresh functionality
            Expanded(
              // Make sure content inside the SingleChildScrollView takes up remaining space
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                child: FutureBuilder<List<Major>>(
                  future: futureMajor,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No data found.'));
                    } else {
                      final majors = snapshot.data!;

                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(
                            16.0), // Add some padding around the scroll view
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Display major details in nicely styled cards
                            ...majors
                                .expand((major) => _buildCourseDetails(major))
                                .toList(),

                            SizedBox(height: 20),

                            // Button to navigate to the next screen
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 30),
                                backgroundColor: Colors.blue, // Button color
                                textStyle: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/student_signup',
                                  arguments: majors[
                                      0], // Pass majors list to the next screen
                                );
                              },
                              child: Text(
                                'Хөтөлбөрт бүртгүүлэх',
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
      _buildCourseDetailCard('Хөтөлбөрийн танилцуулга:',
          major.majorsDescription ?? 'Танилцуулга байхгүй'),
      _buildCourseDetailCard(
          'Хэрэгжиж эхэлсэн он:', major.descriptionBrief ?? 'Мэдээлэл байхгүй'),
    ];
  }

  // Create a card for each course detail
  Widget _buildCourseDetailCard(String label, var value) {
    String displayValue;

    // Check if the value is a DateTime object and format it
    if (value is DateTime) {
      displayValue =
          DateFormat('yyyy-MM-dd').format(value); // Format the DateTime
    } else {
      displayValue = value.toString(); // If not DateTime, convert to string
    }

    return Card(
      elevation: 6.0, // Elevation for the card to make it look elevated
      margin:
          const EdgeInsets.symmetric(vertical: 8.0), // Add margin between cards
      color: Colors.white, // Card background color
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(12.0), // Rounded corners for the card
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
            SizedBox(width: 12), // Add spacing between label and value
            Expanded(
              child: Text(
                displayValue,
                style: TextStyle(fontSize: 16, color: Colors.black87),
                overflow: TextOverflow.ellipsis, // Handle overflow
              ),
            ),
          ],
        ),
      ),
    );
  }
}
