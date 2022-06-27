import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fhmapp/core/services/shared_preferences.dart';
import 'package:fhmapp/core/services/file_operations.dart';
import 'package:fhmapp/ui/shared/spacing.dart';
import 'package:fhmapp/ui/widgets/appbars.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:stacked/stacked.dart';
import '../../core/services/utilities.dart';
import '../../locator.dart';
import '../shared/dropper.dart';
import '../shared/style.dart';
import '../shared/validator.dart';
import '../viewmodels/profile_view_model.dart';
import '../viewmodels/user_action_model.dart';
import '../widgets/change_info.dart';
import '../widgets/misc.dart';
import '../widgets/neumorph_drop_down.dart';
import '../widgets/neumorph_textfield.dart';
import 'package:path/path.dart';

class PersonalInfo extends StatelessWidget {
  PersonalInfo({Key? key}) : super(key: key);

  final SharedPrefs _sharedPrefs = locator<SharedPrefs>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: InfoAppBar(
            title: Hero(
          tag: 'personal',
          child: Text(
            'Edit Personal Info',
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
                ProfileImage(),
                UiSpacing.verticalSpacingMedium(),
                Text('Edit Your Personal Info',
                    style: Theme.of(context).textTheme.headline3),
                FutureBuilder<Object>(
                    future: _sharedPrefs.getLocalStorage('email'),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox();
                      } else {
                        return Text(snapshot.data.toString(),
                            style: Theme.of(context).textTheme.headline3);
                      }
                    }),
                UiSpacing.verticalSpacingMedium(),
                const Personal(),
                UiSpacing.verticalSpacingMedium(),
                const Demographics(),
                UiSpacing.verticalSpacingMedium(),
                const Work(),
              ],
            ),
          ),
        ));
  }
}

class ProfileImage extends StatefulWidget {
  const ProfileImage({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      viewModelBuilder: () => ProfileViewModel(),
      onModelReady: (model) => model.getUserInfo(),
      builder: (context, model, child) {
        if (model.isBusy) {
          return const CircularProgressIndicator();
        } else {
          return Stack(
            children: [
              ClipOval(
                  child: model.user.profilePicture != ''
                      ? CachedNetworkImage(
                          imageUrl:
                              (model.imageUrl == null || model.imageUrl == '')
                                  ? model.user.profilePicture!
                                  : model.imageUrl!,
                          //   useOldImageOnUrlChange: true,
                          errorWidget: (context, url, error) {
                            return noProfile;
                          },
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          placeholderFadeInDuration:
                              const Duration(milliseconds: 200),
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        )
                      : noProfile),
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: null,
                  child: Container(
                      alignment: Alignment.center,
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          color: kWhite,
                          borderRadius: BorderRadius.circular(5)),
                      child: IconButton(
                          icon: const Icon(
                            Icons.camera_alt_outlined,
                            color: primaryColor,
                          ),
                          onPressed: model.changeProfileImage)),
                ),
              )
            ],
          );
        }
      },
    );
  }
}

class Work extends StatefulWidget {
  const Work({Key? key}) : super(key: key);

  @override
  State<Work> createState() => _WorkState();
}

class _WorkState extends State<Work> {
  final GlobalKey<FormState> _workFormKey = GlobalKey<FormState>();
  final TextEditingController _facilityController = TextEditingController();
  final TextEditingController _communityController = TextEditingController();
  final TextEditingController _cadreController = TextEditingController();
  final SharedPrefs _sharedPrefs = locator<SharedPrefs>();

  fieldsController() async {
    _cadreController.text = await _sharedPrefs.getLocalStorage('cadre');

    _communityController.text = await _sharedPrefs.getLocalStorage('community');
    _facilityController.text = await _sharedPrefs.getLocalStorage('facility');
  }

  @override
  void initState() {
    fieldsController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _workFormKey,
      child: ChangeInfo(
        header: 'Work Information',
        fields: [
          UiSpacing.verticalSpacingSmall(),
          NeumorphTextField(
            width: UiSpacing.screenSize(context).width,
            controller: _cadreController,
            hintText: 'Cadre',
            prefixIcon: Image.asset('assets/images/login/cadre.png'),
            validator: (input) => Validator.validField(input, 'cadre'),
          ),
          UiSpacing.verticalSpacingSmall(),
          NeumorphTextField(
            width: UiSpacing.screenSize(context).width,
            controller: _facilityController,
            hintText: 'Facility',
            prefixIcon: Image.asset('assets/images/login/facility.png'),
            validator: (input) => Validator.validField(input, 'facility'),
          ),
          UiSpacing.verticalSpacingSmall(),
        ],
        button: ViewModelBuilder<UserActionModel>.reactive(
          viewModelBuilder: () => UserActionModel(),
          builder: (context, model, child) => ButtonWrapper(
            buttonText: model.isBusy ? 'Please wait' : 'Save',
            onPressed: () {
              if (_workFormKey.currentState!.validate()) {
                _workFormKey.currentState?.save();
                FocusScope.of(context).requestFocus(FocusNode());

                model.changePersonalInfo(context, {
                  'cadre': _cadreController.text,
                  'facility': _facilityController.text,
                });
              }
            },
          ),
        ),
      ),
    );
  }
}

class Personal extends StatefulWidget {
  const Personal({Key? key}) : super(key: key);

