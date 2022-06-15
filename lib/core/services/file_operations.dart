import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FileOperations {
  // static UploadTask? uploadFile(String destination, File file) async {
  //   try {
  //     final ref = FirebaseStorage.instance.ref(destination);
  //     return ref.putFile(file);
  //   } on FirebaseException catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }

  static Future uploadFile(String destination, File imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference =
        FirebaseStorage.instance.ref(destination).child(fileName);

    TaskSnapshot uploadTask = await reference.putFile(imageFile);

    String url = await uploadTask.ref.getDownloadURL();

    return url;
  }

  static Future deleteFile(String destination, String url) async {
    try {
      void reference = await FirebaseStorage.instance.refFromURL(url).delete();

      return true;
    } on FirebaseException catch (e) {
      print(e);
      return null;
    }
  }

  // static UploadTask? uploadBytes(String destination, Uint8List data) {
  //   try {
  //     final ref = FirebaseStorage.instance.ref(destination);

  //     return ref.putData(data);
  //   } on FirebaseException catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }
}
