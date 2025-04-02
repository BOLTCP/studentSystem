class TeachersCoursePlanning {
  final int teacherCoursePlanningId;
  final int teacherId;
  final int majorId;
  final String courseName;
  final int credit;
  final int courseId;
  final DateTime createdAt;
  final String majorName;
  final String courseCode;
  final int teacherMajorId;
  final int? courseLecture;

  // Constructor
  TeachersCoursePlanning({
    required this.teacherCoursePlanningId,
    required this.teacherId,
    required this.majorId,
    required this.courseName,
    required this.credit,
    required this.courseId,
    required this.createdAt,
    required this.majorName,
    required this.courseCode,
    required this.teacherMajorId,
    this.courseLecture,
  });

  // Factory method to create an object from a JSON map
  factory TeachersCoursePlanning.fromJsonTeachersCoursePlanning(
      Map<String, dynamic> json) {
    return TeachersCoursePlanning(
      teacherCoursePlanningId: json['teacher_course_planning_id'],
      teacherId: json['teacher_id'],
      majorId: json['major_id'],
      courseName: json['course_name'],
      credit: json['credit'],
      courseId: json['course_id'],
      createdAt: DateTime.parse(json['created_at']),
      majorName: json['major_name'],
      courseCode: json['course_code'],
      teacherMajorId: json['teacher_major_id'],
    );
  }

  // Method to convert the object to a JSON map
  Map<String, dynamic> toJsonTeachersCoursePlanning() {
    return {
      'teacher_course_planning_id': teacherCoursePlanningId,
      'teacher_id': teacherId,
      'major_id': majorId,
      'course_name': courseName,
      'credit': credit,
      'course_id': courseId,
      'created_at': createdAt.toIso8601String(),
      'major_name': majorName,
      'course_code': courseCode,
      'teacher_major_id': teacherMajorId,
    };
  }
}
