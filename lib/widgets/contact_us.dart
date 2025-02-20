import 'package:flutter/material.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Холбоо барих',
          style: TextStyle(
              color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.blue[50],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _showHRDialog(context); // Show dialog on button press
              },
              child: Text("Хүний нөөц"),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text("View Location"),
            ),
            SizedBox(height: 20),
            IconButton(
              icon: Icon(Icons.phone, size: 40),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  void _showHRDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose an Option"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Хүний нөөц"),
                onTap: () {
                  Navigator.pop(context);
                  _showHRChoicesDialog(context);
                },
              ),
              ListTile(
                title: Text("Option 2"),
                onTap: () {
                  Navigator.pop(context);
                  _handleOptionSelection("Option 2");
                },
              ),
              ListTile(
                title: Text("Option 3"),
                onTap: () {
                  Navigator.pop(context);
                  _handleOptionSelection("Option 3");
                },
              ),
              ListTile(
                title: Text("Option 4"),
                onTap: () {
                  Navigator.pop(context);
                  _handleOptionSelection("Option 4");
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showHRChoicesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose an Option"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Багш"),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/user_signup',
                    arguments: {
                      'userRoleSpecification': 'Багш',
                    },
                  );
                  _handleOptionSelection("Option 1");
                },
              ),
              ListTile(
                title: Text("Харуул хамгаалалт"),
                onTap: () {
                  Navigator.pop(context);
                  _handleOptionSelection("Option 2");
                },
              ),
              ListTile(
                title: Text("Цэвэрлэгч"),
                onTap: () {
                  Navigator.pop(context);
                  _handleOptionSelection("Option 3");
                },
              ),
              ListTile(
                title: Text("Сан техникч"),
                onTap: () {
                  Navigator.pop(context);
                  _handleOptionSelection("Option 4");
                },
              ),
              ListTile(
                title: Text("Цахилгаанчин"),
                onTap: () {
                  Navigator.pop(context);
                  _handleOptionSelection("Option 4");
                },
              ),
              ListTile(
                title: Text("Хүний нөөц"),
                onTap: () {
                  Navigator.pop(context);
                  _handleOptionSelection("Option 4");
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleOptionSelection(String option) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("You selected"),
          content: Text(option),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
