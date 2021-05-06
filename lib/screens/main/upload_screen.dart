import 'package:college_gram/firebase/users/user_model.dart';
import 'package:flutter/material.dart';

class UploadScreen extends StatefulWidget {
  final UserModel currentUser;
  UploadScreen(this.currentUser);
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Upload Page"),
      ),
    );
  }
}
