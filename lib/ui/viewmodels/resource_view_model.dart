import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:stacked/stacked.dart';

import '../../core/model/resource_model.dart';
import '../../core/services/file_operations.dart';
import '../../core/services/resource_download_service.dart';
import '../../core/services/respository.dart';
import '../../core/services/shared_preferences.dart';
import '../../locator.dart';

class ResourceViewModel extends MultipleFutureViewModel {
  final SharedPrefs _sharedPrefs = locator<SharedPrefs>();
  final Respository _respository = locator<Respository>();
  String? _fileUrl;
  String? get fileUrl => _fileUrl;
  String? _downloadProgress;
  String? get downloadProgress => _downloadProgress;
  bool? _isRemote;
  bool? get isRemote => _isRemote;
  Future createResource({
    required String id,
    required String name,
    required String category,
    required String resourceExtension,
    required File resource,
  }) async {
    if (await resource.exists()) {
      final String creator = await _sharedPrefs.getLocalStorage('email');

      await runBusyFuture(FileOperations.uploadFile('/resources', resource)
              .then((downloadUrl) => _fileUrl = downloadUrl as String))
          .onError((error, stackTrace) {
        Fluttertoast.showToast(msg: error.toString());
        return error.toString();
      });

      final Map<String, dynamic> resourceItem = {
        'id': id,
        'category': category,
        'name': name,
        'path': fileUrl,
        'creator': creator,
        'extension': resourceExtension,
        'isRemote': true,
        'downloadedUsers': []
      };
      notifyListeners();
      runBusyFuture(_respository.addPost(resourceItem, 'resources'));
    }
  }

  // rd(Resource resource) {
  //   _downloadProgress = resource.extension;
  //   _isRemote = resource.isRemote;
  // }

  // downloadResource(BuildContext context, Resource resource) async {
  //   var dio = Dio();
  //   _isRemote = resource.isRemote;
  //   String resourceName = resource.name;

  //   try {
  //     String path = await ResourceService().getLocalPath();
  //     String fullpath =
  //         '$path/${resource.category}/$resourceName.${resource.extension}';

  //     File downloadedResource = File(fullpath);

  //     if (await downloadedResource.exists()) {
  //       OpenFile.open(fullpath);
  //     } else {
  //       String url = resource.path;

  //       await dio.download(
  //         url,
  //         fullpath,
  //         onReceiveProgress: (received, total) {
  //           if (total != -1) {
  //             _downloadProgress =
  //                 (received / total * 100).toStringAsFixed(0) + "%";
  //           }
  //         },
  //       ).then((value) async {
  //         await _sharedPrefs.setLocalStorage(resource.id, resource.name);
  //       }).onError((e, s) {
  //         print(e);
  //         ResourceService.deleteFile(downloadedResource);
  //         return;
  //       });

  //       _isRemote = false;
  //       _downloadProgress = resource.extension;
  //     }

  //     OpenFile.open(fullpath);
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(const SnackBar(content: Text(' File Downloaded')));
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text(
  //             'An error occurred while downloading the file. Please try again later. Thank you.')));
  //   }
  // }

  @override
  Map<String, Future Function()> get futuresMap => {};
}
