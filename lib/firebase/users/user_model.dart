import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String id;
  String name;
  String photoURL;
  String bio;
  UserModel(this.id, this.name, this.photoURL, this.bio);

  factory UserModel.fromFirebaseAuthUser(User user) {
    return UserModel(user.uid, user.displayName, user.photoURL, 'not-defined');
  }

  Map<String, dynamic> toMap() {
    return Map<String, dynamic>.of({
      'id': id,
      'name': name,
      'profileURL': photoURL,
      'bio': bio,
    });
  }
}
