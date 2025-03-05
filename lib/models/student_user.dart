import 'package:logger/logger.dart';

var logger = Logger();

class StudentUser {
  int studentId;
  int userId;
  int? studentClubId;
  String additionalRoles;
  String studentCode;
  String studentEmail;
  Map<String, dynamic>? studentFile; // Assuming it's a JSON object, nullable
  int enrollmentNumber;
  int enrollmentYear;
  String yearClassification;
  String? isActive;
  String currentAcademicDegree;
  String academicDegreeFile;
  int majorId;
  DateTime createdAt;
  Map<String, dynamic>? contracts; // Nullable

  // Constructor
  StudentUser({
    required this.studentId,
    required this.userId,
    this.studentClubId,
    required this.additionalRoles,
    required this.studentCode,
    required this.studentEmail,
    this.studentFile,
    required this.enrollmentNumber,
    required this.enrollmentYear,
    required this.yearClassification,
    this.isActive,
    required this.currentAcademicDegree,
    required this.academicDegreeFile,
    required this.majorId,
    required this.createdAt,
    this.contracts,
  });

  // fromJson method
  factory StudentUser.fromJsonStudentUser(Map<String, dynamic> json) {
    return StudentUser(
      studentId: json['student_id'] ?? 0, // Default to 0 if null
      userId: json['user_id'] ?? 0, // Default to 0 if null
      studentClubId: json['student_club_id'], // Nullable
      additionalRoles:
          json['additional_roles'] ?? 'байхгүй', // Default to 'байхгүй' if null
      studentCode:
          json['student_code'] ?? '', // Default to empty string if null
      studentEmail:
          json['student_email'] ?? '', // Default to empty string if null
      studentFile: json['student_file'], // Nullable JSON object
      enrollmentNumber: json['enrollment_number'] ?? 0, // Default to 0 if null
      enrollmentYear: json['enrollment_year'] ?? 0, // Default to 0 if null
      yearClassification:
          json['year_classification'] ?? '', // Default to empty string if null
      isActive: json['is_active'], // Nullable
      currentAcademicDegree:
          (json['current_academic_degree'] ?? '').trim(), // Trim spaces
      academicDegreeFile:
          json['academic_degree_file'] ?? 'none', // Default to 'none' if null
      majorId: json['major_id'] ?? 0, // Default to 0 if null
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(), // Parse the date or use current date
      contracts: json['contracts'], // Nullable
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
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
      'contracts': contracts,
    };
  }

  // Debug method to print the object data
  void debugPrint() {
    logger.d('Student {');
    logger.d('  studentId: $studentId');
    logger.d('  userId: $userId');
    logger.d('  studentClubId: $studentClubId');
    logger.d('  additionalRoles: $additionalRoles');
    logger.d('  studentCode: $studentCode');
    logger.d('  studentEmail: $studentEmail');
    logger.d('  studentFile: $studentFile');
    logger.d('  enrollmentNumber: $enrollmentNumber');
    logger.d('  enrollmentYear: $enrollmentYear');
    logger.d('  yearClassification: $yearClassification');
    logger.d('  isActive: $isActive');
    logger.d('  currentAcademicDegree: $currentAcademicDegree');
    logger.d('  academicDegreeFile: $academicDegreeFile');
    logger.d('  majorId: $majorId');
    logger.d('  createdAt: $createdAt');
    logger.d('  contracts: $contracts');
    logger.d('}');
  }
}
