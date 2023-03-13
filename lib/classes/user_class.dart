import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

final _database = FirebaseDatabase.instance.ref();

class AppUser {
  late final String userId;
  late final String firstname;
  late final String lastname;
  late final String number;
  late final String email;

  AppUser(
      {required this.userId,
      required this.firstname,
      required this.lastname,
      required this.number,
      required this.email});

  factory AppUser.fromJson(Map<String, dynamic> dataValue) {
    return AppUser(
      userId: dataValue['userId'],
      firstname: dataValue['firstname'],
      lastname: dataValue['lastname'],
      email: dataValue['email'],
      number: dataValue['number'],
    );
  }
}

//Helper functions
Future<AppUser> fetchUser(String userId) async {
  final DatabaseReference userReference = _database.child('Users/$userId');
  final DatabaseEvent event = await userReference.once();
  final data = event.snapshot.value;
  Map<String, dynamic> dataValue =
      jsonDecode(jsonEncode(data)) as Map<String, dynamic>;
  return AppUser.fromJson(dataValue);
}
