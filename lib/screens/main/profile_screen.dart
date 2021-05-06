import 'package:college_gram/firebase/auth/firebase_auth_method.dart';
import 'package:college_gram/firebase/users/user_model.dart';
import 'package:college_gram/widgets/error_widget.dart';
import 'package:college_gram/widgets/loading_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

FirebaseAuthMethod userAuthMethod = FirebaseAuthMethod();

class ProfileScreen extends StatefulWidget {
  final UserModel _userModel;
  ProfileScreen(this._userModel);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Profile Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => scaffoldKey.currentState.openEndDrawer(),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('End Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                userAuthMethod.logoutUser();
                Navigator.pushNamed(context, '/auth');
              },
            ),
          ],
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Row(
              children: [
                Image.network(
                  widget._userModel.photoURL,
                  width: 50.0,
                  height: 50.0,
                ),
                Text(widget._userModel.name),
              ],
            ),
            Text(widget._userModel.bio)
          ],
        ),
      ),
    );
  }
}
