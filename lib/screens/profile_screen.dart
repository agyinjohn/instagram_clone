import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';

import '../utils/post_method.dart';
import '../widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({required this.uid, super.key});
  final uid;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int following = 0;
  int followers = 0;
  int len = 0;
  bool isfollowing = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      var postlength = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      len = postlength.docs.length;
      userData = userSnap.data()!;
      isfollowing = userData['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      followers = userData['followers'].length;
      following = userData['following'].length;
      isLoading = false;
      setState(
        () {},
      );
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBacgroundColor,
              title: Text(userData['username']),
            ),
            body: ListView(children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 40,
                          backgroundImage: NetworkImage(
                            userData['photoUrl'],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                columnWidget(len, 'posts'),
                                // const SizedBox(
                                //   width: 8,
                                // ),
                                columnWidget(followers, 'followers'),
                                // const SizedBox(
                                //   width: 8,
                                // ),
                                columnWidget(following, 'following')
                              ],
                            ),
                            FirebaseAuth.instance.currentUser!.uid == widget.uid
                                ? FollowButton(
                                    borderColor: Colors.grey,
                                    text: 'Edit Profile',
                                    textColor: primaryColor,
                                    backgroundColor: mobileBacgroundColor,
                                    funtion: () {},
                                  )
                                : isfollowing
                                    ? FollowButton(
                                        borderColor: Colors.grey,
                                        text: 'Unfollow',
                                        textColor: primaryColor,
                                        backgroundColor: mobileBacgroundColor,
                                        funtion: () async {
                                          await FireStoreMethods()
                                              .followingUser(
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid,
                                                  widget.uid);
                                          setState(() {
                                            isfollowing = false;
                                            followers--;
                                          });
                                        },
                                      )
                                    : FollowButton(
                                        borderColor: Colors.grey,
                                        text: 'Follow',
                                        textColor: primaryColor,
                                        backgroundColor: mobileBacgroundColor,
                                        funtion: () async {
                                          await FireStoreMethods()
                                              .followingUser(
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid,
                                                  widget.uid);
                                          setState(() {
                                            isfollowing = true;
                                            followers++;
                                          });
                                        },
                                      )
                          ]),
                        )
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 15),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        userData['username'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 1),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        userData['userbio'],
                      ),
                    ),
                    const Divider(),
                    FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('posts')
                            .where('uid', isEqualTo: widget.uid)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return GridView.builder(
                              itemCount:
                                  (snapshot.data! as dynamic).docs.length,
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: 1,
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 1.5),
                              itemBuilder: (context, index) {
                                var snap =
                                    (snapshot.data! as dynamic).docs[index];
                                return Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Image(
                                    image: NetworkImage(snap['photoUrl']),
                                    fit: BoxFit.cover,
                                  ),
                                );
                              });
                        })
                  ],
                ),
              ),
            ]),
          );
  }

  Column columnWidget(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
