import 'package:college_gram/firebase/storage/firestore_methods.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../../firebase/posts/post_model.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';
import '../accounts/auth_screen.dart';
import 'feed_screen.dart';

StorageReference storageReference = StorageReference();

class UploadingScreen extends StatefulWidget {
  final PostModel postModel;
  final File file;
  UploadingScreen(this.file, this.postModel);
  @override
  _UploadingScreenState createState() => _UploadingScreenState();
}

class _UploadingScreenState extends State<UploadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: FutureBuilder<TaskSnapshot>(
          future:
              storageReference.uploadPicture(widget.file, widget.postModel.id),
          builder: (context, taskSnapshot) {
            if (taskSnapshot.hasError) {
              return MyCustomErrorWidget(taskSnapshot.error);
            }
            switch (taskSnapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Waiting for connection  "),
                    CircularProgressIndicator(),
                  ],
                );
                break;
              case ConnectionState.active:
                {
                  var currentProgress = taskSnapshot.data.bytesTransferred /
                      taskSnapshot.data.totalBytes;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Uploading Data  "),
                      CircularProgressIndicator(
                        value: currentProgress,
                      ),
                    ],
                  );
                }
                break;
              case ConnectionState.done:
                {
                  return FutureBuilder<String>(
                      future: taskSnapshot.data.ref.getDownloadURL(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return MyCustomErrorWidget(snapshot.error);
                        }
                        if (snapshot.connectionState == ConnectionState.done) {
                          widget.postModel.imageUrl = snapshot.data;
                          postCollection.addPost(widget.postModel);
                          return AuthScreen();
                        }
                        return LoadingWidget();
                      });
                }
                break;
            }
            return Text("none");
          },
        ),
      ),
    );
  }
}
