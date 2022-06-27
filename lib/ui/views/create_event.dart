import 'dart:io';

import 'package:fhmapp/core/services/shared_preferences.dart';
import 'package:fhmapp/ui/shared/spacing.dart';
import 'package:fhmapp/ui/widgets/appbars.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:stacked/stacked.dart';
import '../../core/services/utilities.dart';
import '../../locator.dart';
import '../shared/dropper.dart';
import '../shared/style.dart';
import '../shared/validator.dart';
import '../viewmodels/event_view_model.dart';
import '../widgets/change_info.dart';
import '../widgets/misc.dart';
import '../widgets/neumorph_drop_down.dart';
import '../widgets/neumorph_textfield.dart';

// class CreateEvent extends StatelessWidget {
//   CreateEvent({Key? key}) : super(key: key);

//   final SharedPrefs _sharedPrefs = locator<SharedPrefs>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: InfoAppBar(
//             title: Hero(
//           tag: 'personal',
//           child: Text(
//             'Create Event',
//             style: Theme.of(context).textTheme.headline5,
//           ),
//         )),
//         body: SingleChildScrollView(
//           physics: scrollPhysics,
//           child: Padding(
//             padding: mainPadding,
//             child: Column(
//               children: [
//                 UiSpacing.verticalSpacingMedium(),
//                 const EventInfo(),
//                 UiSpacing.verticalSpacingMedium(),
//               ],
//             ),
//           ),
//         ));
//   }
// }

class CreateEvent extends StatefulWidget {
  final List<String>? fhmappAdminFor;
  const CreateEvent({Key? key, this.fhmappAdminFor}) : super(key: key);

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  String? startDateInString;
  DateTime? startDate;
  bool isAttendable = true;
  File? imageFile;
  late DateTime fromDate;
  late DateTime toDate;

  bool isDateSelected = false;
  final GlobalKey<FormState> _eventFormKey = GlobalKey<FormState>();

  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();

  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _organizedByController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late String fhmappAdminFor;
  final SharedPrefs _sharedPrefs = locator<SharedPrefs>();

