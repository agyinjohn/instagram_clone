import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class ImageStorage {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadeImageToStorage(
      Uint8List? file, bool isPost, String childName) async {
    Reference reference =
        _firebaseStorage.ref().child(childName).child(_auth.currentUser!.uid);
    if (isPost) {
      String id = const Uuid().v1();
      reference = reference.child(id);
    }
    UploadTask task = reference.putData(file!);
    TaskSnapshot snapshot = await task;

    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
