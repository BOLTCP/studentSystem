import 'package:flutter/material.dart';
import 'package:studentsystem/models/user_details.dart';
import 'package:studentsystem/models/courses.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:studentsystem/api/get_api_url.dart';

var logger = Logger();

class CoursesDefault extends StatefulWidget {
  final UserDetails userDetails;

  const CoursesDefault({super.key, required this.userDetails});

  @override
  State<CoursesDefault> createState() => _CoursesDefaultState();
}

class _CoursesDefaultState extends State<CoursesDefault> {
  late Future<List<Courses>> futureCourses;

  @override
  void initState() {
    super.initState();
    futureCourses = fetchCourses();
  }

  Future<List<Courses>> fetchCourses() async {
    try {
      final response = await http.post(
        getApiUrl('/Get/Student/Major/Courses/'),
        body: json.encode({
          'major_id': widget.userDetails.student!.majorId,
        }),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);

        List<Courses> majorsCourses =
            (decodedJson['majors_courses'] as List<dynamic>)
                .map((majorsCourse) => majorsCourse)
                .whereType<Courses>()
                .toList();

        return majorsCourses;
      } else {
        logger.d('Error: ${response.statusCode}');
        throw Exception('Something went wrong!');
      }
    } catch (e) {
      logger.d('Error: $e');
      throw Exception('An error occurred. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Хичээлүүд',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.blue[50],
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 400,
                  child: Column(
                    children: [
                      DataTable(
                        border: TableBorder(
                          right: BorderSide(
                            color: Color.fromARGB(255, 255, 204, 0)
                                .withOpacity(0.5),
                            width: 2.0,
                          ),
                          left: BorderSide(
                            color: Color.fromARGB(255, 255, 204, 0)
                                .withOpacity(0.5),
                            width: 2.0,
                          ),
                          top: BorderSide(
                            color: Color.fromARGB(255, 255, 204, 0)
                                .withOpacity(0.5),
                            width: 2.0,
                          ),
                          bottom: BorderSide(
                            color: Color.fromARGB(255, 255, 204, 0)
                                .withOpacity(0.5),
                            width: 2.0,
                          ),
                        ),
                        columnSpacing: 20.0,
                        columns: [
                          DataColumn(label: Text('Төрөл')),
                          DataColumn(label: Text('Хөтөлбөрийн нэр')),
                          DataColumn(label: Text('Эрдмийн зэрэг')),
                          DataColumn(label: Text('Код')),
                        ],
                        rows: [
                          DataRow(
                            cells: [
                              DataCell(Text('Өдөр')),
                              DataCell(Text('Програм хангамж')),
                              DataCell(Text('Бакалавр')),
                              DataCell(Text('SE')),
                            ],
                            color: MaterialStateProperty.all(
                                (const Color.fromARGB(255, 255, 204, 0))),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                      ),
                      FutureBuilder(
                        future: futureCourses,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text(
                                    'An error occurred: ${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            List<Course> majorsCourses =
                                snapshot.data as List<Course>;

                            return DataTable(
                              border: TableBorder(
                                right: BorderSide(
                                  color: Color.fromARGB(255, 255, 204, 0)
                                      .withOpacity(0.5),
                                  width: 2.0,
                                ),
                                left: BorderSide(
                                  color: Color.fromARGB(255, 255, 204, 0)
                                      .withOpacity(0.5),
                                  width: 2.0,
                                ),
                                top: BorderSide(
                                  color: Color.fromARGB(255, 255, 204, 0)
                                      .withOpacity(0.5),
                                  width: 2.0,
                                ),
                                bottom: BorderSide(
                                  color: Color.fromARGB(255, 255, 204, 0)
                                      .withOpacity(0.5),
                                  width: 2.0,
                                ),
                              ),
                              columnSpacing: 10.0,
                              columns: [
                                DataColumn(label: Text('№')),
                                DataColumn(label: Text('Хичээлийн нэр')),
                                DataColumn(label: Text('Код')),
                                DataColumn(label: Text('Кредит')),
                              ],
                              rows: majorsCourses.map((majorsCourse) {
                                return DataRow(cells: [
                                  DataCell(Text(
                                      '${majorsCourses.indexOf(majorsCourse)}')),
                                  DataCell(Text(majorsCourse.courseName)),
                                  DataCell(Text(majorsCourse.courseCode)),
                                  DataCell(
                                      Text('${majorsCourse.totalCredits}')),
                                ]);
                              }).toList(),
                            );
                          } else {
                            return Center(child: Text('No courses available.'));
                          }
                        },
                      ),
                      /*
                      
                      DataTable(
                        border: TableBorder(
                          right: BorderSide(
                            color: Color.fromARGB(255, 255, 204, 0)
                                .withOpacity(0.5),
                            width: 2.0,
                          ),
                          left: BorderSide(
                            color: Color.fromARGB(255, 255, 204, 0)
                                .withOpacity(0.5),
                            width: 2.0,
                          ),
                          top: BorderSide(
                            color: Color.fromARGB(255, 255, 204, 0)
                                .withOpacity(0.5),
                            width: 2.0,
                          ),
                          bottom: BorderSide(
                            color: Color.fromARGB(255, 255, 204, 0)
                                .withOpacity(0.5),
                            width: 2.0,
                          ),
                        ),
                        columnSpacing: 10.0,
                        columns: [
                          DataColumn(label: Text('№')),
                          DataColumn(label: Text('Хичээлийн нэр')),
                          DataColumn(label: Text('Код')),
                          DataColumn(label: Text('Кредит')),
                        ],
                        rows: [
                          DataRow(
                            cells: [
                              DataCell(Text('')),
                              DataCell(Text('1-р курс Намар')),
                              DataCell(Text('')),
                              DataCell(Text('')),
                            ],
                            color: MaterialStateProperty.all(
                                (const Color.fromARGB(255, 255, 204, 0))),
                          ),
                          DataRow(cells: [
                            DataCell(Text('1')),
                            DataCell(Text('Математик I')),
                            DataCell(Text('COM201')),
                            DataCell(Text('3')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('2')),
                            DataCell(Text('Гадаад хэл I (Англи)')),
                            DataCell(Text('GEN101')),
                            DataCell(Text('3')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('3')),
                            DataCell(Text('Алгоритмын үндэс')),
                            DataCell(Text('COM202')),
                            DataCell(Text('3')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('4')),
                            DataCell(Text('Мэдээллийн технологийн үндэс')),
                            DataCell(Text('GEN104')),
                            DataCell(Text('3')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('5')),
                            DataCell(Text('Хүний хөгжил')),
                            DataCell(Text('GEN105')),
                            DataCell(Text('3')),
                          ]),
                          DataRow(
                            cells: [
                              DataCell(Text('')),
                              DataCell(Text('1-р курс Хавар')),
                              DataCell(Text('')),
                              DataCell(Text('')),
                            ],
                            color: MaterialStateProperty.all(
                                (const Color.fromARGB(255, 0, 255, 127))),
                          ),
                          DataRow(cells: [
                            DataCell(Text('1')),
                            DataCell(Text('Гадаад хэл II (Англи)')),
                            DataCell(Text('GEN102')),
                            DataCell(Text('3')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('2')),
                            DataCell(Text('Математик II')),
                            DataCell(Text('COM203')),
                            DataCell(Text('3')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('3')),
                            DataCell(Text('Математик логик')),
                            DataCell(Text('COM204')),
                            DataCell(Text('3')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('4')),
                            DataCell(Text('Програмчлалын хэл')),
                            DataCell(Text('COM205')),
                            DataCell(Text('3')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('5')),
                            DataCell(Text('Тогтвортой хөгжил')),
                            DataCell(Text('GEN106')),
                            DataCell(Text('2')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('6')),
                            DataCell(Text('Биеийн тамир эрүүл ахуй')),
                            DataCell(Text('GEN110')),
                            DataCell(Text('1')),
                          ]),
                          DataRow(
                            cells: [
                              DataCell(Text('')),
                              DataCell(Text('2-р курс Намар')),
                              DataCell(Text('')),
                              DataCell(Text('')),
                            ],
                            color: MaterialStateProperty.all(
                                (const Color.fromARGB(255, 255, 204, 0))),
                          ),
                          DataRow(cells: [
                            DataCell(Text('1')),
                            DataCell(Text('Компьютер график дизайны үндэс')),
                            DataCell(Text('ART201')),
                            DataCell(Text('3')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('2')),
                            DataCell(
                                Text('Магадлалын онол, математик статистик')),
                            DataCell(Text('GEN121')),
                            DataCell(Text('3')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('3')),
                            DataCell(Text('Мэдээллийн технологийн удиртгал')),
                            DataCell(Text('COM206')),
                            DataCell(Text('3')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('4')),
                            DataCell(Text('Обьект хандлагат програмчлал')),
                            DataCell(Text('COM207')),
                            DataCell(Text('3')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('5')),
                            DataCell(Text('Физик')),
                            DataCell(Text('GEN112')),
                            DataCell(Text('3')),
                          ]),
                          DataRow(
                            cells: [
                              DataCell(Text('')),
                              DataCell(Text('2-р курс Хавар')),
                              DataCell(Text('')),
                              DataCell(Text('')),
                            ],
                            color: MaterialStateProperty.all(
                                (const Color.fromARGB(255, 0, 255, 127))),
                          ),
                          DataRow(cells: [
                            DataCell(Text('1')),
                            DataCell(
                                Text('Өгөгдлийн сангийн зохион байгуулалт')),
                            DataCell(Text('COM301')),
                            DataCell(Text('3')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('2')),
                            DataCell(Text('Програм хангамж хөгжүүлэлт')),
                            DataCell(Text('COM302')),
                            DataCell(Text('3')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('3')),
                            DataCell(Text('Хэвлэлийн дизайн')),
                            DataCell(Text('ART305')),
                            DataCell(Text('3')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('4')),
                            DataCell(Text('Монголын түүх, соёл')),
                            DataCell(Text('GEN107')),
                            DataCell(Text('3')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('5')),
                            DataCell(Text('Өгөгдлийн бүтэц')),
                            DataCell(Text('COM208')),
                            DataCell(Text('3')),
                          ]),
                          DataRow(
                            cells: [
                              DataCell(Text('')),
                              DataCell(Text('3-р курс Намар')),
                              DataCell(Text('')),
                              DataCell(Text('')),
                            ],
                            color: MaterialStateProperty.all(
                                (const Color.fromARGB(255, 255, 204, 0))),
                          ),
                          DataRow(cells: [
                            DataCell(Text('1')),
                            DataCell(Text('Системийн шинжилгээ ба загварчлал')),
                            DataCell(Text('COM303')),
                            DataCell(Text('3')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('2')),
                            DataCell(Text('Бичих, илтгэх ур чадвар')),
                            DataCell(Text('GEN103')),
                            DataCell(Text('3')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('3')),
                            DataCell(Text('Тооцон бодох математик')),
                            DataCell(Text('COM304')),
                            DataCell(Text('3')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('4')),
                            DataCell(Text('Өгөгдлийн сангийн програмчлал')),
                            DataCell(Text('COM305')),
                            DataCell(Text('3')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('5')),
                            DataCell(Text('Сэтгэлгээний түүх')),
                            DataCell(Text('GEN108')),
                            DataCell(Text('3')),
                          ]),
                          DataRow(
                            cells: [
                              DataCell(Text('')),
                              DataCell(Text('3-р курс Хавар')),
                              DataCell(Text('')),
                              DataCell(Text('')),
                            ],
                            color: MaterialStateProperty.all(
                                (const Color.fromARGB(255, 0, 255, 127))),
                          ),
                          DataRow(cells: [
                            DataCell(Text('1')),
                            DataCell(Text('Видео эвлүүлэг')),
                            DataCell(Text('ART205')),
                            DataCell(Text('3')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('2')),
                            DataCell(Text('Мэдээллийн системийн үндэс')),
                            DataCell(Text('ACC202')),
                            DataCell(Text('3')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('3')),
                            DataCell(Text('Вэб програмчлалын онол')),
                            DataCell(Text('COM306')),
                            DataCell(Text('3')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('4')),
                            DataCell(Text('Компьютерын сүлжээ I')),
                            DataCell(Text('COM209')),
                            DataCell(Text('3')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('5')),
                            DataCell(Text('Дадлага ажил I')),
                            DataCell(Text('COM311')),
                            DataCell(Text('3')),
                          ]),
                          DataRow(
                            cells: [
                              DataCell(Text('')),
                              DataCell(Text('4-р курс Намар')),
                              DataCell(Text('')),
                              DataCell(Text('')),
                            ],
                            color: MaterialStateProperty.all(
                                (const Color.fromARGB(255, 255, 204, 0))),
                          ),
                          DataRow(cells: [
                            DataCell(Text('1')),
                            DataCell(Text('Хөдөлгөөнт график дизайн')),
                            DataCell(Text('ART405')),
                            DataCell(Text('3')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('2')),
                            DataCell(Text('Интерпрайз архитектур')),
                            DataCell(Text('COM401')),
                            DataCell(Text('3')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('3')),
                            DataCell(Text('Өгөгдөл олборлолт ба шинжилгээ')),
                            DataCell(Text('COM402')),
                            DataCell(Text('3')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('4')),
                            DataCell(Text('Үйлдлийн системийн онол')),
                            DataCell(Text('COM403')),
                            DataCell(Text('3')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('5')),
                            DataCell(Text('Дадлага ажил II')),
                            DataCell(Text('COM411')),
                            DataCell(Text('3')),
                          ]),
                          DataRow(
                            cells: [
                              DataCell(Text('')),
                              DataCell(Text('4-р курс Хавар')),
                              DataCell(Text('')),
                              DataCell(Text('')),
                            ],
                            color: MaterialStateProperty.all(
                                (const Color.fromARGB(255, 0, 255, 127))),
                          ),
                          DataRow(cells: [
                            DataCell(Text('1')),
                            DataCell(Text('Бакалаврын төгсөлтийн ажил')),
                            DataCell(Text('COM412')),
                            DataCell(Text('4')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('2')),
                            DataCell(Text('Мэдээллийн аюулгүй байдлын үндэс')),
                            DataCell(Text('COM404')),
                            DataCell(Text('3')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('3')),
                            DataCell(Text('Процессийн шинжилгээ')),
                            DataCell(Text('COM405')),
                            DataCell(Text('3')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('4')),
                            DataCell(Text('Систем хөгжүүлэх төсөл')),
                            DataCell(Text('COM406')),
                            DataCell(Text('2')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('5')),
                            DataCell(Text('Хиймэл оюун ба машин сургалт')),
                            DataCell(Text('COM407')),
                            DataCell(Text('3')),
                          ]),
                        ],
                      ),

                       */
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: ListTile(
                title: Text(
                  'Сургалтын хөтөлбөр',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            ListTile(
              title: Text('Хувийн сургалтын төлөвлөгөө'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/courses_default',
                );
              },
            ),
            ListTile(
              title: Text('Сургалтын төлөвлөгөө'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/courses_screen',
                  arguments: widget.userDetails,
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
            backgroundColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}
