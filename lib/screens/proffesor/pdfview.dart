import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

class PdfViewer extends StatefulWidget {
  String path, filetype;
  PdfViewer();
  PdfViewer.withdata(this.path, this.filetype);
  @override
  _PdfViewerState createState() => _PdfViewerState(this.path, this.filetype);
}

class _PdfViewerState extends State<PdfViewer> {
  String path, fileType;
  PDFDocument doc;

  _PdfViewerState(this.path, this.fileType);

  Future<PDFDocument> initialPdf() async {
    String url;
    await FirebaseStorage.instance
        .ref()
        .child(path)
        .getDownloadURL()
        .then((value) => url = value);
    doc = await PDFDocument.fromURL(url);
    return doc;
  }

  String url;
  Future<String> initialImage() async {
    await FirebaseStorage.instance
        .ref()
        .child(path)
        .getDownloadURL()
        .then((value) => url = value);
    return url;
  }

  @override
  Widget build(BuildContext context) {
    if (fileType == "pdf") {
      return FutureBuilder(
        builder: (context, snapshot) {
          Widget widget;
          if (snapshot.hasData) {
            widget = Scaffold(
              body: PDFViewer(document: doc),
            );
          } else {
            widget = Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return widget;
        },
        future: initialPdf(),
      );
    } else {
      return FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              body: Center(
                child: Image.network(
                  url,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
        future: initialImage(),
      );
    }
  }
}
