import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../providers/user_provider.dart';
import '../utils/post_method.dart';
import '../widgets/comment_card.dart';

class CommentScreen extends StatefulWidget {
  final postId;
  const CommentScreen({required this.postId, super.key});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _textController = TextEditingController();
    User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBacgroundColor,
        title: const Text(
          'Comments',
          style: TextStyle(color: primaryColor),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .doc(widget.postId)
              .collection('comments')
              .orderBy(
                'datePublished',
                descending: true,
              )
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return CommentCard(
                    snap: snapshot.data!.docs[index],
                  );
                },
              );
            }
          }),
      bottomNavigationBar: SafeArea(
          child: Container(
        height: kToolbarHeight,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: const EdgeInsets.only(right: 8, left: 16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(user!.photoUrl),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8, left: 16),
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: 'Comment as  ${user.username}',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await FireStoreMethods().postComment(
                    _textController.text.trim(),
                    widget.postId,
                    user.uid,
                    user.photoUrl,
                    user.username);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: const Text(
                  'Post',
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
