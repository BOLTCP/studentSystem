import 'package:logger/logger.dart';

var logger = Logger();

class Major {
  final int majorId;
  final String majorName;
  final DateTime majorsYear;
  final String majorsType;
  final double creditUnitRate;
  final double majorTuition;
  final String academicDegree;
  final int totalYears;
  final int totalCreditsPerYear;
  final int departmentsOfEducationiD;
  final DateTime createdAt;
  final double exam1;
  final double exam2;
  final String? majorsDescription;
  final String? descriptionBrief;
  final Map<String, dynamic>? qualifications;
  final String? qualifications1;
  final String? qualifications2;
  final String signUps;

  Major({
    required this.majorId,
    required this.majorName,
    required this.majorsYear,
    required this.majorsType,
    required this.creditUnitRate,
    required this.majorTuition,
    required this.academicDegree,
    required this.totalYears,
    required this.totalCreditsPerYear,
    required this.departmentsOfEducationiD,
    required this.createdAt,
    required this.exam1,
    required this.exam2,
    this.majorsDescription,
    this.descriptionBrief,
    this.qualifications,
    this.qualifications1,
    this.qualifications2,
    required this.signUps,
  });

  @override
  String toString() {
    return 'Major: $majorName, Year: $majorsYear, Type: $majorsType, Credit Unit Rate: $creditUnitRate, Major Tuition: $majorTuition, Academic Degree: $academicDegree, '
        'Total Years: $totalYears, Total Credits per Year: $totalCreditsPerYear, Created At: $createdAt, '
        'Exam1: $exam1, Exam2: $exam2, Description: $majorsDescription, Brief Description: $descriptionBrief, '
        'Qualifications: $qualifications, Qualifications1: $qualifications1, Qualifications2: $qualifications2';
  }

  factory Major.fromJson(Map<String, dynamic> json) {
    return Major(
      majorId: json['major_id'],
      majorName: json['major_name'],
      majorsYear: DateTime.parse(json['majors_year']),
      majorsType: json['majors_type'],
      creditUnitRate: _parseCurrency(json['credit_unit_rate']),
      majorTuition: _parseCurrency(json['major_tuition']),
      academicDegree: json['academic_degree'],
      totalYears: json['total_years'],
      totalCreditsPerYear: json['total_credits_per_year'],
      departmentsOfEducationiD: json['department_of_edu_id'],
      createdAt: DateTime.parse(json['created_at']),
      exam1: (json['exam1'] as num).toDouble(),
      exam2: (json['exam2'] as num).toDouble(),
      majorsDescription: json['majors_description'],
      descriptionBrief: json['description_brief'],
      qualifications: json['qualifications'] != null
          ? Map<String, dynamic>.from(json['qualifications'])
          : null,
      qualifications1: json['qualifications1'],
      qualifications2: json['qualifications2'],
      signUps: json['sign_ups'],
    );
  }

// Helper function to parse currency strings into double
  static double _parseCurrency(String currency) {
    if (currency.isEmpty) return 0.0;

    // Remove the dollar sign, commas, and parse the remaining number as double
    String parsed = currency.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(parsed) ?? 0.0;
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'major_id': majorId,
      'major_name': majorName,
      'majors_year': majorsYear.toIso8601String(),
      'majors_type': majorsType,
      'credit_unit_rate': creditUnitRate,
      'major_tuition': majorTuition,
      'academic_degree': academicDegree,
      'total_years': totalYears,
      'total_credits_per_year': totalCreditsPerYear,
      'department_of_edu_id': departmentsOfEducationiD,
      'created_at': createdAt.toIso8601String(),
      'exam1': exam1,
      'exam2': exam2,
      'majors_description': majorsDescription,
      'description_brief': descriptionBrief,
      'qualifications': qualifications,
      'qualifications1': qualifications1,
      'qualifications2': qualifications2,
      'sign_ups': signUps,
    };
  }
}

class MajorBrief {
  final int majorId;
  final String majorName;
  final String? majorsDescription;

  MajorBrief({
    required this.majorId,
    required this.majorName,
    this.majorsDescription,
  });

  factory MajorBrief.fromJson(Map<String, dynamic> json) {
    try {
      return MajorBrief(
        majorId: json['major_id'],
        majorName: json['major_name'] ?? '',
        majorsDescription: json['majors_description'] ?? '',
      );
    } catch (e) {
      logger.d('Error parsing field: $e');
      rethrow; // This rethrows the exception, which can be caught in your Flutter app
    }
  }
}
