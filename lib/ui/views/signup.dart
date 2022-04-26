import 'package:fhmapp/ui/widgets/misc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../core/services/utilities.dart';
import '../shared/Routes.dart';
import '../shared/spacing.dart';
import '../shared/static_lists.dart';
import '../shared/style.dart';
import '../shared/validator.dart';
import '../widgets/buttons.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/dots.dart';

class SignUp extends StatelessWidget {
  SignUp({Key? key}) : super(key: key);

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _subDistrictController = TextEditingController();
  final TextEditingController _facilityController = TextEditingController();
  final TextEditingController _communityController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _cadreController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final PageController pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kWhite,
        body: SizedBox(
          height: UiSpacing.screenSize(context).height,
          child: PageView.builder(
              controller: pageController,
              itemCount: 4,
              itemBuilder: (context, index) => SignBuilder(
                    formKey: formKey,
                    pageController: pageController,
                    currentPage: index.toDouble(),
                    mainTitle: 'STEP ${index + 1}',
                    subTitle: subtitle[index],
                    widget: fields(context, index,
                        cadreController: _cadreController,
                        communityController: _communityController,
                        confirmPasswordController: _confirmPasswordController,
                        districtController: _districtController,
                        dobController: _dobController,
                        emailController: _emailController,
                        facilityController: _facilityController,
                        firstNameController: _firstNameController,
                        lastNameController: _lastNameController,
                        passwordController: _passwordController,
                        phoneController: _phoneController,
                        subDistrictController: _subDistrictController),
                    trailingWidget: trailingWidget(context, index),
                  )),
        ));
  }
}

class SignBuilder extends StatelessWidget {
  final String mainTitle;
  final String subTitle;
  final List<Widget>? widget;
  final Widget trailingWidget;
  final double currentPage;
  final PageController pageController;
  final GlobalKey<FormState> formKey;

  const SignBuilder(
      {Key? key,
      required this.mainTitle,
      required this.subTitle,
      required this.formKey,
      required this.currentPage,
      required this.pageController,
      this.widget,
      required this.trailingWidget})
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
          //height: UiSpacing.screenSize(context).height,
          child: Form(
            key: formKey,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    descriptiveText(
                      context,
                      subTitle,
                    ),
                    Dots(
                      currentPage: currentPage,
                      pageController: pageController,
                    )
                  ],
                ),
                UiSpacing.verticalSpacingLarge(),
                ...?widget,
                UiSpacing.verticalSpacingSmall(),
                trailingWidget,
                UiSpacing.verticalSpacingLarge(),
                //const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    currentPage != 0
                        ? IconButton(
                            onPressed: () => pageController.previousPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeOut),
                            icon: Image.asset(
                              'assets/images/onboarding/back.png',
                              color: kBlack,
                              scale: 3,
                            ),
                          )
                        : const SizedBox(),
                    RoundedButtonTheme(
                      width: 100,
                      text: currentPage != 3 ? 'Next' : 'Register',
                      buttonColor: kBlack,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState?.save();

                          FocusScope.of(context).requestFocus(FocusNode());
                          return pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeOut);
                        }
                      },
                    ),
                  ],
                ),
                UiSpacing.verticalSpacingLarge(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget trailingWidget(BuildContext context, index) {
  List<Widget> widgets = [
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
              ..onTap = () => Navigator.pushNamed(context, Routes.login),
          ),
        ],
      ),
    ),
    const SizedBox(),
    const SizedBox(),
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
              ..onTap = () => Utilities.tAndC(context),
          ),
          TextSpan(
            text: 'of this app',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    ),
  ];
  return widgets[index];
}

List<Widget> fields(BuildContext context, index,
    {required TextEditingController firstNameController,
    required TextEditingController lastNameController,
    required TextEditingController dobController,
    required TextEditingController emailController,
    required TextEditingController phoneController,
    required TextEditingController passwordController,
    required TextEditingController districtController,
    required TextEditingController subDistrictController,
    required TextEditingController facilityController,
    required TextEditingController cadreController,
    required TextEditingController communityController,
    required TextEditingController confirmPasswordController}) {
  List<List<Widget>> stepList = [
    [
      CustomTextField(
        width: UiSpacing.screenSize(context).width,
        controller: firstNameController,
        hintText: 'First Name',
        prefixIcon: Image.asset('assets/images/login/user.png'),
      ),
      UiSpacing.verticalSpacingSmall(),
      CustomTextField(
        width: UiSpacing.screenSize(context).width,
        controller: lastNameController,
        hintText: 'Last Name',
        prefixIcon: Image.asset('assets/images/login/user.png'),
      ),
      UiSpacing.verticalSpacingSmall(),
      CustomTextField(
        width: UiSpacing.screenSize(context).width,
        controller: phoneController,
        hintText: 'Gender',
        prefixIcon: Image.asset('assets/images/login/email.png'),
        validator: (input) => Validator.isValidEmail(input),
      ),
      UiSpacing.verticalSpacingSmall(),
      CustomTextField(
        width: UiSpacing.screenSize(context).width,
        controller: emailController,
        hintText: 'Phone',
        prefixIcon: Image.asset('assets/images/login/email.png'),
        validator: (input) => Validator.isValidEmail(input),
      ),
    ],
    [
      CustomTextField(
        width: UiSpacing.screenSize(context).width,
        controller: emailController,
        hintText: 'E-mail',
        prefixIcon: Image.asset('assets/images/login/email.png'),
        validator: (input) => Validator.isValidEmail(input),
      ),
      UiSpacing.verticalSpacingSmall(),
      CustomTextField(
        width: UiSpacing.screenSize(context).width,
        controller: passwordController,
        hintText: 'Password',
        obscureText: true,
        prefixIcon: Image.asset('assets/images/login/password.png'),
        validator: (input) => Validator.isValidPassword(input),
      ),
      UiSpacing.verticalSpacingSmall(),
      CustomTextField(
        width: UiSpacing.screenSize(context).width,
        controller: confirmPasswordController,
        hintText: 'Confirm Password',
        prefixIcon: Image.asset('assets/images/login/password.png'),
        obscureText: true,
        validator: (input) => Validator.isValidPassword(input),
      ),
    ],
    [
      CustomTextField(
        width: UiSpacing.screenSize(context).width,
        controller: districtController,
        hintText: 'Region',
        prefixIcon: Image.asset('assets/images/login/region.png'),
      ),
      UiSpacing.verticalSpacingSmall(),
      CustomTextField(
        width: UiSpacing.screenSize(context).width,
        controller: districtController,
        hintText: 'District',
        prefixIcon: Image.asset('assets/images/login/district.png'),
      ),
      UiSpacing.verticalSpacingSmall(),
      CustomTextField(
        width: UiSpacing.screenSize(context).width,
        controller: subDistrictController,
        hintText: 'Sub-District',
        prefixIcon: Image.asset('assets/images/login/subDistrict.png'),
      ),
      UiSpacing.verticalSpacingSmall(),
    ],
    [
      CustomTextField(
        width: UiSpacing.screenSize(context).width,
        controller: cadreController,
        hintText: 'Cadre',
        prefixIcon: Image.asset('assets/images/login/cadre.png'),
      ),
      UiSpacing.verticalSpacingSmall(),
      CustomTextField(
        width: UiSpacing.screenSize(context).width,
        controller: facilityController,
        hintText: 'Facility',
        prefixIcon: Image.asset('assets/images/login/facility.png'),
      ),
      UiSpacing.verticalSpacingSmall(),
    ],
  ];

  return stepList[index];
}
