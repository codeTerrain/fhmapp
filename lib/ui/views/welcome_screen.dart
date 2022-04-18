import 'dart:async';

import 'package:fhmapp/ui/shared/spacing.dart';
import 'package:fhmapp/ui/shared/style.dart';
import 'package:fhmapp/ui/views/onboarding.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

import '../widgets/misc.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          Center(
            child: Stack(alignment: Alignment.center, children: [
              Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          'assets/images/general/welcome.png',
                        ),
                        fit: BoxFit.cover)),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  CircleAvatar(
                    backgroundColor: kWhite,
                    radius: 60,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Image.asset(
                        'assets/images/logos/ghs_logo.png',
                      ),
                    ),
                  ),
                  UiSpacing.verticalSpacingSmall(),
                  const SizedBox(width: 100, child: LogoAnimate())
                ],
              ),
              Positioned(
                bottom: -520,
                child: CircleAvatar(
                  radius: UiSpacing.screenSize(context).width / 1.3,
                  backgroundColor: secondary1,
                ),
              ),
              Positioned(
                bottom: 30,
                child: SizedBox(
                  width: UiSpacing.screenSize(context).width / 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/images/logos/waho.png',
                      ),
                      Image.asset('assets/images/logos/ukaid.png'),
                      Image.asset('assets/images/logos/palladium.png')
                    ],
                  ),
                ),
              )
            ]),
          ),
          const Onboarding()
        ],
      ),
    );
  }
}

class LogoAnimate extends StatefulWidget {
  const LogoAnimate({Key? key}) : super(key: key);

  @override
  State<LogoAnimate> createState() => _LogoAnimateState();
}

class _LogoAnimateState extends State<LogoAnimate>
    with SingleTickerProviderStateMixin {
  late FlipCardController flipCardController;
  late Timer _timer;

  @override
  void initState() {
    flipCardController = FlipCardController();
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      flipCardController.toggleCard();

      /// push onboarding screen after 340 seconds
      if (timer.tick == 340) {
        Navigator.of(context).push(createRoute(page: const Onboarding()));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      controller: flipCardController,
      direction: FlipDirection.VERTICAL,
      flipOnTouch: false,
      front: Image.asset(
        'assets/images/logos/fhmapp_front.png',
      ),
      back: Image.asset(
        'assets/images/logos/fhmapp_mirror.png',
      ),
    );
  }
}
