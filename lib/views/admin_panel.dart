import 'dart:async';
import 'dart:html';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart' as Path;
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_web/firebase_storage_web.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pu_library/views/home_page_admin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:side_navigation/side_navigation.dart';

import 'package:intl/intl.dart';
import 'package:image_picker_web/image_picker_web.dart';
import '../models/signin_page.dart';
import '../utils/routes.dart';

class Adminpanel extends StatefulWidget {
  const Adminpanel({super.key});

  @override
  State<Adminpanel> createState() => _AdminpanelState();
}

class _AdminpanelState extends State<Adminpanel> {
  final controllerName = TextEditingController();

  final controllerDate = TextEditingController();
  bool isavailable = true;

  final controllerAuthor = TextEditingController();

  final controllerCategory = TextEditingController();

  final dateInput = TextEditingController();
  final availableNumber = TextEditingController();
  @override
  void initState() {
    dateInput.text = ""; //set the initial value of text field
    super.initState();
  }

  // String date = dateInput.text;
  var cat = ['Fiction', 'Non-Fiction', 'IT', 'Programming', 'Electrical-Eng'];
  String catvalue = 'Programming';

  var items = ['isavailable', 'notavailable'];
  String dropdownvalue = 'isavailable';

  int selectedIndex = 0;
  late String imgUrl;
  late Uint8List selectedImageInBytes;
  late fb.UploadTask _uploadTask;
  var value;
  // late int a = int.parse(availableNumber.text);
  uploadImage() async {
    // HTML input element
    FileUploadInputElement uploadInput = FileUploadInputElement();
    uploadInput.click();

    uploadInput.onChange.listen(
      (changeEvent) {
        final file = uploadInput.files!.first;
        final reader = FileReader();
        // The FileReader object lets web applications asynchronously read the
        // contents of files (or raw data buffers) stored on the user's computer,
        // using File or Blob objects to specify the file or data to read.
        // Source: https://developer.mozilla.org/en-US/docs/Web/API/FileReader

        reader.readAsDataUrl(file);
        // The readAsDataURL method is used to read the contents of the specified Blob or File.
        //  When the read operation is finished, the readyState becomes DONE, and the loadend is
        // triggered. At that time, the result attribute contains the data as a data: URL representing
        // the file's data as a base64 encoded string.
        // Source: https://developer.mozilla.org/en-US/docs/Web/API/FileReader/readAsDataURL

        reader.onLoadEnd.listen(
          // After file finiesh reading and loading, it will be uploaded to firebase storage
          (loadEndEvent) async {
            uploadToFirebase(file);
          },
        );
      },
    );
  }

  Future<void> uploadToFirebase(File imageFile) async {
    final filePath = 'images/${DateTime.now()}.png';
    Reference ref = FirebaseStorage.instance
        .ref('gs://pu-library-16b5e.appspot.com')
        .child(filePath);
    setState(() {
      _uploadTask = fb
          .storage()
          .ref('gs://pu-library-16b5e.appspot.com')
          .child(filePath)
          .put(imageFile);
    });
  }

  String? name, imageUrl, userEmail, uid;

