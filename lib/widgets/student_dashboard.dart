import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:onemissystem/models/auth_user.dart';
import 'package:onemissystem/login_screen.dart';
import 'package:onemissystem/api/get_api_url.dart'; // Import the login screen
import 'package:logger/logger.dart';

var logger = Logger();

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  late Future<AuthUser> futureUser;
  int _selectedIndex = 0;
  /*List<Widget> _screens = [];*/

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
    /*_screens = [
      _buildDashboardScreen(),
      _buildSettingsScreen(),
      _buildNotificationsScreen(),
      _buildLogoutScreen(), // Adding the logout screen
    ];*/
  }

  // Fetch user data from API
  Future<AuthUser> fetchUser() async {
    final response = await http.get(getApiUrl('/api/user'));

    logger.d("Received response with status code: ${response.statusCode}");

    if (response.statusCode == 200) {
      try {
        logger.d('Response body: ${response.body}');
        return AuthUser.fromJson(json.decode(response.body));
      } catch (e) {
        logger.d('Error parsing JSON: $e');
        throw Exception('Failed to parse user data: $e');
      }
    } else {
      logger.d('Error: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to load user data: ${response.statusCode}');
    }
  }

  // Handle item selection in BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // If logout is selected, perform logout
      if (_selectedIndex == 3) {
        _logout();
      }
    });
  }

  // Logout function
  void _logout() {
    setState(() {
      futureUser = Future.value(AuthUser(
        userId: 0,
        loginName: '',
        passwordHash: '',
        profilePicture: '',
        registryNumber: '',
        familyTreeName: '',
        fname: '',
        lname: '',
        birthday: DateTime.now(),
        gender: '',
        citizenship: '',
        stateCity: '',
        townDistrict: '',
        validAddress: '',
        stateCityLiving: '',
        townDistrictLiving: '',
        validAddressLiving: '',
        postalAddress: null,
        homePhoneNumber: null,
        phoneNumber: '',
        phoneNumberEmergency: '',
        country: '',
        ethnicity: '',
        socialBackground: '',
        stateCityOfBirth: '',
        townDistrictOfBirth: '',
        placeOfBirth: '',
        education: '',
        currentAcademicDegree: '',
        profession: null,
        professionCertification: null,
        passportNumber: '',
        married: '',
        militaryService: '',
        pensionsEstablished: null,
        additionalNotes: null,
        bloodType: null,
        driversCertificate: '',
        driversCertificateNumber: '',
        disabled: '',
        userRole: '',
        isActive: false,
        email: '',
        createdAt: DateTime.now(),
      ));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LoginScreen()), // Navigate to login screen
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Сурагчийн Хянах Самбар',
            style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.blue[50],
      body: FutureBuilder<AuthUser>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data found.'));
          } else {
            final user = snapshot.data!;
            return SingleChildScrollView(
              // Wrap the user details with a scrollable widget
              child: Column(
                children: _buildUserDetails(user),
              ),
            );
          }
        },
      ),
      // Add Bottom Navigation Bar
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
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app),
            label: 'Logout', // New logout icon
            backgroundColor: Colors.blue,
          ),
        ],
        currentIndex: _selectedIndex, // Track the current index
        onTap: _onItemTapped, // Handle tap events
      ),
    );
  }

  // Dashboard screen displaying user details
  /*Widget _buildDashboardScreen() {
    return FutureBuilder<AuthUser>(
      future: futureUser,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('No data found.'));
        } else {
          final user = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              children: _buildUserDetails(user),
            ),
          );
        }
      },
    );
  }

  // Settings screen (empty for now, you can add content here)
  Widget _buildSettingsScreen() {
    return Center(
      child: Text("Settings Screen"),
    );
  }

  // Notifications screen (empty for now, you can add content here)
  Widget _buildNotificationsScreen() {
    return Center(
      child: Text("Notifications Screen"),
    );
  }

  // Logout screen (can be customized if needed)
  Widget _buildLogoutScreen() {
    return Center(
      child: Text("Logging out..."),
    );
  }*/

  // Build user details list
  List<Widget> _buildUserDetails(AuthUser user) {
    return [
      _buildUserDetailRow('Name', '${user.fname} ${user.lname}'),
      _buildUserDetailRow('Email', user.email),
      _buildUserDetailRow('Gender', user.gender),
      _buildUserDetailRow(
          'Birthday', DateFormat('yyyy-MM-dd').format(user.birthday)),
      _buildUserDetailRow('Phone', user.phoneNumber),
      _buildUserDetailRow('Profile Picture', user.profilePicture),
      _buildUserDetailRow('Country', user.country),
      _buildUserDetailRow('State/City', user.stateCity),
      _buildUserDetailRow('Education', user.education),
      _buildUserDetailRow('Current Degree', user.currentAcademicDegree),
      _buildUserDetailRow('Role', user.userRole),
      _buildUserDetailRow('Created At', user.createdAt.toLocal().toString()),
      _buildUserDetailRow('Registry Number', user.registryNumber),
      _buildUserDetailRow('Family Tree', user.familyTreeName),
      _buildUserDetailRow('Citizenship', user.citizenship),
      _buildUserDetailRow('Town/District', user.townDistrict),
      _buildUserDetailRow('Valid Address', user.validAddress),
      _buildUserDetailRow('Phone (Emergency)', user.phoneNumberEmergency),
      _buildUserDetailRow('Blood Type', user.bloodType ?? 'N/A'),
      _buildUserDetailRow('Passport Number', user.passportNumber),
      _buildUserDetailRow('Marital Status', user.married),
      _buildUserDetailRow('Military Service', user.militaryService),
      _buildUserDetailRow('Disabled', user.disabled),
      _buildUserDetailRow('Profession', user.profession ?? 'N/A'),
      _buildUserDetailRow('Social Background', user.socialBackground),
      _buildUserDetailRow('Postal Address', user.postalAddress ?? 'N/A'),
      _buildUserDetailRow('Home Phone Number', user.homePhoneNumber ?? 'N/A'),
      _buildUserDetailRow('State/City of Birth', user.stateCityOfBirth),
      _buildUserDetailRow('Town/District of Birth', user.townDistrictOfBirth),
      _buildUserDetailRow('Place of Birth', user.placeOfBirth),
      _buildUserDetailRow('Ethnicity', user.ethnicity),
      _buildUserDetailRow('State/City Living', user.stateCityLiving),
      _buildUserDetailRow('Town/District Living', user.townDistrictLiving),
      _buildUserDetailRow('Valid Address Living', user.validAddressLiving),
      _buildUserDetailRow(
          'Pensions Established', user.pensionsEstablished ?? 'N/A'),
      _buildUserDetailRow('Additional Notes', user.additionalNotes ?? 'N/A'),
      _buildUserDetailRow('Drivers Certificate', user.driversCertificate),
      _buildUserDetailRow(
          'Drivers Certificate Number', user.driversCertificateNumber),
      _buildUserDetailRow(
          'Profession Certification', user.professionCertification ?? 'N/A'),
      _buildUserDetailRow('Email', user.email),
      _buildUserDetailRow('Registry Number', user.registryNumber),
      _buildUserDetailRow(
          'Active Status', user.isActive ? 'Active' : 'Inactive'),
    ];
  }

  // Build a user detail row
  Widget _buildUserDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
