import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as fb;

class Display extends StatefulWidget {
  // const Card({super.key});
  final String name;
  final String available;
  // final String pubdate;
  final String imageurl;
  // final String author;
  const Display({
    super.key,
    required this.name,
    required this.available,
    // required this.pubdate,
    required this.imageurl,
    // required this.author,
  });

  @override
  State<Display> createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
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
                // const SizedBox(
                //   height: 10,
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Image.asset(
                    // 'assets/images/signup.png',
                    'assets/images/${widget.imageurl}',
                    width: 400,
                    height: 180,
                    // scale: 2,
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
