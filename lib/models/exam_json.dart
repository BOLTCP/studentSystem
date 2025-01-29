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
  String studentSirname;
  String resgistryNumber;
  String examCode;
  String email;
  List<Exam> exams;
  DateTime createdAt;
  DateTime validUntil;

  Student({
    required this.studentName,
    required this.studentSirname,
    required this.resgistryNumber,
    required this.examCode,
    required this.email,
    required this.exams,
    required this.createdAt,
    required this.validUntil,
  });

  // From JSON with error handling and type checking
  factory Student.fromJson(Map<String, dynamic> json) {
    try {
      var examsJson = json['exams'] as List? ?? [];
      List<Exam> examsList = examsJson
          .map((e) => Exam.fromJson(e as Map<String, dynamic>))
          .toList();

      return Student(
        studentName: json['student_name'] ?? 'Unknown',
        studentSirname: json['student_sirname'] ?? 'Unknown',
        resgistryNumber: json['registry_number'] ?? 'Unknown',
        examCode: json['exam_code'] ?? 'Unknown',
        email: json['email'] ?? 'No email provided',
        exams: examsList,
        createdAt: DateTime.parse(
            json['created_at'] ?? DateTime.now().toIso8601String()),
        validUntil: DateTime.parse(
            json['valid_until'] ?? DateTime.now().toIso8601String()),
      );
    } catch (e) {
      logger.d("Error parsing Student: $e");
      return Student(
        studentName: 'Unknown',
        studentSirname: 'Unknown',
        resgistryNumber: 'Unknown',
        examCode: 'Unknown',
        email: 'No email provided',
        exams: [],
        createdAt: DateTime.now(),
        validUntil: DateTime.now(),
      ); // Return default student in case of error
    }
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'student_name': studentName,
      'student_sirname': studentSirname,
      'registry_number': resgistryNumber,
      'examCode': examCode,
      'email': email,
      'exams': exams.map((e) => e.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'valid_until': validUntil.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Student(studentName: $studentName, student_sirname: $studentSirname, registry_number: $resgistryNumber, studentCode: $examCode, email: $email, exams: $exams, createdAt: $createdAt, validUntil: $validUntil)';
  }
}
