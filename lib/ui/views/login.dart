import 'package:fhmapp/ui/shared/spacing.dart';
import 'package:fhmapp/ui/shared/style.dart';
import 'package:fhmapp/ui/widgets/custom_textfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../shared/routes.dart';
import '../widgets/buttons.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kWhite,
        body: SignBuilder(
          mainTitle: 'FHMApp Login',
          subTitle: 'The division\'s complete solution',
          widget: [
            CustomTextField(
              width: UiSpacing.screenSize(context).width,
              controller: controller,
              hintText: 'E-mail address',
              prefixIcon: Image.asset('assets/images/login/user.png'),
            ),
            UiSpacing.verticalSpacingSmall(),
            CustomTextField(
              width: UiSpacing.screenSize(context).width,
              controller: controller,
              hintText: 'Password',
              prefixIcon: Image.asset('assets/images/login/password.png'),
            ),
          ],
        ));
  }
}

class SignBuilder extends StatelessWidget {
  final String mainTitle;
  final String subTitle;
  final List<Widget>? widget;

  const SignBuilder(
      {Key? key, required this.mainTitle, required this.subTitle, this.widget})
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
              SafeArea(
                child: Padding(
                    padding: const EdgeInsets.only(top: 80, right: 16),
                    child: Image.asset(
                      'assets/images/logos/ghs_logo.png',
                      scale: 3,
                    )),
              ),
              UiSpacing.verticalSpacingLarge(),
              Text(
                mainTitle,
                style: Theme.of(context).textTheme.headline1,
              ),
              UiSpacing.verticalSpacingTiny(),
              descriptiveText(
                context,
                subTitle,
              ),
              UiSpacing.verticalSpacingLarge(),
              ...?widget,

              UiSpacing.verticalSpacingSmall(),
              descriptiveText(
                context,
                'Forgotten Password',
              ),
              UiSpacing.verticalSpacingSmall(),

              RichText(
                text: TextSpan(
                  text: 'Don\'t have an account?  ',
                  style: Theme.of(context).textTheme.bodyText1,
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Sign up',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: primaryColor),
                      recognizer: TapGestureRecognizer()
                        ..onTap =
                            () => Navigator.pushNamed(context, Routes.signup),
                    ),
                  ],
                ),
              ),

              UiSpacing.verticalSpacingLarge(),
              //  const Spacer(),
              Center(
                child: RoundedButtonTheme(
                  width: 100,
                  text: 'Login',
                  buttonColor: kBlack,
                  onPressed: () =>
                      Navigator.pushNamed(context, Routes.navigation),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
