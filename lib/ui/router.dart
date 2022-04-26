import 'package:fhmapp/ui/views/dashboard.dart';
import 'package:flutter/material.dart';

import 'views/login.dart';
import 'views/navigation.dart';
import 'views/onboarding.dart';
import 'views/signup.dart';
import 'views/profile.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/onboarding':
        return MaterialPageRoute(builder: (_) => const Onboarding());

      case '/login':
        return MaterialPageRoute(builder: (_) => const Login());
      case '/signup':
        return MaterialPageRoute(builder: (_) => SignUp());
      case '/dashboard':
        return MaterialPageRoute(builder: (_) => const Dashboard());
      case '/navigation':
        return MaterialPageRoute(builder: (_) => const Navigation());
      case '/profile':
        return MaterialPageRoute(builder: (_) => Profile());

      // case '/sessionInfo':
      //   final args = settings.arguments as SessionInfoArguments;
      //   return MaterialPageRoute(
      //       builder: (_) => SessionInfo(
      //             session: args.session,
      //             batchId: args.batchId,
      //           ));

      default:
        return MaterialPageRoute(
            builder: (_) => const Center(
                  child: Text('Page Not found'),
                ));
    }
  }
}
