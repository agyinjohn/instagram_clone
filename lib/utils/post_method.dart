import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/utils/storage_method.dart';
import '../models/post.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<String> upLoadPost(String description, Uint8List? file, String uid,
      String username, String profilUrl) async {
    String result = 'Some error occured';
    try {
      final String photoUrl =
          await ImageStorage().uploadeImageToStorage(file!, true, 'posts');
      String postId = const Uuid().v1();
      Post post = Post(
          dataPublished: DateTime.now(),
          description: description,
          likes: [],
          photoUrl: photoUrl,
          uid: uid,
          profileUrl: profilUrl,
          postId: postId,
          username: username);
      await _firebaseFirestore
          .collection('posts')
          .doc(postId)
          .set(post.toJson());
      result = 'Successful';
    } catch (error) {
      result = 'failed';
      print(error.toString());
    }
    return result;
  }

  Future<void> postLikes(
      {required String uid,
      required String postId,
      required List likes}) async {
    if (likes.contains(uid)) {
      _firebaseFirestore.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayRemove([uid])
      });
    } else {
      _firebaseFirestore.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayUnion(
          [uid],
        ),
      });
    }
  }

  Future<void> postComment(
    String description,
    String postId,
    String uid,
    String profileImage,
    String username,
  ) async {
    if (description.isNotEmpty) {
      try {
        String commentId = const Uuid().v1();
        await _firebaseFirestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profileImage,
          'username': username,
          'text': description,
          'uid': uid,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
      } catch (err) {
        print(err.toString());
      }
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firebaseFirestore.collection('posts').doc(postId).delete();
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> followingUser(String uid, String followingUid) async {
    try {
      DocumentSnapshot snap =
          await _firebaseFirestore.collection('users').doc(uid).get();

      List following = (snap.data()! as dynamic)['following'];
      if (following.contains(followingUid)) {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followingUid]),
        });
        await FirebaseFirestore.instance
            .collection('users')
            .doc(followingUid)
            .update({
          'followers': FieldValue.arrayRemove([uid]),
        });
      } else {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followingUid])
        });
        await FirebaseFirestore.instance
            .collection('users')
            .doc(followingUid)
            .update({
          'followers': FieldValue.arrayUnion([uid])
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }
}
