import 'dart:io';

import 'package:fhmapp/ui/shared/spacing.dart';
import 'package:fhmapp/ui/viewmodels/user_action_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

import '../../ui/shared/static_lists.dart';
import '../../ui/shared/style.dart';
import '../../ui/widgets/buttons.dart';
import '../../ui/widgets/misc.dart';

class Utilities {
  static Future<CroppedFile?> pickMedia({
    required bool isGallery,
    required Future<CroppedFile?> Function(CroppedFile file) cropImage,
  }) async {
    final source = isGallery ? ImageSource.gallery : ImageSource.camera;
    final pickedFile =
        await ImagePicker().pickImage(source: source, imageQuality: 60);

    if (pickedFile == null) return null;

    //file size limit
    final bytes = File(pickedFile.path).readAsBytesSync().lengthInBytes;
    final kb = bytes / 1024;
    final mb = kb / 1024;
    if (mb > 0.7) {
      Fluttertoast.showToast(msg: 'Select an image less than 700kb');
      return null;
    }
    final file = CroppedFile(pickedFile.path);

    return cropImage(file);
  }

  static Future<CroppedFile?> cropSquareImage(
          CroppedFile imageFile, CropStyle cropStyle) async =>
      await ImageCropper().cropImage(
        cropStyle: cropStyle,
        sourcePath: imageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1.1),
        aspectRatioPresets: [CropAspectRatioPreset.ratio16x9],
        compressQuality: 60,
        compressFormat: ImageCompressFormat.png,
        uiSettings: [androidUiSettingsLocked(), iosUiSettingsLocked()],
      );

  static IOSUiSettings iosUiSettingsLocked() => IOSUiSettings(
        rotateClockwiseButtonHidden: false,
        rotateButtonsHidden: false,
      );

  static AndroidUiSettings androidUiSettingsLocked() => AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: primaryColor,
        toolbarWidgetColor: kWhite,
        hideBottomControls: true,
      );

  static tAndC(BuildContext context,
      {String title = '', String description = 'Task Updated Successfully'}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: roundedListTileBorder,
          title: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                      color: kWhite,
                      border: Border.all(color: primaryColor, width: 3),
                      shape: BoxShape.circle),
                  child: const Icon(
                    Icons.close,
                    color: primaryColor,
                    size: 15,
                  )),
            ),
          ),
          content: const SingleChildScrollView(
            child: Text(
              privacyPolicy,
              textAlign: TextAlign.center,
            ),
          ),
          actions: <Widget>[
            Center(
              heightFactor: 2,
              child: RoundedButtonTheme(
                  width: 100,
                  text: 'Agree',
                  buttonColor: kBlack,
                  onPressed: () => Navigator.pop(context)),
            ),
          ],
        );
      },
    );
  }

  static confirmLogout(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!

      builder: (BuildContext context) {
        return AlertDialog(
          shape: roundedListTileBorder,
          title: Row(
            children: [
              const CircleAvatar(
                backgroundColor: primaryColor,
                child: Icon(Icons.check),
              ),
              UiSpacing.horizontalSpacingTiny(),
              Text(
                'Confirm Logout',
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(fontSize: 15, color: primaryColor),
              )
            ],
          ),
          content: const SingleChildScrollView(
            child: Text(
              'Are you sure you want to logout?',
              textAlign: TextAlign.center,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            ViewModelBuilder<UserActionModel>.nonReactive(
              viewModelBuilder: () => UserActionModel(),
              builder: (context, model, child) => RoundedButtonTheme(
                  width: 100,
                  text: 'Yes',
                  buttonColor: primaryColor,
                  onPressed: () =>
                      model.signout().then((value) => Navigator.pop(context))),
            ),
            RoundedButtonTheme(
                width: 100,
                text: 'No',
                buttonColor: secondary2,
                onPressed: () => Navigator.pop(context)),
          ],
        );
      },
    );
  }

  static showSnackBar(BuildContext context,
      {required double width, required String text}) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        text,
      ),
      width: width,
      shape: roundedListTileBorder,
      behavior: SnackBarBehavior.floating,
    ));
  }

  static activityDone(BuildContext context,
      {String title = '', String description = 'Success'}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        var failure = const CircleAvatar(
          backgroundColor: secondary2,
          child: Icon(Icons.highlight_remove_rounded),
        );
        var success = const CircleAvatar(
          backgroundColor: primaryColor,
          child: Icon(Icons.check),
        );
        return AlertDialog(
          shape: roundedListTileBorder,
          title: Row(
            children: [
              description == 'Success' ? success : failure,
              UiSpacing.horizontalSpacingTiny(),
              Text(
                description,
                style: Theme.of(context).textTheme.headline5?.copyWith(
                    fontSize: 15,
                    color:
                        description == 'Success' ? primaryColor : secondary2),
              )
            ],
          ),
        );
      },
    );
  }
}
