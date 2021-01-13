import 'dart:html' as webFile;

import 'package:flutter/foundation.dart';
// import 'package:file_picker/file_picker.dart';

void saveFile() {
  if (kIsWeb) {
    var blob = webFile.Blob(["data"], 'text/plain', 'native');

    var anchorElement = webFile.AnchorElement(
      href: webFile.Url.createObjectUrlFromBlob(blob).toString(),
    )
      ..setAttribute("download", "data.txt")
      ..click();
  }
}

// void pickFile() async {
//   if (kIsWeb) {
//     final webFile.File file = await FilePicker(
//       allowedExtensions: ['pd'],
//       type: FileType.custom,
//     );

//     final reader = webFile.FileReader();
//     reader.readAsText(file);

//     await reader.onLoad.first;

//     String data = reader.result;
//   }
// }
