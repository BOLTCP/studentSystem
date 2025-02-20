import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class Rules1 extends StatefulWidget {
  const Rules1({Key? key}) : super(key: key);

  @override
  State<Rules1> createState() => _Rules1State();
}

class _Rules1State extends State<Rules1> {
  late PdfControllerPinch pdfControllerPinch;

  @override
  void initState() {
    super.initState();
    // Load PDF from assets
    pdfControllerPinch = PdfControllerPinch(
        document:
            PdfDocument.openAsset('assets/documents/Сургалтын_Журам.pdf'));
  }

  @override
  void dispose() {
    pdfControllerPinch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Сургалтын журам',
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
      body: SafeArea(
        child: _buildUI(),
      ),
    );
  }

  Widget _buildUI() {
    return Column(
      children: [
        _pdfView(),
      ],
    );
  }

  Widget _pdfView() {
    return Expanded(
      child: PdfViewPinch(controller: pdfControllerPinch),
    );
  }
}
