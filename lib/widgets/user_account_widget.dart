import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as fb;

class User_acc_widget extends StatefulWidget {
  // const Card({super.key});
  final name;
  final booked_book;
  final imageurl;
  final booked_book_id1;
  final booked_book_id2;
  final booked_book_id3;
  final email;
  final issued_book1;
  final issued_book2;
  final issued_book3;
  final booked_book_id1_time;
  final booked_book_id2_time;
  final booked_book_id3_time;
  final issued_book1_time;
  final issued_book2_time;
  final issued_book3_time;

  const User_acc_widget({
    super.key,
    required this.name,
    required this.booked_book,
    required this.imageurl,
    required this.booked_book_id1,
    required this.booked_book_id2,
    required this.booked_book_id3,
    required this.email,
    required this.issued_book1,
    required this.issued_book2,
    required this.issued_book3,
    required this.booked_book_id1_time,
    required this.booked_book_id2_time,
    required this.booked_book_id3_time,
    required this.issued_book1_time,
    required this.issued_book2_time,
    required this.issued_book3_time,
  });

  @override
  State<User_acc_widget> createState() => _DisplayState();
}

class _DisplayState extends State<User_acc_widget> {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference books =
      FirebaseFirestore.instance.collection('books');
  final user = FirebaseAuth.instance.currentUser;
  var userPhotos;
  var value1;
  var value2;
  var value3;
  Future<void> getPhoto(id) async {
    //query the user photo
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user?.email)
        .snapshots()
        .listen((event) {
      setState(() {
        userPhotos = event.get("booked_book");

        // print(userPhotos);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: GridView(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        children: [
          Card(
            elevation: 40,
            shadowColor: Colors.black,
            child: Column(
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    CircleAvatar(
                      radius: 50,
                      child: ClipOval(
                        child: Image.network(
                          widget.imageurl,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                          // scale: 2,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Column(
                      children: [
                        Text(
                          ' ${widget.name}',
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          'Books Booked : ${widget.booked_book}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Email : ${widget.email}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Card(
            elevation: 40,
            shadowColor: Colors.black,
            child: Column(
              children: [
                SizedBox(
                  height: 12,
                ),
                Text('Booked Books Names',
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 200),
                  child: Column(
                    children: [
                      Text(
                        '1. ${widget.booked_book_id1}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Date:[ ${widget.booked_book_id1_time}]',
                        // style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 200),
                  child: Column(
                    children: [
                      Text(
                        '2. ${widget.booked_book_id2}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Date:[ ${widget.booked_book_id2_time}]',
                        // style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 200),
                  child: Column(
                    children: [
                      Text(
                        '3. ${widget.booked_book_id3}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Date:[ ${widget.booked_book_id3_time}]',
                        // style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Column(
                  children: [
                    FloatingActionButton.extended(
                      onPressed: () async {
                        var variable1 = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user?.email)
                            .get();
                        print(variable1['booked_book']);
                        if (variable1['booked_book_id1'] != null) {
                          if (variable1['booked_book'] == 3) {
                            users
                                .doc(user?.email)
                                .update({'booked_book_id1': ''});
                            users
                                .doc(user?.email)
                                .update({'booked_book_id1_time': ''});
                            users
                                .doc(user?.email)
                                .update({'booked_book_id1_time': ''});
                            users.doc(user?.email).update({'booked_book': 2});
                          } else if (variable1['booked_book'] == 2) {
                            users
                                .doc(user?.email)
                                .update({'booked_book_id1': ''});
                            users
                                .doc(user?.email)
                                .update({'booked_book_id1_time': ''});
                            users
                                .doc(user?.email)
                                .update({'booked_book_id1': ''});
                            users.doc(user?.email).update({'booked_book': 1});
                          } else if (variable1['booked_book'] == 1) {
                            users
                                .doc(user?.email)
                                .update({'booked_book_id1': ''});
                            users
                                .doc(user?.email)
                                .update({'booked_book_id1_time': ''});
                            users.doc(user?.email).update({'booked_book': 0});
                          }
                        } else {
                          final snackBar = SnackBar(
                            content: const Text('There is no booking'),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {
                                // Some code to undo the change.
                              },
                            ),
                          );

                          // Find the ScaffoldMessenger in the widget tree
                          // and use it to show a SnackBar.
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      shape: const BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      backgroundColor: Colors.red,
                      label: Text('Remove Booking_1'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FloatingActionButton.extended(
                        onPressed: () async {
                          var variable1 = await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user?.email)
                              .get();
                          print(variable1['booked_book']);

                          if (variable1['booked_book_id2'] != null) {
                            if (variable1['booked_book'] == 3) {
                              users
                                  .doc(user?.email)
                                  .update({'booked_book_id2': ''});
                              users
                                  .doc(user?.email)
                                  .update({'booked_book_id2_time': ''});
                              users.doc(user?.email).update({'booked_book': 2});
                            } else if (variable1['booked_book'] == 2) {
                              users
                                  .doc(user?.email)
                                  .update({'booked_book_id2': ''});
                              users
                                  .doc(user?.email)
                                  .update({'booked_book_id2_time': ''});
                              users.doc(user?.email).update({'booked_book': 1});
                            } else if (variable1['booked_book'] == 1) {
                              users
                                  .doc(user?.email)
                                  .update({'booked_book_id2': ''});
                              users
                                  .doc(user?.email)
                                  .update({'booked_book_id2_time': ''});
                              users.doc(user?.email).update({'booked_book': 0});
                            }
                          } else {
                            final snackBar = SnackBar(
                              content: const Text('There is no booking'),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () {
                                  // Some code to undo the change.
                                },
                              ),
                            );

                            // Find the ScaffoldMessenger in the widget tree
                            // and use it to show a SnackBar.
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                        shape: const BeveledRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        backgroundColor: Colors.red,
                        label: Text('Remove Booking_2')),
                    const SizedBox(
                      height: 20,
                    ),
                    FloatingActionButton.extended(
                        onPressed: () async {
                          var variable1 = await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user?.email)
                              .get();
                          print(variable1['booked_book']);
                          if (variable1['booked_book_id3'] != null) {
                            if (variable1['booked_book'] == 3) {
                              users
                                  .doc(user?.email)
                                  .update({'booked_book_id3': ''});
                              users
                                  .doc(user?.email)
                                  .update({'booked_book_id3_time': ''});
                              users.doc(user?.email).update({'booked_book': 2});
                            } else if (variable1['booked_book'] == 2) {
                              users
                                  .doc(user?.email)
                                  .update({'booked_book_id3': ''});
                              users
                                  .doc(user?.email)
                                  .update({'booked_book_id3_time': ''});
                              users.doc(user?.email).update({'booked_book': 1});
                            } else if (variable1['booked_book'] == 1) {
                              users
                                  .doc(user?.email)
                                  .update({'booked_book_id3': ''});
                              users
                                  .doc(user?.email)
                                  .update({'booked_book_id3_time': ''});
                              users.doc(user?.email).update({'booked_book': 0});
                            }
                          } else if (variable1['booked_book_id3'] == null) {
                            final snackBar = SnackBar(
                              content: const Text('There is no booking'),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () {
                                  // Some code to undo the change.
                                },
                              ),
                            );

                            // Find the ScaffoldMessenger in the widget tree
                            // and use it to show a SnackBar.
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                        shape: const BeveledRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        backgroundColor: Colors.red,
                        label: Text('Remove Booking_3')),
                  ],
                )
              ],
            ),
          ),
          Card(
            elevation: 40,
            shadowColor: Colors.black,
            child: Column(
              children: [
                SizedBox(
                  height: 12,
                ),
                Text('Issued Books Names',
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 200),
                  child: Column(
                    children: [
                      Text(
                        '1. ${widget.issued_book1}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Issued Date:[ ${widget.issued_book1_time}]',
                        // style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 200),
                  child: Column(
                    children: [
                      Text(
                        '2. ${widget.issued_book2}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Issued Date:[ ${widget.issued_book2_time}]',
                        // style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 200),
                  child: Column(
                    children: [
                      Text(
                        '3. ${widget.issued_book3}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Issued Date: [ ${widget.issued_book3_time}]',
                        // style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