  @override
  void initState() {
    fhmappAdminFor = widget.fhmappAdminFor![0];
    fromDate = DateTime.now();
    toDate = DateTime.now().add(const Duration(hours: 2));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InfoAppBar(
          title: Hero(
        tag: 'personal',
        child: Text(
          'Create Event',
          style: Theme.of(context).textTheme.headline5,
        ),
      )),
      body: SingleChildScrollView(
        physics: scrollPhysics,
        child: Padding(
          padding: mainPadding,
          child: Column(
            children: [
              Form(
                key: _eventFormKey,
                child: Column(
                  children: [
                    ChangeInfo(
                        header: 'Event Cover Image',
                        fields: [
                          GestureDetector(
                            onTap: () => buttonClicked(true),
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                Container(
                                    width: UiSpacing.screenSize(context).width,
                                    height: 200,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            style: BorderStyle.solid,
                                            color: grey)),
                                    child: imageFile != null
                                        ? ClipRRect(
                                            borderRadius: generalBorderRadius,
                                            child: Image.file(imageFile!))
                                        : const SizedBox()),
                                const Icon(Icons.photo_size_select_large,
                                    color: kBlack, size: 50),
                              ],
                            ),
                          )
                        ],
                        button: const SizedBox()),
                    UiSpacing.verticalSpacingSmall(),
                    ChangeInfo(
                      header: 'Event Start Date',
                      button: const SizedBox(),
                      fields: [
                        buildFromDateSelector(description: 'From'),
                      ],
                    ),
                    UiSpacing.verticalSpacingSmall(),
                    ChangeInfo(
                      header: 'Event End Date',
                      button: const SizedBox(),
                      fields: [buildToDateSelector(description: 'To')],
                    ),
                    UiSpacing.verticalSpacingSmall(),
                    ChangeInfo(
                      header: 'Event Information',
                      fields: [
                        NeumorphTextField(
                          width: UiSpacing.screenSize(context).width,
                          controller: _eventNameController,
                          hintText: 'Name of Event',
                          prefixIcon: const Icon(Icons.abc),
                          validator: (input) =>
                              Validator.validField(input, 'Name of Event'),
                        ),
                        UiSpacing.verticalSpacingSmall(),
                        NeumorphTextField(
                          width: UiSpacing.screenSize(context).width,
                          controller: _descriptionController,
                          hintText: 'Event Description',
                          maxLength: 300,
                          maxLines: 6,
                          keyboardType: TextInputType.multiline,
                          minLines: 4,
                          height: 150,
                          prefixIcon: Icon(Icons.description_outlined,
                              color: transGrey),
                        ),
                        UiSpacing.verticalSpacingSmall(),
                        NeumorphTextField(
                          width: UiSpacing.screenSize(context).width,
                          controller: _locationController,
                          hintText: 'Location',
                          prefixIcon: Icon(Icons.location_on_outlined,
                              color: transGrey),
                          validator: (input) =>
                              Validator.validField(input, 'Location'),
                        ),
                        UiSpacing.verticalSpacingSmall(),
                        NeumorphTextField(
                          width: UiSpacing.screenSize(context).width,
                          controller: _organizedByController,
                          hintText: 'Organized By',
                          prefixIcon:
                              Icon(Icons.location_city, color: transGrey),
                          validator: (input) =>
                              Validator.validField(input, 'Organized by'),
                        ),
                        UiSpacing.verticalSpacingSmall(),
                        NeumorphDropDown(
                          context,
                          width: UiSpacing.screenSize(context).width,
                          dropItems: widget.fhmappAdminFor!,
                          hintText: 'Post For ',
                          prefixIcon:
                              Image.asset('assets/images/login/user.png'),
                          value: fhmappAdminFor,
                          onChanged: (String? newValue) {
                            setState(() {
                              fhmappAdminFor = newValue!;
                            });
                          },
                        ),
                        UiSpacing.verticalSpacingMedium(),
                        Text(
                          'Is Event Attendable?',
                          style: Theme.of(context)
                              .textTheme
                              .headline3
                              ?.copyWith(
                                  color: grey, fontWeight: FontWeight.w500),
                        ),
                        NeumorphDropDown<bool>(
                          context,
                          width: UiSpacing.screenSize(context).width,
                          dropItems: Dropper.chioce,
                          hintText: 'true/false',
                          prefixIcon:
                              const Icon(Icons.app_registration_rounded),
                          value: isAttendable,
                          onChanged: (bool? newValue) {
                            setState(() {
                              isAttendable = newValue!;
                            });
                          },
                        ),
                        UiSpacing.verticalSpacingSmall(),

                        // dobSelector(
                        //   context: context,
                        //   hintText: startDateInString ?? 'Event Date',
                        //   onTap: () async {
                        //     final datePick = await datePicker(context);
                        //     if (datePick != null && datePick != startDate) {
                        //       setState(() {
                        //         startDate = datePick;
                        //         isDateSelected = true;

                        //         startDateInString =
                        //             "${startDate?.month}/${startDate?.day}/${startDate?.year}";
                        //         _startDateController.text =
                        //             startDateInString ?? '';
                        //       });
                        //     }
                        //   },
                        //   borderColor: kWhite,
                        //   controller: _startDateController,
                        // ),
                        UiSpacing.verticalSpacingSmall(),
                      ],
                      button: ViewModelBuilder<EventViewModel>.reactive(
                        viewModelBuilder: () => EventViewModel(),
                        builder: (context, model, child) => ButtonWrapper(
                          buttonText: model.isBusy ? 'Please wait' : 'Save',
                          onPressed: () {
                            if (_eventFormKey.currentState!.validate()) {
                              _eventFormKey.currentState?.save();
                              FocusScope.of(context).requestFocus(FocusNode());

                              model
                                  .createEvent(
                                      name: _eventNameController.text,
                                      id: DateTime.now()
                                          .millisecondsSinceEpoch
                                          .toString(),
                                      isAttendable: isAttendable,
                                      location: _locationController.text,
                                      organizedBy: _organizedByController.text,
                                      description: _descriptionController.text,
                                      startDate: fromDate,
                                      programmeTag: fhmappAdminFor,
                                      endDate: toDate,
                                      imageFile: imageFile)
                                  .then((value) {
                                _locationController.clear();
                                _organizedByController.clear();
                                _descriptionController.clear();
                                //imageFiles.clear();
                                setState(() {});
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future buttonClicked(bool isGallery) async {
    final CroppedFile? file = await Utilities.pickMedia(
      fileSize: 3.0,
      isGallery: isGallery,
      cropImage: (croppedFile) => Utilities.cropSquareImage(
          croppedFile, CropStyle.rectangle,
          cropAspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 2.2)),
    );

    if (file == null) return;
    var compressedFile = await Utilities.compressFile(File(file.path));
    setState(() => imageFile = compressedFile);
  }

  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(fromDate, pickDate: pickDate);
    if (date == null) return;
    if (date.isAfter(toDate)) {
      toDate =
          DateTime(date.year, date.month, date.day, toDate.hour, toDate.minute);
    }
    setState(() => fromDate = date);
  }

  Future pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(toDate,
        pickDate: pickDate, firstDate: pickDate ? fromDate : null);
    if (date == null) return;
    setState(() => toDate = date);
  }

  Widget buildFromDateSelector({
    required String description,
  }) =>
      Row(
        children: [
          Expanded(
            flex: 2,
            child: dateListTile(
                text: Utilities.toDate(fromDate),
                onClicked: () => pickFromDateTime(pickDate: true)),
          ),
          Expanded(
            flex: 1,
            child: dateListTile(
                text: Utilities.toTime(fromDate),
                onClicked: () => pickFromDateTime(pickDate: false)),
          ),
        ],
      );
  Widget buildToDateSelector({
    required String description,
  }) =>
      Row(
        children: [
          Expanded(
            flex: 2,
            child: dateListTile(
                text: Utilities.toDate(toDate),
                onClicked: () => pickToDateTime(pickDate: true)),
          ),
          Expanded(
            flex: 1,
            child: dateListTile(
                text: Utilities.toTime(toDate),
                onClicked: () => pickToDateTime(pickDate: false)),
          ),
        ],
      );

  ListTile dateListTile(
          {required String text, required VoidCallback onClicked}) =>
      ListTile(
        title: Text(text),
        trailing: const Icon(Icons.arrow_drop_down),
        onTap: onClicked,
      );

  Future<DateTime?> pickDateTime(
    DateTime initialDate, {
    required bool pickDate,
    DateTime? firstDate,
  }) async {
    if (pickDate) {
      final date = await showDatePicker(
          context: context,
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: const ColorScheme.light(
                  primary: primaryColor,
                  onPrimary: kWhite,
                ),
                dialogBackgroundColor: kWhite,
              ),
              child: child!,
            );
          },
          initialDate: initialDate,
          firstDate: firstDate ??
              DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day),
          lastDate: DateTime(2100));

      if (date == null) return null;
      final time = Duration(
        hours: initialDate.hour,
        minutes: initialDate.minute,
      );

      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(initialDate),
          initialEntryMode: TimePickerEntryMode.dial,
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: const ColorScheme.light(
                  primary: primaryColor,
                  onPrimary: kWhite,
                ),
                dialogBackgroundColor: primaryColor,
              ),
              child: child!,
            );
          });
      if (timeOfDay == null) return null;

      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);

      print(date.add(time));
      return date.add(time);
    }
  }
}
