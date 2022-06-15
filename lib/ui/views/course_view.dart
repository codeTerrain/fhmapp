import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../viewmodels/elearning_view_model.dart';

class CourseView extends StatefulWidget {
  final String url;
  const CourseView({required this.url, Key? key}) : super(key: key);

  @override
  State<CourseView> createState() => _CourseViewState();
}

class _CourseViewState extends State<CourseView> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ViewModelBuilder<ElearningViewModel>.reactive(
          viewModelBuilder: () => ElearningViewModel(),
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
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
          ),
        ),
      ),
    );
  }
}
