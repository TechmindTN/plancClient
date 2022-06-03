// import 'package:extended_image/extended_image.dart';
// import 'package:flutter/material.dart';

// class ImageEditorScreen extends StatefulWidget{
//   @override
//   State<ImageEditorScreen> createState() => _ImageEditorScreenState();
// }

// class _ImageEditorScreenState extends State<ImageEditorScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: ExtendedImage.asset(
//       "assets/img/wallet.png",
//       fit: BoxFit.contain,
//       mode: ExtendedImageMode.editor,
//       // extendedImageEditorKey: editorKey,
//       initEditorConfigHandler: (state) {
//         return EditorConfig(
//           cornerColor: Colors.black,
//           lineColor: Colors.black,

//             maxScale: 8.0,
//             cropRectPadding: EdgeInsets.all(20.0),
//             hitTestSize: 20.0,
//             // cropAspectRatio: _aspectRatio.aspectRatio
//             );
//       },
//     )

//       ),
//     );
//     // TODO: implement build
//     throw UnimplementedError();
//   }
// }