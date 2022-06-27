import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import '../../core/services/authentication_service.dart';
import '../../core/services/navigation_service.dart';
import '../../core/services/respository.dart';
import '../../core/services/shared_preferences.dart';
import '../../core/services/utilities.dart';
import '../../locator.dart';
import '../shared/Routes.dart';

class UserActionModel extends MultipleFutureViewModel {
  final SharedPrefs _sharedPrefs = locator<SharedPrefs>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final FirebaseMessaging fcm = FirebaseMessaging.instance;

  final Respository _respository = locator<Respository>();

  Future signout() async {
    await _authenticationService.signOut();
    String email = await _sharedPrefs.getLocalStorage('email');
    _respository.userOnlineState(email: email, online: false);
    fcm.getToken().then((token) {
      _respository
          .updateToken(email: email, token: token, updatedLoggedInDevices: {});
      _sharedPrefs.removeAll();
    });

    _navigationService.navigateTo(Routes.login);
  }

  Future changePassword(BuildContext context,
      {required String currentPassword, required String newPassword}) async {
    var result = await runBusyFuture(
        _authenticationService.changePassword(currentPassword, newPassword));
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

  Future changePersonalInfo(
      BuildContext context, Map<String, dynamic> data) async {
    String email = await _sharedPrefs.getLocalStorage('email');
    var result = await runBusyFuture(_respository.updateInfo(email, data));
    if (result is bool) {
      if (result) {
        data.forEach((key, value) async {
          await _sharedPrefs.setLocalStorage(key, value);
        });
        Utilities.activityDone(context, description: 'Success');
      } else {
        Utilities.activityDone(context, description: 'Failure');
      }
    } else {
      Utilities.activityDone(context, description: result.toString());
    }
  }

  @override
  Map<String, Future Function()> get futuresMap => {};
}
