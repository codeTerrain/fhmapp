import 'dart:io';

import 'package:fhmapp/core/services/file_operations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:stacked/stacked.dart';

import '../../core/model/user_model.dart';
import '../../core/services/respository.dart';
import '../../core/services/shared_preferences.dart';
import '../../core/services/utilities.dart';
import '../../locator.dart';

class ProfileViewModel extends FutureViewModel {
  final SharedPrefs _sharedPrefs = locator<SharedPrefs>();
  final Respository _respository = locator<Respository>();
  File? imageFile;
  String? _imageUrl;
  String? get imageUrl => _imageUrl;
  late Users _user;
  Users get user => _user;

  Future<Users?> getUserInfo() async {
    String userId = await _sharedPrefs.getLocalStorage('userId');
    String firstName = await _sharedPrefs.getLocalStorage('firstName');
    String lastName = await _sharedPrefs.getLocalStorage('lastName');
    String email = await _sharedPrefs.getLocalStorage('email');
    String phone = await _sharedPrefs.getLocalStorage('phone');
    String cadre = await _sharedPrefs.getLocalStorage('cadre');
    String userType = await _sharedPrefs.getLocalStorage('userType');
    String gender = await _sharedPrefs.getLocalStorage('gender');
    String community = await _sharedPrefs.getLocalStorage('community');
    String district = await _sharedPrefs.getLocalStorage('district');
    String facility = await _sharedPrefs.getLocalStorage('facility');
    String region = await _sharedPrefs.getLocalStorage('region');
    String dateJoined = await _sharedPrefs.getLocalStorage('dateJoined');
    String dob = await _sharedPrefs.getLocalStorage('dob');
    String profilePicture =
        await _sharedPrefs.getLocalStorage('profilePicture');
    List<String>? fhmappAdminFor =
        await _sharedPrefs.getListLocalStorage('fhmappAdminFor');

    Users user = Users(
        userId: userId,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        gender: gender,
        dateJoined: DateTime.fromMillisecondsSinceEpoch(int.parse(dateJoined)),
        cadre: cadre,
        community: community,
        district: district,
        dob: DateTime.fromMillisecondsSinceEpoch(int.parse(dob)),
        facility: facility,
        region: region,
        userType: userType,
        fhmappAdminFor: fhmappAdminFor,
        profilePicture: profilePicture);

    _user = user;

    notifyListeners();
    return _user;
  }

  changeProfileImage() async {
    File localFile;
    final CroppedFile? pickedFile = await Utilities.pickMedia(
      isGallery: true,
      cropImage: (croppedFile) =>
          Utilities.cropSquareImage(croppedFile, CropStyle.circle),
    );

    if (pickedFile == null) return;
    localFile = File(pickedFile.path);
    imageFile = localFile;
    notifyListeners();

    if (imageFile != null) {
      //_sharedPrefs.removeEntry('profilePicture');
      runBusyFuture(uploadFile());
    }
  }

  Future uploadFile() async {
    runBusyFuture(FileOperations.uploadFile('/profile', imageFile!).then(
        (downloadUrl) async {
      _imageUrl = downloadUrl;
      if (user.profilePicture != null) {
        FileOperations.deleteFile('/profile', user.profilePicture!);
      }
      _sharedPrefs.setLocalStorage('profilePicture', imageUrl ?? '');

      bool result = await _respository
          .updateInfo(user.email, {'profilePicture': downloadUrl});

      if (result) {
        Fluttertoast.showToast(
            msg: 'Your profile image was updated successfully.');
      }

      notifyListeners();
    }, onError: (err) {
      //setBusy(false);
      Fluttertoast.showToast(msg: 'This file is not an image');
    }));
  }

  @override
  Future futureToRun() => getUserInfo();
}
