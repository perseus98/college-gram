import 'package:college_gram/firebase/users/user_model.dart';
import 'package:college_gram/screens/main/feed_screen.dart';
import 'package:college_gram/screens/main/profile_screen.dart';
import 'package:college_gram/screens/main/upload_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final UserModel currentUser;
  HomeScreen(this.currentUser);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final pageController = PageController(
    initialPage: 1,
  );
  int currentPage = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            currentPage = index;
          });
        },
        children: [
          UploadScreen(widget.currentUser),
          FeedScreen(widget.currentUser),
          ProfileScreen(widget.currentUser)
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (index) {
          pageController.jumpToPage(index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_enhance_outlined),
            label: "Upload Post",
            activeIcon: Icon(Icons.camera_enhance),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: "Upload Post",
            activeIcon: Icon(Icons.dashboard),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_outlined),
            label: "Upload Post",
            activeIcon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
