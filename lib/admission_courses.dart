import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:studentsystem/courses.dart';
import 'package:studentsystem/models/major.dart';
import 'package:studentsystem/api/get_api_url.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class AdmissionCourses extends StatefulWidget {
  const AdmissionCourses({Key? key}) : super(key: key);

  @override
  _AdmissionCoursesState createState() => _AdmissionCoursesState();
}

class _AdmissionCoursesState extends State<AdmissionCourses> {
  int? selectedChipIndex;
  List<MajorBrief> majors = [];

  Future<void> _getCourses(int selectedChipIndex) async {
    final int courseTypeIndex = selectedChipIndex;
    final String courseType = courseTypeIndex == 0
        ? 'Бакалавр'
        : courseTypeIndex == 1
            ? 'Бакалавр/evening'
            : courseTypeIndex == 2
                ? 'Магистр'
                : courseTypeIndex == 3
                    ? 'Доктор'
                    : courseTypeIndex == 4
                        ? 'Бакалавр'
                        : 'null';

    try {
      final response = await http.post(
        getApiUrl('/admission/Courses'),
        body: json.encode({'courseType': courseType}),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);
        List<MajorBrief> fetchedMajors = (decodedJson['majors'] as List)
            .map((majorJson) => MajorBrief(
                  majorId: majorJson['major_id'],
                  majorName: majorJson['major_name'],
                  majorsDescription: majorJson['majors_description'],
                ))
            .toList();

        setState(() {
          majors = fetchedMajors;
        });
      } else {
        logger.d('Error: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Course type does not exist!')),
        );
      }
    } catch (e) {
      logger.d('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  void _getCoursesIntroduction(int majorId) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => CoursesIntroduction(majorId: majorId)),
    );
  }

  List<Widget> _buildMajorDetails() {
    return majors.map((major) {
      return _buildMajorDetailRow(
          major.majorId, major.majorName, major.majorsDescription);
    }).toList();
  }

  Widget _buildMajorDetailRow(
      int majorId, String title, String? majorsDescription) {
    return SizedBox(
      width: 300.0,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.0),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(35.0),
                ),
                // ActionChip now has a Material widget for elevation
                Material(
                  elevation:
                      4.0, // Added elevation to Material for shadow effect
                  borderRadius:
                      BorderRadius.circular(8.0), // Rounded corners for chip
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    child: ActionChip(
                      backgroundColor: Colors.blue[50],
                      side: BorderSide(color: Colors.lightBlue),
                      label: Center(
                        // Center the text
                        child: Text(
                          title,
                          softWrap: true,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign:
                              TextAlign.center, // Ensure the text is centered
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      labelStyle: TextStyle(fontSize: 16.0),
                      onPressed: () {},
                    ),
                  ),
                ),
                Positioned(
                  bottom: 21.0,
                  left: 16.0,
                  child: GestureDetector(
                    onTap: () {
                      _showDescriptionDialog(
                          majorsDescription ?? "Тайлбар байхгүй.");
                    },
                    child: Image.asset(
                      'assets/images/icons/major_description.png',
                      width: 25.0,
                      height: 25.0,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 21.0,
                  right: 16.0,
                  child: GestureDetector(
                    onTap: () => _getCoursesIntroduction(majorId),
                    child: Image.asset(
                      'assets/images/icons/student_signup.png',
                      width: 25.0,
                      height: 25.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDescriptionDialog(String majorsDescription) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "Тайлбар",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              content: Text(majorsDescription,
                  style:
                      TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    "Хаах",
                    style: TextStyle(fontSize: 24.0),
                  ),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Элсэлтийн Бүртгэл',
          style: TextStyle(
              color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.login),
            tooltip: 'Нэвтрэх',
            onPressed: () {
              Navigator.pushNamed(context, '/login_screen');
            },
          ),
        ],
      ),
      backgroundColor: Colors.blue[50],
      body: Center(
        child: SizedBox(
          width: 550,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Card(
                  elevation: 20.0,
                  shadowColor: Colors.blue.shade900,
                  margin: const EdgeInsets.all(20.0),
                  color: Colors.blue,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 5.0),
                              child: Expanded(
                                child: const Text(
                                  'Хөтөлбөрүүд',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(left: 5.0)),
                            Positioned(
                              child: Icon(
                                Icons.school,
                                size: 40.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: [
                              // Use ActionChip directly without InkWell
                              ActionChip(
                                backgroundColor: Colors.white,
                                avatar: Icon(
                                  selectedChipIndex == 0
                                      ? Icons.circle_rounded
                                      : Icons.circle_outlined,
                                  fill: 0.5,
                                  color: Colors.black,
                                ),
                                label: const Text('Бакалавр',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                labelStyle: TextStyle(fontSize: 24.0),
                                onPressed: () {
                                  setState(() {
                                    selectedChipIndex = 0;
                                    _getCourses(selectedChipIndex!);
                                  });
                                },
                              ),
                              ActionChip(
                                backgroundColor: Colors.white,
                                avatar: Icon(
                                  selectedChipIndex == 1
                                      ? Icons.circle_rounded
                                      : Icons.circle_outlined,
                                  fill: 0.5,
                                  color: Colors.black,
                                ),
                                label: const Text(
                                  'Бакалавр / Орой',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                labelStyle: TextStyle(fontSize: 24.0),
                                onPressed: () {
                                  setState(() {
                                    selectedChipIndex = 1;
                                    _getCourses(selectedChipIndex!);
                                  });
                                },
                              ),
                              ActionChip(
                                backgroundColor: Colors.white,
                                avatar: Icon(
                                  selectedChipIndex == 2
                                      ? Icons.circle_rounded
                                      : Icons.circle_outlined,
                                  fill: 0.5,
                                  color: Colors.black,
                                ),
                                label: const Text(
                                  'Магистр',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                labelStyle: TextStyle(fontSize: 24.0),
                                onPressed: () {
                                  setState(() {
                                    selectedChipIndex = 2;
                                    _getCourses(selectedChipIndex!);
                                  });
                                },
                              ),
                              ActionChip(
                                backgroundColor: Colors.white,
                                avatar: Icon(
                                  selectedChipIndex == 3
                                      ? Icons.circle_rounded
                                      : Icons.circle_outlined,
                                  fill: 0.5,
                                  color: Colors.black,
                                ),
                                label: const Text(
                                  'Доктор',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                labelStyle: TextStyle(fontSize: 24.0),
                                onPressed: () {
                                  setState(() {
                                    selectedChipIndex = 3;
                                    _getCourses(selectedChipIndex!);
                                  });
                                },
                              ),
                              ActionChip(
                                backgroundColor: Colors.white,
                                avatar: Icon(
                                  selectedChipIndex == 4
                                      ? Icons.circle_rounded
                                      : Icons.circle_outlined,
                                  fill: 0.5,
                                  color: Colors.black,
                                ),
                                label: const Text(
                                  'Шилжин Суралцах',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                labelStyle: TextStyle(fontSize: 24.0),
                                onPressed: () {
                                  setState(() {
                                    selectedChipIndex = 4;
                                    _getCourses(selectedChipIndex!);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: SizedBox(
                    child: Column(
                      children: _buildMajorDetails(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
