import 'package:college_gram/screens/accounts/auth_screen.dart';
import 'package:flutter/material.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  navigateToAuth() {
    Navigator.pushNamed(context, '/auth');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Text("Welcome to CollegeGram"),
            ElevatedButton(
                onPressed: () => navigateToAuth(), child: Text("Get Started"))
          ],
        ),
      ),
    );
  }
}
