Application Structure

  1.
  Main Dart logic in lib/
  Platform-specific C++, C, and CMake files for desktop targets under windows/, linux/, and android/
  API/backend logic in lib/api/
  Routing and Navigation
  Defined in lib/main.dart:

  /login_screen → Login
  /contact_us → Contact page
  /admission_courses, /user_signup, /student_signup, /courses, /user_profile etc.
  Widgets
  
  Student: student_signup.dart, personal_info.dart
  Teacher: teacher_dashboard.dart, teachers_majors.dart
  Course: courses_screen.dart, courses_default.dart, admission_courses.dart
    
  2. Key Business Logic
  Models:
  Found under lib/models/
  major.dart — Major entity
  user.dart, user_details.dart — User and profile information
  API Integration:
  HTTP requests use Dart’s http package, e.g. in courses.dart for fetching major details.
  Backend logic is in lib/api/server.js:
  Handles user registration, password hashing, profile info, and more.
  Applies role-based logic for both teachers and students.
  Uses bcrypt for security and returns structured user data.

  3. Platform Support and Build System
  Windows, Linux, Android:
  Each platform has specific runner code and build instructions, e.g.:
  windows/runner/main.cpp, linux/runner/my_application.cc
  CMake files set up builds and plugin support for desktop environments.

  4. Coding Skills Highlights
  Flutter/Dart:
  Clean widget separation, stateless/stateful widgets, and route management.
  API and model abstraction for maintainability.
  Use of async/await and error handling in network operations.
  Cross-platform Design:
  CMake and platform-specific runners for desktop support.
  Backend Integration:
  Node.js/JavaScript backend logic for user authentication and profile management.
  Secure password handling and dynamic user role assignment.
