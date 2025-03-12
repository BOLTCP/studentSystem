import 'package:studentsystem/models/auth_user.dart';
import 'package:studentsystem/models/major.dart';
import 'package:studentsystem/models/student_user.dart';
import 'package:studentsystem/models/department.dart';
import 'package:studentsystem/models/teacher.dart';
import 'package:studentsystem/models/departments_of_education.dart';

class UserDetails {
  final AuthUser user;
  final TeacherUser? teacher;
  final StudentUser? student;
  final Major? major;
  final Department? department;
  final DepartmentOfEducation? departmentOfEducation;

  UserDetails({
    required this.user,
    this.teacher,
    this.student,
    this.major,
    this.department,
    this.departmentOfEducation,
  });
}
