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
  Map<String, dynamic> toJson() {
    return {
      'teacher_major_id': teacherMajorId,
      'teacher_id': teacherId,
      'academic_degree_of_major': academicDegree,
      'major_name': majorName,
      'major_id': majorId,
      'credit': credit,
      'department_id': departmentId,
      'created_at': createdAt.toIso8601String(),
      'department_of_educations_id': departmentOfEducationsId,
    };
  }

  @override
  String toString() {
    return 'TeachersMajorPlanning{'
        'teacherMajorId: $teacherMajorId, '
        'teacherId: $teacherId, '
        'academicDegree: $academicDegree, '
        'majorName: $majorName, '
        'majorId: $majorId, '
        'credit: $credit, '
        'departmentId: $departmentId, '
        'createdAt: $createdAt, '
        'departmentOfEducationsId: $departmentOfEducationsId'
        '}';
  }
}
