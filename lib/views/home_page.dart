import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:pu_library/models/books.dart';
import 'package:pu_library/widgets/itemwidget.dart';
import 'package:side_navigation/side_navigation.dart';

import '../utils/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Stream<QuerySnapshot> _readbook =
      FirebaseFirestore.instance.collection('books').snapshots();

  /// The currently selected index of the bar
  int selectedIndex = 0;

  var collection = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Center(
            child: Text(
              'Hamro Library - HomePage',
              style: TextStyle(
                  color: Color.fromARGB(255, 248, 250, 250),
                  // Color.fromARGB(255, 2, 76, 74),
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 91, 92, 138)
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
                label: 'SignUp/Login',
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
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;

                    return Display(
                      name: data['name'],
                      available: data['available'].toString(),
                      imageurl: data['imageurl'].toString(),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildbooks(Books books) => GridTile(child: Text(books.name));
}
