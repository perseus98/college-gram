import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  factory UserModel.fromDocDataMap(Map<String, dynamic> data) {
    return UserModel(data['id'], data['name'], data['photoURL'], data['bio']);
  }

  Map<String, dynamic> toMap() {
    return Map<String, dynamic>.of({
      'id': id,
      'name': name,
      'photoURL': photoURL,
      'bio': bio,
    });
  }
}
