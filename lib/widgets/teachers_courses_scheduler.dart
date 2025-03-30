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
import 'package:studentsystem/models/teachers_schedule.dart';
import 'package:studentsystem/models/classrooms.dart';
import 'package:studentsystem/widgets/teachers_courses.dart';

var logger = Logger();

class TeacherCoursesScheduler extends StatefulWidget {
  const TeacherCoursesScheduler({required this.userDetails, super.key});

  final UserDetails userDetails;

  @override
  _TeacherCoursesSchedulerState createState() =>
      _TeacherCoursesSchedulerState();
}

class _TeacherCoursesSchedulerState extends State<TeacherCoursesScheduler> {
  //late Future<UserDetails> userDetails;
  late String departmentName = '';
  List<String> weekdays = [];
  late String currentDayOfWeek = '';
  late Future<UserDetails> futureUserDetails;
  late Future<List<TeachersSchedule>> futureTeachersAutoSchedule;
  late Future<List<Classroom>> futureClassrooms;
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
  Map<int, String> teachersCourses = {};
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
    classroomSearchType = fetchClassroomsType();
    futureClassrooms = fetchClassrooms();
    _generateWeekdays();
    _fetchTeachersCourses();
    String val = _parseAbbreviation('АҮ');
    logger.d(val);
  }

  void _fetchTeachersCourses() {
    for (var coursePlanning in widget.userDetails.teachersCoursePlanning!) {
      teachersCourses[widget.userDetails.teachersCoursePlanning!
              .indexOf(coursePlanning)] =
          coursePlanning.courseName
              .split(' ')
              .map((courseName) => courseName[0])
              .join('')
              .toUpperCase();
    }
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

      logger.d('Response status: ${response.statusCode}');
      logger.d('Response body: ${response.body}');

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

  Future<List<TeachersSchedule>> fetchTeachersAutoSchedule() async {
    try {
      final response = await http.get(
        getApiUrl(
            '/Get/Teachers/Auto/Schedule?teacher_id=${widget.userDetails.teacher!.teacherId}'),
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

        List<TeachersSchedule> teachersAutoSchedule = (decodedJson[
                'teachers_auto_schedule'] as List)
            .map((teachersAutoSchedule) =>
                TeachersSchedule.fromMapTeachersSchedule(teachersAutoSchedule))
            .toList();

        return teachersAutoSchedule;
      } else {
        logger.d('Error: ${response.statusCode}');
        throw Exception('User does not exist!');
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
              "${allWeekdays[((index + 1) - (((index + 1) / 7).toInt() * 7) - 1).toInt() == -1 ? 6 : ((index + 1) - (((index + 1) / 7).toInt() * 7) - 1).toInt()]} гарагт ${((index + 1) / 7).toDouble().ceil()} цагт хичээлийн хуваарь байрлаж байна! Өөр хуваарь сонгох эсвэл байгаа хуваарийг өөрчилнө үү!"),
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

  final int rows = 8;
  final int cols = 7;
  Map<int, String> itemPositions = {};
  Set<String> placedItems = {};
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
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
                          border: Border.all(color: Colors.black38, width: 1),
                          color: Colors.grey[300],
                        ),
                        child: Text(day,
                            style: TextStyle(fontWeight: FontWeight.bold)),
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
                            border: Border.all(color: Colors.black38, width: 1),
                            color: Colors.grey[200],
                          ),
                          child: Text("${rowIndex + 1}"),
                        ),
                        ...List.generate(cols, (colIndex) {
                          int index = rowIndex * cols + colIndex;

                          return DragTarget<String>(
                            onAcceptWithDetails: (receivedItem) {
                              setState(() {
                                String receivedData = receivedItem.data;

                                if (itemPositions.containsKey(index)) {
                                  _existingScheduleError(index, receivedData);
                                  return;
                                }

                                itemPositions.removeWhere(
                                    (key, value) => value == receivedData);
                                placedItems.remove(receivedData);

                                itemPositions[index] = receivedData;
                                placedItems.add(receivedData);
                                teachersCourses.remove(receivedData);
                              });
                            },
                            onLeave: (receivedItem) {
                              String receivedData = receivedItem!;

                              if (itemPositions.containsValue(receivedData)) {
                                setState(() {
                                  itemPositions.removeWhere(
                                      (key, value) => value == receivedData);
                                  placedItems.remove(receivedData);
                                });
                              }

                              setState(() {
                                if (teachersCourses
                                    .containsKey(receivedData.hashCode)) {
                                  teachersCourses[receivedData.hashCode] =
                                      receivedData;
                                }
                              });
                            },
                            builder: (context, candidateData, rejectedData) {
                              return GestureDetector(
                                onLongPress: () async {
                                  String parseResult = await _parseAbbreviation(
                                      itemPositions[index]);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(parseResult),
                                      duration: Duration(milliseconds: 750),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 100,
                                  height: 60,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black38, width: 1),
                                    color: itemPositions.containsKey(index)
                                        ? Colors.blueAccent
                                        : Colors.white,
                                  ),
                                  child: itemPositions[index] != null
                                      ? Draggable<String>(
                                          data: itemPositions[index]!,
                                          feedback: Material(
                                            color: Colors.transparent,
                                            child: _buildDraggableWidget(
                                                itemPositions[index]!),
                                          ),
                                          childWhenDragging: Opacity(
                                            opacity: 0.5,
                                            child: _buildDraggableWidget(
                                                itemPositions[index]!),
                                          ),
                                          child: _buildDraggableWidgetWithIcon(
                                              itemPositions[index]!),
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
          SizedBox(
            width: 424,
            height: 190,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double itemWidth = 80;
                  int itemsPerRow = (constraints.maxWidth / itemWidth).floor();

                  List<List<String>> rows = [];
                  List<String> courseNames = teachersCourses.values.toList();
                  for (int i = 0; i < courseNames.length; i += itemsPerRow) {
                    rows.add(courseNames.sublist(
                        i,
                        i + itemsPerRow > courseNames.length
                            ? courseNames.length
                            : i + itemsPerRow));
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: rows.map((rowItems) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: SizedBox(
                            height: 80,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: rowItems.map((item) {
                                return placedItems.contains(item)
                                    ? Opacity(
                                        opacity: 0.3,
                                        child: _buildDraggableWidget(item),
                                      )
                                    : GestureDetector(
                                        onLongPress: () async {
                                          String parseResult =
                                              await _parseAbbreviation(item);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(parseResult),
                                              duration:
                                                  Duration(milliseconds: 750),
                                            ),
                                          );
                                        },
                                        child: Draggable<String>(
                                          data: item,
                                          feedback: Material(
                                            color: Colors.transparent,
                                            child: _buildDraggableWidget(item),
                                          ),
                                          childWhenDragging: Opacity(
                                            opacity: 0.5,
                                            child: _buildDraggableWidget(item),
                                          ),
                                          child: _buildDraggableWidget(item),
                                        ),
                                      );
                              }).toList(),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDraggableWidget(String label) {
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
              label,
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDraggableWidgetWithIcon(String label) {
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
                  return FutureBuilder<List<Classroom>>(
                    future: fetchClassrooms(),
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
                        List<Classroom> classrooms = snapshot.data!;
                        return AlertDialog(
                          title: Text('Хичээл орох анги сонгоно уу!'),
                          content: Container(
                            color: Colors.white70,
                            width: double.maxFinite,
                            height: 300,
                            child: ListView.builder(
                              itemCount: classrooms.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                      '№ ${classrooms[index].classroomNumber}, Багтаамж: ${classrooms[index].capacity}, Проектор: ${classrooms[index].projector}'),
                                  subtitle:
                                      Text(classrooms[index].classroomType),
                                  onTap: () {
                                    Placeholder();
                                  },
                                );
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
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: TextStyle(color: Colors.white),
                  ),
                  Icon(Icons.place, color: Colors.white),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
