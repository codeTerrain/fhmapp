import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked/stacked.dart';
import '../../core/model/post_model.dart';
import '../../core/services/file_operations.dart';
import '../../core/services/respository.dart';
import '../../core/services/shared_preferences.dart';
import '../../locator.dart';

class PostViewModel extends MultipleFutureViewModel {
  final SharedPrefs _sharedPrefs = locator<SharedPrefs>();
  final Respository _respository = locator<Respository>();
  final List<String> _imageUrls = [];
  List<String> get imageUrls => _imageUrls;

  Future post({
    required String postId,
    required String category,
    String? content,
    List<File>? images,
  }) async {
    if (images!.isNotEmpty || content!.isNotEmpty) {
      final String creator = await _sharedPrefs.getLocalStorage('email');
      for (var image in images) {
        await runBusyFuture(FileOperations.uploadFile('/posts', image)
            .then((downloadUrl) => _imageUrls.add(downloadUrl as String))
            .onError((error, stackTrace) {
          Fluttertoast.showToast(msg: error.toString());
          return;
        }));
      }

      final Map<String, dynamic> postItem = {
        'postId': postId,
        'category': category,
        'content': content,
        'images': imageUrls,
        'creator': creator,
        'likes': []
      };
      notifyListeners();
      runBusyFuture(
          _respository.addPost(postItem).then((value) => imageUrls.clear()));

      //_imageUrls.add(downloadURL);
      print(imageUrls);
    }
  }

  updateLikes({required Post post, required String currentUserEmail}) {
    Set<String> likes = {};

    likes = post.likes.toSet().cast<String>();
    if (likes.contains(currentUserEmail)) {
      print('true');
      likes.remove(currentUserEmail);
    } else {
      print('false');
      likes.add(currentUserEmail);
    }

    _respository.updateLikes(
        postId: post.postId, email: currentUserEmail, updatedLikes: likes);
  }

  // Future uploadFile() async {
  //   runBusyFuture(FileOperations.uploadFile('/profile', imageFile!).then(
  //       (downloadUrl) async {
  //     if (result) {
  //       Fluttertoast.showToast(
  //           msg: 'Your profile image was updated successfully.');
  //     }

  //     notifyListeners();
  //   }, onError: (err) {
  //     //Fluttertoast.showToast(msg: 'This file is not an image');
  //   }));
  // }

  @override
  Map<String, Future Function()> get futuresMap => {};
}
