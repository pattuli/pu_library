import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pu_library/utils/routes.dart';
import 'package:pu_library/models/users.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pu_library/widgets/rounded_button.dart';
import 'package:side_navigation/side_navigation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/services.dart';

//code for designing the UI of our text field where the user writes his email id or password

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

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool isSignIn = false;
  bool google = false;
  late String email;
  late String password;
  late String firstname;
  late String lastname;
  bool showSpinner = false;
  int selectedIndex = 0;
  String? name, imageUrl, userEmail, uid;
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'PU_Library',
            style: TextStyle(
                color: Color.fromARGB(255, 2, 76, 74),
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 168, 166, 166),
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
                label: 'Login',
              ),
              SideNavigationBarItem(
                icon: Icons.add_circle,
                label: 'SignUp',
              ),
            ],
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
              if (selectedIndex == 0) {
                Navigator.pushNamed(context, Myroutes.homeRoute);
              } else if (selectedIndex == 1) {
                Navigator.pushNamed(context, Myroutes.loginRoute);
              } else if (selectedIndex == 2) {
                Navigator.pushNamed(context, Myroutes.signUp);
              }
            },
            theme: SideNavigationBarTheme(
              backgroundColor: const Color.fromARGB(255, 102, 99, 99),
              togglerTheme: SideNavigationBarTogglerTheme.standard(),
              itemTheme: SideNavigationBarItemTheme.standard(),
              dividerTheme: SideNavigationBarDividerTheme.standard(),
            ),
          ),
          Expanded(
            child: ModalProgressHUD(
              inAsyncCall: showSpinner,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children:
                      // Text('Please SingUp to enter Hamro Library');
                      <Widget>[
                    const Center(
                        child: Text(
                      'SignUp',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    )),
                    const SizedBox(
                      height: 30,
                    ),
                    TextField(
                        keyboardType: TextInputType.emailAddress,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          firstname = value;
                          //Do something with the user input.
                        },
                        decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter your first name',
                            label: const Text('Firstname'))),
                    const SizedBox(
                      height: 8.0,
                    ),
                    TextField(
                        keyboardType: TextInputType.emailAddress,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          lastname = value;
                          //Do something with the user input.
                        },
                        decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter your last name',
                            label: const Text('Lastname'))),
                    const SizedBox(
                      height: 8.0,
                    ),
                    TextField(
                        keyboardType: TextInputType.emailAddress,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          email = value;
                          //Do something with the user input.
                        },
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter your email',
                          label: const Text('Email'),
                        )),
                    const SizedBox(
                      height: 8.0,
                    ),
                    TextField(
                        obscureText: true,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          password = value;
                          //Do something with the user input.
                        },
                        decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter your Password',
                            label: const Text('Password'))),
                    const SizedBox(
                      height: 24.0,
                    ),
                    RoundedButton(
                      colour: Colors.blueAccent,
                      title: 'Register',
                      onPressed: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          final newUser =
                              await _auth.createUserWithEmailAndPassword(
                                  email: email, password: password);
                          if (newUser != null) {
                            final user = FirebaseAuth.instance.currentUser;
                            if (user != null) {
                              final uid = user.uid;
                            }
                            users.doc(user?.uid).set({
                              'firstname': firstname,
                              'lastname': lastname,
                              'email': email,
                              'booked_book': 0,
                              'booked_book_id1': '',
                              'booked_book_id2': '',
                              'booked_book_id3': '',
                            });

                            // users.add({
                            //   'uid': user?.uid,
                            //   'email': email,
                            //   'booked_book': 0,
                            //   'booked_book_id1': '',
                            //   'booked_book_id2': '',
                            //   'booked_book_id3': '',
                            // });
                            Navigator.pushNamed(context, Myroutes.loginRoute);
                          }
                        } catch (e) {
                          print(e);
                        }

                        setState(() {
                          showSpinner = false;
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
