import 'package:college_gram/firebase/users/user_model.dart';
import 'package:college_gram/screens/main/uploading_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:uuid/uuid.dart';

import '../../firebase/posts/post_model.dart';

var uuid = Uuid();

enum PictureMode { camera, gallery }

class UploadScreen extends StatefulWidget {
  final UserModel currentUser;
  UploadScreen(this.currentUser);
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  String id;

  PickedFile _imageFile;
  dynamic _pickImageError;
  String _retrieveDataError;

  final ImagePicker _picker = ImagePicker();

  final _uploadFormKey = GlobalKey<FormState>();
  final captionEditTextController = TextEditingController();

  @override
  void initState() {
    id = uuid.v1();
    super.initState();
  }

  void navigateToUploadingScreen() {
    PostModel postModel = PostModel(
        id: id,
        owner: widget.currentUser.id,
        imageUrl: "",
        caption: captionEditTextController.text);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                UploadingScreen(File(_imageFile.path), postModel)));
  }

  Future<void> retrieveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      _retrieveDataError = response.exception.code;
    }
  }

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _picker.getImage(
        source: source,
        maxWidth: 400.0,
        maxHeight: 400.0,
      );
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Upload Screen"),
        centerTitle: true,
      ),
      body: Form(
        key: _uploadFormKey,
        child: ListView(
          padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
          children: <Widget>[
            imagePickerWidget,
            TextFormField(
              controller: captionEditTextController,
              decoration: InputDecoration(
                  hintText: "Enter caption", labelText: "Caption"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            Container(
              margin: EdgeInsets.only(top: 30.0),
              padding: EdgeInsets.symmetric(
                  vertical: 1.0,
                  horizontal: MediaQuery.of(context).size.width * 0.2),
              child: ElevatedButton(
                onPressed: () {
                  print(_imageFile.path.isEmpty);
                  if (_uploadFormKey.currentState.validate() &&
                      _imageFile.path.isNotEmpty) {
                    navigateToUploadingScreen();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Complete missing fields')));
                  }
                },
                child: Text('Upload'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get imagePickerWidget => FutureBuilder<void>(
        future: retrieveLostData(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return imageBuilderLayout;
            case ConnectionState.done:
              return _previewImage();
            default:
              if (snapshot.hasError) {
                return Text(
                  'Pick image/video error: ${snapshot.error}}',
                  textAlign: TextAlign.center,
                );
              } else {
                return imageBuilderLayout;
              }
          }
        },
      );

  Widget get imageBuilderLayout => Container(
        child: ElevatedButton(
          child: Text("Press"),
          onPressed: () => promptToSelect(),
        ),
      );

  Widget _previewImage() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile != null) {
      return Semantics(
          child: Image.file(
            File(_imageFile.path),
            height: 400.0,
            width: 400.0,
          ),
          label: 'image_picker_example_picked_image');
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return GestureDetector(
        onTap: () => promptToSelect(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width * 0.6,
          margin: EdgeInsets.all(50.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black26,
          ),
          child: Icon(
            Icons.add_a_photo_rounded,
            color: Colors.white,
            size: 50.0,
          ),
        ),
      );
    }
  }

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Future<void> promptToSelect() async {
    switch (await showDialog<PictureMode>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select Image from:'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, PictureMode.camera);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.camera_enhance_rounded),
                    Text("   "),
                    Text('Camera'),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, PictureMode.gallery);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.collections),
                    Text("   "),
                    Text('Gallery'),
                  ],
                ),
              ),
            ],
          );
        })) {
      case PictureMode.camera:
        // Let's go.
        _onImageButtonPressed(ImageSource.camera, context: context);
        print("Camera selected");
        // ...
        break;
      case PictureMode.gallery:
        // ...
        _onImageButtonPressed(ImageSource.gallery, context: context);
        print("Gallery selected");
        break;
      default:
        print("None selected");
    }
  }
}
