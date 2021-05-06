import 'package:college_gram/firebase/auth/google_auth_method.dart';
import 'package:college_gram/firebase/users/user_model.dart';
import 'package:college_gram/screens/accounts/auth_screen.dart';
import 'package:college_gram/screens/main/feed_screen.dart';
import 'package:college_gram/screens/main/profile_screen.dart';
import 'package:college_gram/widgets/error_widget.dart';
import 'package:college_gram/widgets/loading_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleAuthMethod googleAuthMethod = GoogleAuthMethod();

class GoogleAuthScreen extends StatefulWidget {
  @override
  _GoogleAuthScreenState createState() => _GoogleAuthScreenState();
}

class _GoogleAuthScreenState extends State<GoogleAuthScreen> {
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser =
        await googleAuthMethod.googleUser.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserCredential>(
        future: signInWithGoogle(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return MyCustomErrorWidget(snapshot.error);
          }
          if (ConnectionState.done == snapshot.connectionState) {
            print(snapshot.data.user);
            UserModel currentUser =
                UserModel.fromFirebaseAuthUser(snapshot.data.user);
            userCollection.addUserToFireStore(currentUser);
            return AuthScreen();
          }
          return LoadingWidget();
        });
  }
}
