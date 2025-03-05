import 'package:logger/logger.dart';

var logger = Logger();

class Department {
  final int departmentId;
  final String departmentName;
  final String departmentCode;
  final String departmentEmail;
  final int numberOfStaff;
  final String logo;
  final DateTime createdAt;
  final int departmentOfEduId;

  Department({
    required this.departmentId,
    required this.departmentName,
    required this.departmentCode,
    required this.departmentEmail,
    required this.numberOfStaff,
    required this.logo,
    required this.createdAt,
    required this.departmentOfEduId,
  });

  // From JSON
  factory Department.fromJsonDepartment(Map<String, dynamic> json) {
    try {
      return Department(
        departmentId: json['department_id'],
        departmentName: json['department_name'],
        departmentCode: json['department_code'],
        departmentEmail: json['department_email'],
        numberOfStaff: json['number_of_staff'] ?? 0,
        logo: json['logo'],
        createdAt: DateTime.parse(json['created_at']),
        departmentOfEduId: json['department_of_edu_id'],
      );
    } catch (e) {
      logger.d('Error in fromJson: $e');
      rethrow;
    }
  }

  // To JSON
  Map<String, dynamic> toJson() {
    try {
      return {
        'department_id': departmentId,
        'department_name': departmentName,
        'department_code': departmentCode,
        'department_email': departmentEmail,
        'number_of_staff': numberOfStaff,
        'logo': logo,
        'created_at': createdAt.toIso8601String(),
        'department_of_edu_id': departmentOfEduId,
      };
    } catch (e) {
      logger.d('Error in toJson: $e');
      rethrow;
    }
  }
}
