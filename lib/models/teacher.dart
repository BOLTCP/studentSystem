import 'dart:convert';

class TeacherUser {
  final int teacherId;
  final int userId;
  final String teacherCode;
  final String teacherEmail;
  final String? certificate;
  final String profession;
  final String academicDegree;
  final String? jobTitle;
  final String isActive;
  final String jobDescription;
  final int departmentsOfEducationId;
  final int? departmentId;

  TeacherUser({
    required this.teacherId,
    required this.userId,
    required this.teacherCode,
    required this.teacherEmail,
    this.certificate,
    required this.profession,
    required this.academicDegree,
    this.jobTitle,
    required this.isActive,
    required this.jobDescription,
    required this.departmentsOfEducationId,
    this.departmentId,
  });

  // Convert JSON to Model
  factory TeacherUser.fromJsonTeacher(Map<String, dynamic> json) {
    return TeacherUser(
      teacherId: json['teacher_id'],
      userId: json['user_id'],
      teacherCode: json['teacher_code'],
      teacherEmail: json['teacher_email'],
      certificate: json['certificate'],
      profession: json['profession'].trim(),
      academicDegree: json['academic_degree'].trim(),
      jobTitle: json['job_title'],
      isActive: json['is_active'],
      jobDescription: json['job_description'],
      departmentsOfEducationId: json['departments_of_education_id'],
      departmentId: json['department_id'],
    );
  }

  // Convert Model to JSON
  Map<String, dynamic> toJson() {
    return {
      'teacher_id': teacherId,
      'user_id': userId,
      'teacher_code': teacherCode,
      'teacher_email': teacherEmail,
      'certificate': certificate,
      'profession': profession,
      'academic_degree': academicDegree,
      'job_title': jobTitle,
      'is_active': isActive,
      'job_description': jobDescription,
      'departments_of_education_id': departmentsOfEducationId,
      'department_id': departmentId,
    };
  }
}
