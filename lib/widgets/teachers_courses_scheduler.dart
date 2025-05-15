import 'package:studentsystem/models/department.dart';
import 'package:studentsystem/models/teacherscourseplanning.dart';
import 'package:studentsystem/models/teachersmajorplanning.dart';
import 'package:studentsystem/widgets/teacher_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:studentsystem/models/auth_user.dart';
import 'package:studentsystem/api/get_api_url.dart';
import 'package:logger/logger.dart';
import 'package:studentsystem/models/teacher.dart';
import 'package:studentsystem/models/user_details.dart';
import 'package:studentsystem/models/departments_of_education.dart';
import 'package:studentsystem/constants/bottom_navigation.dart';
import 'package:studentsystem/constants/teacher_drawer.dart';
import 'package:studentsystem/models/teachersschedule.dart';
import 'package:studentsystem/models/classrooms.dart';

var logger = Logger();

class TeacherCoursesScheduler extends StatefulWidget {
  const TeacherCoursesScheduler({required this.userDetails, super.key});

  final UserDetails userDetails;

  @override
  _TeacherCoursesSchedulerState createState() =>
      _TeacherCoursesSchedulerState();
}

class _TeacherCoursesSchedulerState extends State<TeacherCoursesScheduler> {
  Key _key = UniqueKey();
  //late Future<UserDetails> userDetails;
  final int rows = 8;
  final int cols = 7;
  Map<int, TeachersCoursePlanning> itemPositions = {};
  Set<TeachersCoursePlanning> placedItems = {};
  late String departmentName = '';
  List<String> weekdays = [];
  late String currentDayOfWeek = '';
  late Future<UserDetails> futureUserDetails;
  late Future<List> futureTeachersAutoSchedule;
  late int prevSchedule = 0;
  late Future<List<Classroom>> futureClassrooms;
  late Future<List> futureTeachersSchedule;
  late int compareValue;
  Set<String> classroomSearchType = {};
  String classroomSearchTypeToServer = '';
  final List<String> allWeekdays = [
    'Даваа',
    'Мягмар',
    'Лхагва',
    'Пүрэв',
    'Баасан',
    'Бямба',
    'Ням'
  ];
  Map<int, TeachersCoursePlanning> teachersCourses = {};
  Map<int, TeachersCoursePlanning> teachersCoursesLectures = {};
  Map<TeachersCoursePlanning, Classroom?> teachersCoursesClassrooms = {};
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Widget> _screens = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _screens = [
      TeacherDashboard(userId: widget.userDetails.user.userId),
    ];
    futureUserDetails = fetchUserDetails(widget.userDetails.user.userId);
    futureTeachersAutoSchedule = fetchTeachersAutoSchedule();
    futureTeachersSchedule = fetchTeachersSchedule();
    classroomSearchType = fetchClassroomsType();
    futureClassrooms = fetchClassrooms();
    _generateWeekdays();
    _fetchTeachersCourses();
  }

  void _reloadPage() {
    setState(() {
      _key = UniqueKey();
    });
  }

  void _fetchTeachersCourses() {
    for (var coursePlanning in widget.userDetails.teachersCoursePlanning!) {
      teachersCourses[widget.userDetails.teachersCoursePlanning!
          .indexOf(coursePlanning)] = coursePlanning;

      TeachersCoursePlanning courseLecture = TeachersCoursePlanning(
        teacherCoursePlanningId: coursePlanning.teacherCoursePlanningId,
        teacherId: coursePlanning.teacherId,
        majorId: coursePlanning.majorId,
        courseId: coursePlanning.courseId,
        courseName: coursePlanning.courseName,
        credit: coursePlanning.credit,
        createdAt: coursePlanning.createdAt,
        majorName: coursePlanning.majorName,
        courseCode: coursePlanning.courseCode,
        teacherMajorId: coursePlanning.teacherMajorId,
        courseLecture: 1,
      );
      teachersCoursesLectures[widget.userDetails.teachersCoursePlanning!
          .indexOf(coursePlanning)] = courseLecture;
    }
    setState(() {
      compareValue = teachersCourses.length * 2;
    });
  }

  Set<String> fetchClassroomsType() {
    for (var coursePlanning in widget.userDetails.teachersCoursePlanning!) {
      classroomSearchType.add(coursePlanning.courseCode.substring(0, 3));
    }
    classroomSearchTypeToServer = classroomSearchType.join(',');
    return classroomSearchType;
  }

  String _parseAbbreviation(itemToParse) {
    String parseResult = '';

    for (var coursePlanning in teachersCourses.entries) {
      if (coursePlanning.value == itemToParse) {
        parseResult +=
            '${widget.userDetails.teachersCoursePlanning![coursePlanning.key].courseName} ';
        parseResult += widget
            .userDetails.teachersCoursePlanning![coursePlanning.key].courseCode;
      }
    }
    return parseResult;
  }

  String _parseAbbreviationLecture(itemToParse) {
    String parseResult = '';

    for (var coursePlanning in teachersCoursesLectures.entries) {
      if (coursePlanning.value == itemToParse) {
        parseResult +=
            '${teachersCoursesLectures[coursePlanning.key]!.courseName} Лекц ';
        parseResult += teachersCoursesLectures[coursePlanning.key]!.courseCode;
      }
    }
    return parseResult;
  }

  String encodeTeachersCoursesClassrooms(
      Map<TeachersCoursePlanning, Classroom?> dataToEncode) {
    List<Map<String, dynamic>> encodedList = dataToEncode.entries.map((entry) {
      return {
        'teachersCoursePlanning': entry.key.toJsonTeachersCoursePlanning(),
        'classroom': entry.value?.toJsoClassroom(),
      };
    }).toList();
    return jsonEncode(encodedList);
  }

  String encodeCoursesClassrooms(
      Map<int, TeachersCoursePlanning> dataToEncode) {
    List<Map<String, String>> encodedList = dataToEncode.entries.map((entry) {
      return {
        'daysOfWeekPositionToint': entry.key.toString(),
        'teachersCoursePlanningId':
            '${entry.value.teacherCoursePlanningId.toString()} Лекц',
      };
    }).toList();
    return jsonEncode(encodedList);
  }

  void refreshUserDetails() {
    setState(() {
      futureUserDetails = fetchUserDetails(widget.userDetails.user.userId);
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
        List<TeachersMajorPlanning> teachersmajorplanning =
            (decodedJson['teachers_major'] as List)
                .map((teachersmajorplanning) =>
                    TeachersMajorPlanning.fromJsonTeachersMajorPlanning(
                        teachersmajorplanning))
                .toList();
        List<TeachersCoursePlanning> teacherscourseplanning =
            (decodedJson['selected_major_courses'] as List)
                .map((teacherscourseplanning) =>
                    TeachersCoursePlanning.fromJsonTeachersCoursePlanning(
                        teacherscourseplanning))
                .toList();

        return UserDetails(
          user: user,
          teacher: teacher,
          student: null,
          department: department,
          departmentOfEducation: departmentOdEducation,
          teachersMajorPlanning: teachersmajorplanning,
          teachersCoursePlanning: teacherscourseplanning,
        );
      } else {
        logger.d('Error: ${response.statusCode}');
        throw Exception('User does not exist!');
      }
    } catch (e) {
      logger.d('Error: $e');
      throw Exception('An error occurred. Please try again.');
    }
  }

  Future<List<Classroom>> fetchClassrooms() async {
    try {
      final response = await http.get(
        getApiUrl(
            '/Get/Classrooms?classroomSearchType=$classroomSearchTypeToServer'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);
        List<Classroom> allClassrooms = ((decodedJson['all_class_rooms']
                as List)
            .map((allClassrooms) => Classroom.fromJsonClassroom(allClassrooms))
            .toList());

        return allClassrooms;
      } else {
        logger.d('Error: ${response.statusCode}');
        throw Exception('User does not exist!');
      }
    } catch (e) {
      logger.d('Error: $e');
      throw Exception('An error occurred. Please try again.');
    }
  }

  Future<List> fetchTeachersSchedule() async {
    try {
      final response = await http.get(
        getApiUrl(
            '/Get/Teachers/Selected/Courses/Schedules?teacher_id=${widget.userDetails.teacher!.teacherId}'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 30));

      logger.d(response.statusCode);
      logger.d(response.body);

      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);
        List teachersAllSchedules =
            ((decodedJson['teachers_made_schedules_array'] as List)
                .map((teachersAllSchedules) => (teachersAllSchedules))
                .toList());

        for (var schedule in teachersAllSchedules) {
          int schedulePosition = (schedule['schedules_timetable_position']);

          int courseId = (schedule['course_id']);

          for (var coursePlanning in teachersCourses.values) {
            if (courseId == coursePlanning.courseId) {
              setState(() {
                placedItems.add(coursePlanning);
                logger.d(placedItems.last);
                itemPositions[schedulePosition] = coursePlanning;
              });
            }
          }
        }

        List teachersAllSchedulesLecture = ((decodedJson[
                'teachers_made_schedules_array_lecture'] as List)
            .map(((teachersAllSchedulesLecture) => teachersAllSchedulesLecture))
            .toList());
        for (var schedule in teachersAllSchedulesLecture) {
          int schedulePosition = (schedule['schedules_timetable_position']);

          int courseId = (schedule['course_id']);

          for (var coursePlanning in teachersCoursesLectures.values) {
            if (courseId == coursePlanning.courseId) {
              setState(() {
                placedItems.add(coursePlanning);
                itemPositions[schedulePosition] = coursePlanning;
              });
            }
          }
        }

        setState(() {
          compareValue =
              teachersAllSchedulesLecture.length + teachersAllSchedules.length;
        });

        return teachersAllSchedules + teachersAllSchedulesLecture;
      } else if (response.statusCode == 201) {
        final decodedJson = json.decode(response.body);
        logger.d(decodedJson['message']);
        List<TeachersSchedule> teachersAllSchedules = [];

        return teachersAllSchedules;
      } else {
        logger.d('Error: ${response.statusCode}');
        throw Exception('User does not exist!');
      }
    } catch (e) {
      logger.d('Error: $e');
      throw Exception('An error occurred. Please try again.');
    }
  }

  Future<List> fetchTeachersAutoSchedule() async {
    try {
      final response = await http.get(
        getApiUrl('/Get/Teachers/Auto/Schedule'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 30));

      logger.d('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);
        logger.d(decodedJson);
        List scheduledClassrooms =
            (decodedJson['scheduled_classrooms_array'] as List)
                .map((scheduledClassrooms) => (scheduledClassrooms))
                .toList();
        List scheduledClassroomsLectures =
            (decodedJson['scheduled_classrooms_lecture_array'] as List)
                .map((scheduledClassrooms) => (scheduledClassrooms))
                .toList();

        prevSchedule =
            scheduledClassrooms.length + scheduledClassroomsLectures.length;

        return [scheduledClassrooms, scheduledClassroomsLectures];
      } else if (response.statusCode == 201) {
        final decodedJson = json.decode(response.body);
        logger.d(decodedJson['message']);
        List scheduledClassrooms = [];
        scheduledClassrooms.add(null);
        List scheduledClassroomsLectures = [];
        scheduledClassroomsLectures.add(null);

        return [scheduledClassrooms, scheduledClassroomsLectures];
      } else {
        logger.d('Error: ${response.statusCode}');
        throw Exception('Server Error!');
      }
    } catch (e) {
      logger.d('Error: $e');
      throw Exception('An error occurred. Please try again.');
    }
  }

  void addClassroomsToTeachersCourses() async {
    try {
      final bool? confirmed = await showDialog<bool?>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              '${teachersCoursesClassrooms.length} - н хичээлийн сонгосон хуваарийг шалгах?',
              /*'${course.courseName} хичээлийг № ${classroom.classroomNumber} ангид $dayOfWeek гарагт $periodOfDay-р цагийн хуваарьт нэмэх?'*/
              style: TextStyle(fontSize: 20),
            ),
            content: Text(
              '', /*'Багтаамж: ${classroom.capacity}, Проектор: ${classroom.projector}'*/
            ),
            actions: [
              TextButton(
                child: Text('Үгүй'),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
              TextButton(
                child: Text('Тийм'),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
            icon: Icon(Icons.info, color: Colors.blue, size: 40),
          );
        },
      );

      if (confirmed == false) {
        return null;
      } else {
        String courseClassroomDataToSend =
            encodeTeachersCoursesClassrooms(teachersCoursesClassrooms);
        String coursesWeekDaysPositions =
            encodeCoursesClassrooms(itemPositions);

        final response = await http.post(
          getApiUrl('/Add/Classroom/To/Teachers/Course'),
          body: json.encode({
            'teachersCoursesClassrooms': courseClassroomDataToSend,
            'coursesClassroomsPositions': coursesWeekDaysPositions,
            'teacher': widget.userDetails.teacher!,
            'teacher_name': widget.userDetails.user.fname,
            /* 'classroom': classroom.toJsoClassroom(),
            'course': course,
            'dayOfWeek': dayOfWeek,
            'periodOfDay': periodOfDay, */
          }),
          headers: {'Content-Type': 'application/json'},
        ).timeout(Duration(seconds: 30));

        if (response.statusCode == 200) {
          final decodedJson = json.decode(response.body);
          logger.d(decodedJson);
          final addedClassroom = decodedJson['added_classroom'];

          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Хичээлийг амжилттай нэмлээ!'),
                content: Text(
                    '' /*'$dayOfWeek гарагт $periodOfDay-р цагт хуваарийг нэмлээ!'*/),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Буцах'),
                  )
                ],
                icon: Icon(Icons.check_circle, color: Colors.green, size: 40),
              );
            },
          );
        } else if (response.statusCode == 400) {
          final decodedJson = json.decode(response.body);
          logger.d(decodedJson);
          final List errorMessages = (decodedJson['errorMessages']);

          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Хичээлүүдийг нэмэхэд алдаа гарлаа!'),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: errorMessages.map<Widget>((message) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(message),
                    );
                  }).toList(),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Буцах'),
                  )
                ],
                icon: Icon(Icons.check_circle, color: Colors.green, size: 40),
              );
            },
          );
        }
      }
    } catch (error) {
      logger.d('Error: $error');
      throw Exception('An error occurred. Please try again.');
    }
  }

  Future<void> _removeScheduleFromTeacher(
      TeachersCoursePlanning coursePlanning) async {
    int schedulePosition = itemPositions.entries
        .where((coursePlan) => coursePlan.value == coursePlanning)
        .first
        .key;
    logger.d(allWeekdays[schedulePosition % 7]);
    try {
      final bool? confirmed = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Энэ хуваарийг хасахыг хүсч байн уу?'),
            content: Text('Багшаас ${coursePlanning.courseName}'
                ' ${allWeekdays[schedulePosition % 7]} гарагийн ${((schedulePosition + 1) / 7).toDouble().ceil()} хуваарийг хасна!'),
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
                child: Text('Тийм хасах'),
              ),
            ],
          );
        },
      );

      if (confirmed == true) {
        final response = await http.delete(
          getApiUrl('/Remove/Schedule/From/Teacher'),
          body: json.encode({
            'teacherId': widget.userDetails.teacher?.teacherId,
            'courseToDelete': coursePlanning.toJsonTeachersCoursePlanning(),
          }),
          headers: {'Content-Type': 'application/json'},
        ).timeout(Duration(seconds: 30));

        if (response.statusCode == 200) {
          refreshUserDetails();
          _reloadPage();
          build(context);
          final decodedJson = json.decode(response.body);
          final deletedSchedule = decodedJson['message'];
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Хасагдлаа'),
                content: Text(
                    'Багшаас ${coursePlanning.courseName} $deletedSchedule'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Буцах'),
                  ),
                ],
                icon: Icon(Icons.delete, color: Colors.red, size: 40),
              );
            },
          );
        }
      } else {
        throw Exception('Failed to add major');
      }
    } catch (e) {
      logger.d('Error: $e');
      throw Exception('An error occurred. Please try again.');
    }
  }

  void _generateWeekdays() {
    DateTime now = DateTime.now();
    int currentDay = now.weekday - 1;
    currentDayOfWeek = allWeekdays[currentDay];
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

  void _existingScheduleError(int dayIndex, receivedItem) {
    double index = dayIndex.toDouble();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Алдаа!", style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text(
              "${allWeekdays[((index + 1) - (((index + 1) / 7).toInt() * 7) - 1).toInt() == -1 ? 6 : ((index + 1) - (((index + 1) / 7).toInt() * 7) - 1).toInt()]} гарагт ${((index + 1) / 7).toDouble().ceil()} -р цагт хичээлийн хуваарь байрлаж байна! Өөр хуваарь сонгох эсвэл байгаа хуваарийг өөрчилнө үү!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Ойлоглоо"),
            ),
          ],
        );
      },
    );
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
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    List<String> weekDays = [
      'Даваа',
      'Мягмар',
      'Лхагва',
      'Пүрэв',
      'Баасан',
      'Бямба',
      'Ням'
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8, right: 8.0, left: 8.0),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  height: 580,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(width: 50),
                          ...weekDays.map(
                            (day) => Container(
                              width: 100,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black38, width: 1),
                                color: Colors.grey[300],
                              ),
                              child: Text(day,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: List.generate(rows, (rowIndex) {
                          return Row(
                            children: [
                              Container(
                                width: 50,
                                height: 60,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black38, width: 1),
                                  color: Colors.grey[200],
                                ),
                                child: Text("${rowIndex + 1}"),
                              ),
                              ...List.generate(cols, (colIndex) {
                                int index = rowIndex * cols + colIndex;

                                return DragTarget<TeachersCoursePlanning>(
                                  onAcceptWithDetails: (receivedItem) {
                                    setState(() {
                                      TeachersCoursePlanning receivedData =
                                          receivedItem.data;

                                      if (itemPositions.containsKey(index)) {
                                        _existingScheduleError(
                                            index, receivedData);
                                        return;
                                      }

                                      if (receivedData.courseLecture == null) {
                                        itemPositions.removeWhere(
                                            (key, value) =>
                                                value == receivedData);
                                        placedItems.remove(receivedData);

                                        itemPositions[index] = receivedData;
                                        placedItems.add(receivedData);
                                        teachersCourses.remove(receivedData);
                                      } else {
                                        itemPositions.removeWhere(
                                            (key, value) =>
                                                value == receivedData);
                                        placedItems.remove(receivedData);

                                        itemPositions[index] = receivedData;
                                        placedItems.add(receivedData);
                                        teachersCoursesLectures
                                            .remove(receivedData);
                                      }
                                    });
                                  },
                                  onLeave: (receivedItem) {
                                    TeachersCoursePlanning receivedData =
                                        receivedItem!;

                                    if (itemPositions
                                        .containsValue(receivedData)) {
                                      setState(() {
                                        itemPositions.removeWhere(
                                            (key, value) =>
                                                value == receivedData);
                                        placedItems.remove(receivedData);
                                      });
                                    }

                                    if (receivedData.courseLecture == null) {
                                      setState(() {
                                        if (teachersCourses.containsKey(
                                            receivedData.hashCode)) {
                                          teachersCourses[receivedData
                                              .hashCode] = receivedData;
                                        }
                                      });
                                    } else {
                                      setState(() {
                                        if (teachersCoursesLectures.containsKey(
                                            receivedData.hashCode)) {
                                          teachersCoursesLectures[receivedData
                                              .hashCode] = receivedData;
                                        }
                                      });
                                    }
                                  },
                                  builder:
                                      (context, candidateData, rejectedData) {
                                    return itemPositions[index]
                                                ?.courseLecture ==
                                            null
                                        ? GestureDetector(
                                            onLongPress: () async {
                                              String parseResult =
                                                  await _parseAbbreviation(
                                                      itemPositions[index]);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(parseResult),
                                                  duration:
                                                      Duration(seconds: 1),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              width: 100,
                                              height: 60,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black38,
                                                    width: 1),
                                                color: itemPositions
                                                        .containsKey(index)
                                                    ? Colors.blueAccent
                                                    : Colors.white,
                                              ),
                                              child:
                                                  itemPositions[index] != null
                                                      ? GestureDetector(
                                                          onDoubleTap: () => {
                                                            _removeScheduleFromTeacher(
                                                                itemPositions[
                                                                    index]!)
                                                          },
                                                          child: Draggable<
                                                              TeachersCoursePlanning>(
                                                            data: itemPositions[
                                                                index]!,
                                                            feedback: Material(
                                                              color: Colors
                                                                  .transparent,
                                                              child: _buildDraggableWidget(
                                                                  itemPositions[
                                                                      index]!),
                                                            ),
                                                            childWhenDragging:
                                                                Opacity(
                                                              opacity: 0.5,
                                                              child: _buildDraggableWidget(
                                                                  itemPositions[
                                                                      index]!),
                                                            ),
                                                            child:
                                                                _buildDraggableWidgetWithIcon(
                                                                    itemPositions[
                                                                        index]!,
                                                                    index),
                                                          ),
                                                        )
                                                      : null,
                                            ),
                                          )
                                        : GestureDetector(
                                            onLongPress: () async {
                                              String parseResult =
                                                  await _parseAbbreviationLecture(
                                                      itemPositions[index]);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(parseResult),
                                                  duration:
                                                      Duration(seconds: 1),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              width: 100,
                                              height: 60,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black38,
                                                    width: 1),
                                                color: itemPositions
                                                        .containsKey(index)
                                                    ? Colors.orangeAccent
                                                    : Colors.white,
                                              ),
                                              child: itemPositions[index] !=
                                                      null
                                                  ? Draggable<
                                                      TeachersCoursePlanning>(
                                                      data:
                                                          itemPositions[index]!,
                                                      feedback: Material(
                                                        color:
                                                            Colors.transparent,
                                                        child:
                                                            _buildDraggableWidgetLecture(
                                                                itemPositions[
                                                                    index]!),
                                                      ),
                                                      childWhenDragging:
                                                          Opacity(
                                                        opacity: 0.5,
                                                        child:
                                                            _buildDraggableWidgetLecture(
                                                                itemPositions[
                                                                    index]!),
                                                      ),
                                                      child:
                                                          _buildDraggableWidgetWithLectureIcon(
                                                              itemPositions[
                                                                  index]!,
                                                              index),
                                                    )
                                                  : null,
                                            ),
                                          );
                                  },
                                );
                              }),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: screenWidth,
                height: 140,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double itemWidth = 80;
                    int itemsPerRow =
                        (constraints.maxWidth / itemWidth).floor();

                    List<List<TeachersCoursePlanning>> rows = [];
                    List<TeachersCoursePlanning> courseNames =
                        teachersCourses.values.toList();
                    for (int i = 0; i < courseNames.length; i += itemsPerRow) {
                      rows.add(courseNames.sublist(
                          i,
                          i + itemsPerRow > courseNames.length
                              ? courseNames.length
                              : i + itemsPerRow));
                    }

                    List<List<TeachersCoursePlanning>> rowsLecture = [];
                    List<TeachersCoursePlanning> courseLectureNames =
                        teachersCoursesLectures.values.toList();
                    for (int i = 0;
                        i < courseLectureNames.length;
                        i += itemsPerRow) {
                      rowsLecture.add(courseLectureNames.sublist(
                          i,
                          i + itemsPerRow > courseLectureNames.length
                              ? courseLectureNames.length
                              : i + itemsPerRow));
                    }

                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: rows.map((rowItems) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: SizedBox(
                                    height: 80,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: rowItems.map((item) {
                                        return placedItems.contains(item)
                                            ? Opacity(
                                                opacity: 0.3,
                                                child:
                                                    _buildDraggableWidget(item),
                                              )
                                            : GestureDetector(
                                                onLongPress: () async {
                                                  String parseResult =
                                                      await _parseAbbreviation(
                                                          item);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content:
                                                          Text(parseResult),
                                                      duration:
                                                          Duration(seconds: 1),
                                                    ),
                                                  );
                                                },
                                                child: Draggable<
                                                    TeachersCoursePlanning>(
                                                  data: item,
                                                  feedback: Material(
                                                    color: Colors.transparent,
                                                    child:
                                                        _buildDraggableWidget(
                                                            item),
                                                  ),
                                                  childWhenDragging: Opacity(
                                                    opacity: 0.5,
                                                    child:
                                                        _buildDraggableWidget(
                                                            item),
                                                  ),
                                                  child: _buildDraggableWidget(
                                                      item),
                                                ),
                                              );
                                      }).toList(),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 14.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                children: rowsLecture.map((rowItems) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: SizedBox(
                                      height: 80,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: rowItems.map((item) {
                                          return placedItems.contains(item)
                                              ? Opacity(
                                                  opacity: 0.3,
                                                  child:
                                                      _buildDraggableWidgetLecture(
                                                          item),
                                                )
                                              : GestureDetector(
                                                  onLongPress: () async {
                                                    String parseResult =
                                                        await _parseAbbreviationLecture(
                                                            item);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content:
                                                            Text(parseResult),
                                                        duration: Duration(
                                                            seconds: 1),
                                                      ),
                                                    );
                                                  },
                                                  child: Draggable<
                                                      TeachersCoursePlanning>(
                                                    data: item,
                                                    feedback: Material(
                                                      color: Colors.transparent,
                                                      child:
                                                          _buildDraggableWidgetLecture(
                                                              item),
                                                    ),
                                                    childWhenDragging: Opacity(
                                                      opacity: 0.5,
                                                      child:
                                                          _buildDraggableWidgetLecture(
                                                              item),
                                                    ),
                                                    child:
                                                        _buildDraggableWidgetLecture(
                                                            item),
                                                  ),
                                                );
                                        }).toList(),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            top: 540,
            left: 225,
            child: ElevatedButton(
              onPressed: () {
                if (teachersCoursesClassrooms.length !=
                    (teachersCourses.length * 2) - prevSchedule) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Заавал бүх хичээлийн хуваарийг болон хичээл орох ангийг сонгосон байх ёстой!'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                } else {
                  addClassroomsToTeachersCourses();
                }
              },
              child: Text('Хуваариудыг шалгах'),
            ),
          ),

          /*
          Positioned(
              top: 540,
              left: 225,
              child: compareValue == teachersCourses.length * 2
                  ? ElevatedButton(
                      onPressed: () {
                        if (teachersCoursesClassrooms.length !=
                            teachersCourses.length * 2) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Заавал бүх хичээлийн хуваарийг болон хичээл орох ангийг сонгосон байх ёстой!'),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        } else {
                          addClassroomsToTeachersCourses();
                        }
                      },
                      child: Text('Хуваариудыг шалгах'),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        null;
                      },
                      child: Text('Хуваариудыг шалгах'),
                    )),
           */
        ],
      ),
    );
  }

  Widget _buildDraggableWidget(TeachersCoursePlanning course) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Builder(builder: (context) {
        return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              course.courseName
                  .split(' ')
                  .map((string) => string[0])
                  .join('')
                  .toUpperCase(),
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDraggableWidgetWithIcon(
      TeachersCoursePlanning course, dayIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Builder(builder: (context) {
        return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(12),
          ),
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return FutureBuilder(
                    future: Future.wait(
                        [futureClassrooms, futureTeachersAutoSchedule]),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return AlertDialog(
                          title: Text('Select Classroom'),
                          content: CircularProgressIndicator(),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel'),
                            ),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('Failed to load classrooms'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close the dialog
                              },
                              child: Text('Close'),
                            ),
                          ],
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return AlertDialog(
                          title: Text('No Classrooms Available'),
                          content: Text('There are no classrooms to display.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Close'),
                            ),
                          ],
                        );
                      } else {
                        List<Classroom> classrooms =
                            snapshot.data![0] as List<Classroom>;
                        List scheduledClassrooms = snapshot.data![1][0];
                        List scheduledClassroomsLectures = snapshot.data![1][1];
                        return AlertDialog(
                          title: Text('Хичээл орох анги сонгоно уу!'),
                          content: Container(
                            color: Colors.white70,
                            width: double.maxFinite,
                            height: 300,
                            child: ListView.builder(
                              itemCount: classrooms.length,
                              itemBuilder: (context, index) {
                                return _buildScheduledClassroomsWidget(
                                    classrooms[index],
                                    dayIndex,
                                    course,
                                    scheduledClassrooms);
                              },
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Буцах'),
                            ),
                          ],
                        );
                      }
                    },
                  );
                },
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  course.courseName
                      .split(' ')
                      .map((string) => string[0])
                      .join('')
                      .toUpperCase(),
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                Icon(Icons.place, color: Colors.white),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDraggableWidgetLecture(TeachersCoursePlanning course) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Builder(builder: (context) {
        return Container(
          width: 100,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.orangeAccent,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              '${course.courseName.split(' ').map((course) => course[0]).join('').toUpperCase()} Лекц',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }),
    );
  }

