import 'package:studentsystem/models/teacherscourseplanning.dart';
import 'package:studentsystem/models/teachersmajorplanning.dart';
import 'package:studentsystem/widgets/teacher_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:studentsystem/api/get_api_url.dart';
import 'package:logger/logger.dart';
import 'package:studentsystem/models/user_details.dart';
import 'package:studentsystem/widgets/bottom_navigation.dart';
import 'package:studentsystem/constants/teacher_drawer.dart';
import 'package:studentsystem/models/major.dart';
import 'package:studentsystem/models/department.dart';
import 'package:studentsystem/models/courses.dart';

var logger = Logger();

class TeachersCourses extends StatefulWidget {
  const TeachersCourses({required this.userDetails, super.key});

  final UserDetails userDetails;

  @override
  _TeachersCoursesState createState() => _TeachersCoursesState();
}

class _TeachersCoursesState extends State<TeachersCourses> {
  late Future<UserDetails> futureUserDetails;
  late Future<List<Course>> futureCoursesDetails;
  late Future<List<TeachersCoursePlanning>> futureTeachersCoursesPlanning;
  ScrollController _scrollController = ScrollController();
  bool teacherHasSelectedCourses = false;
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
    futureTeachersCoursesPlanning = fetchTeachersCoursesPlanning();
    futureCoursesDetails = fetchCoursesDetails();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void refreshCoursesPlanning() {
    setState(() {
      futureTeachersCoursesPlanning = fetchTeachersCoursesPlanning();
    });
  }

  Future<List<TeachersCoursePlanning>> fetchTeachersCoursesPlanning() async {
    try {
      final response = await http.get(
        getApiUrl(
            '/Get/Current/CoursesPlanning/Of/Teacher?teacher_id=${widget.userDetails.teacher!.teacherId}'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);
        List<TeachersCoursePlanning> teacherscourseplanning =
            (decodedJson['current_courses'] as List)
                .map((teacherscourseplanning) =>
                    TeachersCoursePlanning.fromJsonTeachersCoursePlanning(
                        teacherscourseplanning))
                .toList();

        setState(() {
          if (teacherscourseplanning.isNotEmpty) {
            teacherHasSelectedCourses = true;
          }
        });

        logger.d(teacherscourseplanning.length);

        return teacherscourseplanning;
      } else {
        setState(() {
          teacherHasSelectedCourses = false;
        });
        logger.d('Error: ${response.statusCode}');
        throw Exception('Teacher has no selected majors');
      }
    } catch (e) {
      logger.d('Error: $e');
      throw Exception('An error occurred. Please try again.');
    }
  }

  Future<List<Course>> fetchCoursesDetails() async {
    String courseCode;
    if (widget.userDetails.department?.departmentCode == 'ПХ') {
      courseCode = 'КОМ';
    } else {
      courseCode = '*';
    }

    try {
      final response = await http
          .post(
            getApiUrl('/Get/AllCourses/Of/Teachers/Selected/Major'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'selected_majors': widget.userDetails.teachersMajorPlanning ?? [],
              'course_code': courseCode,
            }),
          )
          .timeout(Duration(seconds: 30));
      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);
        List<Course> teachersMajorsCourses =
            (decodedJson['teachers_courses'] as List)
                .map((courseJson) => Course.fromJsonCourses(courseJson))
                .toList();

