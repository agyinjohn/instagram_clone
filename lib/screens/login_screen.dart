import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instagram_clone/screens/home_screen.dart';
import 'package:instagram_clone/screens/signup_screen.dart';
import 'package:instagram_clone/utils/global_variables.dart';
import 'package:instagram_clone/utils/pick_image_method.dart';
import 'package:instagram_clone/utils/sign_up_method.dart';
import '../responsive/responsive_layout_screen.dart';
import '../utils/colors.dart';
import '../widgets/text_field.dart';
import '../screens/web_screen.dart';
import '../screens/mobile_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController passwordTextEditingController =
      TextEditingController();
  bool isloading = false;

  Future<String> logUserIn() async {
    setState(() {
      isloading = true;
    });
    final result = await Authentication().loginUser(
        passwordTextEditingController.text.trim(),
        emailTextEditingController.text.trim());

    setState(() {
      isloading = false;
    });
    if (result == 'Successfull') {
      Fluttertoast.showToast(msg: result);
      print(result);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveScreen(
              mobileScreen: MobileScreen(), webScreen: WebScreen())));
    } else {
      // ignore: use_build_context_synchronously
      showSnackBarAction(context, result);
    }
    return result;
  }

  @override
  void dispose() {
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        padding: MediaQuery.of(context).size.width > webScreenSize
            ? EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 3)
            : const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: Container(),
            ),
            // ignore: deprecated_member_use
            SvgPicture.asset('assets/ic_instagram.svg', color: primaryColor),
            const SizedBox(
              height: 64,
            ),
            TextFieldInput(
                textEditingController: emailTextEditingController,
                textInputType: TextInputType.emailAddress,
                hintText: 'Enter email'),
            const SizedBox(
              height: 25,
            ),
            TextFieldInput(
              textEditingController: passwordTextEditingController,
              textInputType: TextInputType.text,
              hintText: 'Enter password',
              isPass: true,
            ),
            const SizedBox(
              height: 25,
            ),
            InkWell(
              onTap: logUserIn,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  color: blueColor,
                ),
                child: isloading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text('Log in'),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Flexible(
              flex: 2,
              child: Container(),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const SignUpScreen(),
                  ),
                );
              },
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      child: const Text(
                        'Don\'t have an account?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
