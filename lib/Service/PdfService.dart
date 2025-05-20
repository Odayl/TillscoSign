// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui';
// import 'package:syncfusion_flutter_pdf/pdf.dart' as sfpdf;
//
// class PdfService {
//   Future<Uint8List> addSignatureToPdf({
//     required String documentPath,
//     required Uint8List signatureBytes,
//   }) async {
//     final documentBytes = await File(documentPath).readAsBytes();
//     final document = sfpdf.PdfDocument(inputBytes: documentBytes);
//     final bitmap = sfpdf.PdfBitmap(signatureBytes);
//
//     for (int i = 0; i < document.pages.count; i++) {
//       final page = document.pages[i];
//       page.graphics.drawImage(
//         bitmap,
//         Rect.fromLTWH(
//           page.getClientSize().width - 160,
//           page.getClientSize().height - 100,
//           150,
//           75,
//         ),
//       );
//     }
//
//     return document.save();
//   }
// }