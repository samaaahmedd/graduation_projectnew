import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:with_you_app/common/firebase_keys/firebase_keys.dart';
import 'package:with_you_app/common/material/app_snackbars.dart';

class SetUserImageUseCase {
  final user = FirebaseAuth.instance.currentUser;
  final _storageRef =
      FirebaseStorage.instance.ref(FireBaseUserKeys.userCollection);
  Future<String?> execute(context, File image) async {
    try {
      DocumentReference usersRef = FirebaseFirestore.instance
          .collection(FireBaseUserKeys.userCollection)
          .doc(user?.email);
      final uploadImageResult =
          await _storageRef.child(user?.email ?? '').putFile(
              image,
              SettableMetadata(
                contentType: "image/jpeg",
              ));
      final uploadPath = await uploadImageResult.ref.getDownloadURL();
      await usersRef
          .set({FireBaseUserKeys.image: uploadPath}, SetOptions(merge: true));
      AppSnackBars.success(context, title: 'Image Uploaded Success');
      return uploadPath;
    } on FirebaseAuthException catch (e) {
      AppSnackBars.error(context, title: e.code.replaceAll('-', ' '));
    } catch (e) {
      AppSnackBars.error(context, title: e.toString());
    }
    return null;
  }
}