  @override
  State<Personal> createState() => _PersonalState();
}

class _PersonalState extends State<Personal> {
  final GlobalKey<FormState> _personalFormKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();

  final TextEditingController _lastNameController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final SharedPrefs _sharedPrefs = locator<SharedPrefs>();

  fieldsController() async {
    _lastNameController.text = await _sharedPrefs.getLocalStorage('lastName');
    _firstNameController.text = await _sharedPrefs.getLocalStorage('firstName');
    _phoneController.text = await _sharedPrefs.getLocalStorage('phone');
  }

  @override
  void initState() {
    fieldsController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _personalFormKey,
      child: ChangeInfo(
        header: 'Personal Information',
        fields: [
          UiSpacing.verticalSpacingSmall(),
          NeumorphTextField(
            width: UiSpacing.screenSize(context).width,
            controller: _firstNameController,
            hintText: 'First Name',
            prefixIcon: Image.asset('assets/images/login/user.png'),
            validator: (input) => Validator.validField(input, 'First Name'),
          ),
          UiSpacing.verticalSpacingSmall(),
          NeumorphTextField(
            width: UiSpacing.screenSize(context).width,
            controller: _lastNameController,
            hintText: 'Last Name',
            prefixIcon: Image.asset('assets/images/login/user.png'),
            validator: (input) => Validator.validField(input, 'Last Name'),
          ),
          UiSpacing.verticalSpacingSmall(),
          NeumorphTextField(
            width: UiSpacing.screenSize(context).width,
            controller: _phoneController,
            hintText: 'phone',
            prefixIcon: phoneIcon,
            validator: (input) => Validator.validField(input, 'Last Name'),
          ),
          UiSpacing.verticalSpacingSmall(),
        ],
        button: ViewModelBuilder<UserActionModel>.reactive(
          viewModelBuilder: () => UserActionModel(),
          builder: (context, model, child) => ButtonWrapper(
            buttonText: model.isBusy ? 'Please wait' : 'Save',
            onPressed: () {
              if (_personalFormKey.currentState!.validate()) {
                _personalFormKey.currentState?.save();
                FocusScope.of(context).requestFocus(FocusNode());

                model.changePersonalInfo(context, {
                  'firstName': _firstNameController.text,
                  'lastName': _lastNameController.text,
                });
              }
            },
          ),
        ),
      ),
    );
  }
}

class Demographics extends StatefulWidget {
  const Demographics({Key? key}) : super(key: key);

  @override
  State<Demographics> createState() => _DemographicsState();
}

final GlobalKey<FormState> _demographicsFormKey = GlobalKey<FormState>();

class _DemographicsState extends State<Demographics> {
  String? region;
  String district = 'Select District';
  bool showDistrict = false;

  final SharedPrefs _sharedPrefs = locator<SharedPrefs>();
  final TextEditingController _communityController = TextEditingController();
  final TextEditingController _subDistrictController = TextEditingController();

  fieldsController() async {
    _communityController.text = await _sharedPrefs.getLocalStorage('community');
    _subDistrictController.text =
        await _sharedPrefs.getLocalStorage('subDistrict');
  }

  @override
  void initState() {
    fieldsController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? oldRegion = region;
    return Form(
      key: _demographicsFormKey,
      child: ChangeInfo(
        header: 'Demographics',
        fields: [
          UiSpacing.verticalSpacingSmall(),
          NeumorphDropDown(
            context,
            width: UiSpacing.screenSize(context).width,
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
          NeumorphDropDown(
            context,
            width: UiSpacing.screenSize(context).width,
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
          NeumorphTextField(
            width: UiSpacing.screenSize(context).width,
            controller: _subDistrictController,
            hintText: 'Sub-District',
            prefixIcon: Image.asset('assets/images/login/subDistrict.png'),
            validator: (input) => Validator.validField(input, 'sub-district'),
          ),
          UiSpacing.verticalSpacingSmall(),
          NeumorphTextField(
            width: UiSpacing.screenSize(context).width,
            controller: _communityController,
            hintText: 'Community',
            prefixIcon: Image.asset('assets/images/login/subDistrict.png'),
            validator: (input) => Validator.validField(input, 'community'),
          ),
          UiSpacing.verticalSpacingSmall(),
        ],
        button: ViewModelBuilder<UserActionModel>.reactive(
          viewModelBuilder: () => UserActionModel(),
          builder: (context, model, child) => ButtonWrapper(
            buttonText: model.isBusy ? 'Please wait' : 'Save',
            onPressed: () {
              if (_demographicsFormKey.currentState!.validate()) {
                _demographicsFormKey.currentState?.save();
                FocusScope.of(context).requestFocus(FocusNode());

                if (region == null ||
                    region == 'Select Region' ||
                    district == 'Select District' ||
                    _subDistrictController.text == '' ||
                    _communityController.text == '') {
                  Fluttertoast.showToast(
                    msg: "Kindly ensure all Demographic fields are filled out",
                    gravity: ToastGravity.CENTER,
                  );
                  return;
                }

                model.changePersonalInfo(context, {
                  'region': region,
                  'district': district,
                  'subDistrict': _subDistrictController.text,
                  'community': _communityController.text,
                });
              }
            },
          ),
        ),
      ),
    );
  }
}
