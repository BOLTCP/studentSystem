import 'dart:convert';

class StudentUser {
  int studentId;
  int userId;
  int? studentClubId;
  String additionalRoles;
  String studentCode;
  String studentEmail;
  Map<String, dynamic> studentFile; // Assuming it's a JSON object
  int enrollmentNumber;
  int enrollmentYear;
  String yearClassification;
  String? isActive;
  String currentAcademicDegree;
  String academicDegreeFile;
  int majorId;
  DateTime createdAt;
  Map<String, dynamic>? contracts;
  String? studentActiveNote;

  // Constructor
  StudentUser({
    required this.studentId,
    required this.userId,
    this.studentClubId,
    required this.additionalRoles,
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
    this.contracts,
    this.studentActiveNote,
  });

  // Factory method to create an instance from JSON
  factory StudentUser.fromJson(Map<String, dynamic> json) {
    return StudentUser(
      studentId: json['student_id'],
      userId: json['user_id'],
      studentClubId: json['student_club_id'],
      additionalRoles: json['additional_roles'],
      studentCode: json['student_code'],
      studentEmail: json['student_email'],
      studentFile: json['student_file'],
      enrollmentNumber: json['enrollment_number'],
      enrollmentYear: json['enrollment_year'],
      yearClassification: json['year_classification'],
      isActive: json['is_active'],
      currentAcademicDegree: json['current_academic_degree'],
      academicDegreeFile: json['academic_degree_file'],
      majorId: json['major_id'],
      createdAt: DateTime.parse(json['created_at']),
      contracts: json['contracts'],
      studentActiveNote: json['student_active_note'],
    );
  }

  // Method to convert an instance into JSON
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
      'student_active_note': studentActiveNote,
    };
  }

  // Debug method to print the object data
  void debugPrint() {
    print('Student {');
    print('  studentId: $studentId');
    print('  userId: $userId');
    print('  studentClubId: $studentClubId');
    print('  additionalRoles: $additionalRoles');
    print('  studentCode: $studentCode');
    print('  studentEmail: $studentEmail');
    print('  studentFile: $studentFile');
    print('  enrollmentNumber: $enrollmentNumber');
    print('  enrollmentYear: $enrollmentYear');
    print('  yearClassification: $yearClassification');
    print('  isActive: $isActive');
    print('  currentAcademicDegree: $currentAcademicDegree');
    print('  academicDegreeFile: $academicDegreeFile');
    print('  majorId: $majorId');
    print('  createdAt: $createdAt');
    print('  contracts: $contracts');
    print('  student_active_note: $studentActiveNote');
    print('}');
  }
}
