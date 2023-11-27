import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class Display_al extends StatefulWidget {
  // const Card({super.key});
  final String name;
  final String available;
  final String pubdate;
  final String imageurl;
  final String author;
  final String category;
  const Display_al({
    super.key,
    required this.name,
    required this.available,
    required this.pubdate,
    required this.imageurl,
    required this.author,
    required this.category,
  });

  @override
  State<Display_al> createState() => _Display_alState();
}

class _Display_alState extends State<Display_al> {
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
      child: Card(
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  child: Image.asset(
                    'assets/images/${widget.imageurl}',
                    width: 400,
                    height: 180,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      ' ${widget.name}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text('Available : ${widget.available}'),
                    const SizedBox(
                      height: 8,
                    ),
                    Text('Category: ${widget.category}'),
                    const SizedBox(
                      height: 8,
                    ),
                    Text('Author: ${widget.author}'),
                    const SizedBox(
                      height: 8,
                    ),
                    Text('Pubdate: ${widget.pubdate}'),
                    const SizedBox(
                      height: 8,
                    ),
                    FloatingActionButton(
                      onPressed: () async {
                        var variable1 = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user?.email)
                            .get();
                        print(variable1['booked_book']);
                        value1 = variable1['booked_book'];
                        var variable2 = await FirebaseFirestore.instance
                            .collection('books')
                            .doc(widget.name.toString())
                            .get();

                        bool a = true;
                        bool b = false;
                        if (variable2['available'] == a) {
                          if (value1 == 0) {
                            users.doc(user?.email).update({
                              'booked_book_id1': widget.name,
                            });
                            users.doc(user?.email).update({
                              'booked_book_id1_time': DateTime.now().toString(),
                            });
                            users.doc(user?.email).update({'booked_book': 1});
                          } else if (value1 == 1 &&
                                  variable1['booked_book_id1'] == widget.name ||
                              variable1['booked_book_id2'] == widget.name ||
                              variable1['booked_book_id3'] == widget.name) {
                            final snackBar = SnackBar(
                              content:
                                  const Text('This Book is already Booked'),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () {},
                              ),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else if (value1 == 1 &&
                              variable1['booked_book_id1'] != null) {
                            users.doc(user?.email).update({
                              'booked_book_id2': widget.name,
                            });
                            users.doc(user?.email).update({
                              'booked_book_id2_time': DateTime.now().toString(),
                            });
                            users.doc(user?.email).update({'booked_book': 2});
                          } else if (value1 == 1 &&
                              variable1['booked_book_id2'] != null) {
                            users.doc(user?.email).update({
                              'booked_book_id1': widget.name,
                            });
                            users.doc(user?.email).update({
                              'booked_book_id1_time': DateTime.now().toString(),
                            });
                            users.doc(user?.email).update({'booked_book': 2});
                          } else if (value1 == 1 &&
                              variable1['booked_book_id3'] != null) {
                            users.doc(user?.email).update({
                              'booked_book_id1': widget.name,
                            });
                            users.doc(user?.email).update({
                              'booked_book_id1_time': DateTime.now().toString(),
                            });
                            users.doc(user?.email).update({'booked_book': 2});
                          } else if (value1 == 2 &&
                                  variable1['booked_book_id1'] == widget.name ||
                              variable1['booked_book_id2'] == widget.name ||
                              variable1['booked_book_id3'] == widget.name) {
                            final snackBar = SnackBar(
                              content:
                                  const Text('This Book is already Booked'),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () {},
                              ),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else if (value1 == 2 &&
                              variable1['booked_book_id1'] == "") {
                            users.doc(user?.email).update({
                              'booked_book_id1': widget.name,
                            });
                            users.doc(user?.email).update({
                              'booked_book_id1_time': DateTime.now().toString(),
                            });
                            users.doc(user?.email).update({'booked_book': 3});
                          } else if (value1 == 2 &&
                              variable1['booked_book_id2'] == "") {
                            users.doc(user?.email).update({
                              'booked_book_id2': widget.name,
                            });
                            users.doc(user?.email).update({
                              'booked_book_id2_time': DateTime.now().toString(),
                            });
                            users.doc(user?.email).update({'booked_book': 3});
                          } else if (value1 == 2 &&
                              variable1['booked_book_id3'] == "") {
                            users.doc(user?.email).update({
                              'booked_book_id3': widget.name,
                            });
                            users.doc(user?.email).update({
                              'booked_book_id3_time': DateTime.now().toString(),
                            });
                            users.doc(user?.email).update({'booked_book': 3});
                          } else if (value1 == 3) {
                            final snackBar = SnackBar(
                              content:
                                  const Text('Your Booking Limitation is Full'),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () {},
                              ),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        } else {
                          final snackBar = SnackBar(
                            content: const Text('The Book is not available'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      shape: const BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      backgroundColor: Colors.green,
                      child: const Text('Book'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
