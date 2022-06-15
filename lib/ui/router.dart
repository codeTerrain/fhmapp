import 'package:fhmapp/ui/views/school_clinic.dart';
import 'package:flutter/material.dart';

import 'views/create_post.dart';
import 'views/dashboard.dart';
import 'views/events.dart';
import 'views/faqs.dart';
import 'views/login.dart';
import 'views/medical_screening.dart';
import 'views/navigation.dart';
import 'views/onboarding.dart';
import 'views/privacy.dart';
import 'views/profile.dart';
import 'views/security.dart';
import 'views/signup.dart';
import 'views/personal_info.dart';
import 'views/welcome_screen.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/onboarding':
        return MaterialPageRoute(builder: (_) => const Onboarding());

      case '/login':
        return MaterialPageRoute(builder: (_) => const Login());
      case '/signup':
        return MaterialPageRoute(builder: (_) => const SignUp());
      case '/dashboard':
        return MaterialPageRoute(builder: (_) => const Dashboard());
      case '/navigation':
        return MaterialPageRoute(builder: (_) => const Navigation());
      case '/events':
        return MaterialPageRoute(builder: (_) => const Events());
      case '/profile':
        return MaterialPageRoute(builder: (_) => const Profile());
      case '/security':
        return MaterialPageRoute(builder: (_) => Security());
      case '/personal':
        return MaterialPageRoute(builder: (_) => PersonalInfo());
      case '/privacy':
        return MaterialPageRoute(builder: (_) => const Privacy());
      case '/faqs':
        return MaterialPageRoute(builder: (_) => const FAQs());
      case '/schoolClinic':
        return MaterialPageRoute(builder: (_) => const SchoolClinic());
      case '/medicalScreening':
        return MaterialPageRoute(builder: (_) => const MedicalScreening());
      case '/createPost':
        return MaterialPageRoute(builder: (_) => const CreatePost());
      case '/welcome':
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());

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
