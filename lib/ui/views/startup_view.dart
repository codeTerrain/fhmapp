import 'package:fhmapp/ui/shared/style.dart';
import 'package:fhmapp/ui/viewmodels/startup_view_model.dart';
import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

class StartUpView extends StatelessWidget {
  const StartUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartUpViewModel>.reactive(
      viewModelBuilder: () => StartUpViewModel(),
      onModelReady: (model) => model.hasLogin(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: kWhite,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: 150,
                height: 100,
                child: Image.asset(
                  'assets/images/logos/ghs_logo.png',
                  scale: 2,
                ),
              ),
              const CircularProgressIndicator(
                color: primaryColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
