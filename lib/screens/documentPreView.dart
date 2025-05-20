// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:signature_document/model/document.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
//
//
// class _DocumentPreview extends StatelessWidget {
//   final Document document;
//
//   const _DocumentPreview({required this.document});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: document.type == 'pdf'
//           ? SfPdfViewer.file(File(document.path))
//           : Image.file(File(document.path)),
//     );
//   }
// }