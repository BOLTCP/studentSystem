  1.Үндсэн Dart логик
  lib/ хавтсанд байрлах
  Платформ тус бүрийн код:
  windows/, linux/, android/ хавтаснуудад C++, C, болон CMake файлууд
  Desktop build-д зориулсан
  Чиглүүлэлт ба Навигаци
  Байршил: lib/main.dart
  Доорх замууд тодорхойлогдсон:
  /login_screen → Нэвтрэх дэлгэц
  /contact_us → Холбоо барих
  /admission_courses, /user_signup, /student_signup, /courses, /user_profile гэх мэт
  Widget-ууд
  Оюутан:
  student_signup.dart
  personal_info.dart
  Багш:
  teacher_dashboard.dart
  teachers_majors.dart
  Хичээлүүд:
  courses_screen.dart
  courses_default.dart
  admission_courses.dart

  2.Бизнес Логик ба Моделууд
  Байршил: lib/models/
  major.dart — Мэргэжлийн entity
  user.dart, user_details.dart — Хэрэглэгчийн болон профайл мэдээлэл
  API Интеграци
  Dart-ийн http санг ашиглан API дуудалтууд хийдэг
  Жишээ: courses.dart файлд мэргэжлийн мэдээлэл татаж авах
  Backend логик:
  lib/api/server.js файлд байрлах
  Үйлдлүүд:
  Хэрэглэгч бүртгэх
  Нууц үг шифрлэх (bcrypt ашиглан)
  Профайл мэдээлэл удирдах
  Багш болон оюутны үүрэгт суурилсан (role-based) логик хэрэгжүүлдэг
  Бүтцэт JSON хариулт буцаадаг

  3.Код Бичих Ур Чадварууд

  Flutter/Dart:
  Stateless болон Stateful widget-уудыг цэвэр хуваарилсан
  Чиглүүлэлтийн менежмент сайн зохион байгуулсан
  async/await болон сүлжээний (network) үйлдлүүдэд алдаа барих (error handling) ашигласан
  Загварчлал ба Абстракци:
  API болон Model-уудыг тусгаарлан зохион байгуулсан тул код арчилгаа (maintainability) сайтай
  Хөндлөн Платформ Дизайн:
  Desktop build-д зориулсан CMake болон platform-specific runner-уудыг ашигласан
  Backend Интеграци:
  Node.js + JavaScript backend ашиглан:
  Хэрэглэгчийн нэвтрэлт
  Нууц үгийн хамгаалалт (bcrypt)
  Хувийн мэдээлэл удирдах
  Хэрэглэгчийн үүрэг (role)-ийг динамикаар оноох


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

  3. Coding Skills Highlights
  Flutter/Dart:
  Clean widget separation, stateless/stateful widgets, and route management.
  API and model abstraction for maintainability.
  Use of async/await and error handling in network operations.
  Cross-platform Design:
  CMake and platform-specific runners for desktop support.
  Backend Integration:
  Node.js/JavaScript backend logic for user authentication and profile management.
  Secure password handling and dynamic user role assignment.
