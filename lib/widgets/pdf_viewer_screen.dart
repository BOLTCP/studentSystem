import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:logger/logger.dart';

var logger = Logger();

class PdfViewerScreen extends StatefulWidget {
  final String pdfPath;
  final String pdfName;
  const PdfViewerScreen({
    super.key,
    required this.pdfPath,
    required this.pdfName,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  int totalPages = 0;
  int currentPage = 0;
  bool isLoading = true; // To show loading indicator while PDF is loading
  String errorMessage = ''; // To show any error
  PDFViewController? pdfViewController; // Controller to interact with PDFView

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  // Request permissions before loading the PDF
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.pdfName),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: PDFView(
                        filePath: widget.pdfPath,
                        onRender: (pages) {
                          logger
                              .d("PDF rendered with $pages pages"); // Debug log
                          setState(() {
                            totalPages = pages!;
                            isLoading = false;
                          });
                        },
                        onError: (error) {
                          logger.d("PDF load error: $error"); // Debug log
                          setState(() {
                            isLoading = false;
                            errorMessage = "Failed to load PDF: $error";
                          });
                        },
                        onViewCreated: (controller) {
                          logger.d("PDF view created"); // Debug log
                          setState(() {
                            pdfViewController = controller;
                          });
                        },
                        onPageChanged: (page, total) {
                          logger.d("Page changed: $page/$total"); // Debug log
                          setState(() {
                            currentPage = page!;
                          });
                        },
                      ),
                    ),
                    // Display current page / total pages at the bottom
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Page ${currentPage + 1}/$totalPages",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    // Navigation Controls (Next/Previous buttons)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: currentPage > 0
                              ? () async {
                                  await pdfViewController
                                      ?.setPage(currentPage - 1);
                                }
                              : null,
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: currentPage < totalPages - 1
                              ? () async {
                                  await pdfViewController
                                      ?.setPage(currentPage + 1);
                                }
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
    );
  }
}
