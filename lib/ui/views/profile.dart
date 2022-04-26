import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../shared/spacing.dart';
import '../shared/style.dart';
import '../shared/validator.dart';
import '../viewmodels/profile_model.dart';
import '../widgets/buttons.dart';
import '../widgets/custom_textfield.dart';

class Profile extends StatelessWidget {
  Profile({Key? key}) : super(key: key);

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                width: UiSpacing.screenSize(context).width,
                controller: oldPasswordController,
                keyboardType: TextInputType.emailAddress,
                hintText: 'Old Password',
                prefixIcon: Image.asset('assets/images/login/user.png'),
              ),
              UiSpacing.verticalSpacingSmall(),
              CustomTextField(
                width: UiSpacing.screenSize(context).width,
                controller: usernameController,
                keyboardType: TextInputType.emailAddress,
                hintText: 'Username',
                prefixIcon: Image.asset('assets/images/login/user.png'),
              ),
              UiSpacing.verticalSpacingSmall(),
              CustomTextField(
                width: UiSpacing.screenSize(context).width,
                controller: newPasswordController,
                hintText: 'Password',
                obscureText: true,
                prefixIcon: Image.asset('assets/images/login/password.png'),
                validator: (input) => Validator.isValidPassword(input),
              ),
              UiSpacing.verticalSpacingSmall(),
              CustomTextField(
                width: UiSpacing.screenSize(context).width,
                controller: confirmPasswordController,
                hintText: 'Confirm password',
                obscureText: true,
                prefixIcon: Image.asset('assets/images/login/password.png'),
                validator: (input) => Validator.isValidPassword(input),
              ),
              UiSpacing.verticalSpacingSmall(),
              Center(
                child: ViewModelBuilder<ProfileViewModel>.reactive(
                  viewModelBuilder: () => ProfileViewModel(),
                  builder: (context, model, child) => RoundedButtonTheme(
                    width: model.isBusy ? 130 : 100,
                    text: model.isBusy ? 'Please wait' : 'Save',
                    buttonColor: kBlack,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState?.save();
                        FocusScope.of(context).requestFocus(FocusNode());
                        model.elearnLogin(
                            context: context,
                            username: usernameController.text,
                            newPassword: newPasswordController.text,
                            oldPassword: oldPasswordController.text);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
