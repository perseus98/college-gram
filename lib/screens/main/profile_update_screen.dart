import 'package:college_gram/firebase/users/user_model.dart';
import 'package:college_gram/screens/accounts/auth_screen.dart';
import 'package:college_gram/screens/main/profile_screen.dart';
import 'package:flutter/material.dart';

class ProfileUpdateScreen extends StatefulWidget {
  final UserModel userModel;
  ProfileUpdateScreen(this.userModel);
  @override
  _ProfileUpdateScreenState createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final bioController = TextEditingController();

  @override
  void initState() {
    nameController.text = widget.userModel.name;
    bioController.text = widget.userModel.bio;
    super.initState();
  }

  void updateProfileData() {
    widget.userModel.name = nameController.text;
    widget.userModel.bio = bioController.text;
    userCollection.addUserToFireStore(widget.userModel);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfileScreen(widget.userModel)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_outlined),
            onPressed: () => Navigator.pop(context)),
        title: Text("Update Profile"),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.only(top: 10.0),
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                  labelText: "Display Name",
                  hintText: "Enter new display name here"),
            ),
            TextFormField(
              controller: bioController,
              decoration: InputDecoration(
                  labelText: "Bio", hintText: "Enter new bio here"),
            ),
            ElevatedButton(
                onPressed: () => updateProfileData(), child: Text("Save"))
          ],
        ),
      ),
    );
  }
}
