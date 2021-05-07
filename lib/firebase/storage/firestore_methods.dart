import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageReference {
  Reference storageReference =
      FirebaseStorage.instance.ref().child('Uploaded Pictures');

  Future<TaskSnapshot> uploadPicture(File file, String id) =>
      storageReference.child("uploaded_$id.jpg").putFile(file);
}
