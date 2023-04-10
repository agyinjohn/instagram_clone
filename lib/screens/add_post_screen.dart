import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/pick_image_method.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/utils/post_method.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _descriptioncontroller = TextEditingController();
  Uint8List? _file;
  bool isLoading = false;
  @override
  void dispose() {
    _descriptioncontroller.dispose();
    super.dispose();
  }

  _postImage(String profileUrl, String uid, String username) async {
    String result = 'An error occured';
    setState(() {
      isLoading = true;
    });
    try {
      String result = await FireStoreMethods().upLoadPost(
          _descriptioncontroller.text.trim(),
          _file!,
          uid,
          username,
          profileUrl);

      if (result == 'Successful') {
        // ignore: use_build_context_synchronously
        showSnackBarAction(context, '✔   Posted');
        setState(() {
          isLoading = false;
        });
        clealPost();
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      // ignore: use_build_context_synchronously
      showSnackBarAction(context, result);
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Create a post'),
        children: [
          SimpleDialogOption(
            padding: const EdgeInsets.all(16),
            child: const Text('Take a photo'),
            onPressed: () async {
              Navigator.of(context).pop();
              Uint8List? file = await pickProfileImage(ImageSource.camera);
              setState(() {
                _file = file;
              });
            },
          ),
          SimpleDialogOption(
            padding: const EdgeInsets.all(16),
            child: const Text('Pick image from gallery'),
            onPressed: () async {
              Navigator.of(context).pop();
              Uint8List? file = await pickProfileImage(ImageSource.gallery);
              setState(() {
                _file = file;
              });
            },
          ),
          SimpleDialogOption(
            padding: const EdgeInsets.all(16),
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  clealPost() {
    setState(() {
      _file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Scaffold(
            body: Center(
              child: IconButton(
                  onPressed: () => _selectImage(context),
                  icon: const Icon(Icons.upload)),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBacgroundColor,
              leading: IconButton(
                onPressed: clealPost,
                icon: const Icon(
                  Icons.arrow_back,
                  color: primaryColor,
                ),
              ),
              title: const Text('Post To'),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () => _postImage(
                    user!.photoUrl,
                    user.uid,
                    user.username,
                  ),
                  child: const Text(
                    'Post',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                isLoading
                    ? const LinearProgressIndicator()
                    : Container(
                        padding: const EdgeInsets.only(top: 5, bottom: 10),
                      ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user!.photoUrl, scale: 2),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextField(
                        controller: _descriptioncontroller,
                        decoration: const InputDecoration(
                          hintText: 'Write a caption......',
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(_file!),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
  }
}
