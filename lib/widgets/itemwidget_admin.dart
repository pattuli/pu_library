import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as fb;

class Display_admin extends StatefulWidget {
  // const Card({super.key});
  final String name;
  final String available;
  final String pubdate;
  final String imageurl;
  final String author;
  final String category;
  // final int availablenumber;
  const Display_admin({
    super.key,
    required this.name,
    required this.available,
    required this.pubdate,
    required this.imageurl,
    required this.author,
    required this.category,
    // required this.availablenumber,
  });

  @override
  State<Display_admin> createState() => _Display_adminState();
}

class _Display_adminState extends State<Display_admin> {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference books =
      FirebaseFirestore.instance.collection('books');
  final user = FirebaseAuth.instance.currentUser;
  var _searchController = TextEditingController();
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
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Image.asset(
                    'assets/images/${widget.imageurl.toString()}',
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
                    Text('Category : ${widget.category}'),
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
                    // Text('Available Number: ${widget.availablenumber}'),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 55,
                        ),
                        FloatingActionButton.extended(
                          onPressed: () async {
                            var variable = await FirebaseFirestore.instance
                                .collection('books')
                                .doc(widget.name.toString())
                                .get();
                            if (variable['available'] == true) {
                              books.doc(widget.name.toString()).update({
                                'available': false,
                              });
                            } else if (variable['available'] == false) {
                              books.doc(widget.name.toString()).update({
                                'available': true,
                              });
                            }
                          },
                          shape: const BeveledRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          backgroundColor: Colors.green,
                          label: Text('Change Availability'),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        FloatingActionButton.extended(
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('books')
                                .doc(widget.name)
                                .delete();
                          },
                          shape: const BeveledRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          backgroundColor: Colors.red,
                          label: Text('Delete Book'),
                        ),
                      ],
                    )
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
