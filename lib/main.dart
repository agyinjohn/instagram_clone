import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/responsive/responsive_layout_screen.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/screens/mobile_screen.dart';
import 'package:instagram_clone/screens/web_screen.dart';

import 'package:instagram_clone/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: 'AIzaSyAtJSKyOxqBUVhx2El01uidMn3iJ5uteIU',
            appId: '1:25547990004:web:aa6f26cdd59f2afb0f0fa1',
            messagingSenderId: '25547990004',
            projectId: 'instagram-clone-edb2c',
            storageBucket: 'instagram-clone-edb2c.appspot.com'));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: webBackgroundColor,
        ),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshhot) {
              if (snapshhot.connectionState == ConnectionState.active) {
                if (snapshhot.hasData) {
                  return const ResponsiveScreen(
                      mobileScreen: MobileScreen(), webScreen: WebScreen());
                } else if (snapshhot.hasError) {
                  return const Scaffold(
                    body: Center(
                      child: Text("Please an error occured"),
                    ),
                  );
                }
              }
              if (snapshhot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(
                  color: Colors.white,
                );
              }
              return const LoginScreen();
            }),
      ),
    );
  }
}
