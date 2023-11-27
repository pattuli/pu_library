import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:pu_library/models/books.dart';
import 'package:pu_library/views/admin_panel.dart';

import 'package:pu_library/widgets/itemwidget_admin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:side_navigation/side_navigation.dart';

import '../models/signin_page.dart';
import '../utils/routes.dart';

class HomePage_admin extends StatefulWidget {
  const HomePage_admin({super.key});

  @override
  State<HomePage_admin> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage_admin> {
  final Stream<QuerySnapshot> _readbook =
      FirebaseFirestore.instance.collection('books').snapshots();

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference books = FirebaseFirestore.instance.collection('books');

  int selectedIndex = 0;
  void Booked() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
    }
    if (users.id == user?.uid) {
      users.add({
        'booked_book_id': books.id,
      });
    }
  }

  var _searchController = TextEditingController();
  String? name, imageUrl, userEmail, uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawerEnableOpenDragGesture: false,

      backgroundColor: Color.fromARGB(255, 249, 245, 241),
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Hamro Library - Admin HomePage',
            style: TextStyle(
                color: Color.fromARGB(255, 248, 250, 250),
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 91, 92, 138),

        //  Color.fromARGB(255, 241, 190, 190),
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
                label: 'View Users',
              ),
              // SideNavigationBarItem(
              //   icon: Icons.login,
              //   label: 'Login',
              // ),
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
                // Adminpanel();
              } else if (selectedIndex == 3) {
                Navigator.pushNamed(context, Myroutes.user_view);
              } else if (selectedIndex == 4) {
                signOutGoogle();
              }
            },
            theme: SideNavigationBarTheme(
              backgroundColor: Color.fromARGB(255, 68, 68, 109),
              //  Color.fromARGB(255, 102, 99, 99),
              togglerTheme: SideNavigationBarTogglerTheme.standard(),
              itemTheme: SideNavigationBarItemTheme(
                  unselectedItemColor: Colors.white,
                  selectedItemColor: Colors.green,
                  labelTextStyle: TextStyle(color: Colors.white)),
              dividerTheme: SideNavigationBarDividerTheme.standard(),
            ),
          ),

          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: _readbook,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: const Text("Loading"));
              }
              const SizedBox(
                height: 20,
              );
              return GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;

                  return Display_admin(
                    name: data['name'],
                    pubdate: data['pubdate'],
                    author: data['author'],
                    available: data['available'].toString(),

                    // pubdate: data['pubdate'],
                    imageurl: data['imageurl'],
                    category: data['category'],
                    // availablenumber: data['availablenumber'],

                    // title: Text(data['name']),
                    // subtitle: Text(data['available'].toString()),
                  );
                }).toList(),
              );
            },
          ))
        ],
      ),
    );
  }

  Widget buildbooks(Books books) => GridTile(child: Text(books.name));
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
}
