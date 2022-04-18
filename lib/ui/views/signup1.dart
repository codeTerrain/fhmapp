import 'dart:math';

import 'package:fhmapp/ui/shared/spacing.dart';
import 'package:fhmapp/ui/shared/style.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../shared/routes.dart';
import '../widgets/buttons.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/dots.dart';
import '../widgets/dots_decor.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  int currentStep = 0;
  late PageController _pageController;
  final TextEditingController controller = TextEditingController();
  PageController get pageController => _pageController;

  @override
  void initState() {
    super.initState();
    int initialPage = min(currentStep, 2);
    //_currentPage = initialPage.toDouble();
    _pageController = PageController(initialPage: initialPage);
  }

  @override
  Widget build(BuildContext context) {
    // Future<void> animateScroll(int page) async {
    //   setState(() => _isScrolling = true);
    //   await _pageController.animateToPage(
    //     max(min(page, 2), 0),
    //     duration: const Duration(milliseconds: 3),
    //     curve: Curves.easeIn,
    //   );
    //   if (mounted) {
    //     setState(() => _isScrolling = false);
    //   }
    // }

    List<Step> getSteps() => [
          Step(
              state: StepState.indexed,
              isActive: currentStep >= 0,
              title: const Text('Personal'),
              content: SignBuilder(
                currentPage: currentStep.ceilToDouble(),
                mainTitle: 'STEP 1',
                subTitle: 'Personal Information',
                widget: [
                  CustomTextField(
                    width: UiSpacing.screenSize(context).width,
                    controller: controller,
                    hintText: 'First Name',
                  ),
                  UiSpacing.verticalSpacingSmall(),
                  CustomTextField(
                    width: UiSpacing.screenSize(context).width,
                    controller: controller,
                    hintText: 'Last Name',
                  ),
                  UiSpacing.verticalSpacingSmall(),
                  CustomTextField(
                    width: UiSpacing.screenSize(context).width,
                    controller: controller,
                    hintText: 'E-mail',
                  ),
                  UiSpacing.verticalSpacingSmall(),
                  CustomTextField(
                    width: UiSpacing.screenSize(context).width,
                    controller: controller,
                    hintText: 'Password',
                  ),
                ],
                richText: [
                  RichText(
                    text: TextSpan(
                      text: 'Already have an account?  ',
                      style: Theme.of(context).textTheme.bodyText1,
                      children: <TextSpan>[
                        TextSpan(
                          text: 'LogIn',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: primaryColor),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () =>
                                Navigator.pushNamed(context, Routes.login),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
          Step(
              state: StepState.indexed,
              isActive: currentStep >= 1,
              title: const Text('Demographics'),
              content: SignBuilder(
                currentPage: currentStep.ceilToDouble(),
                mainTitle: 'STEP 2',
                subTitle: 'Demographics',
                widget: [
                  CustomTextField(
                    width: UiSpacing.screenSize(context).width,
                    controller: controller,
                    hintText: 'Region',
                  ),
                  UiSpacing.verticalSpacingSmall(),
                  CustomTextField(
                    width: UiSpacing.screenSize(context).width,
                    controller: controller,
                    hintText: 'District',
                  ),
                  UiSpacing.verticalSpacingSmall(),
                  CustomTextField(
                    width: UiSpacing.screenSize(context).width,
                    controller: controller,
                    hintText: 'Sub-District',
                  ),
                  UiSpacing.verticalSpacingSmall(),
                ],
              )),
          Step(
            state: StepState.complete,
            isActive: currentStep >= 2,
            title: const Text('Work Information'),
            content: SignBuilder(
              currentPage: currentStep.ceilToDouble(),
              mainTitle: 'STEP 3',
              subTitle: 'Work Information',
              widget: [
                CustomTextField(
                  width: UiSpacing.screenSize(context).width,
                  controller: controller,
                  hintText: 'Cadre',
                ),
                UiSpacing.verticalSpacingSmall(),
                CustomTextField(
                  width: UiSpacing.screenSize(context).width,
                  controller: controller,
                  hintText: 'Facility',
                ),
                UiSpacing.verticalSpacingSmall(),
              ],
              richText: [
                RichText(
                  text: TextSpan(
                    text: 'By signing up, you agree to the ',
                    style: Theme.of(context).textTheme.bodyText1,
                    children: <TextSpan>[
                      TextSpan(
                        text: 'terms\n and conditions ',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: primaryColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap =
                              () => Navigator.pushNamed(context, Routes.login),
                      ),
                      TextSpan(
                        text: 'of this app',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ];
    return Scaffold(
      backgroundColor: kWhite,
      body: Stack(
        children: [
          Stepper(
            type: StepperType.horizontal,
            currentStep: currentStep,
            controlsBuilder: (BuildContext context, ControlsDetails details) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  currentStep != 0
                      ? IconButton(
                          onPressed: details.onStepCancel,
                          icon: Image.asset(
                            'assets/images/onboarding/back.png',
                            color: kBlack,
                            scale: 3,
                          ),
                        )
                      : const SizedBox(),
                  RoundedButtonTheme(
                    width: 100,
                    text: currentStep != 2 ? 'Next' : 'Register',
                    buttonColor: kBlack,
                    onPressed: details.onStepContinue,
                  ),
                ],
              );
            },
            onStepContinue: () {
              final isLastStep = currentStep == getSteps().length - 1;
              if (isLastStep) {
                // print('Completed');
              } else {
                setState(() => currentStep += 1);
              }
            },
            onStepCancel: () =>
                currentStep == 0 ? null : setState(() => currentStep -= 1),
            steps: getSteps(),
          ),
          SafeArea(
            child: Container(
              height: 60,
              width: UiSpacing.screenSize(context).width,
              color: kWhite,
            ),
          ),
        ],
      ),
    );
  }
}

class SignBuilder extends StatelessWidget {
  final String mainTitle;
  final String subTitle;
  final double currentPage;
  final List<Widget>? widget;
  final List<RichText>? richText;

  const SignBuilder(
      {Key? key,
      required this.currentPage,
      required this.mainTitle,
      required this.subTitle,
      this.richText,
      this.widget})
      : super(key: key);
  Text descriptiveText(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyText1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: SizedBox(
          width: UiSpacing.screenSize(context).width / 1.15,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/logos/ghs_logo.png',
                scale: 3,
              ),
              UiSpacing.verticalSpacingLarge(),
              Text(
                mainTitle,
                style: Theme.of(context).textTheme.headline1,
              ),
              UiSpacing.verticalSpacingTiny(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  descriptiveText(
                    context,
                    subTitle,
                  ),
                  Semantics(
                    label: "Page ${currentPage.round() + 1} of 3",
                    excludeSemantics: true,
                    child: DotsIndicator(
                      // reversed: widget.rtl,
                      dotsCount: 3,
                      position: currentPage,
                      //onTap: (pos) => animateScroll(pos.toInt()) ,
                      decorator: const DotsDecorator(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0))),
                        //  colors: [primaryColor],
                        spacing: EdgeInsets.only(bottom: 0, right: 6),
                        size: Size(15.0, 12.0),
                        color: kWhite,
                        activeSize: Size(22.0, 10.0),
                        activeShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              UiSpacing.verticalSpacingMedium(),
              ...?widget,

              UiSpacing.verticalSpacingSmall(),

              ...?richText,

              UiSpacing.verticalSpacingLarge(),
              //  const Spacer(),
              // const Center(
              //   child: RoundedButtonTheme(
              //     width: 80,
              //     text: 'Login',
              //     buttonColor: kBlack,
              //     onPressed: null,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
