import 'package:fhmapp/core/services/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../core/services/utilities.dart';
import '../../locator.dart';

class ElearningViewModel extends MultipleFutureViewModel {
  final SharedPrefs _sharedPrefs = locator<SharedPrefs>();

  String? _elearnUsername;
  String? _elearnPassword;
  String? get elearnUsername => _elearnUsername;
  String? get elearnPassword => _elearnPassword;

  Future elearnLogin({
    required String username,
    required String oldPassword,
    required String newPassword,
    required BuildContext context,
  }) async {
    var result = await runBusyFuture(
        setElearnCredential(oldPassword, username, newPassword));
    notifyListeners();

    if (result is bool) {
      if (result) {
        Utilities.activityDone(context, description: 'Success');
      } else {
        Utilities.activityDone(context, description: 'Failure');
      }
    } else {
      Utilities.activityDone(context, description: result.toString());
    }
  }

  Future setElearnCredential(
      String oldPassword, String username, String newPassword) async {
    try {
      await _sharedPrefs.getLocalStorage('elearnUsername');

      var _elearnPassword =
          await _sharedPrefs.getLocalStorage('elearnPassword');

      if (oldPassword != _elearnPassword) {
        return false;
      } else {
        await _sharedPrefs.setLocalStorage('elearnUsername', username);
        await _sharedPrefs.setLocalStorage('elearnPassword', newPassword);
        return true;
      }
    } catch (e) {
      return e;
    }
  }

  getElearnCredential() async {
    try {
      setBusy(true);
      _elearnUsername = await _sharedPrefs.getLocalStorage('elearnUsername');
      _elearnPassword = await _sharedPrefs.getLocalStorage('elearnPassword');
      setBusy(false);
    } catch (e) {
      return e;
    }
  }

  @override
  Map<String, Future Function()> get futuresMap => {};
}
