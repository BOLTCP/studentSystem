import 'package:studentsystem/models/auth_user.dart';
import 'package:studentsystem/models/major.dart';
import 'package:studentsystem/models/student_user.dart';
import 'package:studentsystem/models/department.dart';

class UserDetails {
  final AuthUser user;
  final StudentUser student;
  final Major major;
  final Department department;

  UserDetails({
    required this.user,
    required this.student,
    required this.major,
    required this.department,
  });
}
