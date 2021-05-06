import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gram/firebase/users/user_model.dart';

class UserCollection {
  CollectionReference usersReference =
      FirebaseFirestore.instance.collection('users');
  Future<void> addUserToFireStore(UserModel userModel) {
    // Call the user's CollectionReference to add a new user
    return usersReference
        .doc(userModel.id)
        .set(userModel.toMap())
        .then((value) => print("User Data saved to firestore"))
        .catchError(
            (error) => print("Failed save user data to firestore: $error"));
  }
}
