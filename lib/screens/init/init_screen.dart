import 'package:college_gram/screens/accounts/auth_screen.dart';
import 'package:college_gram/screens/init/intro_screen.dart';
import 'package:college_gram/widgets/error_widget.dart';
import 'package:college_gram/widgets/loading_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitScreen extends StatefulWidget {
  @override
  _InitScreenState createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  bool firstTime = true;
  @override
  void initState() {
    checkFirstTimeUse();
    super.initState();
  }

  checkFirstTimeUse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    firstTime = prefs.getBool('first_time') ?? true;
    if (firstTime) {
      prefs.setBool('first_time', false);
      print("first init => false");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return MyCustomErrorWidget(snapshot.error);
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return firstTime ? IntroScreen() : AuthScreen();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return LoadingWidget();
      },
    );
  }
}
