// import 'dart:io';
// import 'dart:typed_data';
// import 'package:image/image.dart' as img;
//
// class ImageService {
//   Future<Uint8List> addSignatureToImage({
//     required String documentPath,
//     required Uint8List signatureBytes,
//   }) async {
//     final documentImage = img.decodeImage(await File(documentPath).readAsBytes())!;
//     final signature = img.decodeImage(signatureBytes)!;
//     final resizedSignature = img.copyResize(signature, width: (documentImage.width * 0.2).toInt());
//
//     img.compositeImage(
//       documentImage,
//       resizedSignature,
//       dstX: documentImage.width - resizedSignature.width - 20,
//       dstY: documentImage.height - resizedSignature.height - 20,
//     );
//
//     return documentPath.toLowerCase().endsWith('.png')
//         ? Uint8List.fromList(img.encodePng(documentImage))
//         : Uint8List.fromList(img.encodeJpg(documentImage));
//   }
// }