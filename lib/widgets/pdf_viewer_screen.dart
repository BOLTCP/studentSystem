import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:studentsystem/widgets/personal_info.dart';

var logger = Logger();

class PdfViewerScreen extends StatefulWidget {
  PdfViewerScreen({
    super.key,
    required this.isAsset,
    required this.canProceed,
  });

  final bool isAsset;
  bool canProceed;

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  int currentPage = 0;
  String errorMessage = ''; // To show any error
  bool isLoading = true; // To show loading indicator while PDF is loading
  PDFViewController? pdfViewController; // Controller to interact with PDFView
  int totalPages = 0;

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      PermissionStatus permissionStatus;

      // For Android 11 and higher, we need to request the manage external storage permission
      if (Platform.isAndroid &&
          int.parse(Platform.operatingSystemVersion
                  .split(' ')[0]
                  .split('.')
                  .first) >=
              11) {
        permissionStatus = await Permission.manageExternalStorage.request();
      } else {
        permissionStatus = await Permission.storage.request();
      }

      if (!permissionStatus.isGranted) {
        setState(() {
          errorMessage = 'Permission to access storage is denied';
          openAppSettings();
        });
      } else {
        logger.d("Permission granted!");
      }
    }
  }

  void _onPageChanged(int page, int total) {
    setState(() {
      currentPage = page;
      totalPages = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Сургалтын Журам'),
      ),
      body: Stack(
        children: [
          // Wrap PDF widget inside a Container to avoid ParentDataWidget error
          Container(
            padding: EdgeInsets.all(8.0),
            child: PDF(
              fitPolicy: FitPolicy.WIDTH,
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: false,
              pageFling: false,
              backgroundColor: Colors.grey,
              onError: (error) {
                print(error.toString());
              },
              onPageError: (page, error) {
                print('$page: ${error.toString()}');
              },
            ).fromAsset('assets/documents/dummyPDF.pdf'),
          ),

          // Show button when the current page is the last page
          if (currentPage == totalPages)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    print('Танилцаж дууссанг баталгаажуулах');
                    widget.canProceed = true;
                  },
                  child: Text('Танилцаж дууссан'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
