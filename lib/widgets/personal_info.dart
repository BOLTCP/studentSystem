import 'package:flutter/material.dart';
import 'package:onemissystem/models/exam_json.dart';
import 'package:onemissystem/models/major.dart';
import 'package:flutter/services.dart';

class PersonalInfo extends StatefulWidget {
  final Major major;
  final Student student;

  const PersonalInfo({
    super.key,
    required this.student,
    required this.major,
  });

  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  @override
  Widget build(BuildContext context) {
    final Student student = widget.student;
    final Major major = widget.major;
    TextEditingController dateController = TextEditingController();
    TextEditingController familyTreeName = TextEditingController();
    TextEditingController parentName = TextEditingController();
    TextEditingController nationality = TextEditingController();

    final _formKey = GlobalKey<FormState>();
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
                                controller:
                                    TextEditingController(text: student.email),
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
                                  DateTime? selectedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2101),
                                  );
                                  if (selectedDate != null) {
                                    String formattedDate =
                                        "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
                                    dateController.text = formattedDate;
                                  }
                                },
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    controller: dateController,
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
                                controller: familyTreeName,
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
                                  setState(() {
                                    selectedGender = newValue;
                                  });
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
                                  controller: parentName,
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
                                controller: nationality,
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
                              border: OutlineInputBorder(
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

              // Second Card - Address Information
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
                                  border: OutlineInputBorder(),
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
                                  'Баянхонгор',
                                  'Дорноговь',
                                  'Дундговь',
                                  'Завхан',
                                  'Өвөрхангай',
                                  'Өмнөговь',
                                  'Сүхбаатар',
                                  'Сэлэнгэ',
                                  'Төв',
                                  'Увс',
                                  'Ховд',
                                  'Хөвсгөл',
                                  'Хэнтий',
                                  'Дархан-Уул',
                                  'Орхон',
                                  'Говьсүмбэр',
                                  'Чингэлтэй',
                                  'Багануур',
                                ].map((city) {
                                  return DropdownMenuItem<String>(
                                    value: city,
                                    child: Text(city),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedCityOrState = newValue;
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                controller: dateController,
                                decoration: InputDecoration(
                                  labelText: 'Бүртгэлтэй хаяг',
                                  hintText:
                                      'Хороо, гудамж, тоот, байрь хороолол',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.text,
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
                                  border: OutlineInputBorder(),
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
                                  'Өлзийт',
                                  'Тавантолгой',
                                  'Баян-Өлгий',
                                  'Өлгий',
                                  'Гурванбулаг',
                                  'Булган',
                                  'Хархорин',
                                  'Жаргалант',
                                  'Төгрөг',
                                  'Баянхонгор',
                                  'Баянхонгор',
                                  'Өлзийт',
                                  'Жаргалант',
                                  'Галшар',
                                  'Заг',
                                  'Дорноговь',
                                  'Сайншанд',
                                  'Дорноговь',
                                  'Гурванцаг',
                                  'Таван толгой',
                                  'Багацогт',
                                  'Дундговь',
                                  'Дундговь',
                                  'Чингис',
                                  'Баянжаргалан',
                                  'Гурвансайхан',
                                  'Сайншанд',
                                  'Завхан',
                                  'Завхан',
                                  'Жаргалант',
                                  'Төгрөг',
                                  'Хайрхан',
                                  'Баруун-Урт',
                                  'Өвөрхангай',
                                  'Өвөрхангай',
                                  'Арвайхээр',
                                  'Баян-Айраг',
                                  'Цэцэрлэг',
                                  'Өмнөговь',
                                  'Даланзадгад',
                                  'Цогт-Овоо',
                                  'Шивээхүрэн',
                                  'Сайншанд',
                                  'Хандгайц',
                                  'Сүхбаатар',
                                  'Сүхбаатар',
                                  'Галшар',
                                  'Баян-Өндөр',
                                  'Түмэнцогт',
                                  'Жаргалант',
                                  'Сэлэнгэ',
                                  'Сэлэнгэ',
                                  'Баруун-Урт',
                                  'Шарын гол',
                                  'Мандал',
                                  'Нээлт',
                                  'Төв',
                                  'Төв',
                                  'Налайх',
                                  'Солонготой',
                                  'Баянхошуу',
                                  'Увс',
                                  'Увс',
                                  'Баян-Өлгий',
                                  'Ховд',
                                  'Өлгий',
                                  'Ховд',
                                  'Чандмань',
                                  'Баянхошуу',
                                  'Галшар',
                                  'Завхан',
                                  'Хөвсгөл',
                                  'Хөвсгөл',
                                  'Мөрөн',
                                  'Галт',
                                  'Наран',
                                  'Хэнтий',
                                  'Хэнтий',
                                  'Жаргалант',
                                  'Өргөтнөх',
                                  'Чингис',
                                  'Баруун-Урт',
                                  'Дархан-Уул',
                                  'Дархан',
                                  'Арцсуурь',
                                  'Шарын гол',
                                  'Ганзаги',
                                  'Орхон',
                                  'Орхон',
                                  'Эрдэнэт',
                                  'Шарын гол',
                                  'Хэрлэн',
                                  'Говьсүмбэр',
                                  'Говьсүмбэр',
                                  'Эрдэнэ',
                                  'Чингэлтэй',
                                  'Чингэлтэй',
                                  'Баянзүрх',
                                  'Налайх',
                                  'Багануур',
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
                                  setState(() {
                                    selectedDistrictOrTown = newValue;
                                  });
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
                                  border: OutlineInputBorder(),
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
                                  'Баянхонгор',
                                  'Дорноговь',
                                  'Дундговь',
                                  'Завхан',
                                  'Өвөрхангай',
                                  'Өмнөговь',
                                  'Сүхбаатар',
                                  'Сэлэнгэ',
                                  'Төв',
                                  'Увс',
                                  'Ховд',
                                  'Хөвсгөл',
                                  'Хэнтий',
                                  'Дархан-Уул',
                                  'Орхон',
                                  'Говьсүмбэр',
                                  'Чингэлтэй',
                                  'Багануур',
                                ].map((city) {
                                  return DropdownMenuItem<String>(
                                    value: city,
                                    child: Text(city),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedCityOrState = newValue;
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                controller: dateController,
                                decoration: InputDecoration(
                                  labelText: 'Гэрийн утас',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.phone,
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
                                  border: OutlineInputBorder(),
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
                                  'Өлзийт',
                                  'Тавантолгой',
                                  'Баян-Өлгий',
                                  'Өлгий',
                                  'Гурванбулаг',
                                  'Булган',
                                  'Хархорин',
                                  'Жаргалант',
                                  'Төгрөг',
                                  'Баянхонгор',
                                  'Баянхонгор',
                                  'Өлзийт',
                                  'Жаргалант',
                                  'Галшар',
                                  'Заг',
                                  'Дорноговь',
                                  'Сайншанд',
                                  'Дорноговь',
                                  'Гурванцаг',
                                  'Таван толгой',
                                  'Багацогт',
                                  'Дундговь',
                                  'Дундговь',
                                  'Чингис',
                                  'Баянжаргалан',
                                  'Гурвансайхан',
                                  'Сайншанд',
                                  'Завхан',
                                  'Завхан',
                                  'Жаргалант',
                                  'Төгрөг',
                                  'Хайрхан',
                                  'Баруун-Урт',
                                  'Өвөрхангай',
                                  'Өвөрхангай',
                                  'Арвайхээр',
                                  'Баян-Айраг',
                                  'Цэцэрлэг',
                                  'Өмнөговь',
                                  'Даланзадгад',
                                  'Цогт-Овоо',
                                  'Шивээхүрэн',
                                  'Сайншанд',
                                  'Хандгайц',
                                  'Сүхбаатар',
                                  'Сүхбаатар',
                                  'Галшар',
                                  'Баян-Өндөр',
                                  'Түмэнцогт',
                                  'Жаргалант',
                                  'Сэлэнгэ',
                                  'Сэлэнгэ',
                                  'Баруун-Урт',
                                  'Шарын гол',
                                  'Мандал',
                                  'Нээлт',
                                  'Төв',
                                  'Төв',
                                  'Налайх',
                                  'Солонготой',
                                  'Баянхошуу',
                                  'Увс',
                                  'Увс',
                                  'Баян-Өлгий',
                                  'Ховд',
                                  'Өлгий',
                                  'Ховд',
                                  'Чандмань',
                                  'Баянхошуу',
                                  'Галшар',
                                  'Завхан',
                                  'Хөвсгөл',
                                  'Хөвсгөл',
                                  'Мөрөн',
                                  'Галт',
                                  'Наран',
                                  'Хэнтий',
                                  'Хэнтий',
                                  'Жаргалант',
                                  'Өргөтнөх',
                                  'Чингис',
                                  'Баруун-Урт',
                                  'Дархан-Уул',
                                  'Дархан',
                                  'Арцсуурь',
                                  'Шарын гол',
                                  'Ганзаги',
                                  'Орхон',
                                  'Орхон',
                                  'Эрдэнэт',
                                  'Шарын гол',
                                  'Хэрлэн',
                                  'Говьсүмбэр',
                                  'Говьсүмбэр',
                                  'Эрдэнэ',
                                  'Чингэлтэй',
                                  'Чингэлтэй',
                                  'Баянзүрх',
                                  'Налайх',
                                  'Багануур',
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
                                  setState(() {
                                    selectedDistrictOrTown = newValue;
                                  });
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
                                maxLength: 100,
                                decoration: InputDecoration(
                                  labelText: 'Гэрийн хаяг',
                                  hintText:
                                      'Хороо, гудамж, тоот, байрь хороолол',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                maxLength: 8,
                                controller: dateController,
                                decoration: InputDecoration(
                                  labelText: 'Гар утас',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.phone,
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
                                decoration: InputDecoration(
                                  labelText: 'Яаралтай үед холбоо барих',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.phone,
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Шуудангийн хаяг',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.text,
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
                                  border: OutlineInputBorder(),
                                ),
                                value: selectedCountry,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedCountry = newValue;
                                  });
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
                                decoration: InputDecoration(
                                    labelText: 'Аймаг / Нийслэл',
                                    border: OutlineInputBorder(),
                                    hintText: 'Улсын Аймаг / Нийслэл'),
                                keyboardType: TextInputType.text,
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
                                decoration: InputDecoration(
                                  labelText: 'Яс үндэс',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                maxLength: 50,
                                decoration: InputDecoration(
                                  labelText: 'Сум / Дүүрэг',
                                  border: OutlineInputBorder(),
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
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Нийгмийн гарал',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Төрсөн газар',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.text,
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
                                  border: OutlineInputBorder(),
                                ),
                                value: selectedEducation,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedEducation = newValue;
                                  });
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
                                  border: OutlineInputBorder(),
                                ),
                                value: selectedAcademicDegree,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedAcademicDegree = newValue;
                                  });
                                },
                                items:
                                    academicDegree.map((String academicDegree) {
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
                                maxLength: 50,
                                decoration: InputDecoration(
                                  labelText: 'Мэргэжил',
                                  border: OutlineInputBorder(),
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
                                decoration: InputDecoration(
                                  labelText: 'Гадаад паспортын дугаар',
                                  border: OutlineInputBorder(),
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
                                  border: OutlineInputBorder(),
                                ),
                                value: bloodType,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    bloodType = newValue;
                                  });
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
                                  border: OutlineInputBorder(),
                                ),
                                value: married,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    married = newValue;
                                  });
                                },
                                items: marriedOrNot.map((String marriedOrNot) {
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
                                  border: OutlineInputBorder(),
                                ),
                                value: driversLicenseType,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    driversLicenseType = newValue;
                                  });
                                },
                                items:
                                    driversLicense.map((String driversLicense) {
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
                                  border: OutlineInputBorder(),
                                ),
                                value: militaryService,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    militaryService = newValue;
                                  });
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
                                decoration: InputDecoration(
                                  labelText: 'Жолооны Үүэмлэхний дугаар',
                                  border: OutlineInputBorder(),
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
                                  border: OutlineInputBorder(),
                                ),
                                value: pensionsEstablished,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    pensionsEstablished = newValue;
                                  });
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
                                  border: OutlineInputBorder(),
                                ),
                                value: disabled,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    disabled = newValue;
                                  });
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
                                maxLength: 250,
                                decoration: InputDecoration(
                                  labelText: 'Нэмэлт тайлбар',
                                  border: OutlineInputBorder(),
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
            ],
          ),
        ),
      ),
    );
  }
}
