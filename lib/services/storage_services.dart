import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class StorageServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instanceFor(
    app: FirebaseDatabase.instance.app,
    databaseURL: 'https://attendance-app-b1d25-default-rtdb.asia-southeast1.firebasedatabase.app/',
  ).ref(); // ini untuk memperjelas firebase nya

  //  upload photo to firecase realtime database as Base64 (string)
  Future<String> uploadAttendancePhoto(String localPath, String photoType) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated'); 

      final file = File(localPath);

      // compress image to reduce size (important for realtime database)
      final compressBytes =  await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        minWidth: 800,
        minHeight: 600,
        quality: 70
      );

      if (compressBytes == null) {
        throw Exception('Failed to compress  image');
      }

      // convert to Base64
      final base64Image = base64Encode(compressBytes);

      // create unique key
      final photoKey = '${DateTime.now().millisecondsSinceEpoch}_$photoType';

      // save to realtime database
      await _database
         .child('attendance_photos')
         .child(user.uid)
         .child(photoKey)
         .set(
          {
            'data': base64Image,
          'timestamp': ServerValue.timestamp,
          'type': photoType
          }
         );

      // return the key as reference 
      return photoKey;
    } catch (e) {
      throw Exception('Failed to upload photo: $e');
    }
  }

  // get photo from firebase realtime database 
  Future<String?> getphotoBase64(String photoKey) async{
    try {
      final User = _auth.currentUser;
      if(User == null) return null;

      final snapshot = await _database
         .child('attandance_photos')
         .child(User.uid)
         .child(photoKey)
         .child('data')
         .get();

    if(snapshot.exists) {
      return snapshot.value as String;
    }

    return null;
    } catch (e) {
      return null;
    }
  }

  //delete photo from firebase database 
  Future<void> deletePhoto(String photoKey) async{
    try {
      final User = _auth.currentUser;
      if(User == null ) return;

      await _database
         .child('attendance_photos')
         .child(User.uid)
         .child(photoKey)
         .remove();
    } catch (e) {
      // ignore
    }
  }
}