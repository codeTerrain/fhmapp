import 'dart:io';

import 'package:fhmapp/ui/widgets/change_info.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';

import 'dart:convert' show utf8;

class Upl extends StatefulWidget {
  const Upl({Key? key}) : super(key: key);

  @override
  State<Upl> createState() => _UplState();
}

class _UplState extends State<Upl> {
  Future<List?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile file = result.files.first;

      final input = File(file.path!).openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(const CsvToListConverter())
          .toList();

      return fields;
    }
    return null;
  }

  List? v;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ButtonWrapper(
                buttonText: 'buttonText',
                onPressed: () {
                  setState(() async {
                    v = await pickFile();
                  });
                }),
            Text('$v')
          ],
        ),
      ),
    );
  }
}
