import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:path/path.dart';
import 'package:pu_library/models/books.dart';
import 'package:pu_library/models/users.dart';
import 'package:pu_library/views/home_page.dart';
import 'package:pu_library/views/itemwidget_al.dart';
import 'package:pu_library/widgets/itemwidget.dart';
import 'package:pu_library/widgets/user_account_widget.dart';
import 'package:side_navigation/side_navigation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../utils/routes.dart';

class User_account extends StatefulWidget {
  const User_account({super.key});

  @override
  State<User_account> createState() => _HomePageState();
}

class _HomePageState extends State<User_account> {
  // final user = FirebaseAuth.instance.currentUser;
  final Stream<QuerySnapshot> _readbook =
      FirebaseFirestore.instance.collection('books').snapshots();

  var users = FirebaseFirestore.instance.collection('users');
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

  late final name;
  late final booked_book;
  late final imageurl;
  late final booked_book_id1;
  late final booked_book_id2;
  late final booked_book_id3;
  late final email;
  late final issued_book1;
  late final issued_book2;
  late final issued_book3;

  final user = FirebaseAuth.instance.currentUser;
  void account() async {
    var variable1 = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.email)
        .get();
    print(variable1['booked_book']);
    name = variable1['firstname'];
    email = variable1['email'];
    booked_book = variable1['booked_book'];
    imageurl = variable1['imageurl'];
    booked_book_id1 = variable1['booked_book_id1'];
    booked_book_id2 = variable1['booked_book_id2'];
    booked_book_id3 = variable1['bokked_book_id3'];
    issued_book1 = variable1['issued_book1'];
    issued_book2 = variable1['issued_book2'];
    issued_book3 = variable1['issued_book3'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Center(
            child: Text(
              'Hamro Library - User Account',
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
                label: 'SignOut',
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
            child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: users.doc(user?.email).snapshots(),
              builder: (_, snapshot) {
                if (snapshot.hasError) return Text('Error = ${snapshot.error}');

                if (snapshot.hasData) {
                  var output = snapshot.data!.data();
                  var value = output!['some_field']; // <-- Your value
                  // return Text('Value = $value');
                  return User_acc_widget(
                    name: output['firstname'],
                    booked_book: output['booked_book'],
                    imageurl: output['imageurl'],
                    booked_book_id1: output['booked_book_id1'],
                    booked_book_id2: output['booked_book_id2'],
                    booked_book_id3: output['booked_book_id3'],
                    email: output['email'],
                    issued_book1: output['issued_book1'],
                    issued_book2: output['issued_book2'],
                    issued_book3: output['issued_book3'],
                    booked_book_id1_time: output['booked_book_id1_time'],
                    booked_book_id2_time: output['booked_book_id2_time'],
                    booked_book_id3_time: output['booked_book_id3_time'],
                    issued_book1_time: output['issued_book1_time'],
                    issued_book2_time: output['issued_book2_time'],
                    issued_book3_time: output['issued_book3_time'],
                  );
                  // GridView(
                  //   gridDelegate:
                  //       const SliverGridDelegateWithFixedCrossAxisCount(
                  //           crossAxisCount: 3),
                  //           children: [],
                  // );
                }

                return Center(child: CircularProgressIndicator());
              },
            ),
            // StreamBuilder<QuerySnapshot>(
            //   stream: users.doc(user?.email).snapshots(),
            //   builder: (BuildContext context,
            //       AsyncSnapshot<QuerySnapshot> snapshot) {
            //     if (snapshot.hasError) {
            //       return Text('Something went wrong');
            //     }

            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return const Text("Loading");
            //     }
            //     SizedBox(
            //       height: 20,
            //     );
            //     return GridView(
            // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: 3),
            //       children:
            //           snapshot.data!.docs.map((DocumentSnapshot document) {
            //         Map<String, dynamic> data =
            //             document.data()! as Map<String, dynamic>;

            //         return Display(
            //           name: data['name'],

            //           available: data['available'].toString(),

            //           // pubdate: data['pubdate'],
            //           imageurl: data['imageurl'].toString(),

            //           // title: Text(data['name']),
            //           // subtitle: Text(data['available'].toString()),
            //         );
            //       }).toList(),
            //     );
            //   },
            // ),
            // Column(
            //   children: [
            //     FloatingActionButton(
            //       onPressed: () async {
            //         var variable1 = await FirebaseFirestore.instance
            //             .collection('users')
            //             .doc(user?.email)
            //             .get();
            //         print(variable1['booked_book']);
            //         User_acc_widget(
            //           booked_book: variable1['booked_book'],
            //           name: variable1['name'],
            //           email: variable1['email'],
            //           imageurl: variable1['imageurl'],
            //           booked_book_id1: variable1['booked_book_id1'],
            //           booked_book_id2: variable1['booked_book_id2'],
            //           booked_book_id3: variable1['booked_book_id3'],
            //           issued_book1: variable1['issued_book1'],
            //           issued_book2: variable1['issued_book2'],
            //           issued_book3: variable1['issues_book3'],
            //         );
            //       },
            //       child: Text('View Details'),
            //     ),
            //     // SizedBox(
            //     //   height: 150,
            //     //   width: 150,
            //     //   child: Card(child: Text(),
            //     // ),
            //   ],
            // ),
          ),
        ],
      ),
    );
  }
}