/*
  Widget _buildDraggableWidgetWithLectureIcon(
      TeachersCoursePlanning course, dayIndex) {
    String dayOfWeek =
        ('${allWeekdays[((dayIndex + 1) - (((dayIndex + 1) / 7).toInt() * 7) - 1)]} гараг');

    String periodOfDay =
        ('${((dayIndex + 1) / 7).toDouble().ceil().toString()}-р цаг');

    bool exists;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Builder(
        builder: (context) {
          return FutureBuilder(
            future: futureTeachersAutoSchedule,
            builder: (context, asyncSnapshot) {
              List scheduledClassroomsLectures = asyncSnapshot.data![1];
              if (scheduledClassroomsLectures[0] == null) {
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 7.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${course.courseName.split(' ').map((course) => course[0]).join('').toUpperCase()} Лекц',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        Icon(Icons.place, color: Colors.white),
                      ],
                    ),
                  ),
                );
              } else {
                exists = scheduledClassroomsLectures.any((item) =>
                    item['time'] == periodOfDay &&
                    item['days'] == dayOfWeek &&
                    item['teacher_id'] == course.teacherId);

                if (exists == true) {
                  teachersCoursesClassrooms[course] = null;
                  placedItems.remove(course);
                  itemPositions.remove(dayIndex);
                }

                /*
                  if (exists == true) {
                    /* 
                    return Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          //
                        },
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 7.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${course.courseName.split(' ').map((course) => course[0]).join('').toUpperCase()} Лекц',
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                Icon(Icons.place, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                    */
                    null;
                  } else {
                    return Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          //
                        },
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 7.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${course.courseName.split(' ').map((course) => course[0]).join('').toUpperCase()} Лекц',
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                Icon(Icons.place, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  */
              }

              return exists == true
                  ?
                  /*
                  Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color:
                            exists == true ? Colors.orangeAccent : Colors.grey,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          //
                        },
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 7.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${course.courseName.split(' ').map((course) => course[0]).join('').toUpperCase()} Лекц',
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                Icon(Icons.place, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    */
                  GestureDetector(
                      onTap: () {
                        // Show AlertDialog if exists is true
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Alert'),
                            content: Text('This course was already taken!'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : Text('lol');
            },
          );
        },
      ),
    );
  }
