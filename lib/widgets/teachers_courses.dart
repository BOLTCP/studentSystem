import 'package:studentsystem/models/teacherscourseplanning.dart';
import 'package:studentsystem/models/teachersmajorplanning.dart';
import 'package:studentsystem/widgets/teacher_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:studentsystem/api/get_api_url.dart';
import 'package:logger/logger.dart';
import 'package:studentsystem/models/user_details.dart';
import 'package:studentsystem/constants/bottom_navigation.dart';
import 'package:studentsystem/constants/teacher_drawer.dart';
import 'package:studentsystem/models/major.dart';
import 'package:studentsystem/models/department.dart';
import 'package:studentsystem/models/courses.dart';
import 'package:studentsystem/models/teacher.dart';

var logger = Logger();

class TeachersCourses extends StatefulWidget {
  const TeachersCourses({required this.userDetails, super.key});

  final UserDetails userDetails;

  @override
  _TeachersCoursesState createState() => _TeachersCoursesState();
}

class _TeachersCoursesState extends State<TeachersCourses> {
  late Future<List<Course>> futureCoursesDetails;
  late Future<List<TeachersCoursePlanning>> futureTeachersCoursesPlanning;
  late Future<UserDetails> futureUserDetails;
  late String? selectedMajorName;
  late TeachersMajorPlanning? selectedMajor;
  bool teacherHasSelectedCourses = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Widget> _screens = [];
  ScrollController _scrollController = ScrollController();
  int _selectedIndex = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _screens = [
      TeacherDashboard(userId: widget.userDetails.user.userId),
    ];
    futureUserDetails = Future.value(widget.userDetails);
    futureTeachersCoursesPlanning = fetchTeachersCoursesPlanning();
    futureCoursesDetails = fetchCoursesDetails();
    selectedMajorName = widget.userDetails.teachersMajorPlanning?[0].majorName;
    selectedMajor = widget.userDetails.teachersMajorPlanning?[0];
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

        logger.d('${teachersMajorsCourses.length} teachersMajorsCourses');
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

