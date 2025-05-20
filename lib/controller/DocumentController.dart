//
//
//
// import 'dart:typed_data';
//
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:signature_document/model/document.dart';
//
// class DocumentController with ChangeNotifier {
//   Document? _selectedDocument;
//   final PdfService _pdfService = PdfService();
//   final ImageService _imageService = ImageService();
//   final FileService _fileService = FileService();
//
//   Document? get selectedDocument => _selectedDocument;
//
//   Future<void> pickDocument() async {
//     try {
//       final result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
//       );
//
//       if (result != null && result.files.single.path != null) {
//         _selectedDocument = Document(
//           path: result.files.single.path!,
//           type: result.files.single.extension == 'pdf' ? 'pdf' : 'image',
//           modifiedAt: DateTime.now(),
//         );
//         notifyListeners();
//       }
//     } catch (e) {
//       throw Exception('Document selection failed: $e');
//     }
//   }
//
//   Future<void> takePhoto() async {
//     try {
//       final pickedFile = await ImagePicker().pickImage(
//         source: ImageSource.camera,
//         imageQuality: 90,
//       );
//
//       if (pickedFile != null) {
//         _selectedDocument = Document(
//           path: pickedFile.path,
//           type: 'image',
//           modifiedAt: DateTime.now(),
//         );
//         notifyListeners();
//       }
//     } catch (e) {
//       throw Exception('Camera capture failed: $e');
//     }
//   }
//
//   Future<void> saveSignedDocument(Uint8List signatureBytes) async {
//     if (_selectedDocument == null) return;
//
//     try {
//       final processedBytes = _selectedDocument!.type == 'pdf'
//           ? await _pdfService.addSignatureToPdf(
//         documentPath: _selectedDocument!.path,
//         signatureBytes: signatureBytes,
//       )
//           : await _imageService.addSignatureToImage(
//         documentPath: _selectedDocument!.path,
//         signatureBytes: signatureBytes,
//       );
//
//       await _fileService.saveFile(
//         bytes: processedBytes,
//         originalPath: _selectedDocument!.path,
//         fileType: _selectedDocument!.type,
//       );
//
//       _selectedDocument = null;
//       notifyListeners();
//     } catch (e) {
//       throw Exception('Document processing failed: $e');
//     }
//   }
//
//   void clearDocument() {
//     _selectedDocument = null;
//     notifyListeners();
//   }
// }