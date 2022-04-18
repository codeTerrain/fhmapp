import 'package:fhmapp/ui/shared/style.dart';
import 'package:fhmapp/ui/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../shared/routes.dart';
import '../widgets/misc.dart';
import 'Login.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pushNamed(Routes.login);
  }

  Widget _buildImage(String assetName, [double width = 300]) {
    return Image.asset('assets/images/onboarding/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(
          color: primaryColor, fontSize: 30.0, fontWeight: FontWeight.w900),
      bodyTextStyle: TextStyle(
          color: primaryColor, fontSize: 25.0, fontWeight: FontWeight.w700),
      imagePadding: EdgeInsets.zero,
      bodyFlex: 3,
      imageFlex: 4,
      bodyAlignment: Alignment.topCenter,
      imageAlignment: Alignment.bottomCenter,
    );

    return Scaffold(
      body: IntroductionScreen(
        key: introKey,
        globalHeader: Align(
          alignment: Alignment.topRight,
          child: SafeArea(
            child: Padding(
                padding: const EdgeInsets.only(top: 16, right: 16),
                child: SizedBox(
                    width: 97,
                    height: 40,
                    child: RoundedButtonTheme(
                        text: 'Skip',
                        onPressed: () => Navigator.of(context)
                            .push(createRoute(page: Login()))))),
          ),
        ),
        pages: [
          PageViewModel(
            title: "Your reproductive health, our concern",
            body: '',
            image: _buildImage('contraception.png'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Your baby's health, our concern",
            body: " ",
            image: _buildImage('maternal.png'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Good Food, Good Health",
            body: "Your Health, Our concern",
            decoration: pageDecoration,
            image: _buildImage('nutrition.png'),
          ),
        ],
        onDone: () => _onIntroEnd(context),
        next: Image.asset(
          'assets/images/onboarding/next.png',
          scale: 3,
        ),
        back: Image.asset(
          'assets/images/onboarding/back.png',
          scale: 3,
        ),
        doneStyle: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(33.0),
          )),
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return secondary1;
            }
            return primaryColor;
          }),
        ),
        done: const Text('Get Started',
            style: TextStyle(
              color: kWhite,
            )),
        curve: Curves.fastLinearToSlowEaseIn,
        controlsMargin: const EdgeInsets.all(0),
        dotsDecorator: const DotsDecorator(
          shape: RoundedRectangleBorder(
              side: BorderSide(color: primaryColor),
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
          spacing: EdgeInsets.only(bottom: 170, right: 6),
          size: Size(12.0, 12.0),
          color: kWhite,
          activeSize: Size(22.0, 10.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
        showBackButton: true,
      ),
    );
  }
}
