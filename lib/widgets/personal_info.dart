import 'package:flutter/material.dart';
import 'package:onemissystem/models/exam_json.dart';
import 'package:onemissystem/models/major.dart';
import 'package:flutter/services.dart';

class PersonalInfo extends StatefulWidget {
  final List<Major> major;
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
    final List<Major> major = widget.major;
    TextEditingController _dateController = TextEditingController();
    TextEditingController _textController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    String? _selectedGender;
    String? _selectedCityOrState;
    String? _selectedDistrictOrTown;

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
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            // First Card - Basic Information
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
                            child: TextFormField(
                              controller: _textController,
                              decoration: InputDecoration(
                                labelText: 'Регистрийн дугаар',
                              ),
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Энийг заавал бөглөнө үү!";
                                }
                                return null;
                              },
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
                                  _dateController.text = formattedDate;
                                }
                              },
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: _dateController,
                                  decoration: InputDecoration(
                                    labelText: 'Төрсөн огноо',
                                    hintText: 'yyyy-mm-dd',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.datetime,
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
                              decoration: InputDecoration(
                                labelText: 'Ургын овог',
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Хүйс',
                                border: OutlineInputBorder(),
                              ),
                              value: _selectedGender,
                              items:
                                  ['эрэгтэй', 'эмэгтэй', 'бусад'].map((gender) {
                                return DropdownMenuItem<String>(
                                  value: gender,
                                  child: Text(gender),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedGender = newValue;
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
                              decoration: InputDecoration(
                                labelText: 'Эцэг / Эхийн нэр',
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Иргэншил',
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Нэр',
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
                              value: _selectedCityOrState,
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
                                  _selectedCityOrState = newValue;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _dateController,
                              decoration: InputDecoration(
                                labelText: 'Бүртгэлтэй хаяг',
                                hintText: 'Хороо, гудамж, тоот, байрь хороолол',
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
                                labelText: 'Аймаг / Хот',
                                border: OutlineInputBorder(),
                              ),
                              value: _selectedDistrictOrTown,
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
                                  _selectedDistrictOrTown = newValue;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Хүйс',
                                border: OutlineInputBorder(),
                              ),
                              value: _selectedGender,
                              items:
                                  ['эрэгтэй', 'эмэгтэй', 'бусад'].map((gender) {
                                return DropdownMenuItem<String>(
                                  value: gender,
                                  child: Text(gender),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedGender = newValue;
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
                              decoration: InputDecoration(
                                labelText: 'Эцэг / Эхийн нэр',
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Иргэншил',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Нэр',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),

            // Fourth Card - Additional Information
            Card(
              elevation: 8,
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
                        "Нэмэлт мэдээлэл",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Тайлбар эсвэл нэмэлт мэдээлэл',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
