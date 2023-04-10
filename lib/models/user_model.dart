import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String username;
  final String photoUrl;
  final String bio;
  final String uid;
  final List followers;
  final List following;
  const User(
      {required this.bio,
      required this.email,
      required this.followers,
      required this.following,
      required this.photoUrl,
      required this.uid,
      required this.username});

  Map<String, dynamic> toJson() => {
        'username': username,
        'userbio': bio,
        'email': email,
        'uid': uid,
        'photoUrl': photoUrl,
        'followers': [],
        'following': [],
      };

  static User fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;

    return User(
        bio: snap['userbio'],
        email: snap['email'],
        followers: snap['followers'],
        following: snap['following'],
        photoUrl: snap['photoUrl'],
        uid: snap['uid'],
        username: snap['username']);
  }
}
