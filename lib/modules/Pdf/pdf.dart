import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class PdfClass extends StatelessWidget {
  dynamic data;

  PdfClass({this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PdfPreview(
        build: (format) {
          return data;
        },
        /*pdfFileName:
        '${snapshot2.data![0]}${snapshot2.data![snapshot2.data!.length - 1]}-${DateFormat('yMEd').format(DateTime.now()).replaceAll('/', '-').replaceAll(',', '-').replaceAll(' ', '')}',*/
      ),
    );
  }
}
