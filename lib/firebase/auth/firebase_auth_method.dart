import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../screens/accounts/google_auth_screen.dart';

class FirebaseAuthMethod {
  Future<void> logoutUser() async {
    FirebaseAuth.instance.signOut();
    googleAuthMethod.signOutGoogleUser();
  }
}
