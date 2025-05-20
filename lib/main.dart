import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:signature_document/screens/SignInPage.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart' as sfpdf;

import 'package:signature/signature.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const SignInPage(),
    theme: ThemeData(
      primarySwatch: Colors.blue,
      fontFamily: GoogleFonts.poppins().fontFamily,
      scaffoldBackgroundColor: Colors.blue[50],
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    ),
  ));
}

class SignatureApp extends StatefulWidget {
  const SignatureApp({super.key});

  @override
  SignatureAppState createState() => SignatureAppState();
}

class SignatureAppState extends State<SignatureApp> {
  File? _selectedDocument;
  Uint8List? _signatureImage;
  String? _documentType;
  late SignatureController _signatureController;


  @override
  void initState() {
    super.initState();
    // Initialize controller in initState
    _signatureController = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportBackgroundColor: Colors.transparent,
    );
  }

  Future<void> _pickDocument() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedDocument = File(result.files.single.path!);
          _documentType =
              result.files.single.extension == 'pdf' ? 'pdf' : 'image';
          _signatureImage = null; // Reset signature on new document
          _signatureController.clear();
        });
      }
    } catch (e) {
      _showError('Document selection failed: ${e.toString()}');
    }
  }

  Future<void> _takePhoto() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 90,
        requestFullMetadata: false, // Helps with HEIC formats
      );
      if (pickedFile != null) {
        setState(() {
          _selectedDocument = File(pickedFile.path);
          _documentType = 'image';
        });
      }
    } catch (e) {
      _showError('Failed to take photo: $e');
    }
  }

  Widget _buildSignaturePad() {
    return Column(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.blueAccent),
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(2, 2),
              )
            ],
          ),
          child: Signature(
            controller: _signatureController,
            backgroundColor: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        // Color selection buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildColorButton(Colors.black),
            _buildColorButton(Colors.red),
            _buildColorButton(Colors.green),
          ],
        ),
        // Stroke width selection buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStrokeWidthButton('Thin', 2),
            _buildStrokeWidthButton('Medium', 4),
            _buildStrokeWidthButton('Thick', 6),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.clear),
              label: const Text('Clear'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Button background color
                foregroundColor: Colors.white, // Text and icon color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => _signatureController.clear(),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Button background color
                foregroundColor: Colors.white, // Text and icon color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _saveAndApplySignature,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildColorButton(Color color) {
    return IconButton(
      icon: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: _signatureController.penColor == color
                ? Colors.white
                : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      onPressed: () {
        final newController = SignatureController(
          penStrokeWidth: _signatureController.penStrokeWidth,
          penColor: color,
          exportBackgroundColor: Colors.transparent,
        );

        // Dispose old controller and replace
        _signatureController.dispose();
        _signatureController = newController;
        setState(() {});
      },
    );
  }

  Widget _buildStrokeWidthButton(String label, double width) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: _signatureController.penStrokeWidth == width
            ? Colors.blue[100]
            : null,
      ),
      onPressed: () {
        final newController = SignatureController(
          penStrokeWidth: width,
          penColor: _signatureController.penColor,
          exportBackgroundColor: Colors.transparent,
        );

        // Dispose old controller and replace
        _signatureController.dispose();
        _signatureController = newController;
        setState(() {});
      },
      child: Text(
        label,
        style: TextStyle(
          color: _signatureController.penStrokeWidth == width
              ? Colors.white
              : Colors.black,
        ),
      ),
    );
  }

  Future<void> _saveAndApplySignature() async {
    if (_signatureController.isEmpty) {
      _showError('Please create a signature first');
      return;
    }

    try {
      final signatureBytes = await _signatureController.toPngBytes();
      if (signatureBytes == null) {
        _showError('Failed to export signature');
        return;
      }

      setState(() => _signatureImage = signatureBytes);

      if (_selectedDocument != null && _signatureImage != null) {
        final processedDoc = await _processDocumentWithSignature();
        await _saveFinalDocument(processedDoc);
      }
    } catch (e) {
      _showError('Failed to save signature: $e');
    }
  }

  Future<Uint8List> _processDocumentWithSignature() async {
    if (_documentType == 'pdf') {
      return _addSignatureToPdf();
    } else {
      return _addSignatureToImage();
    }
  }

  Future<Uint8List> _addSignatureToPdf() async {
    try {
      final signatureImage = _signatureImage!;
      final documentBytes = await _selectedDocument!.readAsBytes();
      final document = sfpdf.PdfDocument(inputBytes: documentBytes);

      // Signature image as PDF bitmap
      final sfpdf.PdfBitmap bitmap = sfpdf.PdfBitmap(signatureImage);
      for (int i = 0; i < document.pages.count; i++) {
        final page = document.pages[i];

        // Draw the signature at the bottom-right of each page
        page.graphics.drawImage(
          bitmap,
          Rect.fromLTWH(
            page.getClientSize().width - 160,
            page.getClientSize().height - 100,
            150,
            75,
          ),
        );
      }
      // Convert List<int> to Uint8List
      final List<int> savedBytes = await document.save();
      return Uint8List.fromList(savedBytes);
    } catch (e) {
      throw Exception('PDF processing failed: ${e.toString()}');
    }
  }

  Future<Uint8List> _addSignatureToImage() async {
    try {
      final documentBytes = await _selectedDocument!.readAsBytes();
      final documentImage = img.decodeImage(documentBytes)!;
      final signature = img.decodeImage(_signatureImage!)!;

      final resizedSignature = img.copyResize(signature,
          width: (documentImage.width * 0.2).clamp(100, 300).toInt());

      img.compositeImage(
        documentImage,
        resizedSignature,
        dstX: documentImage.width - resizedSignature.width - 20,
        dstY: documentImage.height - resizedSignature.height - 20,
      );

      // Preserve original image format
      return _selectedDocument!.path.toLowerCase().endsWith('.png')
          ? Uint8List.fromList(img.encodePng(documentImage))
          : Uint8List.fromList(img.encodeJpg(documentImage));
    } catch (e) {
      throw Exception('Image processing failed: ${e.toString()}');
    }
  }

  Future<void> _saveFinalDocument(Uint8List bytes) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());

      if (_documentType == 'image') {
        // Save image to temporary file first
        // final imagePath = '${directory.path}/signed_$timestamp.jpg';
        final ext = _selectedDocument!.path.split('.').last;
        final imagePath = '${directory.path}/signed_$timestamp.$ext';

        final savedFile = await File(imagePath).writeAsBytes(bytes);

        // Save to gallery
        final success = await GallerySaver.saveImage(savedFile.path,
            albumName: "SignedDocs");

        if (!mounted) return;

        setState(() {
          _selectedDocument = savedFile;
          _signatureController.clear();
        });

        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Success'),
            content: Text(success == true
                ? 'Image saved to Gallery successfully.'
                : 'Image saved locally, but failed to save to Gallery.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
      if (_documentType == 'pdf') {
        // Save PDF to app's documents directory
        // final pdfPath = '${directory.path}/signed_$timestamp.pdf';
        // final savedFile = await File(pdfPath).writeAsBytes(bytes);
        final pdfFileName = 'signed_$timestamp.pdf';
        final savedFile =
            await File('${directory.path}/$pdfFileName').writeAsBytes(bytes);

        // Ask for permission
        final hasPermission = await _requestStoragePermission();
        if (!hasPermission) {
          _showError('Storage permission not granted.');
          return;
        }

        final downloadsPath = await _getDownloadsDirectoryPath();
        final targetPath = '$downloadsPath/$pdfFileName';
        final targetFile = await savedFile.copy(targetPath);

        if (!mounted) return;

        setState(() {
          _selectedDocument = targetFile;
          _signatureController.clear();
        });

        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Success'),
            content: Text('PDF saved to:\n$targetPath'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      _showError('Failed to save document: $e');
    }
  }

  Future<bool> _requestStoragePermission() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  Future<String> _getDownloadsDirectoryPath() async {
    if (Platform.isAndroid) {
      final directory = Directory('/storage/emulated/0/Download');
      if (await directory.exists()) {
        return directory.path;
      }
    }
    throw Exception('Downloads directory not found or unsupported platform');
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: _selectedDocument == null
          ? _buildOnboardingScreen()
          : _buildDocumentViewer(),
    );
  }

  Widget _buildOnboardingScreen() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 60, bottom: 40),
          child: Text(
            'TillscoSign',
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(40)),
            ),
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Click the image to take a photo',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: _takePhoto,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(30),
                      child: Icon(Icons.camera_alt,
                          size: 100, color: Colors.black54),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _pickDocument,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 20),
                  ),
                  child: Text(
                    'Choose Document',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentViewer() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => setState(() {
                _selectedDocument = null;
                _documentType = null;
                _signatureImage = null;
                _signatureController.clear();
              }),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(8.0),
              child: _documentType == 'pdf'
                  ? SfPdfViewer.file(_selectedDocument!)
                  : Image.file(_selectedDocument!),
            ),
          ),
          const SizedBox(height: 12),
          if (_selectedDocument != null) _buildSignaturePad(),
        ],
      ),
    );
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String
      hashedPassword; // Should store only hashed passwords in production

  User({
    String? id,
    required this.name,
    required this.email,
    required this.hashedPassword,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'hashedPassword': hashedPassword,
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        hashedPassword: json['hashedPassword'],
      );
}

