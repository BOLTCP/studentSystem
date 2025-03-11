import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studentsystem/models/user_details.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.userDetails});

  final Future<UserDetails> userDetails;

  Widget _buildProfileCard(String label, String value) {
    return Card(
      elevation: 5.0,
      margin: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: Text(label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(value, style: TextStyle(fontSize: 16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Хэрэглэгчийн мэдээлэл',
          textAlign: TextAlign.start,
          style: TextStyle(
              fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.blue[50],
      body: FutureBuilder<UserDetails>(
        future: userDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data found.'));
          } else {
            final userDetails = snapshot.data!;
            return userDetails.user.userRole == 'Багш'
                ? SingleChildScrollView(
                    padding: EdgeInsetsDirectional.only(top: 5.0, bottom: 80.0),
                    child: Center(
                      child: SizedBox(
                        width: 550,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildProfileCard('Нэр',
                                '${userDetails.user.fname} ${userDetails.user.lname}'),
                            _buildProfileCard(
                                'Хэрэглэгч нь: ', userDetails.user.userRole),
                            _buildProfileCard('Хэрэглэгч / Багшийн код: ',
                                userDetails.teacher!.teacherCode),
                            _buildProfileCard(
                                'Хэрэглэгчийн И-мэйл', userDetails.user.email),
                            _buildProfileCard(
                                'Түвшин', userDetails.teacher!.academicDegree),
                            _buildProfileCard('Салбар сургууль',
                                userDetails.department.departmentName),
                            _buildProfileCard(
                                'Төлөв', userDetails.teacher!.isActive),
                            _buildProfileCard('Хүйс', userDetails.user.gender),
                            _buildProfileCard('Регистрийн дугаар',
                                userDetails.user.registryNumber),
                            _buildProfileCard(
                                'Төрсөн өдөр',
                                DateFormat('yyyy-MM-dd')
                                    .format(userDetails.user.birthday)),
                            _buildProfileCard(
                                'Утасны дугаар', userDetails.user.phoneNumber),
                            _buildProfileCard('Багшийн И-мэйл',
                                userDetails.teacher!.teacherEmail),
                            _buildProfileCard(
                                'Өмнөх боловсрол', userDetails.user.education),
                            _buildProfileCard(
                                'Created At',
                                userDetails.user.createdAt
                                    .toLocal()
                                    .toString()),
                          ],
                        ),
                      ),
                    ),
                  )
                : userDetails.user.userRole == 'Оюутан'
                    ? SingleChildScrollView(
                        child: Center(
                          child: SizedBox(
                            width: 550,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _buildProfileCard('Нэр',
                                    '${userDetails.user.fname} ${userDetails.user.lname}'),
                                _buildProfileCard('Хэрэглэгч нь: ',
                                    userDetails.user.userRole),
                                _buildProfileCard('Хэрэглэгч / Багшийн код: ',
                                    userDetails.student!.studentCode),
                                _buildProfileCard('Хэрэглэгчийн И-мэйл',
                                    userDetails.user.email),
                                _buildProfileCard('Түвшин',
                                    userDetails.student!.currentAcademicDegree),
                                _buildProfileCard('Салбар сургууль',
                                    userDetails.department.departmentName),
                                _buildProfileCard(
                                    'Төлөв', userDetails.student!.isActive!),
                                _buildProfileCard(
                                    'Хүйс', userDetails.user.gender),
                                _buildProfileCard('Регистрийн дугаар',
                                    userDetails.user.registryNumber),
                                _buildProfileCard(
                                    'Төрсөн өдөр',
                                    DateFormat('yyyy-MM-dd')
                                        .format(userDetails.user.birthday)),
                                _buildProfileCard('Утасны дугаар',
                                    userDetails.user.phoneNumber),
                                _buildProfileCard('Багшийн И-мэйл',
                                    userDetails.student!.studentEmail),
                                _buildProfileCard('Өмнөх боловсрол',
                                    userDetails.user.education),
                                _buildProfileCard(
                                    'Created At',
                                    userDetails.user.createdAt
                                        .toLocal()
                                        .toString()),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Placeholder();
          }
        },
      ),
    );
  }
}
