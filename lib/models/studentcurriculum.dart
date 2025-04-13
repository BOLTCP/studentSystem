class StudentCurriculum {
  final int studentCurriculumId;
  final int studentId;
  final int courseId;
  final int credit;
  final DateTime studentYear;
  final String semesterYear;
  final DateTime? modifiedAt;
  final String courseCode;

  StudentCurriculum({
    required this.studentCurriculumId,
    required this.studentId,
    required this.courseId,
    required this.credit,
    required this.studentYear,
    required this.semesterYear,
    this.modifiedAt,
    required this.courseCode,
  });

  factory StudentCurriculum.fromJson(Map<String, dynamic> json) {
    return StudentCurriculum(
      studentCurriculumId: json['studentCurriculumId'] as int,
      studentId: json['studentId'] as int,
      courseId: json['courseId'] as int,
      credit: json['credit'] as int,
      studentYear: DateTime.parse(json['studentYear'] as String),
      semesterYear: json['semesterYear'] as String,
      modifiedAt: json['modifiedAt'] == null
          ? null
          : DateTime.parse(json['modifiedAt'] as String),
      courseCode: json['courseCode'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentCurriculumId': studentCurriculumId,
      'studentId': studentId,
      'courseId': courseId,
      'credit': credit,
      'studentYear': studentYear.toIso8601String(),
      'semesterYear': semesterYear,
      'modifiedAt': modifiedAt?.toIso8601String(),
      'courseCode': courseCode,
    };
  }
}
