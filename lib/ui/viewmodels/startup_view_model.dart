import 'package:fhmapp/core/services/authentication_service.dart';
import 'package:fhmapp/core/services/navigation_service.dart';
import 'package:fhmapp/ui/shared/routes.dart';
import 'package:stacked/stacked.dart';

import '../../locator.dart';

class StartUpViewModel extends BaseViewModel {
  final NavigationService navigationService = locator<NavigationService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  hasLogin() async {
    if (await _authenticationService.isLogin() == true) {
      navigationService.navigateTo(Routes.navigation);
    } else {
      navigationService.navigateTo(Routes.welcome);
    }
  }
}
