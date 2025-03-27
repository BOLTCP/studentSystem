import 'dart:convert';
import 'dart:io' as io;
import 'package:flutter/foundation.dart' as Foundation;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import 'package:studentsystem/api/get_api_url.dart';
import 'package:studentsystem/constants/bottom_navigation.dart';
import 'package:studentsystem/constants/teacher_drawer.dart';
import 'package:studentsystem/models/departments_of_education.dart';
import 'package:studentsystem/models/teacher.dart';
import 'package:studentsystem/models/auth_user.dart';
import 'package:studentsystem/models/department.dart';
import 'package:studentsystem/models/major.dart';
import 'package:studentsystem/models/teachersmajorplanning.dart';
import 'package:studentsystem/models/user_details.dart';
import 'package:studentsystem/widgets/teacher_dashboard.dart';

var logger = Logger();

class TeachersMajors extends StatefulWidget {
  const TeachersMajors({required this.userDetails, super.key});

  final UserDetails userDetails;

  @override
  _TeachersMajorsState createState() => _TeachersMajorsState();
}

class _TeachersMajorsState extends State<TeachersMajors> {
  late String departmentName = '';
  List<String> weekdays = [];
  late String currentDayOfWeek = '';
  late Future<List<Major>> futureMajorDetails;
  late Future<UserDetails> futureUserDetails;
  late Future<Department> futureDepartmentsDetails;
  late Future<List<TeachersMajorPlanning>> futureTeachersMajorPlanning;
  ScrollController _scrollController = ScrollController();
  bool teacherHasSelectedMajors = false;

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
    futureTeachersMajorPlanning = fetchTeachersMajorPlanning();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void refreshUserDetails() {
    setState(() {
      futureUserDetails = fetchUserDetails(widget.userDetails.user.userId);
    });
  }

  void refreshMajorsPlanning() {
    setState(() {
      futureTeachersMajorPlanning = fetchTeachersMajorPlanning();
    });
  }

