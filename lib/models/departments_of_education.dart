import 'dart:convert';

class DepartmentOfEducation {
  final int departmentsOfEducationId;
  final String edDepartmentName;
  final String edDepartmentCode;
  final List<dynamic> teachers;

  DepartmentOfEducation({
    required this.departmentsOfEducationId,
    required this.edDepartmentName,
    required this.edDepartmentCode,
    required this.teachers,
  });

  // From JSON
  factory DepartmentOfEducation.fromJsonDepartmentOfEducation(
      Map<String, dynamic> json) {
    try {
      var teachersData = json['teachers'];

      List<Map<String, dynamic>> teacherList = [];

      if (teachersData != null) {
        if (teachersData is List) {
          teacherList = List<Map<String, dynamic>>.from(teachersData);
        } else if (teachersData is Map) {
          teacherList = [Map<String, dynamic>.from(teachersData)];
        }
      }

      return DepartmentOfEducation(
        departmentsOfEducationId: json['departments_of_education_id'],
        edDepartmentName: json['ed_department_name'],
        edDepartmentCode: json['ed_department_code'],
        teachers: teacherList,
      );
    } catch (e) {
      print('Error in fromJsonDepartmentOfEducation: $e');
      rethrow;
    }
  }

  // To JSON
  Map<String, dynamic> toJson() {
    try {
      return {
        'departments_of_education_id': departmentsOfEducationId,
        'ed_department_name': edDepartmentName,
        'ed_department_code': edDepartmentCode,
        'teachers':
            teachers, // This assumes teachers is already a List<dynamic> or JSON-friendly object
      };
    } catch (e) {
      print('Error in toJson: $e');
      rethrow;
    }
  }

  // Override toString for a custom string representation
  @override
  String toString() {
    return 'DepartmentOfEducation(departmentsOfEducationId: $departmentsOfEducationId, edDepartmentName: $edDepartmentName, edDepartmentCode: $edDepartmentCode, teachers: $teachers)';
  }
}
