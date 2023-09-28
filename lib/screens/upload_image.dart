import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ImageUploaderWidget extends StatefulWidget {
  @override
  _ImageUploaderWidgetState createState() => _ImageUploaderWidgetState();
}

class _ImageUploaderWidgetState extends State<ImageUploaderWidget> {
  File? _pickedImageFile;
  final int maxFileSize = 1 * 1024 * 1024; // 10 MB

  void _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.isNotEmpty) {
      File pickedFile = File(result.files.single.path!);

      // Check file size manually
      int fileSize = await pickedFile.length();
      if (fileSize <= maxFileSize) {
        setState(() {
          _pickedImageFile = pickedFile;
        });
      } else {
        // showDialog(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return AlertDialog(
        //       title: Text('File Size Limit Exceeded'),
        //       content: Text(
        //           'Please select a file with a maximum size of ${maxFileSize ~/ (1024 * 1024)} MB.'),
        //       actions: [
        //         TextButton(
        //           onPressed: () => Navigator.pop(context),
        //           child: Text('OK'),
        //         ),
        //       ],
        //     );
        //   },
        // );
      }
    }
  }

  void _saveImage() async {
    if (_pickedImageFile != null) {
      String fileName = path.basename(_pickedImageFile!.path);
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      String newPath = path.join(appDocPath, 'user_images', fileName);

      await Directory(path.dirname(newPath)).create(recursive: true);
      await _pickedImageFile!.copy(newPath);
      print('Image saved to: $newPath');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            SizedBox(height: 16),
            _pickedImageFile != null
                ? Image.file(_pickedImageFile!)
                : Text('No image selected'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveImage,
              child: Text('Save Image'),
            ),
          ],
        ),
      ),
    );
  }
}
