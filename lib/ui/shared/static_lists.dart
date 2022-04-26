import 'package:flutter/material.dart';
import 'routes.dart';

Map<String, String> programs = {
  'MCH': 'Maternal & Child Health',
  'FP': 'Family Planning',
  'ADH': 'Adolescent Health',
  'NUT': 'Nutrition',
};
Map<String, String> drawerItems = {
  'Profile': Routes.profile,
  'Events': Routes.events,
  'Job Aid': Routes.jobAid,
  'FAQs': Routes.faqs,
  'Logout': Routes.logout,
};

List<String> subtitle = [
  'Personal Information 1',
  'Personal Information 2',
  'Demographics',
  'Work Information'
];

Map<String, TextEditingController> textEditingControllers = {};
