import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:signature_document/screens/signatureApp.dart';
import 'package:uuid/uuid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const SignatureApp(),
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
