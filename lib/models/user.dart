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
  String? education;
  String? profession;
  List<Exam>? exams;
  DateTime createdAt;
  DateTime validUntil;

  User({
    required this.userName,
    required this.userSirname,
    required this.registryNumber,
    this.examCode,
    required this.email,
    this.education,
    this.profession,
    this.exams,
    required this.createdAt,
    required this.validUntil,
  });

  // From JSON with error handling and type checking
  factory User.fromJson(Map<String, dynamic> json) {
    try {
      // Directly extract values from the JSON if they exist
      return User(
        userName: json['user_name'] ?? 'Unknown',
        userSirname: json['user_sirname'] ?? 'Unknown',
        registryNumber: json['registry_number'] ?? 'Unknown',
        examCode:
            null, // Default to null since there's no exam code for this user type
        email: json['email'] ?? 'No email provided',
        education: json['education'] ?? 'Unknown',
        profession: json['profession'] ?? 'Unknown',
        exams: [], // No exams for this user
        createdAt: DateTime.parse(
            json['created_at'] ?? DateTime.now().toIso8601String()),
        validUntil: DateTime.parse(
            json['valid_until'] ?? DateTime.now().toIso8601String()),
      );
    } catch (e) {
      logger.d("Error parsing user: $e");
      // Return a default user in case of an error
      return User(
        userName: 'Unknown',
        userSirname: 'Unknown',
        registryNumber: 'Unknown',
        examCode: 'Unknown',
        email: 'No email provided',
        education: 'Unknown',
        profession: 'Unknown',
        exams: [],
        createdAt: DateTime.now(),
        validUntil: DateTime.now(),
      );
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
      'education': education,
      'profession': profession,
      'exams': exams?.map((e) => e.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'valid_until': validUntil.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'User(userName: $userName, userSirname: $userSirname, registryNumber: $registryNumber, examCode: $examCode, email: $email, education: $education, profession: $profession, exams: $exams, createdAt: $createdAt, validUntil: $validUntil)';
  }
}
