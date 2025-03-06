import 'package:studentsystem/models/auth_user.dart';
import 'package:studentsystem/models/major.dart';
import 'package:studentsystem/models/student_user.dart';
import 'package:studentsystem/models/department.dart';
import 'package:studentsystem/models/teacher.dart';

class UserDetails {
  final AuthUser user;
  final TeacherUser? teacher;
  final StudentUser? student;
  final Major? major;
  final Department department;

  UserDetails({
    required this.user,
    this.teacher,
    this.student,
    this.major,
    required this.department,
  });
}
