class Users {
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final DateTime dob;
  final DateTime dateJoined;
  final String phone;
  final String cadre;
  final String region;
  final String gender;
  final String district;
  final String? community;
  final String userType;
  final String facility;
  final String? userDocId;
  final String? appRegisteredOn;

  final String? profilePicture;
  final String? subDistrict;

  final List<dynamic>? loggedInDevices;

  Users(
      {required this.userId,
      required this.dob,
      required this.dateJoined,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.phone,
      required this.cadre,
      required this.region,
      required this.gender,
      required this.district,
      required this.community,
      this.subDistrict,
      required this.facility,
      this.userDocId,
      this.profilePicture,
      this.appRegisteredOn,
      required this.userType,
      this.loggedInDevices});

  factory Users.fromJson(Map<dynamic, dynamic> data, String docId) => Users(
        userDocId: docId,
        userId: data['userId'],
        firstName: data['firstName'],
        lastName: data['lastName'],
        email: data['email'],
        dob: data['dob'].toDate(),
        dateJoined: data['dateJoined'].toDate(),
        phone: data['phone'],
        cadre: data['cadre'],
        region: data['region'],
        gender: data['gender'],
        district: data['district'],
        community: data['community'],
        subDistrict: data['subDistrict'],
        facility: data['facility'],
        profilePicture: data['profilePicture'],
        userType: data['userType'],
        loggedInDevices: data['loggedInDevices'],
        appRegisteredOn: data['appRegisteredOn'],
      );
}