  @override
  Widget build(BuildContext context) {
    CollectionReference books = FirebaseFirestore.instance.collection('books');
    if (dropdownvalue == 'isavailable') {
      isavailable = true;
    } else {
      isavailable = false;
    }

    Future<void> addBook() {
      // Call the user's CollectionReference to add a new user
      return books
          .doc(controllerName.text)
          .set({
            'name': controllerName.text, // John Doe
            'pubdate': dateInput.text, // Stokes and Sons
            'available': isavailable, // 42
            'category': catvalue,
            'author': controllerAuthor.text,
            // 'availablenumber': a,
            'imageurl': value,
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Hamro Library - Admin Panel',
            style: TextStyle(
                color: Color.fromARGB(255, 248, 250, 250),
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
              backgroundColor: Color.fromARGB(255, 68, 68, 109),
              togglerTheme: SideNavigationBarTogglerTheme.standard(),
              itemTheme: SideNavigationBarItemTheme(
                  unselectedItemColor: Colors.white,
                  selectedItemColor: Colors.green,
                  labelTextStyle: TextStyle(color: Colors.white)),
              // itemTheme: SideNavigationBarItemTheme.standard(),
              dividerTheme: SideNavigationBarDividerTheme.standard(),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 35,
                ),
                Container(
                  width: 300,
                  height: 60,
                  color: Colors.white,
                  child: const Center(
                    child: Text(
                      'Admin Panel',
                      style: TextStyle(
                          // backgroundColor: Colors.green,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 40),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Table(
                  defaultColumnWidth: FixedColumnWidth(200.0),
                  border: TableBorder.all(
                      color: Colors.black, style: BorderStyle.solid, width: 2),
                  children: [
                    TableRow(children: [
                      Column(children: const [
                        Text('Name', style: TextStyle(fontSize: 20.0))
                      ]),
                      Column(children: const [
                        Text('Available', style: TextStyle(fontSize: 20.0))
                      ]),
                      Column(children: const [
                        Text('Punlish Date', style: TextStyle(fontSize: 20.0))
                      ]),
                      Column(children: const [
                        Text('Category', style: TextStyle(fontSize: 20.0))
                      ]),
                      Column(children: const [
                        Text('Author Name', style: TextStyle(fontSize: 20.0))
                      ]),
                      // Column(children: const [
                      //   Text('Available Number',
                      //       style: TextStyle(fontSize: 20.0))
                      // ]),
                      Column(children: const [
                        Text('Upload Image', style: TextStyle(fontSize: 20.0))
                      ]),
                    ]),
                    TableRow(
                      children: [
                        Column(children: [
                          TextField(
                            controller: controllerName,
                          ),
                        ]),
                        Column(children: [
                          DropdownButton(
                              // Initial Value
                              value: dropdownvalue,

                              // Down Arrow Icon
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: items.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownvalue = newValue!;
                                });
                              })
                        ]),
                        Column(
                          children: [
                            TextField(
                                controller: dateInput,
                                //editing controller of this TextField
                                decoration: const InputDecoration(
                                    icon: Icon(Icons
                                        .calendar_today), //icon of text field
                                    labelText:
                                        "Enter Date" //label text of field
                                    ),
                                readOnly: true,
                                //set it true, so that user will not able to edit text
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1950),
                                      //DateTime.now() - not to allow to choose before today.
                                      lastDate: DateTime(2100));

                                  if (pickedDate != null) {
                                    print(
                                        pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                    String formattedDate =
                                        DateFormat('yyyy-MM-dd')
                                            .format(pickedDate);
                                    print(
                                        formattedDate); //formatted date output using intl package =>  2021-03-16
                                    setState(() {
                                      dateInput.text =
                                          formattedDate; //set output date to TextField value.
                                    });
                                  } else {}
                                }),
                          ],
                        ),
                        Column(children: [
                          DropdownButton(
                              // Initial Value
                              value: catvalue,

                              // Down Arrow Icon
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: cat.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  catvalue = newValue!;
                                });
                              })
                        ]),
                        Column(children: [
                          TextField(
                            controller: controllerAuthor,
                          )
                        ]),
                        // Column(children: [
                        //   TextField(
                        //     keyboardType: TextInputType.number,
                        //     controller: availableNumber,
                        //   ),
                        // ]),
                        Column(children: [
                          FloatingActionButton.extended(
                            onPressed: () {
                              FileUploadInputElement uploadInput =
                                  FileUploadInputElement();
                              uploadInput.click();

                              uploadInput.onChange.listen(
                                (changeEvent) {
                                  final file = uploadInput.files!.first;
                                  final reader = FileReader();
                                  // The FileReader object lets web applications asynchronously read the
                                  // contents of files (or raw data buffers) stored on the user's computer,
                                  // using File or Blob objects to specify the file or data to read.
                                  // Source: https://developer.mozilla.org/en-US/docs/Web/API/FileReader

                                  reader.readAsDataUrl(file);
                                  // The readAsDataURL method is used to read the contents of the specified Blob or File.
                                  //  When the read operation is finished, the readyState becomes DONE, and the loadend is
                                  // triggered. At that time, the result attribute contains the data as a data: URL representing
                                  // the file's data as a base64 encoded string.
                                  // Source: https://developer.mozilla.org/en-US/docs/Web/API/FileReader/readAsDataURL

                                  reader.onLoadEnd.listen(
                                    // After file finiesh reading and loading, it will be uploaded to firebase storage
                                    (loadEndEvent) async {
                                      // uploadToFirebase(file);
                                      final filePath =
                                          'images/${DateTime.now()}.png';
                                      value = file.name;
                                      print(value);
                                    },
                                  );
                                },
                              );
                            },
                            shape: const BeveledRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            backgroundColor: Colors.green,
                            label: Text('Image'),
                          ),
                        ]),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 50,
                  width: 100,
                  child: FloatingActionButton(
                    onPressed: () {
                      addBook();
                      setState(() {
                        final snackBar = SnackBar(
                          content:
                              const Text('Book has been added to Database'),
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
                      });
                      Navigator.pushNamed(context, Myroutes.adminPanel);
                    },
                    shape: const BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    backgroundColor: Colors.green,
                    child: const Text(
                      'Upload',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

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
