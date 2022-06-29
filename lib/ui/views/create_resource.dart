import 'dart:io';

import 'package:fhmapp/core/services/shared_preferences.dart';
import 'package:fhmapp/ui/shared/spacing.dart';
import 'package:fhmapp/ui/widgets/appbars.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:stacked/stacked.dart';
import '../../core/services/utilities.dart';
import '../../locator.dart';
import '../shared/style.dart';
import '../shared/validator.dart';
import '../viewmodels/resource_view_model.dart';
import '../widgets/change_info.dart';
import '../widgets/misc.dart';
import '../widgets/neumorph_textfield.dart';

class CreateResource extends StatefulWidget {
  final String fhmappAdminCategory;
  const CreateResource({Key? key, required this.fhmappAdminCategory})
      : super(key: key);

  @override
  State<CreateResource> createState() => _CreateResourceState();
}

class _CreateResourceState extends State<CreateResource> {
  bool isDateSelected = false;
  final GlobalKey<FormState> _resourceFormKey = GlobalKey<FormState>();

  final TextEditingController _fileSystemNameController =
      TextEditingController();
  final TextEditingController _extensionController = TextEditingController();
  final TextEditingController _resourceNameController = TextEditingController();

  late String fhmappAdminFor;
  final SharedPrefs _sharedPrefs = locator<SharedPrefs>();
  File? resource;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: InfoAppBar(
          title: Hero(
            tag: 'personal',
            child: Text(
              'Create Resource File',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          trailing: ViewModelBuilder<ResourceViewModel>.reactive(
            viewModelBuilder: () => ResourceViewModel(),
            builder: (context, model, child) => SizedBox(
              width: model.isBusy ? 110 : 80,
              height: 40,
              child: ButtonWrapper(
                buttonText: model.isBusy ? 'Uploading' : 'Upload',
                onPressed: () {
                  if (_resourceFormKey.currentState!.validate()) {
                    _resourceFormKey.currentState?.save();
                    FocusScope.of(context).requestFocus(FocusNode());

                    model
                        .createResource(
                            id: DateTime.now()
                                .millisecondsSinceEpoch
                                .toString(),
                            name: _resourceNameController.text,
                            category: widget.fhmappAdminCategory,
                            resourceExtension: _extensionController.text,
                            resource: resource!)
                        .then((value) {
                      Navigator.pop(context);
                      _extensionController.clear();
                      _fileSystemNameController.clear();
                      _resourceNameController.clear();

                      setState(() {});
                    });
                  }
                },
              ),
            ),
          ),
        ),
        body: Form(
          key: _resourceFormKey,
          child: ListView(
            padding: mainPadding,
            physics: scrollPhysics,
            children: [
              UiSpacing.verticalSpacingSmall(),
              NeumorphTextField(
                width: UiSpacing.screenSize(context).width,
                controller: _resourceNameController,
                hintText: 'Name of Resource',
                prefixIcon: const Icon(Icons.abc),
                validator: (input) =>
                    Validator.validField(input, 'Name of Resource'),
              ),
              UiSpacing.verticalSpacingSmall(),
              NeumorphTextField(
                width: UiSpacing.screenSize(context).width,
                controller: _extensionController,
                enabled: false,
                validator: (input) =>
                    Validator.validField(input, 'resource extension'),
                hintText: 'Resource Extension',
                prefixIcon: Icon(Icons.extension, color: transGrey),
              ),
              UiSpacing.verticalSpacingSmall(),
              GestureDetector(
                child: NeumorphTextField(
                  width: UiSpacing.screenSize(context).width,
                  controller: _fileSystemNameController,
                  hintText: 'Select File',
                  prefixIcon: Icon(Icons.location_city, color: transGrey),
                  validator: (input) =>
                      Validator.validField(input, 'Select File'),
                  suffixIcon: Image.asset(
                    'assets/images/general/add.png',
                    color: grey,
                  ),
                  enabled: false,
                ),
                onTap: buttonClicked,
              ),
              UiSpacing.verticalSpacingMedium(),
            ],
          ),
        ));
  }

  Future buttonClicked() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    final file = result.files.first;
    if (file.size > 100000000) {
      Fluttertoast.showToast(
        msg: "Select file less than 100mb",
        gravity: ToastGravity.CENTER,
      );
      return;
    }
    File selectedFile = File(file.path!);

    setState(() {
      _extensionController.text = file.extension ?? '';
      _fileSystemNameController.text = file.name;
      resource = selectedFile;
    });
  }
}
