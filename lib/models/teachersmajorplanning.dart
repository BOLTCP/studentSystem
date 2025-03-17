class TeachersMajorPlanning {
  final int teacherMajorId;
  final int teacherId;
  final String academicDegree;
  final String majorName;
  final int majorId;
  final int credit;
  final int departmentId;
  final DateTime createdAt;
  final int departmentOfEducationsId;

  TeachersMajorPlanning({
    required this.teacherMajorId,
    required this.teacherId,
    required this.academicDegree,
    required this.majorName,
    required this.majorId,
    required this.credit,
    required this.departmentId,
    required this.createdAt,
    required this.departmentOfEducationsId,
  });

  // Static fromJson method to parse the JSON into the Major object
  factory TeachersMajorPlanning.fromJsonTeachersMajorPlanning(
      Map<String, dynamic> json) {
    return TeachersMajorPlanning(
      teacherMajorId: json['teacher_major_id'],
      teacherId: json['teacher_id'],
      academicDegree: json['academic_degree_of_major'],
      majorName: json['major_name'],
      majorId: json['major_id'],
      credit: json['credit'],
      departmentId: json['department_id'],
      createdAt: DateTime.parse(json['created_at']),
      departmentOfEducationsId: json['department_of_educations_id'],
    );
  }
}