  Future<void> _addCourseToTeacher(BuildContext context, Major major) async {
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

  Future<void> _removeFromCourseTeacher(teacherId, courseId) async {
    logger.d(teacherId, courseId);
    try {
      final response = await http.delete(
        getApiUrl('/Remove/Course/From/Teacher'),
        body: json.encode({
          'teacher_id': teacherId,
          'course_id': courseId,
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
    } catch (e) {
      logger.d('Error: $e');
      throw Exception('An error occurred. Please try again.');
    }
  }

  /*
  
  Future<void> _addCoursesOfMajorToTeacher(courseId) async {
    logger.d("HERE");
    try {
      final response = await http.post(
        getApiUrl('/Add/Courses/Of/Major/To/Teacher'),
        body: json.encode({
          'major_id': courseId,
        }),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Сонгосон хөтөлбөр амжилттай нэмэгдлээ'),
              content: Text('Хөтөлбөр $courseId нэмэгдлээ'),
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

   */

  Future<void> _addCoursesOfMajorToTeacher(TeacherUser teacherId, Course course,
      TeachersMajorPlanning selectedMajor) async {
    try {
      final response = await http.post(
        getApiUrl('/Add/Courses/OfMajor/To/Teacher'),
        body: json.encode({
          'teacher': teacherId,
          'course': course,
          'selectedMajor': selectedMajor
        }),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 30));
      final decodedJson = json.decode(response.body);
      if (response.statusCode == 200) {
        refreshCoursesPlanning();
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
                    _addCourseToTeacher(context, major);
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
                    _addCourseToTeacher(context, major);
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

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder(
                  future: Future.wait([
                    futureCoursesDetails,
                    futureTeachersCoursesPlanning,
                    futureUserDetails,
                  ]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text('An error occurred: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      List<Course> majorsCourses =
                          snapshot.data![0] as List<Course>;
                      List<TeachersCoursePlanning> teachersCourses =
                          snapshot.data![1] as List<TeachersCoursePlanning>;
                      UserDetails userDetails =
                          snapshot.data![2] as UserDetails;

                      if (userDetails.teachersMajorPlanning == null) {
                        return Center(
                            child: Text(
                                'Багшид оноогдсон хөтөлбөрүүд байхгүй байна.'));
                      }

                      return Column(
                        children: [
                          Center(
                            child: SizedBox(
                              width:
                                  MediaQuery.of(context).size.height * 0.5 - 40,
                              height: 350,
                              child: Scrollbar(
                                thickness: 4.0,
                                trackVisibility: true,
                                thumbVisibility: true,
                                child: CustomScrollView(
                                  slivers: [
                                    SliverToBoxAdapter(
                                      child: Container(
                                        padding: EdgeInsets.all(8.0),
                                        color: Colors.blue[100],
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Expanded(
                                              child: ListTile(
                                                title: Text(
                                                    'Багш ${userDetails.user.fname}, ${userDetails.teacher!.teacherCode}'),
                                                subtitle: Text(
                                                    '${userDetails.user.userRole}, ${userDetails.teacher!.jobTitle}'),
                                                trailing: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Image.asset(
                                                        'assets/images/icons/teacher_teaching.png')
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Card(
                                                elevation: 12.0,
                                                color: Colors.white,
                                                child: SizedBox(
                                                  height: 50,
                                                  child: DropdownButton<String>(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    value: selectedMajorName,
                                                    hint: Center(
                                                        child: Text(
                                                            "Хөтөлбөр сонгох")),
                                                    onChanged: (String? value) {
                                                      if (value != null) {
                                                        setState(() {
                                                          selectedMajor = userDetails
                                                              .teachersMajorPlanning
                                                              ?.firstWhere(
                                                                  (major) =>
                                                                      major
                                                                          .majorName ==
                                                                      value);
                                                          selectedMajorName =
                                                              value;
                                                        });
                                                      }
                                                    },
                                                    items: userDetails
                                                            .teachersMajorPlanning
                                                            ?.map((major) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value:
                                                                major.majorName,
                                                            child: Text(
                                                              major.majorName,
                                                              style: TextStyle(
                                                                  fontSize: 16),
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              softWrap: true,
                                                            ),
                                                          );
                                                        }).toList() ??
                                                        [],
                                                    isExpanded: true,
                                                    selectedItemBuilder:
                                                        (BuildContext context) {
                                                      return userDetails
                                                              .teachersMajorPlanning
                                                              ?.map<Widget>(
                                                                  (major) {
                                                            return Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Expanded(
                                                                  child: Center(
                                                                    child: Text(
                                                                      selectedMajorName ??
                                                                          "Select a major",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16),
                                                                      maxLines:
                                                                          3,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      softWrap:
                                                                          true,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          }).toList() ??
                                                          [];
                                                    },
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    _buildSilverList(
                                        majorsCourses, selectedMajor)
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
                    mainAxisAlignment: MainAxisAlignment.center,
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
                                        'Нийт сонгогдсон хичээлүүд: ${teachersCoursePlanning.length}',
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
                                    width: MediaQuery.of(context).size.height *
                                            0.5 -
                                        40,
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
                                                  coursePlanning.courseName),
                                              subtitle: Text(
                                                  '${coursePlanning.courseCode}, ${coursePlanning.majorName.split(' ').map((majorName) => majorName[0]).join('')}'),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10),
                                                    child: IconButton(
                                                      icon: Image.asset(
                                                        'assets/images/icons/teachers_majors_selection.png',
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pushNamed(
                                                          context,
                                                          '/teachers_majors',
                                                          arguments: widget
                                                              .userDetails,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10),
                                                    child: IconButton(
                                                      icon: Icon(Icons.delete),
                                                      onPressed: () {
                                                        _removeFromCourseTeacher(
                                                            widget
                                                                .userDetails
                                                                .teacher!
                                                                .teacherId,
                                                            coursePlanning
                                                                .courseId);
                                                      },
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10),
                                                    child: IconButton(
                                                      icon: Image.asset(
                                                        'assets/images/icons/teachers_courses.png',
                                                      ),
                                                      onPressed: () {
                                                        _addCoursesOfMajorToTeacher(
                                                            widget.userDetails
                                                                .teacher!,
                                                            coursePlanning
                                                                as Course,
                                                            selectedMajor
                                                                as TeachersMajorPlanning);
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
                  child: SizedBox(
                    width: 500,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Оноогдсон хөтөлбөрүүдэд багш сонгосон хичээл байхгүй байна',
                                style: TextStyle(fontSize: 16.0),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Хичээлүүд',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          ),
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

  Widget _buildSilverList(majorsCourses, selectedMajor) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          Course course = majorsCourses[index];
          return Container(
            color: Colors.white,
            child: course.majorId == selectedMajor.majorId
                ? ListTile(
                    title: Text('${course.courseName}, ${course.courseCode}'),
                    subtitle: Text(
                        '${course.courseYear}, ${course.courseType}, ${course.totalCredits}, ${course.courseSeason}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              _addCoursesOfMajorToTeacher(
                                  widget.userDetails.teacher!,
                                  course,
                                  selectedMajor);
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                : /* course.majorId != selectedMajor.majorId
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Card(
                                elevation: 5.0,
                                margin: EdgeInsets.symmetric(vertical: 10.0),
                                child: SizedBox(
                                  height: 100.0,
                                  child: Center(
                                    child: Text(
                                      "No data available for the selected major.",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.black54),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )*/
                SizedBox.shrink(),
          );
        },
        childCount: majorsCourses.length,
      ),
    );
  }
}
