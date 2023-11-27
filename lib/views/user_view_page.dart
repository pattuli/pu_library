import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:side_navigation/side_navigation.dart';

import '../models/signin_page.dart';
import '../utils/routes.dart';

class User_view extends StatefulWidget {
  const User_view({super.key});

  @override
  State<User_view> createState() => User_viewState();
}

class User_viewState extends State<User_view> {
  final Stream<QuerySnapshot> _readuser =
      FirebaseFirestore.instance.collection('users').snapshots();

  int selectedIndex = 0;

  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final user = FirebaseAuth.instance.currentUser;
  var value;
  String? name, imageUrl, userEmail, uid;
  @override
  Widget build(BuildContext context) {
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
      Navigator.pushNamed(context, Myroutes.signin);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Hamro Library - User View Page',
            style: TextStyle(
                color: Color.fromARGB(255, 248, 250, 250),
                // Color.fromARGB(255, 2, 76, 74),
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 91, 92, 138),
        // Color.fromARGB(255, 168, 166, 166),
      ),
      body: Row(
        children: [
          /// Pretty similar to the BottomNavigationBar!
          SideNavigationBar(
            selectedIndex: selectedIndex,
            items: const [
              SideNavigationBarItem(
                icon: Icons.verified_user,
                label: 'Admin',
              ),
              SideNavigationBarItem(
                icon: Icons.dashboard,
                label: 'Home',
              ),
              SideNavigationBarItem(
                icon: Icons.admin_panel_settings_rounded,
                label: 'Admin Panel',
              ),
              SideNavigationBarItem(
                icon: Icons.view_agenda,
                label: 'View User',
              ),
              SideNavigationBarItem(
                icon: Icons.logout,
                label: 'SignOut',
              ),
            ],
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
              if (selectedIndex == 1) {
                Navigator.pushNamed(context, Myroutes.homeroute_admin);
              } else if (selectedIndex == 2) {
                Navigator.pushNamed(context, Myroutes.adminPanel);
              } else if (selectedIndex == 3) {
                Navigator.pushNamed(context, Myroutes.user_view);
              } else if (selectedIndex == 4) {
                signOutGoogle();
              }
            },
            theme: SideNavigationBarTheme(
              backgroundColor: const Color.fromARGB(255, 68, 68, 109),
              // Color.fromARGB(255, 102, 99, 99),
              togglerTheme: SideNavigationBarTogglerTheme.standard(),
              // itemTheme: SideNavigationBarItemTheme.standard(),
              itemTheme: SideNavigationBarItemTheme(
                  unselectedItemColor: Colors.white,
                  selectedItemColor: Colors.green,
                  labelTextStyle: TextStyle(color: Colors.white)),
              dividerTheme: SideNavigationBarDividerTheme.standard(),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _readuser,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Text("Loading"));
                }
                const SizedBox(
                  height: 20,
                );

                return ListView(
                  children: snapshot.data!.docs.map(
                    (DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      const Text('User View');

                      return Table(
                        defaultColumnWidth: const FixedColumnWidth(30.0),
                        border: TableBorder.all(
                            color: Colors.black,
                            style: BorderStyle.solid,
                            width: 1),
                        children: [
                          TableRow(children: [
                            Column(children: const [
                              Center(
                                child: Text(
                                  'Username',
                                  style: TextStyle(fontSize: 15.0),
                                ),
                              ),
                            ]),
                            Column(children: const [
                              Center(
                                child: Text('Booked Books',
                                    style: TextStyle(fontSize: 15.0)),
                              )
                            ]),
                            Column(children: const [
                              Center(
                                child: Text('Remove Booking',
                                    style: TextStyle(fontSize: 15.0)),
                              )
                            ]),
                            Column(children: const [
                              Center(
                                child: Text('Issue Books',
                                    style: TextStyle(fontSize: 15.0)),
                              )
                            ]),
                            Column(children: const [
                              Center(
                                child: Text('Issued Books',
                                    style: TextStyle(fontSize: 15.0)),
                              )
                            ]),
                            Column(children: const [
                              Center(
                                child: Text('Remove_Issued_Books',
                                    style: TextStyle(fontSize: 15.0)),
                              )
                            ]),
                          ]),
                          TableRow(children: [
                            Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  data['firstname'].toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                FloatingActionButton.extended(
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(data['email'])
                                        .delete();
                                  },
                                  shape: const BeveledRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  backgroundColor: Colors.red,
                                  label: const Text('Delete User'),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                    '1. ${data['booked_book_id1'].toString()}'),
                                Text(
                                    'Date:[ ${data['booked_book_id1_time'].toString()}]'),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text('2.${data['booked_book_id2'].toString()}'),
                                Text(
                                    'Date: [ ${data['booked_book_id2_time'].toString()}]'),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text('3.${data['booked_book_id3'].toString()}'),
                                Text(
                                    'Date: [ ${data['booked_book_id3_time'].toString()}]'),
                              ],
                            ),
                            Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: SizedBox(
                                    height: 30,
                                    width: 150,
                                    child: FloatingActionButton(
                                      onPressed: () async {
                                        var variable = await FirebaseFirestore
                                            .instance
                                            .collection('users')
                                            .doc(data['email'])
                                            .get();
                                        print(variable['booked_book']);
                                        // value = variable['booked_book'];
                                        if (variable['booked_book'] == 3) {
                                          users.doc(data['email']).update({
                                            'booked_book': 2,
                                          });
                                        } else if (variable['booked_book'] ==
                                            2) {
                                          users.doc(data['email']).update({
                                            'booked_book': 1,
                                          });
                                        } else if (variable['booked_book'] ==
                                            1) {
                                          users.doc(data['email']).update({
                                            'booked_book': 0,
                                          });
                                        }
                                        users.doc(data['email']).update({
                                          'booked_book_id1': '',
                                        });
                                        users.doc(data['email']).update({
                                          'booked_book_id1_time': '',
                                        });
                                      },
                                      shape: const BeveledRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(0))),
                                      backgroundColor: Colors.red,
                                      child: const Text('Remove1'),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: SizedBox(
                                    height: 30,
                                    width: 150,
                                    child: FloatingActionButton(
                                      onPressed: () async {
                                        var variable = await FirebaseFirestore
                                            .instance
                                            .collection('users')
                                            .doc(data['email'])
                                            .get();
                                        print(variable['booked_book']);
                                        if (variable['booked_book'] == 3) {
                                          users.doc(data['email']).update({
                                            'booked_book': 2,
                                          });
                                        } else if (variable['booked_book'] ==
                                            2) {
                                          users.doc(data['email']).update({
                                            'booked_book': 1,
                                          });
                                        } else if (variable['booked_book'] ==
                                            1) {
                                          users.doc(data['email']).update({
                                            'booked_book': 0,
                                          });
                                        }
                                        users.doc(data['email']).update({
                                          'booked_book_id2': '',
                                        });
                                        users.doc(data['email']).update({
                                          'booked_book_id2_time': '',
                                        });
                                      },
                                      shape: const BeveledRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(0))),
                                      backgroundColor: Colors.red,
                                      child: const Text('Remove2'),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: SizedBox(
                                    height: 30,
                                    width: 150,
                                    child: FloatingActionButton(
                                      onPressed: () async {
                                        var variable = await FirebaseFirestore
                                            .instance
                                            .collection('users')
                                            .doc(data['email'])
                                            .get();
                                        print(variable['booked_book']);
                                        if (variable['booked_book'] == 3) {
                                          users.doc(data['email']).update({
                                            'booked_book': 2,
                                          });
                                        } else if (variable['booked_book'] ==
                                            2) {
                                          users.doc(data['email']).update({
                                            'booked_book': 1,
                                          });
                                        } else if (variable['booked_book'] ==
                                            1) {
                                          users.doc(data['email']).update({
                                            'booked_book': 0,
                                          });
                                        }

                                        users.doc(data['email']).update({
                                          'booked_book_id3': '',
                                        });
                                        users.doc(data['email']).update({
                                          'booked_book_id3_time': '',
                                        });
                                      },
                                      shape: const BeveledRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(0))),
                                      backgroundColor: Colors.red,
                                      child: const Text('Remove3'),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: SizedBox(
                                    height: 30,
                                    width: 150,
                                    child: FloatingActionButton(
                                      onPressed: () async {
                                        var variable = await FirebaseFirestore
                                            .instance
                                            .collection('users')
                                            .doc(data['email'])
                                            .get();
                                        print(variable['booked_book']);
                                        // value = variable['booked_book'];
                                        if (variable['booked_book'] == 3) {
                                          users.doc(data['email']).update({
                                            'booked_book': 2,
                                          });
                                        } else if (variable['booked_book'] ==
                                            2) {
                                          users.doc(data['email']).update({
                                            'booked_book': 1,
                                          });
                                        } else if (variable['booked_book'] ==
                                            1) {
                                          users.doc(data['email']).update({
                                            'booked_book': 0,
                                          });
                                        }
                                        if (variable['booked_book_id1'] == '') {
                                          final snackBar = const SnackBar(
                                            content: Text(
                                                'You havent booked book at ID1'),
                                            // action: SnackBarAction(
                                            //   label: 'Undo',
                                            //   onPressed: () {},
                                            // ),
                                          );

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        } else if (variable['issued_book1'] ==
                                            '') {
                                          users.doc(data['email']).update({
                                            'issued_book1':
                                                variable['booked_book_id1'],
                                          });

                                          users.doc(data['email']).update({
                                            'issued_book1_time':
                                                DateTime.now().toString(),
                                          });
                                          users.doc(data['email']).update({
                                            'booked_book_id1_time': '',
                                          });

                                          users.doc(data['email']).update({
                                            'booked_book_id1': '',
                                          });
                                        } else if (variable['issued_book2'] ==
                                            '') {
                                          users.doc(data['email']).update({
                                            'issued_book2':
                                                variable['booked_book_id1'],
                                          });
                                          users.doc(data['email']).update({
                                            'issued_book2_time':
                                                DateTime.now().toString(),
                                          });
                                          users.doc(data['email']).update({
                                            'booked_book_id1_time': '',
                                          });
                                          users.doc(data['email']).update({
                                            'booked_book_id1': '',
                                          });
                                        } else if (variable['issued_book3'] ==
                                            '') {
                                          users.doc(data['email']).update({
                                            'issued_book3':
                                                variable['booked_book_id1'],
                                          });
                                          users.doc(data['email']).update({
                                            'issued_book3_time':
                                                DateTime.now().toString(),
                                          });
                                          users.doc(data['email']).update({
                                            'booked_book_id1_time': '',
                                          });
                                          users.doc(data['email']).update({
                                            'booked_book_id3': '',
                                          });
                                        } else {
                                          const snackBar = SnackBar(
                                            content: Text(
                                                'You cannot issue the book'),
                                            // action: SnackBarAction(
                                            //   label: 'Undo',
                                            //   onPressed: () {},
                                            // ),
                                          );

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        }
                                      },
                                      shape: const BeveledRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(0))),
                                      backgroundColor: Colors.green,
                                      child: const Text('Issue_Book1'),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: SizedBox(
                                    height: 30,
                                    width: 150,
                                    child: FloatingActionButton(
                                      onPressed: () async {
                                        var variable = await FirebaseFirestore
                                            .instance
                                            .collection('users')
                                            .doc(data['email'])
                                            .get();
                                        print(variable['booked_book']);
                                        if (variable['booked_book'] == 3) {
                                          users.doc(data['email']).update({
                                            'booked_book': 2,
                                          });
                                        } else if (variable['booked_book'] ==
                                            2) {
                                          users.doc(data['email']).update({
                                            'booked_book': 1,
                                          });
                                        } else if (variable['booked_book'] ==
                                            1) {
                                          users.doc(data['email']).update({
                                            'booked_book': 0,
                                          });
                                        }
                                        if (variable['booked_book_id2'] == '') {
                                          const snackBar = SnackBar(
                                            content: Text(
                                                'You havent booked book at ID2'),
                                            // action: SnackBarAction(
                                            //   label: 'Undo',
                                            //   onPressed: () {},
                                            // ),
                                          );

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        } else if (variable['issued_book2'] ==
                                            '') {
                                          users.doc(data['email']).update({
                                            'issued_book2':
                                                variable['booked_book_id2'],
                                          });

                                          users.doc(data['email']).update({
                                            'issued_book2_time':
                                                DateTime.now().toString(),
                                          });
                                          users.doc(data['email']).update({
                                            'booked_book_id2_time': '',
                                          });
                                          users.doc(data['email']).update({
                                            'booked_book_id2': '',
                                          });
                                        } else if (variable['issued_book1'] ==
                                            '') {
                                          users.doc(data['email']).update({
                                            'issued_book1':
                                                variable['booked_book_id2'],
                                          });
                                          users.doc(data['email']).update({
                                            'issued_book1_time':
                                                DateTime.now().toString(),
                                          });
                                          users.doc(data['email']).update({
                                            'booked_book_id2_time': '',
                                          });
                                          users.doc(data['email']).update({
                                            'booked_book_id2': '',
                                          });
                                        } else if (variable['issued_book3'] ==
                                            '') {
                                          users.doc(data['email']).update({
                                            'issued_book3':
                                                variable['booked_book_id2'],
                                          });
                                          users.doc(data['email']).update({
                                            'issued_book3_time':
                                                DateTime.now().toString(),
                                          });
                                          users.doc(data['email']).update({
                                            'booked_book_id2_time': '',
                                          });
                                          users.doc(data['email']).update({
                                            'booked_book_id2': '',
                                          });
                                        } else {
                                          const snackBar = SnackBar(
                                            content: Text(
                                                'You cannot issue the book'),
                                            // action: SnackBarAction(
                                            //   label: 'Undo',
                                            //   onPressed: () {},
                                            // ),
                                          );

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        }
                                      },
                                      shape: const BeveledRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(0))),
                                      backgroundColor: Colors.green,
                                      child: const Text('Issue_Book2'),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: SizedBox(
                                    height: 30,
                                    width: 150,
                                    child: FloatingActionButton(
                                      onPressed: () async {
                                        var variable = await FirebaseFirestore
                                            .instance
                                            .collection('users')
                                            .doc(data['email'])
                                            .get();
                                        print(variable['booked_book']);
                                        if (variable['booked_book'] == 3) {
                                          users.doc(data['email']).update({
                                            'booked_book': 2,
                                          });
                                        } else if (variable['booked_book'] ==
                                            2) {
                                          users.doc(data['email']).update({
                                            'booked_book': 1,
                                          });
                                        } else if (variable['booked_book'] ==
                                            1) {
                                          users.doc(data['email']).update({
                                            'booked_book': 0,
                                          });
                                        }
                                        if (variable['booked_book_id3'] == '') {
                                          const snackBar = SnackBar(
                                            content: Text(
                                                'You havent booked book at ID3'),
                                            // action: SnackBarAction(
                                            //   label: 'Undo',
                                            //   onPressed: () {},
                                            // ),
                                          );

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        } else if (variable['issued_book3'] ==
                                            '') {
                                          users.doc(data['email']).update({
                                            'issued_book3':
                                                variable['booked_book_id3'],
                                          });
                                          users.doc(data['email']).update({
                                            'issued_book3_time':
                                                DateTime.now().toString(),
                                          });
                                          users.doc(data['email']).update({
                                            'booked_book_id3_time': '',
                                          });
                                          users.doc(data['email']).update({
                                            'booked_book_id3': '',
                                          });
                                        } else if (variable['issued_book2'] ==
                                            '') {
                                          users.doc(data['email']).update({
                                            'issued_book2':
                                                variable['booked_book_id3'],
                                          });
                                          users.doc(data['email']).update({
                                            'issued_book2_time':
                                                DateTime.now().toString(),
                                          });
                                          users.doc(data['email']).update({
                                            'booked_book_id3_time': '',
                                          });
                                          users.doc(data['email']).update({
                                            'booked_book_id3': '',
                                          });
                                        } else if (variable['issued_book1'] ==
                                            '') {
                                          users.doc(data['email']).update({
                                            'issued_book1':
                                                variable['booked_book_id3'],
                                          });
                                          users.doc(data['email']).update({
                                            'issued_book1_time':
                                                DateTime.now().toString(),
                                          });
                                          users.doc(data['email']).update({
                                            'booked_book_id3_time': '',
                                          });
                                          users.doc(data['email']).update({
                                            'booked_book_id3': '',
                                          });
                                        } else {
                                          const snackBar = SnackBar(
                                            content: Text(
                                                'You cannot issue the book'),
                                            // action: SnackBarAction(
                                            //   label: 'Undo',
                                            //   onPressed: () {},
                                            // ),
                                          );

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        }
                                      },
                                      shape: const BeveledRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(0))),
                                      backgroundColor: Colors.green,
                                      child: const Text('Issue_Book3'),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Text('1. ${data['issued_book1'].toString()}'),
                                Text(
                                    '[ ${data['issued_book1_time'].toString()}]'),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text('2.${data['issued_book2'].toString()}'),
                                Text(
                                    '[ ${data['issued_book2_time'].toString()}]'),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text('3.${data['issued_book3'].toString()}'),
                                Text(
                                    '[ ${data['issued_book3_time'].toString()}]'),
                              ],
                            ),
                            Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: SizedBox(
                                    height: 30,
                                    width: 150,
                                    child: FloatingActionButton(
                                      onPressed: () {
                                        users.doc(data['email']).update({
                                          'issued_book1': '',
                                        });
                                        users.doc(data['email']).update({
                                          'issued_book1_time': '',
                                        });
                                      },
                                      shape: const BeveledRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(0))),
                                      backgroundColor: Colors.red,
                                      child: const Text('Remove1'),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: SizedBox(
                                    height: 30,
                                    width: 150,
                                    child: FloatingActionButton(
                                      onPressed: () {
                                        users.doc(data['email']).update({
                                          'issued_book2': '',
                                        });
                                        users.doc(data['email']).update({
                                          'issued_book2_time': '',
                                        });
                                      },
                                      shape: const BeveledRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(0))),
                                      backgroundColor: Colors.red,
                                      child: const Text('Remove2'),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: SizedBox(
                                    height: 30,
                                    width: 150,
                                    child: FloatingActionButton(
                                      onPressed: () {
                                        users.doc(data['email']).update({
                                          'issued_book3': '',
                                        });
                                        users.doc(data['email']).update({
                                          'issued_book3_time': '',
                                        });
                                      },
                                      shape: const BeveledRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(0))),
                                      backgroundColor: Colors.red,
                                      child: const Text('Remove3'),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ]),
                        ],
                      );
                    },
                  ).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
