import 'package:fhmapp/ui/shared/spacing.dart';
import 'package:fhmapp/ui/shared/style.dart';
import 'package:fhmapp/ui/shared/validator.dart';
import 'package:fhmapp/ui/widgets/custom_textfield.dart';
import 'package:fhmapp/ui/widgets/misc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../shared/routes.dart';
import '../viewmodels/login_view_model.dart';
import '../widgets/buttons.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kWhite,
        body: Form(
            key: _formKey,
            child: SignBuilder(
              mainTitle: 'FHMApp Login',
              subTitle: 'The division\'s complete solution',
              widget: [
                CustomTextField(
                  width: UiSpacing.screenSize(context).width,
                  controller: loginEmailController,
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'E-mail address',
                  prefixIcon: Image.asset('assets/images/login/user.png'),
                  validator: (input) => Validator.isValidEmail(input),
                ),
                UiSpacing.verticalSpacingSmall(),
                CustomTextField(
                  width: UiSpacing.screenSize(context).width,
                  controller: loginPasswordController,
                  hintText: 'Password',
                  obscureText: true,
                  prefixIcon: Image.asset('assets/images/login/password.png'),
                  validator: (input) => Validator.isValidPassword(input),
                ),
              ],
              button: Center(
                child: ViewModelBuilder<LoginViewModel>.reactive(
                  viewModelBuilder: () => LoginViewModel(),
                  builder: (context, model, child) => RoundedButtonTheme(
                    width: model.isBusy ? 130 : 100,
                    text: model.isBusy ? 'Please wait' : 'Login',
                    buttonColor: kBlack,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState?.save();
                        FocusScope.of(context).requestFocus(FocusNode());

                        // setState(() {
                        //   _isSaving = true;
                        // });

                        // model.isBusy?
                        model.login(
                            email:
                                loginEmailController.text.toLowerCase().trim(),
                            password: loginPasswordController.text.trim());
                        //  _isSaving = false;
                      }
                    },
                  ),
                ),
              ),
            )));
  }
}

class SignBuilder extends StatelessWidget {
  final String mainTitle;
  final String subTitle;
  final List<Widget>? widget;
  final Widget button;

  const SignBuilder(
      {Key? key,
      required this.mainTitle,
      required this.subTitle,
      this.widget,
      required this.button})
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
      physics: scrollPhysics,
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
              button,
            ],
          ),
        ),
      ),
    );
  }
}
