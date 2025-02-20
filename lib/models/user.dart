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

class User {
  String userName;
  String userSirname;
  String registryNumber; // Changed from 'resgistryNumber' to 'registryNumber'
  String? examCode;
  String email;
  List<Exam>? exams;
  DateTime createdAt;
  DateTime validUntil;

  User({
    required this.userName,
    required this.userSirname,
    required this.registryNumber,
    this.examCode,
    required this.email,
    this.exams,
    required this.createdAt,
    required this.validUntil,
  });

  // From JSON with error handling and type checking
  factory User.fromJson(Map<String, dynamic> json) {
    try {
      var examsJson = json['exams'] as List? ?? [];
      List<Exam> examsList = examsJson
          .map((e) => Exam.fromJson(e as Map<String, dynamic>))
          .toList();

      if (json.containsKey('exam_json')) {
        var examJson = json['exam_json'];

        return User(
          userName: examJson['user_name'] ?? 'Unknown',
          userSirname: examJson['user_sirname'] ?? 'Unknown',
          registryNumber: examJson['registry_number'] ?? 'Unknown',
          examCode: examJson['exam_code'] ?? 'Unknown',
          email: examJson['email'] ?? 'No email provided',
          exams: examsList,
          createdAt: DateTime.parse(
              examJson['created_at'] ?? DateTime.now().toIso8601String()),
          validUntil: DateTime.parse(
              examJson['valid_until'] ?? DateTime.now().toIso8601String()),
        );
      } else if (json.containsKey('user_json')) {
        var userJson = json['user_json'];

        return User(
          userName: userJson['user_name'] ?? 'Unknown',
          userSirname: userJson['user_sirname'] ?? 'Unknown',
          registryNumber: userJson['registry_number'] ?? 'Unknown',
          examCode:
              null, // Default to null since there's no exam code for staff
          email: userJson['email'] ?? 'No email provided',
          exams: [], // No exams for staff
          createdAt: DateTime.now(),
          validUntil: DateTime.now(),
        );
      } else {
        return User(
          userName: 'Unknown',
          userSirname: 'Unknown',
          registryNumber: 'Unknown',
          examCode: 'Unknown',
          email: 'No email provided',
          exams: [],
          createdAt: DateTime.now(),
          validUntil: DateTime.now(),
        );
      }
    } catch (e) {
      logger.d("Error parsing user: $e");
      return User(
        userName: 'Unknown',
        userSirname: 'Unknown',
        registryNumber: 'Unknown',
        examCode: 'Unknown',
        email: 'No email provided',
        exams: [],
        createdAt: DateTime.now(),
        validUntil: DateTime.now(),
      ); // Return default user in case of error
    }
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'user_name': userName,
      'user_sirname': userSirname,
      'registry_number': registryNumber, // Corrected the typo
      'examCode': examCode,
      'email': email,
      'exams': exams?.map((e) => e.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'valid_until': validUntil.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'User(userName: $userName, userSirname: $userSirname, registryNumber: $registryNumber, examCode: $examCode, email: $email, exams: $exams, createdAt: $createdAt, validUntil: $validUntil)';
  }
}
