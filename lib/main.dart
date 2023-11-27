import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pu_library/models/signin_page.dart';
import 'package:pu_library/views/admin_panel.dart';
import 'package:pu_library/views/home_page.dart';
import 'package:pu_library/views/home_page_admin.dart';
import 'package:pu_library/views/home_page_al.dart';
import 'package:pu_library/views/login_page.dart';
// import 'package:pu_library/views/random.dart';
import 'package:pu_library/views/signup_page1.dart';
import 'package:pu_library/utils/routes.dart';
import 'package:pu_library/views/user_account.dart';
import 'package:pu_library/views/user_view_page.dart';
import 'package:pu_library/models/values.dart';
// import 'package:pu_library/widgets/user_widget.dart';

void main() async {
  final value = new values();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "Your API Key",
    authDomain: "Your Auth Domain",
    projectId: "Your ProjectId",
    messagingSenderId: "Your MessagingsenderId",
    appId: "Your AppId",
    storageBucket: "Your Storage Bucket",
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hamro Library',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      initialRoute: Myroutes.homeRoute,
      routes: {
        // "/": (context) => Loginpage(),
        Myroutes.homeRoute: (context) => HomePage(),
        Myroutes.loginRoute: (context) => LoginScreen(),
        Myroutes.signUp: (context) => RegistrationScreen(),
        Myroutes.adminPanel: (context) => Adminpanel(),
        Myroutes.homeroute_al: (context) => HomePage_al(),
        Myroutes.user_view: (context) => User_view(),
        Myroutes.user_account: (context) => User_account(),
        Myroutes.homeroute_admin: (context) => HomePage_admin(),
        Myroutes.signin: (context) => GoogleSignIn(),
      },
    );
  }
}
