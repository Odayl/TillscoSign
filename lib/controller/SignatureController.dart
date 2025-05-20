// import 'dart:typed_data';
//
// import 'package:flutter/cupertino.dart';
//
// class SignatureController with ChangeNotifier {
//   final SignatureController _padController = SignatureController(
//     penStrokeWidth: 3,
//     penColor: Colors.black,
//     exportBackgroundColor: Colors.white,
//   );
//   Uint8List? _signatureBytes;
//
//   SignatureController get padController => _padController;
//   Uint8List? get signatureBytes => _signatureBytes;
//
//   Future<void> saveSignature() async {
//     final bytes = await _padController.toPngBytes();
//     if (bytes == null) throw Exception('Failed to save signature');
//     _signatureBytes = bytes;
//     notifyListeners();
//   }
//
//   void clearSignature() {
//     _padController.clear();
//     _signatureBytes = null;
//     notifyListeners();
//   }
//
//   @override
//   void dispose() {
//     _padController.dispose();
//     super.dispose();
//   }
// }