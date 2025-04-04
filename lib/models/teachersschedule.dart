class TeachersSchedule {
  int classroomId;
  int students;
  int teacherId;
  int courseId;
  int majorId;
  String teacherName;
  String teachersEmail;
  String scheduleType;
  String time;
  int coursePlanningId;
  String days;
  int teachersScheduleId;
  DateTime createdAt;
  String courseName;
  int classroomCapacity;
  String classroomType;
  String classroomNumber;

  // Constructor
  TeachersSchedule({
    required this.classroomId,
    required this.students,
    required this.teacherId,
    required this.courseId,
    required this.majorId,
    required this.teacherName,
    required this.teachersEmail,
    required this.scheduleType,
    required this.time,
    required this.coursePlanningId,
    required this.days,
    required this.teachersScheduleId,
    required this.createdAt,
    required this.courseName,
    required this.classroomCapacity,
    required this.classroomType,
    required this.classroomNumber,
  });

  factory TeachersSchedule.fromJsonTeachersSchedule(Map<String, dynamic> json) {
    return TeachersSchedule(
      classroomId: json['classroom_id'],
      students: json['students'],
      teacherId: json['teacher_id'],
      courseId: json['course_id'],
      majorId: json['major_id'],
      teacherName: json['teacher_name'],
      teachersEmail: json['teachers_email'],
      scheduleType: json['schedule_type'],
      time: json['time'],
      coursePlanningId: json['course_planning_id'],
      days: json['days'],
      teachersScheduleId: json['teachers_schedule_id'],
      createdAt: DateTime.parse(json['created_at']),
      courseName: json['course_name'],
      classroomCapacity: json['classroom_capacity'],
      classroomType: json['classroom_type'],
      classroomNumber: json['classroom_number'],
    );
  }

  // Factory constructor to create a TeachersSchedule object from a map (e.g., from JSON)
  factory TeachersSchedule.fromMap(Map<String, dynamic> map) {
    return TeachersSchedule(
      classroomId: map['classroom_id'],
      students: map['students'],
      teacherId: map['teacher_id'],
      courseId: map['course_id'],
      majorId: map['major_id'],
      teacherName: map['teacher_name'],
      teachersEmail: map['teachers_email'],
      scheduleType: map['schedule_type'],
      time: map['time'],
      coursePlanningId: map['course_planning_id'],
      days: map['days'],
      teachersScheduleId: map['teachers_schedule_id'],
      createdAt: DateTime.parse(map['created_at']),
      courseName: map['course_name'],
      classroomCapacity: map['classroom_capacity'],
      classroomType: map['classroom_type'],
      classroomNumber: map['classroom_number'],
    );
  }

  // Method to convert the TeachersSchedule object to a map (for insertion into a database or JSON serialization)
  Map<String, dynamic> toJsonTeachersSchedule() {
    return {
      'classroom_id': classroomId,
      'students': students,
      'teacher_id': teacherId,
      'course_id': courseId,
      'major_id': majorId,
      'teacher_name': teacherName,
      'teachers_email': teachersEmail,
      'schedule_type': scheduleType,
      'time': time,
      'course_planning_id': coursePlanningId,
      'days': days,
      'teachers_schedule_id': teachersScheduleId,
      'created_at': createdAt.toIso8601String(),
      'course_name': courseName,
      'classroom_capacity': classroomCapacity,
      'classroom_type': classroomType,
      'classroom_number': classroomNumber,
    };
  }

  // Method to convert a list of TeachersSchedule objects to a list of maps (useful for JSON serialization)
  static List<Map<String, dynamic>> toListMap(
      List<TeachersSchedule> schedules) {
    return schedules
        .map((schedule) => schedule.toJsonTeachersSchedule())
        .toList();
  }

  // Method to convert a map to a TeachersSchedule (for example, after fetching data from the database)
  static TeachersSchedule fromMapToObject(Map<String, dynamic> map) {
    return TeachersSchedule.fromMap(map);
  }
}
