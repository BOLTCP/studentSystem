import 'package:logger/logger.dart';

var logger = Logger();

class AuthUser {
  final int userId;
  final String loginName;
  final String passwordHash;
  final String profilePicture;
  final String registryNumber;
  final String familyTreeName;
  final String fname;
  final String lname;
  final DateTime birthday;
  final String gender;
  final String citizenship;
  final String stateCity;
  final String townDistrict;
  final String validAddress;
  final String stateCityLiving;
  final String townDistrictLiving;
  final String validAddressLiving;
  final String? postalAddress; // Nullable field
  final String? homePhoneNumber; // Nullable field
  final String phoneNumber;
  final String phoneNumberEmergency;
  final String country;
  final String ethnicity;
  final String socialBackground;
  final String stateCityOfBirth;
  final String townDistrictOfBirth;
  final String placeOfBirth;
  final String education;
  final String currentAcademicDegree;
  final String? profession; // Nullable field
  final String? professionCertification; // Nullable field
  final String? fPassportNumber;
  final String married;
  final String militaryService;
  final String? pensionsEstablished; // Nullable field
  final String? additionalNotes; // Nullable field
  final String? bloodType; // Nullable field
  final String? driversCertificate;
  final String? driversCertificateNumber;
  final String disabled;
  final String userRole;
  final bool isActive;
  final String email;
  final DateTime createdAt;

  AuthUser({
    required this.userId,
    required this.loginName,
    required this.passwordHash,
    required this.profilePicture,
    required this.registryNumber,
    required this.familyTreeName,
    required this.fname,
    required this.lname,
    required this.birthday,
    required this.gender,
    required this.citizenship,
    required this.stateCity,
    required this.townDistrict,
    required this.validAddress,
    required this.stateCityLiving,
    required this.townDistrictLiving,
    required this.validAddressLiving,
    this.postalAddress,
    this.homePhoneNumber,
    required this.phoneNumber,
    required this.phoneNumberEmergency,
    required this.country,
    required this.ethnicity,
    required this.socialBackground,
    required this.stateCityOfBirth,
    required this.townDistrictOfBirth,
    required this.placeOfBirth,
    required this.education,
    required this.currentAcademicDegree,
    this.profession,
    this.professionCertification,
    this.fPassportNumber,
    required this.married,
    required this.militaryService,
    this.pensionsEstablished,
    this.additionalNotes,
    this.bloodType,
    required this.driversCertificate,
    required this.driversCertificateNumber,
    required this.disabled,
    required this.userRole,
    required this.isActive,
    required this.email,
    required this.createdAt,
  });

  // From JSON
  factory AuthUser.fromJsonAuthUser(Map<String, dynamic> json) {
    try {
      return AuthUser(
        userId: json['user_id'] ?? 0, // Provide default value if missing
        loginName: json['login_name'] ?? '', // Default to empty string
        passwordHash: json['password_hash'] ?? '', // Default to empty string
        profilePicture:
            json['profile_picture'] ?? '', // Default to empty string
        registryNumber:
            json['registry_number'] ?? '', // Default to empty string
        familyTreeName:
            json['family_tree_name'] ?? '', // Default to empty string
        fname: json['fname'] ?? '', // Default to empty string
        lname: json['lname'] ?? '', // Default to empty string
        birthday: json['birthday'] != null
            ? DateTime.parse(json['birthday'])
            : DateTime.now(), // Default to current date if missing or malformed
        gender: json['gender'] ?? '', // Default to empty string
        citizenship: json['citizenship'] ?? '', // Default to empty string
        stateCity: json['state_city'] ?? '', // Default to empty string
        townDistrict: json['town_district'] ?? '', // Default to empty string
        validAddress: json['valid_address'] ?? '', // Default to empty string
        stateCityLiving:
            json['state_city_living'] ?? '', // Default to empty string
        townDistrictLiving:
            json['town_district_living'] ?? '', // Default to empty string
        validAddressLiving:
            json['valid_address_living'] ?? '', // Default to empty string
        postalAddress:
            json['postal_address'] ?? '', // Default to empty string (nullable)
        homePhoneNumber: json['home_phone_number'] ??
            '', // Default to empty string (nullable)
        phoneNumber: json['phone_number'] ?? '', // Default to empty string
        phoneNumberEmergency:
            json['phone_number_emergency'] ?? '', // Default to empty string
        country: json['country'] ?? '', // Default to empty string
        ethnicity: json['ethnicity'] ?? '', // Default to empty string
        socialBackground:
            json['social_background'] ?? '', // Default to empty string
        stateCityOfBirth:
            json['state_city_of_birth'] ?? '', // Default to empty string
        townDistrictOfBirth:
            json['town_district_of_birth'] ?? '', // Default to empty string
        placeOfBirth: json['place_of_birth'] ?? '', // Default to empty string
        education: json['education'] ?? '', // Default to empty string
        currentAcademicDegree:
            json['current_academic_degree'] ?? '', // Default to empty string
        profession:
            json['profession'] ?? '', // Default to empty string (nullable)
        professionCertification: json['profession_certification'] ??
            '', // Default to empty string (nullable)
        fPassportNumber:
            json['f_passport_number'] ?? '', // Default to empty string
        married: json['married'] ?? '', // Default to empty string
        militaryService:
            json['military_service'] ?? '', // Default to empty string
        pensionsEstablished: json['pensions_established'] ??
            '', // Default to empty string (nullable)
        additionalNotes: json['additional_notes'] ??
            '', // Default to empty string (nullable)
        bloodType:
            json['blood_type'] ?? '', // Default to empty string (nullable)
        driversCertificate:
            json['drivers_certificate'] ?? '', // Default to empty string
        driversCertificateNumber: json['drivers_certificate_number'] ?? '',
        disabled: json['disabled'] ?? '', // Default to empty string
        userRole: json['user_role'] ?? '', // Default to empty string if missing
        isActive: json['is_active'] ?? true, // Default to true if missing
        email: json['email'] ?? '', // Default to empty string
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : DateTime.now(), // Default to current date if missing
      );
    } catch (e) {
      logger.d('Error parsing field: $e');
      rethrow; // This rethrows the exception, which can be caught in your Flutter app
    }
  }

  @override
  String toString() {
    return 'AuthUser(user_role: $userRole)';
  }
}
