// import 'package:flutter/material.dart';
//
// import '../controller/DocumentController.dart';
//
// class _ActionButtons extends StatelessWidget {
//   const _ActionButtons();
//
//   @override
//   Widget build(BuildContext context) {
//     final documentController = context.read<DocumentController>();
//
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         FloatingActionButton(
//           onPressed: documentController.pickDocument,
//           tooltip: 'Pick Document',
//           child: const Icon(Icons.folder_open),
//         ),
//         FloatingActionButton(
//           onPressed: documentController.takePhoto,
//           tooltip: 'Take Photo',
//           child: const Icon(Icons.camera_alt),
//         ),
//       ],
//     );
//   }
// }