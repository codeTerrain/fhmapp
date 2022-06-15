import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:fluttertoast/fluttertoast.dart';
import '../../core/services/utilities.dart';
import '../shared/dropper.dart';
import '../shared/routes.dart';
import '../shared/spacing.dart';
import '../shared/static_lists.dart';
import '../shared/style.dart';
import '../shared/validator.dart';
import '../viewmodels/signup_view_model.dart';
import '../widgets/buttons.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/dots.dart';
import '../widgets/drop_down.dart';
import '../widgets/misc.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? gender;
  String? region;
  String district = 'Select District';
  bool showDistrict = false;
  String? birthDateInString;
  DateTime? birthDate;
  bool isDateSelected = false;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _subDistrictController = TextEditingController();
  final TextEditingController _facilityController = TextEditingController();
  final TextEditingController _communityController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _cadreController = TextEditingController();
  final PageController pageController = PageController(initialPage: 0);

  Text descriptiveText(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyText1,
    );
  }

  List<Widget> fields(int index, String? oldRegion) {
    List<List<Widget>> stepList = [
      [
        CustomTextField(
          width: UiSpacing.screenSize(context).width,
          controller: _firstNameController,
          hintText: 'First Name',
          prefixIcon: Image.asset('assets/images/login/user.png'),
          validator: (input) => Validator.validField(input, 'first Name'),
        ),
        UiSpacing.verticalSpacingSmall(),
        CustomTextField(
          width: UiSpacing.screenSize(context).width,
          controller: _lastNameController,
          hintText: 'Last Name',
          prefixIcon: Image.asset('assets/images/login/user.png'),
          validator: (input) => Validator.validField(input, 'last name'),
        ),
        UiSpacing.verticalSpacingSmall(),
        CustomDropDown(
          context,
          dropItems: Dropper.gender,
          hintText: 'Gender',
          prefixIcon: Image.asset('assets/images/login/user.png'),
          value: gender,
          onChanged: (String? newValue) {
            setState(() {
              gender = newValue!;
            });
          },
        ),
        UiSpacing.verticalSpacingSmall(),
        CustomTextField(
          width: UiSpacing.screenSize(context).width,
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          hintText: 'Phone',
          prefixIcon: phoneIcon,
          validator: (input) => Validator.validField(input, 'phone number'),
        ),
        UiSpacing.verticalSpacingSmall(),
      ],
      [
        CustomTextField(
          width: UiSpacing.screenSize(context).width,
          controller: _emailController,
          hintText: 'E-mail',
          prefixIcon: Image.asset('assets/images/login/email.png'),
          validator: (input) => Validator.isValidEmail(input),
        ),
        UiSpacing.verticalSpacingSmall(),
        CustomTextField(
          width: UiSpacing.screenSize(context).width,
          controller: _passwordController,
          hintText: 'Password',
          obscureText: true,
          prefixIcon: Image.asset('assets/images/login/password.png'),
          validator: (input) => Validator.isValidPassword(input),
        ),
        UiSpacing.verticalSpacingSmall(),
        CustomTextField(
          width: UiSpacing.screenSize(context).width,
          controller: _confirmPasswordController,
          hintText: 'Confirm Password',
          prefixIcon: Image.asset('assets/images/login/password.png'),
          obscureText: true,
          validator: (input) => Validator.isValidPassword(input),
        ),
      ],
      [
        CustomDropDown(
          context,
          dropItems: Dropper.regions.keys.toList(),
          hintText: 'Region',
          prefixIcon: Image.asset('assets/images/login/region.png'),
          value: region,
          onChanged: (String? newValue) {
            setState(() {
              region = newValue!;
              // set default district based on region selection
              if (region != oldRegion) {
                district = 'Select District';
                oldRegion = region;
              }
              if (Dropper.regions[region]!.isEmpty) {
                showDistrict = true;
              } else if (Dropper.regions[region]!.isNotEmpty) {
                showDistrict = false;
              }
            });
          },
        ),
        UiSpacing.verticalSpacingSmall(),
        CustomDropDown(
          context,
          dropItems: region == null
              ? Dropper.regions['Select Region']!.toList()
              : Dropper.regions[region]!.toList(),
          hintText: 'District',
          prefixIcon: Image.asset('assets/images/login/district.png'),
          value: district,
          onChanged: (String? newValue) {
            setState(() {
              district = newValue!;
            });
          },
        ),
        UiSpacing.verticalSpacingSmall(),
        CustomTextField(
          width: UiSpacing.screenSize(context).width,
          controller: _subDistrictController,
          hintText: 'Sub-District',
          prefixIcon: Image.asset('assets/images/login/subDistrict.png'),
          validator: (input) => Validator.validField(input, 'sub-district'),
        ),
        UiSpacing.verticalSpacingSmall(),
        CustomTextField(
          width: UiSpacing.screenSize(context).width,
          controller: _communityController,
          hintText: 'Community',
          prefixIcon: Image.asset('assets/images/login/subDistrict.png'),
          validator: (input) => Validator.validField(input, 'community'),
        ),
        UiSpacing.verticalSpacingSmall(),
        dobSelector(
            context: context,
            hintText: birthDateInString ?? 'Date of Birth',
            onTap: () async {
              final datePick = await datePicker(context);
              if (datePick != null && datePick != birthDate) {
                setState(() {
                  birthDate = datePick;
                  isDateSelected = true;

                  birthDateInString =
                      "${birthDate?.month}/${birthDate?.day}/${birthDate?.year}";
                  _dobController.text = birthDateInString ?? '';
                });
              }
            },
            controller: _dobController),
      ],
      [
        CustomTextField(
          width: UiSpacing.screenSize(context).width,
          controller: _cadreController,
          hintText: 'Cadre',
          prefixIcon: Image.asset('assets/images/login/cadre.png'),
          validator: (input) => Validator.validField(input, 'cadre'),
        ),
        UiSpacing.verticalSpacingSmall(),
        CustomTextField(
          width: UiSpacing.screenSize(context).width,
          controller: _facilityController,
          hintText: 'Facility',
          prefixIcon: Image.asset('assets/images/login/facility.png'),
          validator: (input) => Validator.validField(input, 'facility'),
        ),
        UiSpacing.verticalSpacingSmall(),
      ],
    ];

    return stepList[index];
  }

  late List<GlobalKey<FormState>> formKeys;
  @override
  void initState() {
    formKeys = List<GlobalKey<FormState>>.generate(4, (counter) {
      GlobalKey<FormState> counter = GlobalKey<FormState>();
      return counter;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? oldRegion = region;

    return Scaffold(
      backgroundColor: kWhite,
      body: SizedBox(
        height: UiSpacing.screenSize(context).height,
        child: PageView.builder(
            physics: scrollPhysics,
            controller: pageController,
            itemCount: 4,
            itemBuilder: (context, index) {
              double currentPage = index.toDouble();

              return SingleChildScrollView(
                //physics: scrollPhysics,
                child: Center(
                  child: SizedBox(
                    width: UiSpacing.screenSize(context).width / 1.15,
                    child: Form(
                      key: formKeys[index],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SafeArea(
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 80, right: 16),
                                child: Image.asset(
                                  'assets/images/logos/ghs_logo.png',
                                  scale: 3,
                                )),
                          ),
                          UiSpacing.verticalSpacingLarge(),
                          Text(
                            'STEP ${index + 1}',
                            style: Theme.of(context).textTheme.headline1,
                          ),
                          UiSpacing.verticalSpacingTiny(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              descriptiveText(
                                context,
                                subtitle[index],
                              ),
                              Dots(
                                currentPage: index.toDouble(),
                                pageController: pageController,
                                formKey: formKeys[index],
                              )
                            ],
                          ),
                          UiSpacing.verticalSpacingLarge(),
                          ...fields(index, oldRegion),
                          TrailingWidget(
                            context: context,
                            index: index,
                          ),
                          UiSpacing.verticalSpacingLarge(),
                          //const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              currentPage != 0
                                  ? IconButton(
                                      onPressed: () =>
                                          pageController.previousPage(
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              curve: Curves.easeOut),
                                      icon: Image.asset(
                                        'assets/images/onboarding/back.png',
                                        color: kBlack,
                                        scale: 3,
                                      ),
                                    )
                                  : const SizedBox(),
                              ViewModelBuilder<SignUpViewModel>.reactive(
                                viewModelBuilder: () => SignUpViewModel(),
                                builder: (context, model, child) =>
                                    RoundedButtonTheme(
                                  width: model.isBusy ? 130 : 100,
                                  text: currentPage != 3
                                      ? 'Next'
                                      : (model.isBusy
                                          ? 'Please wait'
                                          : 'Register'),
                                  buttonColor: kBlack,
                                  onPressed: () {
                                    if (formKeys[index]
                                        .currentState!
                                        .validate()) {
                                      formKeys[index].currentState?.save();

                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      if (currentPage == 3) {
                                        if (_confirmPasswordController.text !=
                                            _passwordController.text) {
                                          Fluttertoast.showToast(
                                            msg:
                                                "Password mismatch. Kindly crosscheck both fields.",
                                            gravity: ToastGravity.CENTER,
                                          );
                                          return pageController.animateToPage(1,
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              curve: Curves.easeOut);
                                        }
                                        if (_passwordController.text.isEmpty ||
                                            _passwordController.text.length <
                                                8) {
                                          Fluttertoast.showToast(
                                            msg:
                                                "Kindly input a password with at least 8 characters",
                                            gravity: ToastGravity.CENTER,
                                          );
                                          return pageController.animateToPage(1,
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              curve: Curves.easeOut);
                                        }

                                        if (gender == null ||
                                            _firstNameController.text == '' ||
                                            _lastNameController.text == '' ||
                                            _phoneController.text == '') {
                                          Fluttertoast.showToast(
                                            msg:
                                                "Fill out all fields in STEP 1",
                                            gravity: ToastGravity.CENTER,
                                          );
                                          return pageController.animateToPage(0,
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              curve: Curves.easeOut);
                                        }

                                        if (_emailController.text == '' ||
                                            Validator.isValidEmail(
                                                    _emailController.text) !=
                                                null) {
                                          Fluttertoast.showToast(
                                            msg: "Enter a valid email",
                                            gravity: ToastGravity.CENTER,
                                          );
                                          return pageController.animateToPage(1,
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              curve: Curves.easeOut);
                                        }
                                        if (region == null ||
                                            region == 'Select Region' ||
                                            district == 'Select District' ||
                                            _subDistrictController.text == '' ||
                                            _communityController.text == '' ||
                                            birthDate == null) {
                                          Fluttertoast.showToast(
                                            msg:
                                                "Fill out all fields in STEP 3",
                                            gravity: ToastGravity.CENTER,
                                          );
                                          return pageController.animateToPage(2,
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              curve: Curves.easeOut);
                                        }
                                        if (_cadreController.text == '' ||
                                            _facilityController.text == '') {
                                          Fluttertoast.showToast(
                                            msg:
                                                "Fill out all fields in STEP 4",
                                            gravity: ToastGravity.CENTER,
                                          );
                                          return pageController.animateToPage(3,
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              curve: Curves.easeOut);
                                        }

                                        model.signUp(
                                            email: _emailController.text
                                                .toLowerCase()
                                                .trim(),
                                            password:
                                                _passwordController.text.trim(),
                                            dob: birthDate,
                                            firstName:
                                                _firstNameController.text,
                                            gender: gender!,
                                            lastName: _lastNameController.text,
                                            phone: _phoneController.text,
                                            cadre: _cadreController.text,
                                            community:
                                                _communityController.text,
                                            district: district,
                                            facility: _facilityController.text,
                                            region: region!,
                                            subDistrict:
                                                _subDistrictController.text);
                                      }

                                      return pageController.nextPage(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          curve: Curves.easeOut);
                                    }
                                  },
                                ),
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
            }),
      ),
    );
  }
}

class TrailingWidget extends StatelessWidget {
  final BuildContext context;
  final int index;
  const TrailingWidget({Key? key, required this.context, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