  Future<UserDetails> fetchUserDetails(int userId) async {
    try {
      final response = await http.post(
        getApiUrl('/User/Login/Teacher'),
        body: json.encode({
          'user_id': userId,
        }),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 30));

      logger.d('Response status: ${response.statusCode}');
      logger.d('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);

        AuthUser user = AuthUser.fromJsonAuthUser(decodedJson['user']);
        TeacherUser teacher =
            TeacherUser.fromJsonTeacher(decodedJson['teacher']);
        DepartmentOfEducation departmentOdEducation =
            DepartmentOfEducation.fromJsonDepartmentOfEducation(
                decodedJson['dept_of_edu']);
        Department department =
            Department.fromJsonDepartment(decodedJson['dep']);
        departmentName = departmentOdEducation.edDepartmentName;
        List<TeachersMajorPlanning> teachersmajorplanning =
            (decodedJson['teachers_major'] as List)
                .map((teachersmajorplanning) =>
                    TeachersMajorPlanning.fromJsonTeachersMajorPlanning(
                        teachersmajorplanning))
                .toList();

        return UserDetails(
            user: user,
            teacher: teacher,
            student: null,
            department: department,
            departmentOfEducation: departmentOdEducation,
            teachersMajorPlanning: teachersmajorplanning);
      } else {
        logger.d('Error: ${response.statusCode}');
        throw Exception('User does not exist!');
      }
    } catch (e) {
      logger.d('Error: $e');
      throw Exception('An error occurred. Please try again.');
    }
  }

  Future<List<TeachersMajorPlanning>> fetchTeachersMajorPlanning() async {
    try {
      final response = await http.get(
        getApiUrl(('/Get/Current/MajorsPlanning/Of/Teacher'
            '?teacher_id=${widget.userDetails.teacher!.teacherId}')),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);
        List<TeachersMajorPlanning> teachersmajorplanning =
            (decodedJson['selected_majors'] as List)
                .map((teachersmajorplanning) =>
                    TeachersMajorPlanning.fromJsonTeachersMajorPlanning(
                        teachersmajorplanning))
                .toList();

        setState(() {
          if (teachersmajorplanning.isNotEmpty) {
            teacherHasSelectedMajors = true;
          }
        });

        logger.d(teachersmajorplanning.length);

        return teachersmajorplanning;
      } else {
        setState(() {
          teacherHasSelectedMajors = false;
        });
        logger.d('Error: ${response.statusCode}');
        throw Exception('Teacher has no selected majors');
      }
    } catch (e) {
      logger.d('Error: $e');
      throw Exception('An error occurred. Please try again.');
    }
  }

  Future<List<Major>> fetchMajorsDetails() async {
    try {
      final response = await http.post(
        getApiUrl('/Get/allMajor/Of/DepartmentsOfEducation'),
        body: json.encode({
          'departments_of_edu_id':
              widget.userDetails.teacher!.departmentsOfEducationId,
          'teacher_id': widget.userDetails.teacher!.teacherId,
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

  Future<Department> fetchDepartmentsDetails() async {
    try {
      final response = await http.post(
        getApiUrl('/Get/allMajor/Of/DepartmentsOfEducation'),
        body: json.encode({
          'department_id': widget.userDetails.teacher!.departmentId,
        }),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);
        Department department =
            Department.fromJsonDepartment(decodedJson['department']);
        return department;
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
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Сонгосон хөтөлбөр амжилттай нэмэгдлээ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ),
                  Icon(Icons.check_circle, color: Colors.green, size: 28),
                ],
              ),
              content: Text('Хөтөлбөр ${major.majorName} нэмэгдлээ'),
              actions: [
                TextButton(
                  onPressed: () async {
                    refreshMajorsPlanning();
                    refreshUserDetails();
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

  Future<void> _removeFromTeachersMajors(teacherId, majorId) async {
    try {
      final bool? confirmed = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Энэ хөтөлбөрийг устгахыг хүсч байна уу?'),
              content: Text('Багшааас хөтөлбөрийг устгах болно'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text('Үгүй'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text('Тийм, устга!'),
                ),
              ],
              icon: Icon(Icons.warning, color: Colors.orange, size: 40),
            );
          });

      if (confirmed == null || !confirmed) {
        return;
      } else {
        final response = await http.post(
          getApiUrl('/Remove/Major/From/Teacher'),
          body: json.encode({'teacher_id': teacherId, 'major_id': majorId}),
          headers: {'Content-Type': 'application/json'},
        ).timeout(Duration(seconds: 30));

        if (response.statusCode == 200) {
          refreshMajorsPlanning();
          final decodedJson = json.decode(response.body);
          logger.d(decodedJson);
          final deletedMajor = decodedJson['deleted_major'];

          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Амжилттай устгагдлаа!'),
                content:
                    Text('Утгагдсан хөтөлбөр нь ${deletedMajor['major_name']}'),
                actions: [
                  TextButton(
                    onPressed: () {
                      refreshUserDetails();
                      Navigator.pop(context);
                    },
                    child: Text('Буцах'),
                  ),
                ],
              );
            },
          );
        } else {
          throw Exception('Устгах хөтөлбөрийг олсонгүй!');
        }
      }
    } catch (e) {
      logger.e('Error: $e');
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
                      maxLines: 4,
                    ),
                  ),
                  Icon(Icons.warning, color: Colors.blue, size: 28),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                        '${widget.userDetails.user.fname} багшид: ${widget.userDetails.departmentOfEducation!.edDepartmentName}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        maxLines: 4),
                  ),
                  Icon(Icons.info, color: Colors.blue, size: 40),
                ],
              ),
              content: Text('одоогоор сонгосон хөтөлбөр байхгүй байна.'),
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
      } else if (response.statusCode == 202) {
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${decodedJson['message']}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      maxLines: 4,
                    ),
                  ),
                  Icon(Icons.cancel, color: Colors.red, size: 28),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Буцах", style: TextStyle(color: Colors.black)),
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    if (Foundation.kIsWeb) {
      logger.d('here');
      return _webWidget(screenWidth, screenHeight);
    } else if (io.Platform.isAndroid) {
      logger.d('herew');
      return _androidWidgetiosWidget(screenWidth, screenHeight);
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Хөтөлбөрүүд',
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
        child: Foundation.kIsWeb
            ? Center(
                child: _webWidget(screenWidth, screenHeight),
              )
            : Center(
                child: _androidWidgetiosWidget(screenWidth, screenHeight),
              ),
      ),
    );
  }

  Widget _androidWidgetiosWidget(screenWidth, screenHeight) {
    logger.d(screenHeight, screenWidth);
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0, right: 8.0, left: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder(
                  future: Future.wait([
                    futureMajorDetails,
                    futureDepartmentsDetails,
                    futureUserDetails
                  ]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text('Error loading data: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      List<Major> majors = snapshot.data![0] as List<Major>;
                      Department department = snapshot.data![1] as Department;
                      UserDetails userDetails =
                          snapshot.data![2] as UserDetails;

                      if (majors.isEmpty) {
                        return Center(child: Text('No majors available.'));
                      }
                      String departmentName = department.departmentName;

                      return Center(
                        child: Column(
                          children: [
                            Center(
                              child: SizedBox(
                                width: screenWidth * 0.4,
                                height: screenHeight * 0.8,
                                child: Scrollbar(
                                  thickness: 4.0,
                                  trackVisibility: true,
                                  thumbVisibility: true,
                                  child: CustomScrollView(
                                    slivers: [
                                      SliverToBoxAdapter(
                                        child: Container(
                                          color: Colors.blue[100],
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
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
                                                                'assets/images/icons/teachers_majors_selection.png'),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        '$departmentName - н хөтөлбөрүүд',
                                                        maxLines: 3,
                                                        textAlign:
                                                            TextAlign.center,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
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
                                                subtitle:
                                                    Text(major.majorsType),
                                                trailing: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
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
                                                              major.majorId);
                                                        },
                                                      ),
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
                        ),
                      );
                    } else {
                      return Center(child: Text('No majors available.'));
                    }
                  },
                ),
              ],
            ),
          ),
          teacherHasSelectedMajors == true
              ? Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FutureBuilder<List<TeachersMajorPlanning>>(
                        future: futureTeachersMajorPlanning,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text(
                                    'Error loading data: ${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            List<TeachersMajorPlanning> teachersMajorPlanning =
                                snapshot.data!;

                            if (teachersMajorPlanning.isEmpty) {
                              return Center(
                                  child: Text('No majors available.'));
                            }

                            return LayoutBuilder(
                              builder: (context, constraints) {
                                return Center(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 8.0,
                                                right: 8.0,
                                                left: 8.0,
                                                top: 8.0),
                                            child: Text(
                                              'Нийт сонгогдсон хөтөлбөрүүд: ${teachersMajorPlanning.length}',
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
                                          width: screenWidth * 0.4,
                                          height: screenHeight * 0.8,
                                          child: Scrollbar(
                                            controller: _scrollController,
                                            thickness: 4.0,
                                            trackVisibility: true,
                                            thumbVisibility: true,
                                            child: ListView.builder(
                                              controller: _scrollController,
                                              itemCount:
                                                  teachersMajorPlanning.length,
                                              itemBuilder: (context, index) {
                                                TeachersMajorPlanning
                                                    majorPlanning =
                                                    teachersMajorPlanning[
                                                        index];
                                                return Container(
                                                  width: 60,
                                                  height: 80,
                                                  color: Colors.white,
                                                  child: ListTile(
                                                    title: Text(majorPlanning
                                                        .majorName),
                                                    subtitle: Text(majorPlanning
                                                        .academicDegree),
                                                    trailing: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 10),
                                                          child: IconButton(
                                                            icon: Icon(
                                                                Icons.delete,
                                                                weight: 1.0),
                                                            onPressed: () {
                                                              _removeFromTeachersMajors(
                                                                  widget
                                                                      .userDetails
                                                                      .teacher!
                                                                      .teacherId,
                                                                  majorPlanning
                                                                      .majorId);
                                                            },
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 10),
                                                          child: IconButton(
                                                            icon: Image.asset(
                                                              'assets/images/icons/teacher_teaching.png',
                                                            ),
                                                            onPressed: () {
                                                              Navigator
                                                                  .pushNamed(
                                                                context,
                                                                '/teacher_courses',
                                                                arguments: widget
                                                                    .userDetails,
                                                              );
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
                                  ),
                                );
                              },
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
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: SizedBox(
                    width: screenWidth * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(
                                  'Одоогоор багшид оноогдсон хөтөлбөр байхгүй байна',
                                  style: TextStyle(fontSize: 16.0),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                                trailing: Icon(Icons.warning,
                                    color: Colors.orange, size: 40),
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

  Widget _webWidget(screenWidth, screenHeight) {
    logger.d(screenHeight, screenWidth);
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0, right: 8.0, left: 8.0, top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder(
                future: Future.wait([
                  futureMajorDetails,
                  futureDepartmentsDetails,
                  futureUserDetails
                ]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Error loading data: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    List<Major> majors = snapshot.data![0] as List<Major>;
                    Department department = snapshot.data![1] as Department;
                    UserDetails userDetails = snapshot.data![2] as UserDetails;

                    if (majors.isEmpty) {
                      return Center(child: Text('No majors available.'));
                    }
                    String departmentName = department.departmentName;

                    return Center(
                      child: Column(
                        children: [
                          Center(
                            child: SizedBox(
                              width: screenWidth * 0.5,
                              height: screenHeight * 0.8,
                              child: Scrollbar(
                                thickness: 4.0,
                                trackVisibility: true,
                                thumbVisibility: true,
                                child: CustomScrollView(
                                  slivers: [
                                    SliverToBoxAdapter(
                                      child: Card(
                                        color: Colors.blue[100],
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            LayoutBuilder(
                                              builder: (context, constraints) {
                                                bool isSmallScreen =
                                                    constraints.maxWidth < 600;
                                                return Flex(
                                                  direction: isSmallScreen
                                                      ? Axis.horizontal
                                                      : Axis.vertical,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    SizedBox(
                                                      width: screenWidth * 0.48,
                                                      child: Card(
                                                        elevation: 12,
                                                        color: Color(
                                                            0xFFFFD700), // Academic Yellow
                                                        child: ListTile(
                                                          title: Text(
                                                              'Багш ${userDetails.user.fname}, ${userDetails.teacher!.teacherCode}'),
                                                          subtitle: Text(
                                                              '${userDetails.user.userRole}, ${userDetails.teacher!.jobTitle}'),
                                                          trailing: Image.asset(
                                                              'assets/images/icons/teachers_majors_selection.png'),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: screenWidth * 0.48,
                                                      child: Card(
                                                        elevation: 12,
                                                        color: Color.fromARGB(
                                                            255,
                                                            88,
                                                            146,
                                                            218), // Blue
                                                        child: Center(
                                                          child: ListTile(
                                                            title: Text(
                                                              '$departmentName - н хөтөлбөрүүд',
                                                              maxLines: 3,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
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
                                            child: Card(
                                              child: ListTile(
                                                title: Text(major.majorName),
                                                subtitle:
                                                    Text(major.majorsType),
                                                trailing: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
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
                                                              major.majorId);
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
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
                      ),
                    );
                  } else {
                    return Center(child: Text('No majors available.'));
                  }
                },
              ),
            ],
          ),
          teacherHasSelectedMajors == true
              ? Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FutureBuilder<List<TeachersMajorPlanning>>(
                        future: futureTeachersMajorPlanning,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text(
                                    'Error loading data: ${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            List<TeachersMajorPlanning> teachersMajorPlanning =
                                snapshot.data!;

                            if (teachersMajorPlanning.isEmpty) {
                              return Center(
                                  child: Text('No majors available.'));
                            }

                            return LayoutBuilder(
                              builder: (context, constraints) {
                                return Center(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: SizedBox(
                                              width: 180,
                                              height: 85,
                                              child: Card(
                                                elevation: 12,
                                                color: Color.fromARGB(
                                                    255, 88, 146, 218),
                                                child: Center(
                                                  child: ListTile(
                                                    title: Text(
                                                      'Багшид оноогдсон хөтөлбөрүүд: ${teachersMajorPlanning.length}',
                                                      maxLines: 3,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Center(
                                        child: SizedBox(
                                          width: screenWidth * 0.5,
                                          height: screenHeight * 0.8,
                                          child: Scrollbar(
                                            controller: _scrollController,
                                            thickness: 4.0,
                                            trackVisibility: true,
                                            thumbVisibility: true,
                                            child: ListView.builder(
                                              controller: _scrollController,
                                              itemCount:
                                                  teachersMajorPlanning.length,
                                              itemBuilder: (context, index) {
                                                TeachersMajorPlanning
                                                    majorPlanning =
                                                    teachersMajorPlanning[
                                                        index];
                                                return Container(
                                                  width: 60,
                                                  height: 90,
                                                  color: Colors.white,
                                                  child: Card(
                                                    child: Center(
                                                      child: ListTile(
                                                        title: Text(
                                                          majorPlanning
                                                              .majorName,
                                                          style: TextStyle(
                                                              fontSize: 4),
                                                        ),
                                                        subtitle: Text(
                                                          majorPlanning
                                                              .academicDegree,
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                        trailing: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right: 5),
                                                              child: IconButton(
                                                                icon: Icon(
                                                                    Icons
                                                                        .delete,
                                                                    weight:
                                                                        1.0),
                                                                onPressed: () {
                                                                  _removeFromTeachersMajors(
                                                                      widget
                                                                          .userDetails
                                                                          .teacher!
                                                                          .teacherId,
                                                                      majorPlanning
                                                                          .majorId);
                                                                },
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right: 5),
                                                              child: IconButton(
                                                                icon:
                                                                    Image.asset(
                                                                  'assets/images/icons/teacher_teaching.png',
                                                                ),
                                                                onPressed: () {
                                                                  Navigator
                                                                      .pushNamed(
                                                                    context,
                                                                    '/teacher_courses',
                                                                    arguments:
                                                                        widget
                                                                            .userDetails,
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
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
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: SizedBox(
                    width: screenWidth * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Card(
                                child: ListTile(
                                  title: Text(
                                    'Одоогоор багшид оноогдсон хөтөлбөр байхгүй байна',
                                    style: TextStyle(fontSize: 16.0),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                  trailing: Icon(Icons.warning,
                                      color: Colors.orange, size: 40),
                                ),
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
}
