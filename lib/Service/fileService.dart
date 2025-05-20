// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:gallery_saver/gallery_saver.dart';
// import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
//
// class FileService {
//   Future<void> saveFile({
//     required Uint8List bytes,
//     required String originalPath,
//     required String fileType,
//   }) async {
//     final directory = await getApplicationDocumentsDirectory();
//     final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
//     final extension = originalPath.split('.').last;
//     final fileName = 'signed_$timestamp.$extension';
//
//     if (fileType == 'pdf') {
//       await _savePdf(bytes, fileName);
//     } else {
//       await _saveImage(bytes, fileName);
//     }
//   }
//
//   Future<void> _savePdf(Uint8List bytes, String fileName) async {
//     final downloadsPath = await _getDownloadsPath();
//     final file = File('$downloadsPath/$fileName');
//     await file.writeAsBytes(bytes);
//   }
//
//   Future<void> _saveImage(Uint8List bytes, String fileName) async {
//     final tempFile = File('${(await getTemporaryDirectory()).path}/$fileName');
//     await tempFile.writeAsBytes(bytes);
//     await GallerySaver.saveImage(tempFile.path, albumName: "SignedDocs");
//   }
//
//   Future<String> _getDownloadsPath() async {
//     if (Platform.isAndroid) {
//       return '/storage/emulated/0/Download';
//     }
//     throw Exception('Unsupported platform');
//   }
// }