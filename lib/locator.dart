import 'package:fhmapp/core/services/resource_download_service.dart';
import 'package:get_it/get_it.dart';

import 'core/services/authentication_service.dart';
import 'core/services/navigation_service.dart';
import 'core/services/dialog_service.dart';
import 'core/services/respository.dart';
import 'core/services/shared_preferences.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => Respository());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => SharedPrefs());
  locator.registerLazySingleton(() => ResourceService());
}
