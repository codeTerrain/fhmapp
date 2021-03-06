import 'package:fhmapp/core/services/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:stacked/stacked.dart';

import '../../core/model/user_model.dart';
import '../../core/services/authentication_service.dart';
import '../../core/services/dialog_service.dart';
import '../../core/services/navigation_service.dart';
import '../../core/services/respository.dart';
import '../../locator.dart';
import '../shared/Routes.dart';

class LoginViewModel extends MultipleFutureViewModel {
  final SharedPrefs _sharedPrefs = locator<SharedPrefs>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final Respository _respository = locator<Respository>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future login({
    required String email,
    required String password,
  }) async {
    _sharedPrefs.removeAll();
    try {
      var result = await runBusyFuture(_authenticationService.loginWithEmail(
        email: email,
        password: password,
      ));

      // ignore: curly_braces_in_flow_control_structures
      if (result is bool) {
        if (result) {
          Users user = await _respository.getUserDetail(email);
          addLoggedinDevice(user);
          _sharedPrefs.setLocalUserData(user);
          _respository.userOnlineState(email: email, online: true);
          _navigationService.navigateTo(Routes.navigation);
        }
      }
    } on FirebaseAuthException catch (e) {
      await _dialogService.showDialog(
          title: 'Login Failure', description: e.code.toString());
    }
  }

  addLoggedinDevice(Users user) {
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;
    Set<String> loggedInDevices = {};
    _fcm.getToken().then((token) {
      if (user.loggedInDevices != null) {
        loggedInDevices = user.loggedInDevices!.toSet().cast<String>();
      }

      if (token != null) {
        loggedInDevices.add(token);
      }
      _respository.updateToken(
          email: user.email, updatedLoggedInDevices: loggedInDevices);
    });
  }

  @override
  Map<String, Future Function()> get futuresMap => {};
}
