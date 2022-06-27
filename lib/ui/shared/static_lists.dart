import 'package:flutter/material.dart';
import '../../core/model/events.dart';
import '../../core/model/program_model.dart';
import 'routes.dart';

Map<String, String> programs = {
  'FP': 'Family Planning',
  'ADH': 'Adolescent Health',
  'NUT': 'Nutrition',
  'MCH': 'Maternal & Child Health',
};
Map<String, String> medicalScreening = {
  'preSchool': 'Pre-School',
  'shsScreening': 'SHS Screening',
  'wellnessClinic': 'Wellness Clinic',
};
Map<String, String> schoolClinic = {
  'preSchool': 'Pre-School',
  'primarySchool': 'Primary School',
  'JHS': 'Junior High School',
  'SHS': 'Senior High School',
};
Map<String, String> drawerItems = {
  'Profile': Routes.profile,
  'Events': Routes.events,
  'Job Aid': Routes.jobAid,
  'Medical Screening': Routes.medicalScreening,
  'School Clinic': Routes.schoolClinic,
  'FAQs': Routes.faqs,
};

List<String> subtitle = [
  'Personal Information 1',
  'Personal Information 2',
  'Demographics',
  'Work Information'
];

Map<String, TextEditingController> textEditingControllers = {};

const String privacyPolicy =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ';

List<Program> programList = List.generate(
    programs.length,
    (index) => Program(
          id: programs.values.toList()[index],
          name: programs[programs.keys.toList()[index]]!,
          image: 'assets/images/dashboard/dummyFamily.png',
        ));
// List<Event> eventList = List.generate(
//     programs.length,
//     (index) => Event(
//         id: programs.keys.toList()[index],
//         name: programs[programs.keys.toList()[index]]!,
//         image: 'assets/images/dashboard/dummyFamily.png',
//         programmeId: [programs.keys.toList()[index]],
//         programmeTag: programs.keys.toList()[index],
//         description:
//             'The standard Lorem Ipsum passage, used since the 1500s Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.  $index',
//         endDate: DateTime.now(),
//         startDate: DateTime.now(),
//         isAttendable: true,
//         registeredUsers: []));
