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
import 'package:studentsystem/widgets/bottom_navigation.dart';
import 'package:studentsystem/widgets/drawer.dart';

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

  void _generateWeekdays() {
    DateTime now = DateTime.now();
    int currentDay = now.weekday;

    List<String> allWeekdays = ['Да', 'Мя', 'Лха', 'Пү', 'Ба', 'Бя', 'Ням'];
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

  final int rows = 7;
  final int cols = 7;

  Map<int, String> itemPositions = {};
  Set<String> placedItems = {}; // Tracks placed items

  List<String> draggableItems = [
    'Circle',
    'Square',
    'Triangle',
    'Rectangle',
    'Star',
    'Hexagon',
    'Pentagon'
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
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Draggable Items
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: draggableItems.map((item) {
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

          SizedBox(height: 10), // Reduced spacing to fix gap

          // Timetable with Headers
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

                // Time Slots & Drag Targets
                Column(
                  children: List.generate(rows, (rowIndex) {
                    return Row(
                      children: [
                        // Time Labels
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
                            onWillAcceptWithDetails: (receivedItem) {
                              // Ensure we can accept only if item is not placed already
                              return !placedItems.contains(receivedItem.data);
                            },
                            onAcceptWithDetails: (receivedItem) {
                              setState(() {
                                // Remove from the previous position if the item is already placed elsewhere
                                if (itemPositions
                                    .containsValue(receivedItem.data)) {
                                  itemPositions.removeWhere((key, value) =>
                                      value == receivedItem.data);
                                  placedItems.remove(receivedItem.data);
                                }

                                // Place item in the new position
                                itemPositions[index] = receivedItem.data;
                                placedItems
                                    .add(receivedItem.data); // Mark as placed
                                draggableItems.remove(receivedItem
                                    .data); // Remove from draggableItems
                              });
                            },
                            onLeave: (receivedItem) {
                              // When a dragged item leaves the timetable area, reactivate it
                              if (!itemPositions.containsKey(index)) {
                                setState(() {
                                  // Reactivate the shape to the draggableItems list
                                  if (!draggableItems.contains(receivedItem)) {
                                    draggableItems.add(receivedItem!);
                                    placedItems.remove(receivedItem);
                                  }
                                });
                              }
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
                                      ? Colors.lightGreen[200]
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
        ],
      ),
    );
  }

  Widget _buildDraggableWidget(String label) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
