import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/screens/feed_page.dart';
import 'package:instagram_clone/screens/search_screen.dart';

import '../screens/add_post_screen.dart';
import 'package:flutter/material.dart';

import '../screens/profile_screen.dart';

const webScreenSize = 600;

List<Widget> homePageItems = [
  const FeedPage(),
  const SearchScreen(),
  const AddPostScreen(),
  const SelectableText('This is page three'),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];
