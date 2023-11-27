import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> uploadFile(
    String filepath,
    String filename,
    Uint8List selected,
  ) async {
    File file = File(filepath);

    try {
      await storage.ref('/$filename').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }
}
