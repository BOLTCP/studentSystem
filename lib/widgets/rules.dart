import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:studentsystem/widgets/pdf_viewer_screen.dart';

var logger = Logger();

class Rules extends StatefulWidget {
  const Rules({Key? key}) : super(key: key);

  @override
  State<Rules> createState() => _RulesState();
}

class _RulesState extends State<Rules> {
  List<String> pdfFiles = [];
  List<String> filteredFiles = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    baseDirectory();
    requestPermissions();
  }

  void checkPermissions() async {
    PermissionStatus status = await Permission.manageExternalStorage.status;
    logger.d("Permission status: $status");
  }

  Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      PermissionStatus permissionStatus;

      // Request permission to access external storage based on the Android version
      if (Platform.isAndroid &&
          int.parse(Platform.operatingSystemVersion
                  .split(' ')[0]
                  .split('.')
                  .first) >=
              11) {
        // For Android 11 and above
        permissionStatus = await Permission.manageExternalStorage.request();
      } else {
        // For lower versions, storage permission is sufficient
        permissionStatus = await Permission.storage.request();
      }

      if (!permissionStatus.isGranted) {
        setState(() {
          print('Permission to access storage is denied');
        });
      } else {
        print("Permission granted!");
      }
    }
  }

  // This method requests permissions and gets the root directory of the external storage.
  Future<void> baseDirectory() async {
    if (Platform.isAndroid) {
      if (await Permission.manageExternalStorage.isGranted) {
        getRootDirectory();
      } else {
        PermissionStatus permissionStatus =
            await Permission.manageExternalStorage.request();
        if (permissionStatus.isGranted) {
          getRootDirectory();
        } else {
          logger.e("Permission to access external storage denied.");
        }
      }
    } else {
      getRootDirectory(); // For iOS or older versions
    }
  }

  // This method retrieves the root external storage directory.
  Future<void> getRootDirectory() async {
    try {
      var rootDirectory = await ExternalPath.getExternalStorageDirectories();
      if (rootDirectory.isNotEmpty) {
        String directoryPath =
            rootDirectory.first; // Path to the external storage
        logger.d("Root directory path: $directoryPath");
        getFiles(directoryPath); // Fetch files from this directory
      } else {
        logger.e("External storage not available.");
      }
    } catch (e) {
      logger.e("Error retrieving root directory: $e");
    }
  }

  Future<void> getFiles(String directoryPath) async {
    try {
      var directory = Directory(directoryPath);
      var files = directory.listSync(); // List files in the directory
      logger.d("Files in directory: ${files.length}");

      for (var file in files) {
        logger.d("File: ${file.path}");
        if (file is File && file.path.toLowerCase().endsWith('.pdf')) {
          setState(() {
            pdfFiles.add(file.path); // Add the PDF file path to the list
            filteredFiles = pdfFiles; // Update filtered files
          });
        }
      }
      logger.d("PDF files found: ${pdfFiles.length}");
    } catch (e) {
      logger.e("Error getting files: $e");
    }
  }

  // Filter the files based on the search query.
  void filterFiles(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredFiles = pdfFiles;
      });
    } else {
      setState(() {
        filteredFiles = pdfFiles
            .where(
              (file) => file.split('/').last.toLowerCase().contains(
                    query.toLowerCase(),
                  ),
            )
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !isSearching
            ? Text(
                "Бичиг баримтууд",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )
            : TextField(
                decoration: InputDecoration(
                  hintText: "Бичиг баримтууд хайж байна",
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  filterFiles(value);
                },
              ),
        backgroundColor: Colors.red[300],
        elevation: 14.0,
        actions: [
          IconButton(
            iconSize: 30,
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                filteredFiles = pdfFiles;
              });
            },
            icon: Icon(isSearching ? Icons.cancel : Icons.search),
          ),
        ],
      ),
      body: filteredFiles.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: filteredFiles.length,
              itemBuilder: (context, index) {
                String filePath = filteredFiles[index];
                String fileName = path.basename(filePath);
                return Card(
                  color: Colors.amber[100],
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      fileName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    leading: Icon(
                      Icons.picture_as_pdf,
                      color: Colors.redAccent,
                      size: 30,
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 18),
                    /*onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PdfViewerScreen(
                            pdfName: 'Сургалтын Журам',
                            pdfPath: filePath,
                          ),
                        ),
                      );
                    },*/
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          baseDirectory();
        },
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
