import 'dart:convert';

class TeachersSchedule {
  final int scheduleId;
  final int classroomId;
  final String classroomCapacity;
  final String classroomType;
  final int students;
  final int teacherId;
  final int courseId;
  final int majorId;
  final String teacherName;
  final String teachersEmail;
  final String scheduleType;
  final String time;

  // Constructor
  TeachersSchedule({
    required this.scheduleId,
    required this.classroomId,
    required this.classroomCapacity,
    required this.classroomType,
    required this.students,
    required this.teacherId,
    required this.courseId,
    required this.majorId,
    required this.teacherName,
    required this.teachersEmail,
    required this.scheduleType,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'schedule_id': scheduleId,
      'classroom_id': classroomId,
      'classroom_capacity': classroomCapacity,
      'classroom_type': classroomType,
      'students': students,
      'teacher_id': teacherId,
      'course_id': courseId,
      'major_id': majorId,
      'teacher_name': teacherName,
      'teachers_email': teachersEmail,
      'schedule_type': scheduleType,
      'time': time,
    };
  }

  factory TeachersSchedule.fromMapTeachersSchedule(Map<String, dynamic> map) {
    return TeachersSchedule(
      scheduleId: map['schedule_id'],
      classroomId: map['classroom_id'],
      classroomCapacity: map['classroom_capacity'],
      classroomType: map['classroom_type'],
      students: map['students'],
      teacherId: map['teacher_id'],
      courseId: map['course_id'],
      majorId: map['major_id'],
      teacherName: map['teacher_name'],
      teachersEmail: map['teachers_email'],
      scheduleType: map['schedule_type'],
      time: map['time'],
    );
  }

  factory TeachersSchedule.fromJson(String json) {
    return TeachersSchedule.fromMapTeachersSchedule(jsonDecode(json));
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
