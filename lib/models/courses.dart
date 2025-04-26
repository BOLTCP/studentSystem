class Courses {
  final List<Course> courses;

  Courses({required this.courses});

  factory Courses.fromJsonCourses(List<dynamic> json) {
    List<Course> coursesList = json
        .where((courseJson) => courseJson != null)
        .map((courseJson) => Course.fromJsonCourses(courseJson ?? {}))
        .toList();

    return Courses(courses: coursesList);
  }
}

class Course {
  final int courseId;
  final String courseName;
  final String courseCode;
  final String courseType;
  final String courseYear;
  final int totalCredits;
  final int majorId;
  final String description;
  final String courseSeason;
  final int? timesPerWeek;

  Course({
    required this.courseId,
    required this.courseName,
    required this.courseCode,
    required this.courseType,
    required this.courseYear,
    required this.totalCredits,
    required this.majorId,
    this.description = '*',
    this.courseSeason = 'Намар, Өвөл, Хавар, Зун',
    this.timesPerWeek = 0,
  });

  // Factory constructor to create a Course instance from JSON
  factory Course.fromJsonCourses(Map<String, dynamic> json) {
    return Course(
      courseId: json['course_id'] as int,
      courseName: json['course_name'] as String,
      courseCode: json['course_code'] as String,
      courseType: json['course_type'] as String,
      courseYear: json['course_year'] as String,
      totalCredits: json['total_credits'] as int,
      majorId: json['major_id'] as int,
      description: json['description'] as String,
      courseSeason: json['course_season'] as String,
      timesPerWeek: json['times_per_week'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'course_id': courseId,
      'course_name': courseName,
      'course_code': courseCode,
      'course_type': courseType,
      'course_year': courseYear,
      'total_credits': totalCredits,
      'major_id': majorId,
      'description': description,
      'course_season': courseSeason,
    };
  }
}
