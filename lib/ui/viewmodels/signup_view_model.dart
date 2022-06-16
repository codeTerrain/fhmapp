import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:stacked/stacked.dart';

import '../../core/model/user_model.dart';
import '../../core/services/authentication_service.dart';
import '../../core/services/navigation_service.dart';
import '../../core/services/respository.dart';
import '../../core/services/shared_preferences.dart';
import '../../locator.dart';
import '../shared/routes.dart';

class SignUpViewModel extends MultipleFutureViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final SharedPrefs _sharedPrefs = locator<SharedPrefs>();
  final NavigationService _navigationService = locator<NavigationService>();

  final Respository _respository = locator<Respository>();
  Future signUp({
    required String password,
    required String firstName,
    required String lastName,
    required String email,
    required DateTime? dob,
    required String phone,
    required String cadre,
    required String region,
    required String gender,
    required String district,
    required String subDistrict,
    required String community,
    required String facility,
    String? profilePicture,
  }) async {
    var result = await runBusyFuture(_authenticationService.handleSignUp(
      email: email,
      password: password,
    ));
    if (result is UserCredential) {
      var userId = result.user?.uid;
      Map<String, dynamic> data = {};
      data['userId'] = userId;
      data['firstName'] = firstName;
      data['lastName'] = lastName;
      data['email'] = email;

      data['dob'] = dob;
      data['phone'] = phone;
      data['cadre'] = cadre;
      data['region'] = region;
      data['gender'] = gender;
      data['district'] = district;
      data['subDistrict'] = subDistrict;
      data['community'] = community;
      data['facility'] = facility;
      data['dateJoined'] = DateTime.now();
      data['appRegisteredOn'] = 'FHMApp';
      data['profilePicture'] = profilePicture;
      data['userType'] = 'notSet';
      data['fhmappAdminFor'] = [];

      _respository.setUserDetails(data).then((user) {
        addLoggedinDevice(user);
        _sharedPrefs.setLocalUserData(user);
        _respository.userOnlineState(email: email, online: true);
        _navigationService.navigateTo(Routes.navigation);
      });
    } else {
      print('Error in registration');
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
