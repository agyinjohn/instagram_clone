import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String username;
  final String photoUrl;
  final dataPublished;
  final String uid;
  final String profileUrl;

  final String postId;
  final likes;
  const Post(
      {required this.dataPublished,
      required this.description,
      required this.likes,
      required this.photoUrl,
      required this.uid,
      required this.profileUrl,
      required this.postId,
      required this.username});

  Map<String, dynamic> toJson() => {
        'username': username,
        'postId': postId,
        'uid': uid,
        'photoUrl': photoUrl,
        'likes': likes,
        'profileUrl': profileUrl,
        'datePublished': dataPublished,
        'description': description
      };
  static Post fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return Post(
        dataPublished: snap['datePublished'],
        description: snap['description'],
        likes: snap['likes'],
        photoUrl: snap['photoUrl'],
        uid: snap['uid'],
        profileUrl: snap['profileUrl'],
        postId: snap['postId'],
        username: snap['username']);
  }
}
