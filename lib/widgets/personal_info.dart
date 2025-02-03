import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:studentsystem/models/exam_json.dart';
import 'package:studentsystem/models/major.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:studentsystem/api/get_api_url.dart';
import 'package:logger/logger.dart';
import 'package:studentsystem/widgets/pdf_viewer_screen.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

var logger = Logger();

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
  Uint8List? signature;
  String base64Signature = '';
  final controller = SignatureController(
    penColor: Colors.black,
    penStrokeWidth: 3,
    exportPenColor: Colors.red,
    exportBackgroundColor: Colors.white,
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool canProceed = false;
  int currentPage = 0;
  String errorMessage = ''; // To show any error
  bool isLoading = true; // To show loading indicator while PDF is loading
  PDFViewController? pdfViewController; // Controller to interact with PDFView
  int totalPages = 0;
  bool isPDFvisible = false;
  bool isPDFvisible1 = false;
  final userRole = 'Оюутан';
  final TextEditingController additionalDescriptionController =
      TextEditingController();

  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController familyTreeNamController = TextEditingController();
  final TextEditingController lnameController = TextEditingController();
  final TextEditingController citizenshipController = TextEditingController();
  final TextEditingController validAddress = TextEditingController();
  final TextEditingController homePhoneNumberController =
      TextEditingController();
  final TextEditingController validAddressLiving = TextEditingController();
  final TextEditingController postalAddressController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController phoneNumberEmergencyController =
      TextEditingController();
  final TextEditingController placeOfBirthContoller = TextEditingController();
  final TextEditingController socialBackgroundController =
      TextEditingController();
  final TextEditingController townDistrictOfBirthController =
      TextEditingController();
  final TextEditingController stateCityOfBirthController =
      TextEditingController();
  final TextEditingController ethnicityController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final TextEditingController fPassportNumberController =
      TextEditingController();
  final TextEditingController driversCertificateNumberController =
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

  @override
  void initState() {
    super.initState();

    selectedGender = null;
    selectedCityOrState = null;
    selectedDistrictOrTown = null;
    selectedCountry = null;
    selectedEducation = null;
    selectedAcademicDegree = null;
    militaryService = null;
    bloodType = null;
    driversLicenseType = null;
    married = null;
    pensionsEstablished = null;
    disabled = null;
    selectedCityOrStateLiving = null;
  }

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

  String? requiredFieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Танилцаж дууссанг баталгаажуулах'),
          content: Text('Баталгаажуулах уу?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  canProceed = true;
                  isPDFvisible = false;
                  logger.d(canProceed);
                });
                Navigator.of(context).pop();
              },
              child: Text('Баталгаажуулах'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Close the dialog, not the whole screen
              },
              child: Text('Хаах'),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog1() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Гэрээтэй танилцаж дууссанг баталгаажуулах'),
          content: Text('Баталгаажуулах уу?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  isPDFvisible1 = false;
                });
                base64Signature = base64Encode(signature as List<int>);
                controller.clear();
                Navigator.of(context).pop();
                if (formKey.currentState?.validate() ?? false) {
                  logger.d("correct");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Та түр хүлээнэ үү!')),
                  );
                  createContract().then((response) {
                    logger.d("Response from createContract: $response");
                    String message = response[0];

                    if (response.length > 1) {
                      var user = response[1];
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(message)),
                    );
                  }).catchError((e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Алдаа гарлаа: $e')),
                    );
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Заавал бөглөх хэсгүүдийг бөглөнө үү.')),
                  );
                }
              },
              child: Text('Баталгаажуулах'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Close the dialog, not the whole screen
              },
              child: Text('Хаах'),
            ),
          ],
        );
      },
    );
  }

  Future<List> createContract() async {
    DateTime createdAt = DateTime.now();
    String createdAtString = createdAt.toIso8601String();

    try {
      final response = await http.post(
        getApiUrl('/Student/Signup/Create/User'),
        body: json.encode({
          'registryNumber': widget.student.resgistryNumber,
          'profile_picture': '',
          'fname': widget.student.studentName,
          'lname': widget.student.studentSirname,
          'major': widget.major,
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
          'email': widget.student.email,
          'signature': base64Signature
        }),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson = jsonDecode(response.body);
        String message = responseJson['message'];
        var user = responseJson['user'];

        return [message, user];
      } else if (response.statusCode == 400) {
        final Map<String, dynamic> responseJson = jsonDecode(response.body);
        String message = responseJson['message'];

        return [message];
      } else if (response.statusCode == 500) {
        final Map<String, dynamic> responseJson = jsonDecode(response.body);
        String message = responseJson['message'];

        return [message];
      } else {
        return ['Unexpected response status: ${response.statusCode}'];
      }
    } catch (e) {
      logger.d('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Алдаа гарлаа, түр хүлээгээд дахин оролдоно уу.')),
      );
      return ['Error: $e'];
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: Stack(
        children: [
          SingleChildScrollView(
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: TextEditingController(
                                          text: widget.student.studentName),
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
                                          text: widget.student.studentSirname),
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: TextEditingController(
                                          text: widget.student.email),
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
                                          text: widget.student.resgistryNumber),
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: TextEditingController(
                                          text:
                                              '${widget.student.exams[0].examType}, ${widget.student.exams[0].score}'),
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
                                              '${widget.student.exams[1].examType}, ${widget.student.exams[1].score}'),
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: TextEditingController(
                                          text: '${widget.student.createdAt}'),
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
                                          text: '${widget.student.validUntil}'),
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
                                "Элсэлтийн Дэлгэрэнгүй Анкет",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: TextEditingController(
                                          text: widget.student.resgistryNumber),
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
                                          birthdayController.text =
                                              formattedDate;
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
                                            if (value == null ||
                                                value.isEmpty) {
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
                                            LengthLimitingTextInputFormatter(
                                                10),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Expanded(
                                child: TextField(
                                  controller: TextEditingController(
                                      text:
                                          '${widget.student.studentSirname}, ${widget.student.studentName}'),
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      maxLength: 50,
                                      controller:
                                          phoneNumberEmergencyController,
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
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
                                      items:
                                          educations.map((String educations) {
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
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
                                      items: marriedOrNot
                                          .map((String marriedOrNot) {
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
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
                                      items:
                                          disability.map((String disability) {
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: TextFormField(
                                      controller:
                                          additionalDescriptionController,
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
                        setState(() {
                          isPDFvisible =
                              true; // Show the PDF when the button is pressed
                        });
                      },
                      child: Text('Сургалтын журамтай танилцах'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: canProceed
                          ? () {
                              setState(() {
                                isPDFvisible1 =
                                    true; // Show the PDF when the button is pressed
                              });
                            }
                          : null,
                      child: Text('Сургалтын гэрээтэй танилцах'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isPDFvisible)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  // Optional: You can hide the PDF when tapping outside of it
                  setState(() {
                    isPDFvisible = false;
                  });
                },
                child: Container(
                  color: Colors.black
                      .withOpacity(0.5), // Semi-transparent background
                  child: Stack(
                    children: [
                      // The PDF itself
                      PDF(
                        fitPolicy: FitPolicy.WIDTH,
                        enableSwipe: true,
                        swipeHorizontal: true,
                        autoSpacing: false,
                        pageFling: false,
                        backgroundColor: Colors.grey,
                        onError: (error) {
                          logger.d(error.toString());
                        },
                        onPageError: (page, error) {
                          logger.d('$page: ${error.toString()}');
                        },
                      ).fromAsset('assets/documents/dummyPDF.pdf'),

                      // Button overlaid on the PDF
                      if (currentPage == totalPages)
                        Positioned(
                          bottom: 20,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () {
                                _showConfirmationDialog(); // Show dialog when button is pressed
                              },
                              child: Text('Танилцаж дууссанг баталгаажуулах'),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          if (isPDFvisible1)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  // Optional: You can hide the PDF when tapping outside of it
                  setState(() {
                    isPDFvisible1 = false;
                  });
                },
                child: Container(
                  color: Colors.black
                      .withOpacity(0.5), // Semi-transparent background
                  child: Stack(
                    children: [
                      // The PDF itself
                      PDF(
                        fitPolicy: FitPolicy.WIDTH,
                        enableSwipe: true,
                        swipeHorizontal: true,
                        autoSpacing: false,
                        pageFling: false,
                        backgroundColor: Colors.grey,
                        onError: (error) {
                          logger.d(error.toString());
                        },
                        onPageError: (page, error) {
                          logger.d('$page: ${error.toString()}');
                        },
                      ).fromAsset('assets/documents/dummyPDF.pdf'),

                      if (currentPage == totalPages)
                        Positioned(
                          bottom: 70,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Signature(
                                  controller: controller,
                                  width: double.infinity,
                                  height: 200,
                                  backgroundColor: Colors.yellowAccent,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () async => controller.clear(),
                                      icon: const Icon(Icons.clear),
                                      label: const Text('Арилгах'),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () async => controller.undo(),
                                      icon: const Icon(Icons.undo),
                                      label: const Text('Буцах'),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () async => controller.redo(),
                                      icon: const Icon(Icons.redo),
                                      label: const Text('Эхлэх'),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        signature =
                                            await controller.toPngBytes();

                                        setState(() {});
                                      },
                                      child: const Text('Болсон'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                if (signature != null)
                                  Image.memory(signature!,
                                      width: double.infinity),
                                ElevatedButton(
                                  onPressed: () {
                                    _showConfirmationDialog1(); // Show dialog when button is pressed
                                  },
                                  child: Text('Гэрээг баталгаажуулах'),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
