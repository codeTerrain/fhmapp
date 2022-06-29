import 'dart:io';

import 'package:fhmapp/core/model/events.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked/stacked.dart';
import '../../core/model/post_model.dart';
import '../../core/services/file_operations.dart';
import '../../core/services/respository.dart';
import '../../core/services/shared_preferences.dart';
import '../../locator.dart';

class EventViewModel extends MultipleFutureViewModel {
  final SharedPrefs _sharedPrefs = locator<SharedPrefs>();
  final Respository _respository = locator<Respository>();
  String? _image;
  String? get image => _image;

  Future createEvent(
      {required String id,
      required String name,
      String? description,
      required String programmeTag,
      File? imageFile,
      required bool isAttendable,
      required DateTime startDate,
      required DateTime endDate,
      required String? location,
      required String? organizedBy}) async {
    final String creator = await _sharedPrefs.getLocalStorage('email');
    if (imageFile != null) {
      await runBusyFuture(FileOperations.uploadFile('/events', imageFile)
          .then((downloadUrl) => _image = downloadUrl)
          .onError((error, stackTrace) {
        Fluttertoast.showToast(msg: error.toString());
        return;
      }));
    }

    final Map<String, dynamic> eventItem = {
      'id': id,
      'name': name,
      'programmeTag': programmeTag,
      'creator': creator,
      'description': description,
      'image': image,
      'isAttendable': isAttendable,
      'startDate': startDate,
      'endDate': endDate,
      'location': location,
      'registeredUsers': [],
      'organizedBy': organizedBy,
    };

    notifyListeners();
    runBusyFuture(_respository.addPost(eventItem, 'events'));
  }

  Future updateEventAttendees({required Event event}) async {
    Set<String> registeredUsers = {};
    final String currentUserEmail = await _sharedPrefs.getLocalStorage('email');

    registeredUsers = event.registeredUsers.toSet().cast<String>();
    if (registeredUsers.contains(currentUserEmail)) {
      registeredUsers.remove(currentUserEmail);
    } else {
      registeredUsers.add(currentUserEmail);
    }

    _respository.updateEventAttendees(
        eventId: event.id,
        email: currentUserEmail,
        updatedAtendees: registeredUsers);
  }

  @override
  Map<String, Future Function()> get futuresMap => {};
}
