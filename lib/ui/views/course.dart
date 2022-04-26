import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../viewmodels/profile_model.dart';

class Course extends StatefulWidget {
  const Course({Key? key}) : super(key: key);

  @override
  State<Course> createState() => _CourseState();
}

class _CourseState extends State<Course> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ViewModelBuilder<ProfileViewModel>.reactive(
          viewModelBuilder: () => ProfileViewModel(),
          onModelReady: (model) => model.getElearnCredential(),
          builder: (context, model, child) => WebView(
            onWebViewCreated: ((controller) {
              this.controller = controller;
            }),
            onPageFinished: (loadedPageUrl) async {
              if (loadedPageUrl ==
                  'http://46.101.235.240/ghslearning/login/index.php') {
                controller.runJavascript(
                    "document.getElementById('username').value='${model.elearnUsername}'");
                controller.runJavascript(
                    "document.getElementById('password').value='${model.elearnPassword}'");
                await Future.delayed(const Duration(seconds: 1));
                await controller.runJavascript("document.forms[1].submit()");
              }
            },
            initialUrl:
                'http://46.101.235.240/ghslearning/course/view.php?id=7',
            javascriptMode: JavascriptMode.unrestricted,
          ),
        ),
      ),
    );
  }
}