        logger.d(teachersMajorsCourses.length);
        return teachersMajorsCourses;
      } else {
        logger.d('Error: ${response.statusCode}');
        throw Exception('Багшид оноогдсон хөтөлбөрт хичээл байхгүй байна!');
      }
    } catch (e) {
      logger.d('Error: $e');
      throw Exception('An error occurred. Please try again.');
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
                    refreshCoursesPlanning();
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
        refreshCoursesPlanning();
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

  Future<void> _addCoursesOfMajorToTeacher(majorId) async {
    DateTime currentTime = DateTime.now();
    String createdAtString = currentTime.toIso8601String();

    try {
      final response = await http.post(
        getApiUrl('/Add/Courses/Of/Major/To/Teacher'),
        body: json.encode({
          'major_id': majorId,
        }),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Сонгосон хөтөлбөр амжилттай нэмэгдлээ'),
              content: Text('Хөтөлбөр ${majorId} нэмэгдлээ'),
              actions: [
                TextButton(
                  onPressed: () {
                    refreshCoursesPlanning();
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
    } catch (e) {
      logger.d('Error: $e');
      throw Exception('An error occurred. Please try again.');
    }
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
                      Text(
                        "Хөтөлбөрийг нэмэх",
                        style: TextStyle(color: Colors.green),
                      ),
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
                      Text(
                        "Хөтөлбөрийг нэмэх",
                        style: TextStyle(color: Colors.green),
                      ),
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
          'Хичээлүүд',
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                FutureBuilder(
                  future: Future.wait(
                      [futureCoursesDetails, futureTeachersCoursesPlanning]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text('Error loading data: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      List<Course> majorsCourses =
                          snapshot.data![0] as List<Course>;
                      List<TeachersCoursePlanning> teachersCourses =
                          snapshot.data![1] as List<TeachersCoursePlanning>;

                      if (majorsCourses.isEmpty) {
                        return Center(child: Text('No majors available.'));
                      }

                      return Column(
                        children: [
                          Center(
                            child: SizedBox(
                              width: 550 - 40,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                'Хөтөлбөрүүд',
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
                                          Course course = majorsCourses[index];
                                          return Container(
                                            color: Colors.white,
                                            child: ListTile(
                                              title: Text(
                                                  '${course.courseName}, ${course.courseCode}'),
                                              subtitle: Text(
                                                  '${course.courseYear}, ${course.courseType}, ${course.totalCredits}, ${course.courseSeason}'),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 20.0),
                                                    child: IconButton(
                                                      icon: Icon(Icons.add),
                                                      onPressed: () {
                                                        _teachersCurrentMajors(
                                                            widget
                                                                .userDetails
                                                                .teacher!
                                                                .teacherId,
                                                            course.majorId);
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        childCount: majorsCourses.length,
                                      ),
                                    )
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
                ),
              ],
            ),
          ),
          teacherHasSelectedCourses == true
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      FutureBuilder<List<TeachersCoursePlanning>>(
                        future: futureTeachersCoursesPlanning,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text(
                                    'Error loading data: ${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            List<TeachersCoursePlanning>
                                teachersCoursePlanning = snapshot.data!;

                            if (teachersCoursePlanning.isEmpty) {
                              return Center(
                                  child: Text('No majors available.'));
                            }

                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Нийт сонгогдсон хөтөлбөрүүд: ${teachersCoursePlanning.length}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Center(
                                  child: SizedBox(
                                    width: 550 - 40,
                                    height: 350,
                                    child: Scrollbar(
                                      controller: _scrollController,
                                      thickness: 4.0,
                                      trackVisibility: true,
                                      thumbVisibility: true,
                                      child: ListView.builder(
                                        controller: _scrollController,
                                        itemCount:
                                            teachersCoursePlanning.length,
                                        itemBuilder: (context, index) {
                                          TeachersCoursePlanning
                                              coursePlanning =
                                              teachersCoursePlanning[index];
                                          return Container(
                                            color: Colors.white,
                                            child: ListTile(
                                              title: Text(
                                                  coursePlanning.majorName),
                                              subtitle: Text(
                                                  coursePlanning.courseName),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 20.0),
                                                    child: IconButton(
                                                      icon: Icon(Icons.delete),
                                                      onPressed: () {
                                                        _removeFromMajorTeacher(
                                                            widget
                                                                .userDetails
                                                                .teacher!
                                                                .teacherId,
                                                            coursePlanning
                                                                .majorId);
                                                      },
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 20.0),
                                                    child: IconButton(
                                                      icon: Image.asset(
                                                        'assets/images/icons/teachers_courses.png',
                                                      ),
                                                      onPressed: () {
                                                        _addCoursesOfMajorToTeacher(
                                                            coursePlanning
                                                                .majorId);
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
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
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Одоогоор багшид оноогдсон хөтөлбөрт сонгосон хичээлүүд байхгүй байна',
                              style: TextStyle(fontSize: 16.0),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
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
}
