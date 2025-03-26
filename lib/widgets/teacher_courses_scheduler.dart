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
  final List<String> allWeekdays = [
    'Даваа',
    'Мягмар',
    'Лхагва',
    'Пүрэв',
    'Баасан',
    'Бямба',
    'Ням'
  ];
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
    _generateWeekdays();
  }

  Future<UserDetails> fetchUserDetails() async {
    try {
      final response = await http.post(
        getApiUrl('Get/allMajor/Of/Course/Teacher'),
        body: json.encode({
          'user_id':
              widget.userDetails.departmentOfEducation!.departmentsOfEducationId
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
                decodedJson['department_of_edu_query']);
        departmentName = departmentOdEducation.edDepartmentName;

        return UserDetails(
            user: user,
            teacher: teacher,
            student: null,
            department: null,
            departmentOfEducation: departmentOdEducation);
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

//${allWeekdays.elementAt(((dayIndex + 1) % 7) - 1)}
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

  List<String> draggableItems = [
    'Circle',
    'Square',
    'Triangle',
    'Rectangle',
    'Star',
    'Hexagon',
    'Pentagon',
    'Circle',
    'Square',
    'Triangle',
    'Rectangle',
    'Star',
    'Hexagon',
    'Pentagon',
    'Circle',
    'Square',
    'Triangle',
    'Rectangle',
    'Star',
    'Hexagon',
    'Pentagon',
    'Circle',
    'Square',
    'Triangle',
    'Rectangle',
    'Star',
    'Hexagon',
    'Pentagon',
  ];

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
      padding:
          const EdgeInsets.only(top: 4.0, bottom: 4.0, right: 8.0, left: 8.0),
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
                                if (itemPositions.containsKey(index)) {
                                  _existingScheduleError(index, receivedItem);
                                  return;
                                }

                                itemPositions.removeWhere(
                                    (key, value) => value == receivedItem.data);
                                placedItems.remove(receivedItem.data);

                                itemPositions[index] = receivedItem.data;
                                placedItems.add(receivedItem.data);
                                draggableItems.remove(receivedItem.data);
                              });
                            },
                            onLeave: (receivedItem) {
                              if (itemPositions.containsValue(receivedItem)) {
                                setState(() {
                                  itemPositions.removeWhere(
                                      (key, value) => value == receivedItem);
                                  placedItems.remove(receivedItem);
                                });
                              }

                              setState(() {
                                if (!draggableItems.contains(receivedItem)) {
                                  draggableItems.add(receivedItem!);
                                }
                              });
                            },
                            builder: (context, candidateData, rejectedData) {
                              return Container(
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
                                        child: _buildDraggableWidget(
                                            itemPositions[index]!),
                                      )
                                    : null,
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
            width: 500,
            height: 198,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double itemWidth = 80;
                  int itemsPerRow = (constraints.maxWidth / itemWidth).floor();

                  List<List<String>> rows = [];
                  for (int i = 0; i < draggableItems.length; i += itemsPerRow) {
                    rows.add(draggableItems.sublist(
                        i,
                        i + itemsPerRow > draggableItems.length
                            ? draggableItems.length
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
                                    : Draggable<String>(
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
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
