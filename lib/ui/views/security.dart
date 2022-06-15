import 'package:fhmapp/ui/shared/spacing.dart';
import 'package:fhmapp/ui/widgets/appbars.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked/stacked.dart';
import '../shared/validator.dart';
import '../viewmodels/elearning_view_model.dart';
import '../viewmodels/user_action_model.dart';
import '../widgets/change_info.dart';
import '../widgets/misc.dart';
import '../widgets/neumorph_textfield.dart';

class Security extends StatelessWidget {
  Security({Key? key}) : super(key: key);

  final TextEditingController controller = TextEditingController();
  final TextEditingController _mainOldPasswordController =
      TextEditingController();
  final TextEditingController _mainNewPasswordController =
      TextEditingController();
  final TextEditingController _mainConfirmPasswordController =
      TextEditingController();
  final TextEditingController _elearnUsernameController =
      TextEditingController();
  final TextEditingController _elearnNewPasswordController =
      TextEditingController();
  final TextEditingController _elearnOldPasswordController =
      TextEditingController();
  final TextEditingController _elearnConfirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _elearnFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: InfoAppBar(
            title: Hero(
          tag: 'security',
          child: Text(
            'Security',
            style: Theme.of(context).textTheme.headline5,
          ),
        )),
        body: SingleChildScrollView(
          physics: scrollPhysics,
          child: Padding(
            padding: mainPadding,
            child: Column(
              children: [
                UiSpacing.verticalSpacingMedium(),
                Form(
                  key: _passFormKey,
                  child: ChangeInfo(
                    header: 'Password',
                    fields: [
                      UiSpacing.verticalSpacingSmall(),
                      NeumorphTextField(
                        width: UiSpacing.screenSize(context).width,
                        controller: _mainOldPasswordController,
                        hintText: 'Old Password',
                        obscureText: true,
                        prefixIcon:
                            Image.asset('assets/images/login/password.png'),
                        validator: (input) => Validator.isValidPassword(input),
                      ),
                      UiSpacing.verticalSpacingSmall(),
                      NeumorphTextField(
                        width: UiSpacing.screenSize(context).width,
                        controller: _mainNewPasswordController,
                        hintText: 'New Password',
                        obscureText: true,
                        prefixIcon:
                            Image.asset('assets/images/login/password.png'),
                        validator: (input) => Validator.isValidPassword(input),
                      ),
                      UiSpacing.verticalSpacingSmall(),
                      NeumorphTextField(
                        width: UiSpacing.screenSize(context).width,
                        controller: _mainConfirmPasswordController,
                        hintText: 'Confirm New Password',
                        obscureText: true,
                        prefixIcon:
                            Image.asset('assets/images/login/password.png'),
                        validator: (input) => Validator.isValidPassword(input),
                      ),
                      UiSpacing.verticalSpacingSmall(),
                    ],
                    button: ViewModelBuilder<UserActionModel>.reactive(
                      viewModelBuilder: () => UserActionModel(),
                      builder: (context, model, child) => ButtonWrapper(
                        buttonText: model.isBusy ? 'Please wait' : 'Save',
                        onPressed: () {
                          if (_passFormKey.currentState!.validate()) {
                            _passFormKey.currentState?.save();
                            FocusScope.of(context).requestFocus(FocusNode());

                            if (_mainConfirmPasswordController.text !=
                                _mainNewPasswordController.text) {
                              Fluttertoast.showToast(
                                msg:
                                    "Password mismatch. Kindly crosscheck and confirm new password.",
                                gravity: ToastGravity.CENTER,
                              );
                              return;
                            }
                            model.changePassword(context,
                                currentPassword:
                                    _mainOldPasswordController.text,
                                newPassword: _mainNewPasswordController.text);
                          }
                        },
                      ),
                    ),
                  ),
                ),
                UiSpacing.verticalSpacingMedium(),
                Form(
                  key: _elearnFormKey,
                  child: ChangeInfo(
                    header: 'E-Learning Credentials',
                    fields: [
                      UiSpacing.verticalSpacingSmall(),
                      NeumorphTextField(
                        width: UiSpacing.screenSize(context).width,
                        controller: _elearnOldPasswordController,
                        hintText: 'E-learning old Password',
                        obscureText: true,
                        prefixIcon:
                            Image.asset('assets/images/login/password.png'),
                        //  validator: (input) => Validator.isValidPassword(input),
                      ),
                      UiSpacing.verticalSpacingSmall(),
                      NeumorphTextField(
                        width: UiSpacing.screenSize(context).width,
                        controller: _elearnUsernameController,
                        hintText: 'E-learning Username',
                        prefixIcon:
                            Image.asset('assets/images/login/password.png'),
                        validator: (input) => Validator.validField(
                            input, 'username in lowercase letters'),
                      ),
                      UiSpacing.verticalSpacingSmall(),
                      NeumorphTextField(
                        width: UiSpacing.screenSize(context).width,
                        controller: _elearnNewPasswordController,
                        hintText: 'New E-Learning Password',
                        obscureText: true,
                        prefixIcon:
                            Image.asset('assets/images/login/password.png'),
                        validator: (input) => Validator.isValidPassword(input),
                      ),
                      UiSpacing.verticalSpacingSmall(),
                      NeumorphTextField(
                        width: UiSpacing.screenSize(context).width,
                        controller: _elearnConfirmPasswordController,
                        hintText: 'Confirm New E-Learning Password',
                        obscureText: true,
                        prefixIcon:
                            Image.asset('assets/images/login/password.png'),
                        validator: (input) => Validator.isValidPassword(input),
                      ),
                      UiSpacing.verticalSpacingSmall(),
                    ],
                    button: ViewModelBuilder<ElearningViewModel>.reactive(
                      viewModelBuilder: () => ElearningViewModel(),
                      builder: (context, model, child) => ButtonWrapper(
                        buttonText: 'Save',
                        onPressed: () {
                          if (_elearnFormKey.currentState!.validate()) {
                            _elearnFormKey.currentState?.save();
                            FocusScope.of(context).requestFocus(FocusNode());
                            model.elearnLogin(
                                context: context,
                                username: _elearnUsernameController.text,
                                newPassword: _elearnNewPasswordController.text,
                                oldPassword: _elearnOldPasswordController.text);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
