import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:path/path.dart';
import 'package:pu_library/models/books.dart';
import 'package:pu_library/models/users.dart';
import 'package:pu_library/views/itemwidget_al.dart';
import 'package:pu_library/widgets/itemwidget.dart';
import 'package:side_navigation/side_navigation.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../utils/routes.dart';

class HomePage_al extends StatefulWidget {
  const HomePage_al({super.key});

  @override
  State<HomePage_al> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage_al> {
  final Stream<QuerySnapshot> _readbook =
      FirebaseFirestore.instance.collection('books').snapshots();

  // Stream<List<Books>> readBooks() => FirebaseFirestore.instance
  //     .collection('books')
  //     .snapshots()
  //     .map((snapshot) =>
  //         snapshot.docs.map((doc) => Books.fromJson(doc.data())).toList());

  // }

  /// The currently selected index of the bar

  // final controllerName = TextEditingController();
  // final controllerAge = TextEditingController();
  // final controllerAddress = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(
            child: Text(
              'Hamro Library - HomePage',
              style: TextStyle(
                  color: Color.fromARGB(255, 248, 250, 250),
                  // Color.fromARGB(255, 2, 76, 74),
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Color.fromARGB(255, 91, 92, 138)
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
                label: 'User',
              ),
              SideNavigationBarItem(
                icon: Icons.dashboard,
                label: 'Home',
              ),
              SideNavigationBarItem(
                icon: Icons.person,
                label: 'Account',
              ),
              SideNavigationBarItem(
                icon: Icons.logout,
                label: 'Signout',
              ),
            ],
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
              if (selectedIndex == 1) {
                Navigator.pushNamed(context, Myroutes.homeroute_al);
              } else if (selectedIndex == 2) {
                Navigator.pushNamed(context, Myroutes.user_account);
              } else if (selectedIndex == 3) {
                Navigator.pushNamed(context, Myroutes.signin);
              }
            },
            theme: SideNavigationBarTheme(
              backgroundColor: Color.fromARGB(255, 68, 68, 109),
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
              SizedBox(
                height: 20,
              );
              return GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;

                  return Display_al(
                    name: data['name'].toString(),

                    available: data['available'].toString(),

                    pubdate: data['pubdate'],
                    author: data['author'],

                    imageurl: data['imageurl'].toString(),
                    category: data['category'],

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
}