*/

  Widget _buildDraggableWidgetWithLectureIcon(
      TeachersCoursePlanning course, dayIndex) {
    teachersCoursesClassrooms[course] = null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Builder(builder: (context) {
        return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.orangeAccent,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(12),
          ),
          child: GestureDetector(
            onTap: () {
              //
            },
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.only(top: 7.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${course.courseName.split(' ').map((course) => course[0]).join('').toUpperCase()} Лекц',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildScheduledClassroomsWidget(Classroom classroom, int dayIndex,
      TeachersCoursePlanning course, List scheduledClassrooms) {
    String dayOfWeek =
        ('${allWeekdays[((dayIndex + 1) - (((dayIndex + 1) / 7).toInt() * 7) - 1)]} гараг');

    String periodOfDay =
        ('${((dayIndex + 1) / 7).toDouble().ceil().toString()}-р цаг');

    if (scheduledClassrooms[0] == null) {
      return ListTile(
        title: Text('№ ${classroom.classroomNumber}'),
        subtitle: Text(classroom.classroomType),
        onTap: () {
          teachersCoursesClassrooms[course] = classroom;
          logger.d(teachersCoursesClassrooms.length);
          Navigator.pop(context);
        },
      );
    } else {
      bool exists = scheduledClassrooms.any((item) =>
          item['time'] == periodOfDay &&
          item['days'] == dayOfWeek &&
          item['classroom_id'] == classroom.classroomId);
      return exists == true
          ? ListTile(
              title: Text('№ ${classroom.classroomNumber}'),
              subtitle: Text(classroom.classroomType),
              trailing: Text(
                'Хуваарийг авсан байна!',
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
              onTap: () {
                Navigator.pop(context);
              },
              enabled: false,
            )
          : ListTile(
              title: Text('№ ${classroom.classroomNumber}'),
              subtitle: Text(classroom.classroomType),
              onTap: () {
                teachersCoursesClassrooms[course] = classroom;
                logger.d(teachersCoursesClassrooms.length);
                Navigator.pop(context);
              },
            );
    }
  }
}
