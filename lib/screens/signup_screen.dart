import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../utils/colors.dart';
import '../utils/pick_image_method.dart';
import '../utils/sign_up_method.dart';
import '../widgets/text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var userProfile =
      'https://th.bing.com/th?id=OIP.nTK-yAWL01laY6CKjMEq3gHaHa&w=250&h=250&c=8&rs=1&qlt=90&o=6&pid=3.1&rm=2';

  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController passwordTextEditingController =
      TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  Uint8List? image;
  bool isLoading = false;

  selectProfileImage() async {
    Uint8List selectedProfile = await pickProfileImage(ImageSource.gallery);
    setState(() {
      image = selectedProfile;
    });
  }

  Future<String> signUpUser(BuildContext ctx) async {
    setState(() {
      isLoading = true;
    });
    final res = await Authentication().signUp(
      username: userNameController.text.trim(),
      userbio: bioController.text.trim(),
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),
      file: image,
    );

    if (res == "Succesfull Sign up") {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
          msg: res, backgroundColor: Colors.grey, textColor: Colors.white);
    } else {
      setState(() {
        isLoading = false;
      });
      // ignore: use_build_context_synchronously
      showSnackBarAction(ctx, res);
    }
    return res;
  }

  @override
  void dispose() {
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    userNameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        width: size.width,
        height: size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: Container(),
            ),
            // ignore: deprecated_member_use
            // SvgPicture.asset('assets/ic_instagram.svg', color: primaryColor),
            Image.asset(
              'assets/apex1.png',
              height: 120,
              width: 250,
            ),
            const SizedBox(
              height: 20,
            ),
            Stack(children: [
              image != null
                  ? CircleAvatar(
                      radius: 64,
                      backgroundImage: MemoryImage(image!),
                    )
                  : CircleAvatar(
                      radius: 64,
                      backgroundImage: NetworkImage(userProfile, scale: 3),
                    ),
              // Container(
              //   decoration: const BoxDecoration(
              //     image: DecorationImage(
              //         image: AssetImage('assets/profile.png'),
              //         fit: BoxFit.fill),
              //   ),
              // ),
              Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    icon: const Icon(Icons.add_a_photo),
                    onPressed: () => selectProfileImage(),
                  ))
            ]),
            const SizedBox(
              height: 25,
            ),
            TextFieldInput(
                textEditingController: userNameController,
                textInputType: TextInputType.text,
                hintText: 'Enter your username'),
            const SizedBox(
              height: 20,
            ),
            TextFieldInput(
                textEditingController: emailTextEditingController,
                textInputType: TextInputType.emailAddress,
                hintText: 'Enter your email'),
            const SizedBox(
              height: 20,
            ),
            TextFieldInput(
              textEditingController: passwordTextEditingController,
              textInputType: TextInputType.text,
              hintText: 'Enter your password',
              isPass: true,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFieldInput(
                textEditingController: bioController,
                textInputType: TextInputType.text,
                hintText: 'Enter your bio'),
            const SizedBox(
              height: 20,
            ),

            InkWell(
              onTap: () => signUpUser(context),
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
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text('Sign In'),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            // Flexible(
            //   flex: 2,
            //   child: Container(),
            // ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ));
              },
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      child: const Text(
                        'Already Have An Account?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text('Sign In'),
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
