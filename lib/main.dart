import 'package:flutter/material.dart';
import 'core/services/dialog_service.dart';
import 'core/services/navigation_service.dart';
import 'locator.dart';

import 'managers/dialog_manager.dart';
import 'ui/router.dart';
import 'ui/shared/theme.dart';
import 'ui/views/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await windowManager.show();
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) => Navigator(
        key: locator<DialogService>().dialogNavigationKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (context) => DialogManager(child: child)),
      ),
      title: 'FHMApp',
      theme: themeData,
      navigatorKey: locator<NavigationService>().navigationKey,
      home: const WelcomeScreen(),
      onGenerateRoute: Routers.generateRoute,
    );
  }
}
