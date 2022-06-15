import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fhmapp/core/model/resource_model.dart';
import 'package:fhmapp/core/services/respository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';
import 'package:path/path.dart';

import '../../locator.dart';

class ResourceService extends BaseViewModel {
  final Respository _respository = locator<Respository>();

  final List<Resource> _resources = [];
  List<Resource> get resources => _resources;

  static String getFileName(Reference file) {
    String fileName = file.name.splitMapJoin(
      RegExp(
          r'.docx|.doc|.txt|.pptx|.html|.jpeg|.jpg|.png|.gif|.pdf|.xlsx|.ppt|.tiff'),
      onMatch: (matchedString) => '',
    );
    return fileName;
  }

  static String getDownloadaedFileName(String path) {
    String fileName = path.splitMapJoin(
      RegExp(
          r'.docx|.svg|.doc|.txt|.pptx|.html|.jpeg|.jpg|.png|.gif|.pdf|.xlsx|.ppt|.tiff'),
      onMatch: (matchedString) => '',
    );
    return fileName;
  }

  static String getDownloadaedCategory(String path) {
    String fileName = path.splitMapJoin(RegExp(r'MCH|FP|ADH|NUT|'),
        onMatch: (matchedCategory) => '${matchedCategory[0]}',
        onNonMatch: (nonMatchedCategory) => '');
    return fileName;
  }

  static String getFileExtension(String fileName) {
    String fileExtension = fileName.split(".").last;
    return fileExtension;
  }

  Future<String> getLocalPath() async {
    var localStorage = await getTemporaryDirectory();

    return localStorage.path;
  }

  Future getAllResources(String category) async {
    //for getting downloaded resources
    String path = await getLocalPath();
    String fullPath = '$path/$category';
    var pathOfDirectory = await Directory(fullPath).create();
    List<FileSystemEntity> fileList = await pathOfDirectory.list().toList();
    List<Resource> offlineList = [];
    for (var doc in fileList) {
      // doc.deleteSync(recursive: true);
      Map<String, Object> data = {
        'path': doc.path,
        'name': getDownloadaedFileName(basename(doc.path)),
        'category': getDownloadaedCategory(doc.path),
        'extension': getFileExtension(doc.path.split('/').last),
        'isRemote': false
      };
      offlineList.add(Resource.fromAPI(data));
    }
    _resources.insertAll(_resources.length, offlineList);
    notifyListeners();

    //for getting online resources
    var onlineResources = await _respository.getResources(category);
    if (onlineResources is QuerySnapshot) {
      List<DocumentSnapshot> docs = onlineResources.docs;
      List<Resource> onlineList = [];

      for (var doc in docs) {
        Map<String, Object> data = {
          'path': doc['path'],
          'name': doc['name'],
          'category': doc['category'],
          'extension': doc['extension'],
          'isRemote': true
        };
        onlineList.add(Resource.fromAPI(data));

//check (by name) if online document has already been downloaded
        var downloadedResource =
            _resources.where((resource) => resource.name == doc['name']);

        if (downloadedResource.isEmpty) {
          _resources.add(Resource.fromAPI(data));
        }
      }

      notifyListeners();
    }
  }
}
