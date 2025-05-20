// import 'package:flutter/material.dart';
//
// import '../controller/DocumentController.dart';
// import '../controller/SignatureController.dart';
//
// class _HomeContent extends StatelessWidget {
//   const _HomeContent();
//
//   @override
//   Widget build(BuildContext context) {
//     final documentController = context.watch<DocumentController>();
//     final signatureController = context.watch<SignatureController>();
//
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           Expanded(
//             child: documentController.selectedDocument == null
//                 ? const _EmptyState()
//                 : _DocumentPreview(document: documentController.selectedDocument!),
//           ),
//           if (documentController.selectedDocument != null)
//             _SignaturePad(
//               signatureController: signatureController,
//               onSave: () => _handleSave(context),
//             ),
//           const _ActionButtons(),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _handleSave(BuildContext context) async {
//     final documentController = context.read<DocumentController>();
//     final signatureController = context.read<SignatureController>();
//
//     try {
//       await signatureController.saveSignature();
//       await documentController.saveSignedDocument(signatureController.signatureBytes!);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Document saved successfully')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
//       );
//     }
//   }
// }