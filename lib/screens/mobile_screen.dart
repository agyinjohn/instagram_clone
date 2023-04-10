import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/utils/global_variables.dart';
import '../models/user_model.dart';
import 'package:provider/provider.dart';
import '../utils/colors.dart';
import './add_post_screen.dart';

import 'package:flutter/cupertino.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({Key? key}) : super(key: key);

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  int _page = 0;
  bool isLoading = false;
  User? user;
  late PageController _pageController;
  void navigationTap(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  void changePage(int page) {
    setState(() {
      _page = page;
    });
  }

  loadUserData() {
    try {
      setState(() {
        isLoading = true;
      });
      user = Provider.of<UserProvider>(context).getUser;

      setState(() {
        isLoading = false;
      });
      print(user!.username);
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print(" err:${error.toString()}");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadUserData();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final User? user = Provider.of<UserProvider>(context).getUser;

    return user == null
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
            body: PageView(
                onPageChanged: changePage,
                controller: _pageController,
                // physics: const NeverScrollableScrollPhysics(),
                children: homePageItems),
            bottomNavigationBar: CupertinoTabBar(
              backgroundColor: mobileBacgroundColor,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                      color: _page == 0 ? primaryColor : secondaryColor,
                    ),
                    label: '',
                    backgroundColor: primaryColor),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.search,
                      color: _page == 1 ? primaryColor : secondaryColor,
                    ),
                    label: '',
                    backgroundColor: primaryColor),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.add_circle,
                      color: _page == 2 ? primaryColor : secondaryColor,
                    ),
                    label: '',
                    backgroundColor: primaryColor),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.favorite,
                      color: _page == 3 ? primaryColor : secondaryColor,
                    ),
                    label: '',
                    backgroundColor: primaryColor),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person,
                      color: _page == 4 ? primaryColor : secondaryColor,
                    ),
                    label: '',
                    backgroundColor: primaryColor),
              ],
              onTap: navigationTap,
            ),
          );
  }
}
