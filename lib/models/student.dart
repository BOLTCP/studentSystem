import 'dart:convert';

class StudentUser {
  int? studentId;
  int userId;
  int? studentClubId;
  String additionalRoles;
  String studentCode;
  String studentEmail;
  Map<String, dynamic> studentFile;
  int enrollmentNumber;
  int enrollmentYear;
  String yearClassification;
  String? isActive;
  String currentAcademicDegree;
  String academicDegreeFile;
  int majorId;
  DateTime createdAt;

  StudentUser({
    this.studentId,
    required this.userId,
    this.studentClubId,
    this.additionalRoles = 'none',
    required this.studentCode,
    required this.studentEmail,
    required this.studentFile,
    required this.enrollmentNumber,
    required this.enrollmentYear,
    required this.yearClassification,
    this.isActive,
    required this.currentAcademicDegree,
    required this.academicDegreeFile,
    required this.majorId,
    required this.createdAt,
  });

  // toMap() method for serializing to Map
  Map<String, dynamic> toMap() {
    return {
      'student_id': studentId,
      'user_id': userId,
      'student_club_id': studentClubId,
      'additional_roles': additionalRoles,
      'student_code': studentCode,
      'student_email': studentEmail,
      'student_file': studentFile,
      'enrollment_number': enrollmentNumber,
      'enrollment_year': enrollmentYear,
      'year_classification': yearClassification,
      'is_active': isActive,
      'current_academic_degree': currentAcademicDegree,
      'academic_degree_file': academicDegreeFile,
      'major_id': majorId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // fromMap() method for deserializing from Map
  factory StudentUser.fromMap(Map<String, dynamic> map) {
    return StudentUser(
      studentId: map['student_id'],
      userId: map['user_id'],
      studentClubId: map['student_club_id'],
      additionalRoles: map['additional_roles'] ?? 'none',
      studentCode: map['student_code'],
      studentEmail: map['student_email'],
      studentFile: map['student_file'] != null
          ? Map<String, dynamic>.from(map['student_file'])
          : {},
      enrollmentNumber: map['enrollment_number'],
      enrollmentYear: map['enrollment_year'],
      yearClassification: map['year_classification'],
      isActive: map['is_active'],
      currentAcademicDegree: map['current_academic_degree'],
      academicDegreeFile: map['academic_degree_file'],
      majorId: map['major_id'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  // toJson() method for serializing to JSON
  String toJson() => json.encode(toMap());

  // fromJson() method for deserializing from JSON
  factory StudentUser.fromJson(String source) =>
      StudentUser.fromMap(json.decode(source));
}