class Document {
  final String id;
  final String filePath;
  final String type; // 'pdf' or 'image'
  final DateTime createdAt;
  final String userId;
  final List<String> signatureIds;

  Document({
    String? id,
    required this.filePath,
    required this.type,
    required this.userId,
    List<String>? signatureIds,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        signatureIds = signatureIds ?? [],
        createdAt = createdAt ?? DateTime.now();

  String get fileName => filePath.split('/').last;

  Map<String, dynamic> toJson() => {
        'id': id,
        'filePath': filePath,
        'type': type,
        'createdAt': createdAt.toIso8601String(),
        'userId': userId,
        'signatureIds': signatureIds,
      };

  factory Document.fromJson(Map<String, dynamic> json) => Document(
        id: json['id'],
        filePath: json['filePath'],
        type: json['type'],
        userId: json['userId'],
        signatureIds: List<String>.from(json['signatureIds']),
        createdAt: DateTime.parse(json['createdAt']),
      );
}
//
// class Signature {
//   final String id;
//   final Uint8List imageData;
//   final Offset position;
//   final DateTime createdAt;
//   final String documentId;
//   final String userId;

//   Signature({
//     String? id,
//     required this.imageData,
//     required this.position,
//     required this.documentId,
//     required this.userId,
//     DateTime? createdAt,
//   }) :
//         id = id ?? const Uuid().v4(),
//         createdAt = createdAt ?? DateTime.now();
//
//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'imageData': base64Encode(imageData),
//     'positionX': position.dx,
//     'positionY': position.dy,
//     'createdAt': createdAt.toIso8601String(),
//     'documentId': documentId,
//     'userId': userId,
//   };
//
//   factory Signature.fromJson(Map<String, dynamic> json) => Signature(
//     id: json['id'],
//     imageData: base64Decode(json['imageData']),
//     position: Offset(json['positionX'], json['positionY']),
//     documentId: json['documentId'],
//     userId: json['userId'],
//     createdAt: DateTime.parse(json['createdAt']),
//   );
// }
