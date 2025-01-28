import 'package:logger/logger.dart';

var logger = Logger();

class Exam {
  String examType;
  double score;

  Exam({required this.examType, required this.score});

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      examType: json['exam_type'] ?? 'Unknown',
      score: json['score'] != null ? (json['score'] as num).toDouble() : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exam_type': examType,
      'score': score,
    };
  }

  @override
  String toString() {
    return 'Exam(examType: $examType, score: $score)';
  }
}

class Student {
  String studentName;
  String studentCode;
  String email;
  List<Exam> exams;
  DateTime createdAt;

  Student({
    required this.studentName,
    required this.studentCode,
    required this.email,
    required this.exams,
    required this.createdAt,
  });

  // From JSON with error handling and type checking
  factory Student.fromJson(Map<String, dynamic> json) {
    try {
      var examsJson = json['exams'] as List? ?? [];
      List<Exam> examsList = examsJson.map((e) => Exam.fromJson(e as Map<String, dynamic>)).toList();

      return Student(
        studentName: json['student_name'] ?? 'Unknown', 
        studentCode: json['student_code'] ?? 'Unknown',
        email: json['email'] ?? 'No email provided',
        exams: examsList,
        createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()), 
      );
    } catch (e) {
      logger.d("Error parsing Student: $e");
      return Student(
        studentName: 'Unknown',
        studentCode: 'Unknown',
        email: 'No email provided',
        exams: [],
        createdAt: DateTime.now(),
      );  // Return default student in case of error
    }
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'student_name': studentName,
      'student_code': studentCode,
      'email': email,
      'exams': exams.map((e) => e.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
    };
  }
  @override
  String toString() {
    return 'Student(studentName: $studentName, studentCode: $studentCode, email: $email, exams: $exams, createdAt: $createdAt)';
  }
}
