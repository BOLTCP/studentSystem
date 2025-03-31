import 'dart:convert';

class Classroom {
  final int classroomId;
  final int departmentId;
  final String classroomType;
  final String classroomNumber;
  final String projector;
  final String tv;
  final DateTime createdAt;
  final int capacity;

  Classroom({
    required this.classroomId,
    required this.departmentId,
    required this.classroomType,
    required this.classroomNumber,
    required this.projector,
    required this.tv,
    required this.createdAt,
    required this.capacity,
  });

  // fromJson
  factory Classroom.fromJsonClassroom(Map<String, dynamic> json) {
    return Classroom(
      classroomId: json['classroom_id'] as int,
      departmentId: json['department_id'] ?? 0,
      classroomType: json['classroom_type'] as String,
      classroomNumber: json['classroom_number'] as String,
      projector: json['projector'] as String,
      tv: json['tv'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      capacity: json['capacity'] as int,
    );
  }

  // toJson
  Map<String, dynamic> toJsoClassroom() {
    return {
      'classroom_id': classroomId,
      'department_id': departmentId,
      'classroom_type': classroomType,
      'classroom_number': classroomNumber,
      'projector': projector,
      'tv': tv,
      'created_at': createdAt.toIso8601String(),
      'capacity': capacity,
    };
  }

  @override
  String toString() {
    return 'Classroom(classroomId: $classroomId, departmentId: $departmentId, classroomType: $classroomType, classroomNumber: $classroomNumber, projector: $projector, tv: $tv, createdAt: $createdAt, capacity: $capacity)';
  }
}
