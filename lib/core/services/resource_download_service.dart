import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fhmapp/core/model/resource_model.dart';
import 'package:fhmapp/core/services/respository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';
import 'package:path/path.dart';

import '../../locator.dart';
import 'shared_preferences.dart';

class ResourceService extends BaseViewModel {
  final Respository _respository = locator<Respository>();

  final SharedPrefs _sharedPrefs = locator<SharedPrefs>();

  final List<Resource> _resources = [];
  List<Resource> get resources => _resources;
  static const String source =
      r'.docx|.svg|.doc|.txt|.pptx|.html|.jpeg|.jpg|.png|.gif|.pdf|.xlsx|.ppt|.tiff|.mp4|.mpeg|.webm|.mov|.avi|.wmv|.flv|.mkv|.mp3|.wav|.ogg|.wma|.aac|.csv';

  static String getFileName(Reference file) {
    String fileName = file.name.splitMapJoin(
      RegExp(source),
      onMatch: (matchedString) => '',
    );
    return fileName;
  }

  static String getDownloadaedFileName(String path) {
    String fileName = path.splitMapJoin(
      RegExp(source),
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

      for (var doc in docs) {
        bool? docContainsKey =
            await _sharedPrefs.containsKey(doc['id'].toString());
        if (docContainsKey is bool) {
          //  print(await _sharedPrefs.getLocalStorage(doc['id'].toString()));
          if (!docContainsKey) {
            //     print(doc['id']);
            Map<String, Object> data = {
              'id': doc['id'],
              'path': doc['path'],
              'name': doc['name'],
              'category': doc['category'],
              'extension': doc['extension'],
              'isRemote': true
            };
            _resources.add(Resource.fromAPI(data));
          }
        }

//check (by id) if online document has already been downloaded

        // var downloadedResource = _resources.where((resource) {
        //   _sharedPrefs.getLocalStorage(resource.id);
        //   return resource.id == doc['id'];
        // });
        // //     print('thh $downloadedResource');

        // if (downloadedResource.isEmpty) {
        //   _resources.add(Resource.fromAPI(data));
        // }
      }

      notifyListeners();
    }
  }

  static Future<void> deleteFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Error in getting access to the file.
    }
  }

  Future updateResourceDownloads({required Resource resource}) async {
    Set<String> updatedDownloadList = {};
    final String currentUserEmail = await _sharedPrefs.getLocalStorage('email');
    print(resource.downloadedUsers);

    if (resource.downloadedUsers != null) {
      updatedDownloadList = resource.downloadedUsers!.toSet().cast<String>();
    }

    updatedDownloadList.add(currentUserEmail);

    _respository.updateResourceDownloads(
        id: resource.id,
        email: currentUserEmail,
        updatedDownloadList: updatedDownloadList);
  }
}
