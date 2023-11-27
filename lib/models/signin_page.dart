import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:side_navigation/side_navigation.dart';

import '../utils/routes.dart';

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  hintStyle: TextStyle(color: Colors.grey),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide:
        BorderSide(color: Color.fromARGB(255, 64, 255, 105), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

class GoogleSignIn extends StatefulWidget {
  const GoogleSignIn({Key? key}) : super(key: key);

  @override
  State<GoogleSignIn> createState() => _GoogleSignInState();
}

class _GoogleSignInState extends State<GoogleSignIn> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String? name, imageUrl, userEmail, uid;
  int selectedIndex = 0;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  List a = ['H', 'M'];
  final econtroller = TextEditingController();

  late final etext;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 250, 250),
      // Color.fromARGB(255, 248, 249, 249),
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Hamro Library - SignUP Page',
            style: TextStyle(
                color: Color.fromARGB(255, 248, 250, 250),
                // Color.fromARGB(255, 2, 76, 74),
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 91, 92, 138),
        // Color.fromARGB(255, 168, 166, 166),
      ),
      body: Row(
        children: [
          /// Pretty similar to the BottomNavigationBar!
          SideNavigationBar(
            selectedIndex: selectedIndex,
            items: const [
              SideNavigationBarItem(
                icon: Icons.dashboard,
                label: 'Home',
              ),
              SideNavigationBarItem(
                icon: Icons.login,
                label: 'SignUp/login',
              ),
            ],
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
              if (selectedIndex == 0) {
                Navigator.pushNamed(context, Myroutes.homeRoute);
              } else if (selectedIndex == 1) {
                Navigator.pushNamed(context, Myroutes.signin);
              }
            },
            theme: SideNavigationBarTheme(
              backgroundColor: const Color.fromARGB(255, 68, 68, 109),
              togglerTheme: SideNavigationBarTogglerTheme.standard(),
              itemTheme: SideNavigationBarItemTheme(
                  unselectedItemColor: Colors.white,
                  selectedItemColor: Colors.green,
                  labelTextStyle: const TextStyle(color: Colors.white)),
              dividerTheme: SideNavigationBarDividerTheme.standard(),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                const SizedBox(
                  width: 150,
                ),
                Column(
                  children: const [
                    SizedBox(
                      height: 250,
                    ),
                    Text(
                      'Hamro Library',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 65,
                          color: Color.fromARGB(255, 120, 122, 244)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Hamro Library help students to book a book in advance.',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 80,
                ),
                SizedBox(
                  height: 350,
                  width: 400,
                  child: Card(
                    elevation: 50,
                    shadowColor: Colors.black,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 13,
                        ),
                        const Text(
                          'Sign In',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              fontFamily: AutofillHints.countryName,
                              color: Color.fromARGB(255, 120, 122, 244)),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text('*If you already have a account Login'),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          child: Center(
                            child: InkWell(
                              onTap: () async {
                                await Firebase.initializeApp();
                                User? user;
                                FirebaseAuth auth = FirebaseAuth.instance;
                                // The `GoogleAuthProvider` can only be
                                // used while running on the web
                                GoogleAuthProvider authProvider =
                                    GoogleAuthProvider();

                                try {
                                  final UserCredential userCredential =
                                      await auth.signInWithPopup(authProvider);
                                  user = userCredential.user;

                                  if (user != null) {
                                    uid = user.uid;
                                    name = user.displayName;
                                    userEmail = user.email;
                                    imageUrl = user.photoURL;

                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setBool('auth', true);
                                    print("name: $name");
                                    print("userEmail: $userEmail");
                                    print("imageUrl: $imageUrl");
                                  }

                                  if (userEmail ==
                                      'pratikbastakoti59@gmail.com') {
                                    Navigator.pushNamed(
                                        context, Myroutes.homeroute_admin);
                                  } else {
                                    Navigator.pushNamed(
                                        context, Myroutes.homeroute_al);
                                  }
                                } catch (e) {
                                  print(e);
                                }
                              },
                              child: Container(
                                // color: Colors.amber,

                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.greenAccent,
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 120, 254, 2)),
                                    borderRadius: BorderRadius.circular(20)),
                                child: const Text('Sign In with Goolge'),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        const Text(
                          'Sign Up',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              fontFamily: AutofillHints.countryName,
                              color: Color.fromARGB(255, 120, 122, 244)),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text('*If you donot have a account SignUp'),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          // height: size.height,
                          // width: size.width,
                          child: Center(
                            child: InkWell(
                              onTap: () async {
                                await Firebase.initializeApp();
                                User? user;
                                FirebaseAuth auth = FirebaseAuth.instance;
                                // The `GoogleAuthProvider` can only be
                                // used while running on the web
                                GoogleAuthProvider authProvider =
                                    GoogleAuthProvider();

                                try {
                                  final UserCredential userCredential =
                                      await auth.signInWithPopup(authProvider);
                                  user = userCredential.user;

                                  if (user != null) {
                                    uid = user.uid;
                                    name = user.displayName;
                                    userEmail = user.email;
                                    imageUrl = user.photoURL;

                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setBool('auth', true);
                                    print("name: $name");
                                    print("userEmail: $userEmail");
                                    print("imageUrl: $imageUrl");
                                  }

                                  users.doc(userEmail).set({
                                    'uid': uid,
                                    'firstname': name,
                                    'imageurl': imageUrl,
                                    'email': userEmail,
                                    'booked_book': 0,
                                    'booked_book_id1': '',
                                    'booked_book_id2': '',
                                    'booked_book_id3': '',
                                    'issued_book1': '',
                                    'issued_book2': '',
                                    'issued_book3': '',
                                  });

                                  Navigator.pushNamed(
                                      context, Myroutes.homeroute_al);
                                  // }
                                } catch (e) {
                                  print(e);
                                }
                              },
                              child: Container(
                                // color: Colors.amber,

                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.greenAccent,
                                    border: Border.all(
                                        color:
                                            Color.fromARGB(255, 120, 254, 2)),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text('Sign Up with Google'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void signOutGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    GoogleAuthProvider authProvider = GoogleAuthProvider();
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await auth.signOut();
    // await authProvider.s

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('auth', false);

    uid = null;
    name = null;
    userEmail = null;
    imageUrl = null;

    print("User signed out of Google account");
  }
}
