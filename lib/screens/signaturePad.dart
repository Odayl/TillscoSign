// import 'package:flutter/material.dart';
// import 'package:signature_document/controller/SignatureController.dart';
// import 'package:signature_document/model/signature.dart';
//
// class _SignaturePad extends StatelessWidget {
//   final SignatureController signatureController;
//   final VoidCallback onSave;
//
//   const _SignaturePad({
//     required this.signatureController,
//     required this.onSave,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           height: 200,
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Signature(controller: signatureController.padController),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             ElevatedButton(
//               onPressed: signatureController.clearSignature,
//               child: const Text('Clear'),
//             ),
//             ElevatedButton(
//               onPressed: onSave,
//               child: const Text('Save'),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }