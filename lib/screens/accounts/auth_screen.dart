import 'package:college_gram/firebase/users/user_collection.dart';
import 'package:college_gram/firebase/users/user_model.dart';
import 'package:college_gram/screens/accounts/google_auth_screen.dart';
import 'package:college_gram/screens/main/feed_screen.dart';
import 'package:college_gram/screens/main/home_screen.dart';
import 'package:college_gram/screens/main/profile_screen.dart';
import 'package:college_gram/widgets/error_widget.dart';
import 'package:college_gram/widgets/loading_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

UserCollection userCollection = UserCollection();

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return MyCustomErrorWidget(snapshot.error);
          }
          if (ConnectionState.active == snapshot.connectionState) {
            if (snapshot.data == null) {
              return GoogleAuthScreen();
            } else {
              print(snapshot.data);
              UserModel currentUser =
                  UserModel.fromFirebaseAuthUser(snapshot.data);
              userCollection.addUserToFireStore(currentUser);
              return HomeScreen(currentUser);
            }
          }
          return LoadingWidget();
        });
  }
}
