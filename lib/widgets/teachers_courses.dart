import 'package:studentsystem/models/teachersmajorplanning.dart';
import 'package:studentsystem/widgets/teacher_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:studentsystem/api/get_api_url.dart';
import 'package:logger/logger.dart';
import 'package:studentsystem/models/user_details.dart';
import 'package:studentsystem/widgets/bottom_navigation.dart';
import 'package:studentsystem/widgets/teacher_drawer.dart';
import 'package:studentsystem/models/major.dart';
import 'package:studentsystem/models/department.dart';

var logger = Logger();

class TeachersCourses extends StatefulWidget {
  const TeachersCourses({required this.userDetails, super.key});

  final UserDetails userDetails;

  @override
  _TeachersCoursesState createState() => _TeachersCoursesState();
}

class _TeachersCoursesState extends State<TeachersCourses> {
  //late Future<UserDetails> userDetails;
  late String departmentName = '';
  List<String> weekdays = [];
  late String currentDayOfWeek = '';
  late Future<List<Major>> futureMajorDetails;
  late Future<UserDetails> futureUserDetails;
  late Future<List<Department>> futureDepartmentsDetails;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Widget> _screens = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _screens = [
      TeacherDashboard(userId: widget.userDetails.user.userId),
    ];
    futureUserDetails = Future.value(widget.userDetails);
    futureMajorDetails = fetchMajorsDetails();
    futureDepartmentsDetails = fetchDepartmentsDetails();
  }

  Future<List<Major>> fetchMajorsDetails() async {
    try {
      final response = await http.post(
        getApiUrl('/Get/allMajor/Of/DepartmentsOfEducation'),
        body: json.encode({
          'departments_of_edu_id':
              widget.userDetails.teacher!.departmentsOfEducationId
        }),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);
        List<Major> majors = (decodedJson['courses'] as List)
            .map((major) => Major.fromJsonMajor(major))
            .toList();

        logger.d(majors.length);
        return majors;
      } else {
        logger.d('Error: ${response.statusCode}');
        throw Exception(
            'Majors of ${widget.userDetails.teacher!.departmentsOfEducationId} does not exist!');
      }
    } catch (e) {
      logger.d('Error: $e');
      throw Exception('An error occurred. Please try again.');
    }
  }

  Future<List<Department>> fetchDepartmentsDetails() async {
    try {
      final response = await http.post(
        getApiUrl('/Get/allMajor/Of/DepartmentsOfEducation'),
        body: json.encode({
          'departments_of_edu_id':
              widget.userDetails.teacher!.departmentsOfEducationId
        }),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);
        List<Department> departments = (decodedJson['departments'] as List)
            .map((department) => Department.fromJsonDepartment(department))
            .toList();
        return departments;
      } else {
        logger.d('Error: ${response.statusCode}');
        throw Exception('Departments not found');
      }
    } catch (e) {
      logger.d('Error: $e');
      throw Exception('An error occurred while fetching departments.');
    }
  }

  Future<void> _addMajorToTeacher(BuildContext context, Major major) async {
    DateTime currentTime = DateTime.now();
    String createdAtString = currentTime.toIso8601String();

    try {
      final response = await http.post(
        getApiUrl('/Add/Major/To/Teacher'),
        body: json.encode({
          'teacher_id': widget.userDetails.teacher!.teacherId,
          'academic_degree_of_major': major.academicDegree,
          'major_name': major.majorName,
          'major_id': major.majorId,
          'credit': major.totalCreditsPerYear,
          'department_id': widget.userDetails.department?.departmentId,
          'created_at': createdAtString,
          'department_of_educations_id': widget
              .userDetails.departmentOfEducation?.departmentsOfEducationId,
        }),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Сонгосон хөтөлбөр амжилттай нэмэгдлээ'),
              content: Text('Хөтөлбөр ${major.majorName} нэмэгдлээ'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _teachersCurrentMajors(
                        widget.userDetails.teacher!.teacherId, major.majorId);
                  },
                  child: Text('Буцах'),
                ),
              ],
            );
          },
        );
      } else {
        throw Exception('Failed to add major');
      }
    } catch (e) {
      logger.d('Error: $e');
      throw Exception('An error occurred. Please try again.');
    }
  }

  Future<void> _removeFromMajorTeacher(teacherId, majorId) async {
    logger.d(teacherId, majorId);
    try {
      final response = await http.post(
        getApiUrl('/Remove/Major/From/Teacher'),
        body: json.encode({
          'teacher_id': teacherId,
          'majorId': majorId,
        }),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);
        logger.d(decodedJson);
        final deleteMessage = decodedJson['message'];
        final deletedMajor = deleteMessage['deleted_major'];
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('$deleteMessage'),
              content: Text('${deletedMajor.major_name}'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Буцах'),
                ),
              ],
            );
          },
        );
      } else {
        throw Exception('Failed to add major');
      }
    } catch (e) {}
  }

  Future<void> _teachersCurrentMajors(int userId, int majorId) async {
    try {
      final response = await http.post(
        getApiUrl('/Get/Current/Majors/Of/Teacher'),
        body: json.encode({
          'teacher_id': userId,
          'major_id': majorId,
        }),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 30));
      final decodedJson = json.decode(response.body);
      if (response.statusCode == 200) {
        List<TeachersMajorPlanning> majors =
            (decodedJson['current_majors'] as List)
                .map((major) =>
                    TeachersMajorPlanning.fromJsonTeachersMajorPlanning(major))
                .toList();
        Major major = Major.fromJsonMajor(decodedJson['a_major_to_be_added']);

        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Одоогоор Багшийн нэр ${widget.userDetails.user.fname}, ${widget.userDetails.user.userRole}, ${widget.userDetails.teacher!.jobTitle}, ${widget.userDetails.departmentOfEducation!.edDepartmentName}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ),
                  Icon(Icons.warning, color: Colors.blue, size: 28),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...majors.map((major) => RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: '${major.majorName}, ',
                                style: TextStyle(color: Colors.purple)),
                            TextSpan(
                                text: 'Зэрэг: ${major.academicDegree}, ',
                                style: TextStyle(color: Colors.pink)),
                          ],
                        ),
                      )),
                  Text('Сонгосон хөтөлбөрүүдийн тоо: ${majors.length}'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Буцах", style: TextStyle(color: Colors.black)),
                ),
                TextButton(
                  onPressed: () {
                    _addMajorToTeacher(context, major);
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: Colors.green),
                      SizedBox(width: 8),
                      Text("Хөтөлбөрийг нэмэх",
                          style: TextStyle(color: Colors.green)),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      } else if (response.statusCode == 201) {
        Major major = Major.fromJsonMajor(decodedJson['a_major_to_be_added']);

        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Одоогоор Багшийн нэр ${widget.userDetails.user.fname}, ${widget.userDetails.user.userRole}, ${widget.userDetails.teacher!.jobTitle}, ${widget.userDetails.departmentOfEducation!.edDepartmentName}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ),
                  Icon(Icons.warning, color: Colors.blue, size: 28),
                ],
              ),
              content: Text(
                  'Одоогоор Багшийн нэр дээр сонгосон хөтөлбөр байхгүй байна.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Буцах", style: TextStyle(color: Colors.black)),
                ),
                TextButton(
                  onPressed: () {
                    _addMajorToTeacher(context, major);
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: Colors.green),
                      SizedBox(width: 8),
                      Text("Хөтөлбөрийг нэмэх",
                          style: TextStyle(color: Colors.green)),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      } else {
        logger.d('Error: ${response.statusCode}');
        throw Exception(
            'Majors of ${widget.userDetails.teacher!.departmentsOfEducationId} does not exist!');
      }
    } catch (e) {
      logger.d('Error: $e');
      throw Exception('An error occurred. Please try again.');
    }
  }

  void onItemTappedTeacherDashboard(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 0) {
      Navigator.pushNamed(
        context,
        '/teacher_dashboard',
        arguments: widget.userDetails,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Хуваарь гаргах',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.blue[50],
      drawer: buildDrawer(context, futureUserDetails),
      bottomNavigationBar:
          buildBottomNavigation(_selectedIndex, onItemTappedTeacherDashboard),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return FutureBuilder(
      future: Future.wait([futureMajorDetails, futureDepartmentsDetails]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading data: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          List<Major> majors = snapshot.data![0] as List<Major>;
          List<Department> departments = snapshot.data![1] as List<Department>;

          if (majors.isEmpty) {
            return Center(child: Text('No majors available.'));
          }

          String departmentName = departments[0].departmentName;

          return Column(
            children: [
              Center(
                child: SizedBox(
                  width: 550,
                  height: 350,
                  child: Scrollbar(
                    thickness: 4.0,
                    trackVisibility: true,
                    thumbVisibility: true,
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Container(
                            padding: EdgeInsets.all(16.0),
                            color: Colors.blue[100],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    '$departmentName - н хөтөлбөрүүд',
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              Major major = majors[index];
                              return Container(
                                color: Colors.white,
                                child: ListTile(
                                  title: Text(major.majorName),
                                  subtitle: Text(major.majorsType),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () {
                                          _teachersCurrentMajors(
                                              widget.userDetails.teacher!
                                                  .teacherId,
                                              major.majorId);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          _removeFromMajorTeacher(
                                              widget.userDetails.teacher!
                                                  .teacherId,
                                              major.majorId);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            childCount: majors.length,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return Center(child: Text('No majors available.'));
        }
      },
    );
  }
}
