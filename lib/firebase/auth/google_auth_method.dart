import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthMethod {
  final GoogleSignIn googleUser = GoogleSignIn();

  void signOutGoogleUser() {
    googleUser.signOut();
  }
}
