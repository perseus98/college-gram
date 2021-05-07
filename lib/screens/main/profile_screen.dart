import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gram/firebase/auth/firebase_auth_method.dart';
import 'package:college_gram/firebase/posts/post_model.dart';
import 'package:college_gram/firebase/users/user_model.dart';
import 'package:college_gram/screens/main/feed_screen.dart';
import 'package:college_gram/screens/main/profile_update_screen.dart';
import 'package:college_gram/widgets/error_widget.dart';
import 'package:college_gram/widgets/loading_widget.dart';
import 'package:college_gram/widgets/profile_post_widget.dart';
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
  bool gridView = true;
  void changeGridState() {
    setState(() {
      gridView = !gridView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: appBar,
        endDrawer: drawer,
        backgroundColor: Colors.white,
        body: StreamBuilder<QuerySnapshot>(
            stream: postCollection.getProfilePost(widget._userModel.id),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return MyCustomErrorWidget(snapshot.error);
              }
              if (snapshot.connectionState == ConnectionState.active) {
                return CustomScrollView(
                  slivers: [
                    SliverList(
                        delegate: SliverChildListDelegate([
                      Container(
                        height: 200.0,
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            Image.network(
                              widget._userModel.photoURL,
                              width: 150.0,
                              height: 150.0,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      widget._userModel.name,
                                      style: TextStyle(fontSize: 20.0),
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      widget._userModel.bio,
                                      style: TextStyle(fontSize: 15.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 80.0,
                        margin: EdgeInsets.only(top: 30.0),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => changeGridState(),
                              child: Container(
                                height: 75.0,
                                width: MediaQuery.of(context).size.width * 0.5,
                                decoration: BoxDecoration(
                                    color: gridView
                                        ? Colors.blue
                                        : Colors.blueGrey,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(50.0))),
                                child: Icon(Icons.grid_view),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => changeGridState(),
                              child: Container(
                                height: 75.0,
                                width: MediaQuery.of(context).size.width * 0.5,
                                decoration: BoxDecoration(
                                    color: gridView
                                        ? Colors.blueGrey
                                        : Colors.blue,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(50.0))),
                                child: Icon(gridView
                                    ? Icons.view_list_outlined
                                    : Icons.view_list),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ])),
                    snapshot.data.size == 0
                        ? SliverToBoxAdapter(
                            child: Center(
                              child: Text("No post found on the cloud"),
                            ),
                          )
                        : gridView
                            ? SliverGrid(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3),
                                delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                  return ProfilePostWidget(
                                      PostModel.fromDocument(
                                          snapshot.data.docs[index]),
                                      gridView);
                                }, childCount: snapshot.data.size),
                              )
                            : SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                return ProfilePostWidget(
                                    PostModel.fromDocument(
                                        snapshot.data.docs[index]),
                                    gridView);
                              }, childCount: snapshot.data.size)),
                  ],
                );
              }
              return LoadingWidget();
            }));
  }

  Widget get appBar => AppBar(
        automaticallyImplyLeading: false,
        title: Text('Profile Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => scaffoldKey.currentState.openEndDrawer(),
          ),
        ],
      );
  Widget get drawer => Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Profile Menu'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            Text("Profile Setting"),
            ListTile(
              title: Text('Edit Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProfileUpdateScreen(widget._userModel)));
              },
            ),
            Divider(),
            Text("Account Setting"),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                userAuthMethod.logoutUser();
                Navigator.pushNamed(context, '/auth');
              },
            ),
          ],
        ),
      );
}
// gridView ? GridView.builder(
// gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// crossAxisCount: 3),
// itemCount: snapshot.data.size,
// itemBuilder: (context, index) {
// return ProfilePostWidget(PostModel.fromDocument(
// snapshot.data.docs[index]));
// }) : ListView.separated(
// itemCount: snapshot.data.size,
// itemBuilder: (context, index) {
// return ProfilePostWidget(
// PostModel.fromDocument(snapshot.data.docs[index]));
// },
// separatorBuilder: (context, index) {
// return Divider(
// color: Colors.black38,
// endIndent: 20.0,
// indent: 20.0,
// thickness: 5.0,
// );
// },
// );
