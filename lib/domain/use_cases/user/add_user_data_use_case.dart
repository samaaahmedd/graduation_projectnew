import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:with_you_app/common/firebase_keys/firebase_keys.dart';
import 'package:with_you_app/common/material/app_snackbars.dart';
import 'package:with_you_app/domain/models/authentication/register_entity.dart';

class AddUserDataUseCase {
  final user = FirebaseAuth.instance.currentUser;

  Future<void> execute(context, UserRegisterEntity userRegisterEntity) async {
    try {
      DocumentReference usersRef = FirebaseFirestore.instance
          .collection(FireBaseUserKeys.userCollection)
          .doc(user?.uid);
      usersRef.set(userRegisterEntity.toMap(), SetOptions(merge: true));
    } on FirebaseAuthException catch (e) {
      AppSnackBars.error(context, title: e.code.replaceAll('-', ' '));
    } catch (e) {
      AppSnackBars.error(context, title: e.toString());
    }
  }
}
