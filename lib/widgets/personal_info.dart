import 'package:flutter/material.dart';
import 'package:onemissystem/models/exam_json.dart';
import 'package:onemissystem/models/major.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:onemissystem/api/get_api_url.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({
    super.key,
    required this.student,
    required this.major,
  });

  final Major major;
  final Student student;

  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  String? _requiredFieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final Student student = widget.student;
    final Major major = widget.major;
    String rulesPath = 'assets/documents/Сургалтын_Журам.pdf';
    bool canProceed = false;
    final userRole = 'Оюутан';
    TextEditingController birthdayController = TextEditingController();
    TextEditingController familyTreeNamController = TextEditingController();
    TextEditingController lnameController = TextEditingController();
    TextEditingController citizenshipController = TextEditingController();
    TextEditingController validAddress = TextEditingController();
    TextEditingController homePhoneNumberController = TextEditingController();
    TextEditingController validAddressLiving = TextEditingController();
    TextEditingController postalAddressController = TextEditingController();
    TextEditingController phoneNumberController = TextEditingController();
    TextEditingController phoneNumberEmergencyController =
        TextEditingController();
    TextEditingController placeOfBirthContoller = TextEditingController();
    TextEditingController socialBackgroundController = TextEditingController();
    TextEditingController townDistrictOfBirthController =
        TextEditingController();
    TextEditingController stateCityOfBirthController = TextEditingController();
    TextEditingController ethnicityController = TextEditingController();
    TextEditingController professionController = TextEditingController();
    TextEditingController fPassportNumberController = TextEditingController();
    TextEditingController driversCertificateNumberController =
        TextEditingController();
    TextEditingController additionalDescriptionController =
        TextEditingController();

    final formKey = GlobalKey<FormState>();
    String? selectedGender;
    String? selectedCityOrState;
    String? selectedDistrictOrTown;
    String? selectedCountry;
    String? selectedEducation;
    String? selectedAcademicDegree;
    String? militaryService;
    String? bloodType;
    String? driversLicenseType;
    String? married;
    String? pensionsEstablished;
    String? disabled;
    String? selectedCityOrStateLiving;
    final List<String> countries = [
      'Монгол',
      'USA',
      'Canada',
      'Russia',
      'India',
      'China',
    ];
    final List<String> educations = [
      'Бага',
      'Дунд',
      'Ахлах',
      'Дээд',
      '*',
    ];
    final List<String> academicDegree = [
      'Бакалавр',
      'Магистр',
      'Доктор',
      '*',
    ];
    final List<String> served = [
      'Тийм',
      'Үгүй',
    ];
    final List<String> blood = [
      'O-',
      'A-',
      'B-',
      'AB-',
      'O+',
      'A+',
      'B+',
      'AB+',
    ];
    final List<String> driversLicense = [
      'A',
      'B',
      'C1',
      'C1E',
      'C',
      'CE',
      'D1',
      'D1E',
      'D',
      'ME',
      'M',
    ];
    final List<String> marriedOrNot = [
      'Гэрлэсэн',
      'Гэрлээгүй',
    ];
    final List<String> pension = [
      'Тийм',
      'Үгүй',
    ];
    final List<String> disability = [
      'Тийм',
      'Үгүй',
    ];

    Future<List> createContract() async {
      DateTime createdAt = DateTime.now();
      String createdAtString = createdAt.toIso8601String();

      try {
        final response = await http.post(
          getApiUrl('/Student/Signup/Create/User'),
          body: json.encode({
            'registryNumber': student.resgistryNumber,
            'profile_picture': '',
            'fname': student.studentName,
            'lname': student.studentSirname,
            'major': major,
            'userRole': userRole,
            'birthday': birthdayController.text,
            'familyTreeName': familyTreeNamController.text,
            'lastName': lnameController.text,
            'citizenship': citizenshipController.text,
            'validAddress': validAddress.text,
            'homePhoneNumber': homePhoneNumberController.text,
            'validAddressLiving': validAddressLiving.text,
            'postalAddress': postalAddressController.text,
            'phoneNumber': phoneNumberController.text,
            'phoneNumberEmergency': phoneNumberEmergencyController.text,
            'placeOfBirth': placeOfBirthContoller.text,
            'socialBackground': socialBackgroundController.text,
            'townDistrictOfBirth': townDistrictOfBirthController.text,
            'stateCityOfBirth': stateCityOfBirthController.text,
            'ethnicity': ethnicityController.text,
            'profession': professionController.text,
            'passportNumber': fPassportNumberController.text,
            'driversCertificateNumber': driversCertificateNumberController.text,
            'additionalDescription': additionalDescriptionController.text,
            'selectedGender': selectedGender,
            'selectedCityOrState': selectedCityOrState,
            'selectedDistrictOrTown': selectedDistrictOrTown,
            'selectedCountry': selectedCountry,
            'selectedEducation': selectedEducation,
            'selectedAcademicDegree': selectedAcademicDegree,
            'militaryService': militaryService,
            'bloodType': bloodType,
            'driversLicenseType': driversLicenseType,
            'married': married,
            'pensionsEstablished': pensionsEstablished,
            'disabled': disabled,
            'createdAt': createdAtString,
            'email': student.email
          }),
          headers: {'Content-Type': 'application/json'},
        ).timeout(Duration(seconds: 30));

        /*
        
        if (response.statusCode == 200) {

          final Map<String, dynamic> responseJson = jsonDecode(response.body);
          final Map<String, dynamic> examJson = responseJson['exam_json'];
          final student = Student.fromJson(examJson);
          logger.d(student.toString());
          return ['loginName': login_name, 'passwordHash': password_hash];
        } else {
          logger.d('Error: ${response.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Сурагч шалгалт өгөөгүй байна!')),
          );
          return student;
        }
      } catch (e) {
        logger.d('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Алдаа гарлаа, түр хүлээгээд дахин оролдоно уу.')),
        );
        return student;
      }
        
         */
      } catch (e) {
        print(e);
      }
      return [0];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Дэлгэрэнгүй анкет',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      backgroundColor: Colors.blue[50],
      body: SingleChildScrollView(
        // Scrollable body to prevent overflow
        child: Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
            bottom: 100.0,
            left: 20.0,
            right: 20.0,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  color: Colors.green[300],
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            "Шалгуулагчийн мэдээлэл",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: TextEditingController(
                                      text: student.studentName),
                                  decoration: InputDecoration(
                                    labelText: 'Нэр',
                                    border: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ), // Change border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .blue), // Border color when focused
                                    ),
                                  ),
                                  readOnly:
                                      true, // Makes the field read-only but without gray shading
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: TextEditingController(
                                      text: student.studentSirname),
                                  decoration: InputDecoration(
                                    labelText: 'Овог',
                                    border: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ), // Change border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .blue), // Border color when focused
                                    ),
                                  ),
                                  readOnly:
                                      true, // Makes the field read-only but without gray shading
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: TextEditingController(
                                      text: student.email),
                                  decoration: InputDecoration(
                                    labelText: 'И - мэйл',
                                    border: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ), // Change border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .blue), // Border color when focused
                                    ),
                                  ),
                                  readOnly:
                                      true, // Makes the field read-only but without gray shading
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: TextEditingController(
                                      text: student.resgistryNumber),
                                  decoration: InputDecoration(
                                    labelText: 'Регистрийн дугаар',
                                    border: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ), // Change border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .blue), // Border color when focused
                                    ),
                                  ),
                                  readOnly:
                                      true, // Makes the field read-only but without gray shading
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: TextEditingController(
                                      text:
                                          '${student.exams[0].examType}, ${student.exams[0].score}'),
                                  decoration: InputDecoration(
                                    labelText: 'Шалгалт 1',
                                    border: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ), // Change border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .blue), // Border color when focused
                                    ),
                                  ),
                                  readOnly:
                                      true, // Makes the field read-only but without gray shading
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: TextEditingController(
                                      text:
                                          '${student.exams[1].examType}, ${student.exams[1].score}'),
                                  decoration: InputDecoration(
                                    labelText: 'Шалгалт 2',
                                    border: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ), // Change border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .blue), // Border color when focused
                                    ),
                                  ),
                                  readOnly:
                                      true, // Makes the field read-only but without gray shading
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: TextEditingController(
                                      text: '${student.createdAt}'),
                                  decoration: InputDecoration(
                                    labelText: 'Шалгалт өгсөн огноо',
                                    border: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ), // Change border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .blue), // Border color when focused
                                    ),
                                  ),
                                  readOnly:
                                      true, // Makes the field read-only but without gray shading
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: TextEditingController(
                                      text: '${student.validUntil}'),
                                  decoration: InputDecoration(
                                    labelText: 'Хүчинтэй хугацаа',
                                    border: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ), // Change border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .blue), // Border color when focused
                                    ),
                                  ),
                                  readOnly:
                                      true, // Makes the field read-only but without gray shading
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                ),
                Card(
                  color: Colors.blue,
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            "Хүмүүнлэгийн Ухааны Их Сургуулийн Элсэлтийн Дэлгэрэнгүй Анкет",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: TextEditingController(
                                      text: widget.major.majorName),
                                  decoration: InputDecoration(
                                    labelText: 'Хөтөлбөр',
                                    border: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ), // Change border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .black), // Border color when focused
                                    ),
                                  ),
                                  readOnly:
                                      true, // Makes the field read-only but without gray shading
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Card(
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            "Үндсэн мэдээлэл",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: TextEditingController(
                                      text: student.resgistryNumber),
                                  decoration: InputDecoration(
                                    labelText: 'Оюутны регистрийн дугаар',
                                    border: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ), // Change border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .blue), // Border color when focused
                                    ),
                                  ),
                                  readOnly: true,
                                  keyboardType: TextInputType.text,
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    DateTime? selectedDate =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime(2101),
                                    );
                                    if (selectedDate != null) {
                                      String formattedDate =
                                          "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
                                      birthdayController.text = formattedDate;
                                    }
                                  },
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      controller: birthdayController,
                                      decoration: InputDecoration(
                                        labelText: 'Төрсөн огноо',
                                        hintText: 'yyyy-mm-dd',
                                        border: OutlineInputBorder(),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                          ), // Change border color
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors
                                                  .blue), // Border color when focused
                                        ),
                                      ),
                                      readOnly: true,
                                      keyboardType: TextInputType.datetime,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Зайлшгүй бөглөх шаардлагатай';
                                        }
                                        final RegExp dateRegExp =
                                            RegExp(r'^\d{4}-\d{2}-\d{2}$');
                                        if (!dateRegExp.hasMatch(value)) {
                                          return 'Огноо "yyyy-mm-dd" форматаар байх ёстой';
                                        }
                                        return null;
                                      },
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'\d|-')),
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: familyTreeNamController,
                                  decoration: InputDecoration(
                                    labelText: 'Ургын овог',
                                    border: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ), // Change border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .blue), // Border color when focused
                                    ),
                                  ),
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Зайлшгүй бөглөх шаардлагатай';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: 'Хүйс',
                                    border: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ), // Change border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .blue), // Border color when focused
                                    ),
                                  ),
                                  value: selectedGender,
                                  items: ['эрэгтэй', 'эмэгтэй', 'бусад']
                                      .map((gender) {
                                    return DropdownMenuItem<String>(
                                      value: gender,
                                      child: Text(gender),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    selectedGender = newValue;
                                  },
                                  hint: Text('Хүйс сонгох'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                    controller: lnameController,
                                    decoration: InputDecoration(
                                      labelText: 'Эцэг / Эхийн нэр',
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                        ), // Change border color
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .blue), // Border color when focused
                                      ),
                                    ),
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Зайлшгүй бөглөх шаардлагатай.';
                                      }
                                      return null;
                                    }),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: TextFormField(
                                  controller: citizenshipController,
                                  decoration: InputDecoration(
                                    labelText: 'Иргэншил',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ), // Change border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .blue), // Border color when focused
                                    ),
                                  ),
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Зайлшгүй бөглөх шаардлагатай.';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Expanded(
                            child: TextField(
                              controller: TextEditingController(
                                  text:
                                      '${student.studentSirname}, ${student.studentName}'),
                              decoration: InputDecoration(
                                labelText: 'Овог нэр',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ), // Change border color
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .blue), // Border color when focused
                                ),
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Card(
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            "Үндсэн харъяалал",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: 'Аймаг / Хот',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ), // Change border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .blue), // Border color when focused
                                    ),
                                  ),
                                  value: selectedCityOrStateLiving,
                                  items: [
                                    'Улаанбаатар',
                                    'Эрдэнэт',
                                    'Дархан',
                                    'Сайншанд',
                                    'Ховд',
                                    'Өргөн',
                                    'Багануур',
                                    'Чойр',
                                    'Баянхонгор',
                                    'Мөрөн',
                                    'Архангай',
                                    'Баян-Өлгий',
                                    'Дорноговь',
                                    'Дундговь',
                                    'Завхан',
                                    'Өвөрхангай',
                                    'Өмнөговь',
                                    'Сүхбаатар',
                                    'Сэлэнгэ',
                                    'Төв',
                                    'Увс',
                                    'Хөвсгөл',
                                    'Хэнтий',
                                    'Дархан-Уул',
                                    'Орхон',
                                    'Говьсүмбэр',
                                    'Чингэлтэй',
                                  ].map((city) {
                                    return DropdownMenuItem<String>(
                                      value: city,
                                      child: Text(city),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    selectedCityOrStateLiving = newValue;
                                  },
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: TextFormField(
                                  controller: validAddress,
                                  decoration: InputDecoration(
                                    labelText: 'Бүртгэлтэй хаяг',
                                    hintText:
                                        'Хороо, гудамж, тоот, байрь хороолол',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ), // Change border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .blue), // Border color when focused
                                    ),
                                  ),
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Зайлшгүй бөглөх шаардлагатай';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: 'Сум / Дүүрэг',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ), // Change border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .blue), // Border color when focused
                                    ),
                                  ),
                                  value: selectedDistrictOrTown,
                                  items: [
                                    'Улаанбаатар',
                                    'Баянгол дүүрэг',
                                    'Баянзүрх дүүрэг',
                                    'Сүхбаатар дүүрэг',
                                    'Чингэлтэй дүүрэг',
                                    'Хан-Уул дүүрэг',
                                    'Налайх дүүрэг',
                                    'Багануур дүүрэг',
                                    'Багамун хороолол',
                                    'Өлзийт',
                                    'Даваа дүүрэг',
                                    'Архангай',
                                    'Цэцэрлэг',
                                    'Бат-Өлзий',
                                    'Есөнзүйл',
                                    'Тавантолгой',
                                    'Баян-Өлгий',
                                    'Өлгий',
                                    'Гурванбулаг',
                                    'Булган',
                                    'Хархорин',
                                    'Жаргалант',
                                    'Төгрөг',
                                    'Дорноговь',
                                    'Сайншанд',
                                    'Гурванцаг',
                                    'Таван толгой',
                                    'Багацогт',
                                    'Дундговь',
                                    'Чингис',
                                    'Баянжаргалан',
                                    'Гурвансайхан',
                                    'Завхан',
                                    'Хайрхан',
                                    'Баруун-Урт',
                                    'Өвөрхангай',
                                    'Арвайхээр',
                                    'Баян-Айраг',
                                    'Өмнөговь',
                                    'Даланзадгад',
                                    'Цогт-Овоо',
                                    'Шивээхүрэн',
                                    'Хандгайц',
                                    'Сүхбаатар',
                                    'Галшар',
                                    'Баян-Өндөр',
                                    'Түмэнцогт',
                                    'Сэлэнгэ',
                                    'Мандал',
                                    'Нээлт',
                                    'Төв',
                                    'Налайх',
                                    'Солонготой',
                                    'Баянхошуу',
                                    'Увс',
                                    'Ховд',
                                    'Чандмань',
                                    'Галт',
                                    'Наран',
                                    'Хэнтий',
                                    'Өргөтнөх',
                                    'Дархан-Уул',
                                    'Дархан',
                                    'Арцсуурь',
                                    'Ганзаги',
                                    'Орхон',
                                    'Эрдэнэт',
                                    'Шарын гол',
                                    'Хэрлэн',
                                    'Говьсүмбэр',
                                    'Эрдэнэ',
                                    'Чингэлтэй',
                                    'Баянзүрх',
                                    'Багануур',
                                    'Ганц нуур',
                                    'Цахилгаан',
                                  ].map((city) {
                                    return DropdownMenuItem<String>(
                                      value: city,
                                      child: Text(city),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    selectedDistrictOrTown = newValue;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Card(
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            "Оршин суугаа хаяг холбоо барих",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: 'Аймаг / Нийслэл',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ), // Change border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .blue), // Border color when focused
                                    ),
                                  ),
                                  value: selectedCityOrState,
                                  items: [
                                    'Улаанбаатар',
                                    'Эрдэнэт',
                                    'Дархан',
                                    'Сайншанд',
                                    'Ховд',
                                    'Өргөн',
                                    'Багануур',
                                    'Чойр',
                                    'Баянхонгор',
                                    'Мөрөн',
                                    'Архангай',
                                    'Баян-Өлгий',
                                    'Дорноговь',
                                    'Дундговь',
                                    'Завхан',
                                    'Өвөрхангай',
                                    'Өмнөговь',
                                    'Сүхбаатар',
                                    'Сэлэнгэ',
                                    'Төв',
                                    'Увс',
                                    'Хөвсгөл',
                                    'Хэнтий',
                                    'Дархан-Уул',
                                    'Орхон',
                                    'Говьсүмбэр',
                                    'Чингэлтэй',
                                  ].map((city) {
                                    return DropdownMenuItem<String>(
                                      value: city,
                                      child: Text(city),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    selectedCityOrState = newValue;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Expanded(
                            child: TextFormField(
                              controller: homePhoneNumberController,
                              decoration: InputDecoration(
                                labelText: 'Гэрийн утас',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ), // Change border color
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .blue), // Border color when focused
                                ),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Зайлшгүй бөглөх шаардлагатай';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: 'Сум / Дүүрэг',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ), // Change border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .blue), // Border color when focused
                                    ),
                                  ),
                                  value: selectedDistrictOrTown,
                                  items: [
                                    'Улаанбаатар',
                                    'Баянгол дүүрэг',
                                    'Баянзүрх дүүрэг',
                                    'Сүхбаатар дүүрэг',
                                    'Чингэлтэй дүүрэг',
                                    'Хан-Уул дүүрэг',
                                    'Налайх дүүрэг',
                                    'Багануур дүүрэг',
                                    'Багамун хороолол',
                                    'Өлзийт',
                                    'Даваа дүүрэг',
                                    'Архангай',
                                    'Цэцэрлэг',
                                    'Бат-Өлзий',
                                    'Есөнзүйл',
                                    'Тавантолгой',
                                    'Баян-Өлгий',
                                    'Өлгий',
                                    'Гурванбулаг',
                                    'Булган',
                                    'Хархорин',
                                    'Жаргалант',
                                    'Төгрөг',
                                    'Дорноговь',
                                    'Сайншанд',
                                    'Гурванцаг',
                                    'Таван толгой',
                                    'Багацогт',
                                    'Дундговь',
                                    'Чингис',
                                    'Баянжаргалан',
                                    'Гурвансайхан',
                                    'Завхан',
                                    'Хайрхан',
                                    'Баруун-Урт',
                                    'Өвөрхангай',
                                    'Арвайхээр',
                                    'Баян-Айраг',
                                    'Өмнөговь',
                                    'Даланзадгад',
                                    'Цогт-Овоо',
                                    'Шивээхүрэн',
                                    'Хандгайц',
                                    'Сүхбаатар',
                                    'Галшар',
                                    'Баян-Өндөр',
                                    'Түмэнцогт',
                                    'Сэлэнгэ',
                                    'Мандал',
                                    'Нээлт',
                                    'Төв',
                                    'Налайх',
                                    'Солонготой',
                                    'Баянхошуу',
                                    'Увс',
                                    'Ховд',
                                    'Чандмань',
                                    'Галт',
                                    'Наран',
                                    'Хэнтий',
                                    'Өргөтнөх',
                                    'Дархан-Уул',
                                    'Дархан',
                                    'Арцсуурь',
                                    'Ганзаги',
                                    'Орхон',
                                    'Эрдэнэт',
                                    'Шарын гол',
                                    'Хэрлэн',
                                    'Говьсүмбэр',
                                    'Эрдэнэ',
                                    'Чингэлтэй',
                                    'Баянзүрх',
                                    'Багануур',
                                    'Ганц нуур',
                                    'Цахилгаан',
                                  ].map((city) {
                                    return DropdownMenuItem<String>(
                                      value: city,
                                      child: Text(city),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    selectedDistrictOrTown = newValue;
                                  },
                                ),
                              ),
                              SizedBox(width: 8),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: validAddressLiving,
                                  maxLength: 100,
                                  decoration: InputDecoration(
                                    labelText: 'Гэрийн хаяг',
                                    hintText:
                                        'Хороо, гудамж, тоот, байрь хороолол',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ), // Change border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .blue), // Border color when focused
                                    ),
                                  ),
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Зайлшгүй бөглөх шаардлагатай';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: TextFormField(
                                  maxLength: 8,
                                  controller: phoneNumberController,
                                  decoration: InputDecoration(
                                    labelText: 'Гар утас',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ), // Change border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .blue), // Border color when focused
                                    ),
                                  ),
                                  keyboardType: TextInputType.phone,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Зайлшгүй бөглөх шаардлагатай';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  maxLength: 50,
                                  controller: phoneNumberEmergencyController,
                                  decoration: InputDecoration(
                                    labelText: 'Яаралтай үед холбоо барих',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ), // Change border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .blue), // Border color when focused
                                    ),
                                  ),
                                  keyboardType: TextInputType.phone,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Зайлшгүй бөглөх шаардлагатай';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: TextFormField(
                                  maxLength: 100,
                                  controller: postalAddressController,
                                  decoration: InputDecoration(
                                    labelText: 'Шуудангийн хаяг',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ), // Change border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .blue), // Border color when focused
                                    ),
                                  ),
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Зайлшгүй бөглөх шаардлагатай';
                                    }
                                    return null;
                                  },
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Card(
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(
                            "Төрсөн газар, үндэс угсаа",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              // Dropdown button wrapped with a Flexible widget to allow resizing
                              Flexible(
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: 'Улс',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ), // Change border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .blue), // Border color when focused
                                    ),
                                  ),
                                  value: selectedCountry,
                                  onChanged: (String? newValue) {
                                    selectedCountry = newValue;
                                  },
                                  items: countries.map((String countries) {
                                    return DropdownMenuItem<String>(
                                      value: countries,
                                      child: Text(countries),
                                    );
                                  }).toList(),
                                ),
                              ),
                              SizedBox(width: 8),
                              // TextFormField inside Expanded widget
                              Expanded(
                                child: TextFormField(
                                  controller: stateCityOfBirthController,
                                  decoration: InputDecoration(
                                    labelText: 'Аймаг / Нийслэл',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ), // Change border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .blue), // Border color when focused
                                    ),
                                  ),
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Зайлшгүй бөглөх шаардлагатай';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: ethnicityController,
                                  maxLength: 50,
                                  decoration: InputDecoration(
                                    labelText: 'Яс үндэс',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ), // Change border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .blue), // Border color when focused
                                    ),
                                  ),
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Зайлшгүй бөглөх шаардлагатай';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: TextFormField(
                                  controller: townDistrictOfBirthController,
                                  maxLength: 50,
                                  decoration: InputDecoration(
                                    labelText: 'Сум / Дүүрэг',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ), // Change border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .blue), // Border color when focused
                                    ),
                                  ),
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Зайлшгүй бөглөх шаардлагатай';
                                    }
                                    return null;
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: socialBackgroundController,
                                  maxLength: 25,
                                  decoration: InputDecoration(
                                    labelText: 'Нийгмийн гарал',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ), // Change border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .blue), // Border color when focused
                                    ),
                                  ),
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Зайлшгүй бөглөх шаардлагатай';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: TextFormField(
                                  controller: placeOfBirthContoller,
                                  maxLength: 100,
                                  decoration: InputDecoration(
                                    labelText: 'Төрсөн газар',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ), // Change border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .blue), // Border color when focused
                                    ),
                                  ),
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Зайлшгүй бөглөх шаардлагатай';
                                    }
                                    return null;
                                  },
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Card(
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(
                            "Мэргэжил Боловсрол",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              // Dropdown button wrapped with a Flexible widget to allow resizing
                              Flexible(
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: 'Боловсрол',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ), // Change border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .blue), // Border color when focused
                                    ),
                                  ),
                                  value: selectedEducation,
                                  onChanged: (String? newValue) {
                                    selectedEducation = newValue;
                                  },
                                  items: educations.map((String educations) {
                                    return DropdownMenuItem<String>(
                                      value: educations,
                                      child: Text(educations),
                                    );
                                  }).toList(),
                                ),
                              ),
                              SizedBox(width: 8),
                              // TextFormField inside Expanded widget
                              Flexible(
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: 'Эрдмийн зэрэг',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ), // Change border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .blue), // Border color when focused
                                    ),
                                  ),
                                  value: selectedAcademicDegree,
                                  onChanged: (String? newValue) {
                                    selectedAcademicDegree = newValue;
                                  },
                                  items: academicDegree
                                      .map((String academicDegree) {
                                    return DropdownMenuItem<String>(
                                      value: academicDegree,
                                      child: Text(academicDegree),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: professionController,
                                  maxLength: 100,
                                  decoration: InputDecoration(
                                    labelText: 'Мэргэжил',
                                    hintText: 'Заавал бөглөх шаардлагагүй',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ), // Change border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .blue), // Border color when focused
                                    ),
                                  ),
                                  keyboardType: TextInputType.text,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Card(
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(
                            "Бусад",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              // Dropdown button wrapped with a Flexible widget to allow resizing
                              Flexible(
                                child: TextFormField(
                                  controller: fPassportNumberController,
                                  decoration: InputDecoration(
                                    labelText: 'Гадаад паспортын дугаар',
                                    hintText: 'Заавал бөглөх шаадлагагүй',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ), // Change border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .blue), // Border color when focused
                                    ),
                                  ),
                                  keyboardType: TextInputType.text,
                                ),
                              ),
                              SizedBox(width: 8),
                              // TextFormField inside Expanded widget
                              Flexible(
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: 'Цусны бүлэг',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ), // Change border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .blue), // Border color when focused
                                    ),
                                  ),
                                  value: bloodType,
                                  onChanged: (String? newValue) {
                                    bloodType = newValue;
                                  },
                                  items: blood.map((String blood) {
                                    return DropdownMenuItem<String>(
                                      value: blood,
                                      child: Text(blood),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Flexible(
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: 'Гэрлэсэн эсэх',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ), // Change border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .blue), // Border color when focused
                                    ),
                                  ),
                                  value: married,
                                  onChanged: (String? newValue) {
                                    married = newValue;
                                  },
                                  items:
                                      marriedOrNot.map((String marriedOrNot) {
                                    return DropdownMenuItem<String>(
                                      value: marriedOrNot,
                                      child: Text(marriedOrNot),
                                    );
                                  }).toList(),
                                ),
                              ),
                              SizedBox(width: 8),
                              Flexible(
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: 'Жолооны ангилал',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ), // Change border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .blue), // Border color when focused
                                    ),
                                  ),
                                  value: driversLicenseType,
                                  onChanged: (String? newValue) {
                                    driversLicenseType = newValue;
                                  },
                                  items: driversLicense
                                      .map((String driversLicense) {
                                    return DropdownMenuItem<String>(
                                      value: driversLicense,
                                      child: Text(driversLicense),
                                    );
                                  }).toList(),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Flexible(
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: 'Цэргийн алба хаасан эсэх',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ), // Change border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .blue), // Border color when focused
                                    ),
                                  ),
                                  value: militaryService,
                                  onChanged: (String? newValue) {
                                    militaryService = newValue;
                                  },
                                  items: served.map((String served) {
                                    return DropdownMenuItem<String>(
                                      value: served,
                                      child: Text(served),
                                    );
                                  }).toList(),
                                ),
                              ),
                              SizedBox(width: 8),
                              Flexible(
                                child: TextFormField(
                                  controller:
                                      driversCertificateNumberController,
                                  decoration: InputDecoration(
                                    labelText: 'Жолооны Үүэмлэхний дугаар',
                                    hintText: 'Заавал бөглөх шаардлагагүй',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ), // Change border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .blue), // Border color when focused
                                    ),
                                  ),
                                  keyboardType: TextInputType.text,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Flexible(
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: 'Тэтгэвэр тогтоосон эсэх',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ), // Change border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .blue), // Border color when focused
                                    ),
                                  ),
                                  value: pensionsEstablished,
                                  onChanged: (String? newValue) {
                                    pensionsEstablished = newValue;
                                  },
                                  items: pension.map((String pension) {
                                    return DropdownMenuItem<String>(
                                      value: pension,
                                      child: Text(pension),
                                    );
                                  }).toList(),
                                ),
                              ),
                              SizedBox(width: 8),
                              Flexible(
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: 'Хөгжлийн бэрхшээл',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ), // Change border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .blue), // Border color when focused
                                    ),
                                  ),
                                  value: disabled,
                                  onChanged: (String? newValue) {
                                    disabled = newValue;
                                  },
                                  items: disability.map((String disability) {
                                    return DropdownMenuItem<String>(
                                      value: disability,
                                      child: Text(disability),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Flexible(
                                child: TextFormField(
                                  controller: additionalDescriptionController,
                                  maxLength: 250,
                                  decoration: InputDecoration(
                                    labelText: 'Нэмэлт тайлбар',
                                    hintText: 'Заавал бөглөх шаардлагагүй',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ), // Change border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .blue), // Border color when focused
                                    ),
                                  ),
                                  keyboardType: TextInputType.text,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/rules',
                    );
                  },
                  child: const Text('Сургалтын журамтай танилцах'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: !canProceed
                      ? () {
                          if (formKey.currentState?.validate() ?? false) {
                            // If the form is valid, submit it
                            // Handle form submission logic here
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Та түр хүлээнэ үү!')),
                            );
                            createContract();
                          } else {
                            // If the form is invalid, show a message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Заавал бөглөх хэсгүүдийг бөглөнө үү.')),
                            );
                          }
                          // Execute contract creation logic
                        }
                      : null, // If canProceed is false, the button is disabled
                  child: const Text('Сургалтын гэрээтэй танилцах'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
