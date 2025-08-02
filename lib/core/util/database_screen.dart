import 'dart:io';
import 'package:calkuta/util/my_color.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseScreen extends StatefulWidget {
  const DatabaseScreen({super.key});

  @override
  _DatabaseScreenState createState() => _DatabaseScreenState();
}

class _DatabaseScreenState extends State<DatabaseScreen> {
  Future<Directory?> getDirectoryPath() async {
    String? directoryPath = await FilePicker.platform.getDirectoryPath();
    if (directoryPath != null && directoryPath.isNotEmpty) {
      return Directory(directoryPath);
    }
    return null;
  }

  Future<void> exportDatabase() async {
    try {
      var permissionStatus = await Permission.storage.request();

      if (permissionStatus.isGranted) {
        var databasesPath = await getDatabasesPath();
        var sourcePath = '$databasesPath/calkuta.db';
        var destinationDirectory = await getDirectoryPath();

        if (destinationDirectory != null) {
          File sourceFile = File(sourcePath);
          File destinationFile =
              File('${destinationDirectory.path}/calkuta.db');
          await sourceFile.copy(destinationFile.path);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Database exported successfully!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Destination directory not selected!')),
          );
        }
      } else {
        debugPrint("error exp: Permission denied. Cannot export db");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Permission denied. Cannot export database!')),
        );
      }
    } catch (e) {
      debugPrint("error exp: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error exporting database: $e')),
      );
    }
  }

  Future<void> importDatabase() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        //allowedExtensions: ['db'],
      );

      if (result != null) {
        String? path = result.files.single.path;
        if (path != null) {
          var databasesPath = await getDatabasesPath();
          var destinationPath = '$databasesPath/calkuta.db';
          File destinationFile = File(destinationPath);
          await File(path).copy(destinationFile.path);
          //print('destinationFile> ${destinationFile.path}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Database imported successfully!')),
          );
        }
      }
    } catch (e) {
      debugPrint('importing error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error importing database: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: MyColor.mytheme),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        title: const Text(
          'Database Screen',
          style: TextStyle(
            color: MyColor.mytheme,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              backgroundColor: Color.fromARGB(255, 127, 98, 132),
              radius: 30,
              child: Icon(Icons.import_export, color: Colors.white, size: 40),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: MyColor.mytheme, width: 1.0)),
              icon: const Icon(Icons.upload,
                  color: Color.fromARGB(255, 127, 98, 132), size: 20),
              onPressed: exportDatabase,
              label: const Text(
                'Export Database',
                style: TextStyle(
                    color: Color.fromARGB(255, 127, 98, 132),
                    fontSize: 18.0,
                    fontWeight: FontWeight.w900),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: MyColor.mytheme, width: 1.0)),
              icon: const Icon(Icons.download,
                  color: Color.fromARGB(255, 127, 98, 132), size: 20),
              onPressed: importDatabase,
              label: const Text(
                'Import Database',
                style: TextStyle(
                    color: Color.fromARGB(255, 127, 98, 132),
                    fontSize: 18.0,
                    fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
