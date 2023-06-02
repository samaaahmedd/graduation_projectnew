import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:with_you_app/common/firebase_keys/firebase_keys.dart';
import 'package:with_you_app/common/material/app_snackbars.dart';

class UpdatePasswordUseCase {
  final user = FirebaseAuth.instance.currentUser;
  Future<bool> execute(context,
      {required String password, required String confirmPassword}) async {
    try {
      if (confirmPassword == password) {
        await user?.updatePassword(password);
        DocumentReference usersRef = FirebaseFirestore.instance
            .collection(FireBaseUserKeys.userCollection)
            .doc(user?.email);
        await usersRef.set(
            {FireBaseUserKeys.password: password}, SetOptions(merge: true));
        AppSnackBars.success(context, title: 'Password Updated Successfully');
        return true;
      } else {
        AppSnackBars.hint(context,
            title: 'New Password And Confirm Password Should Be Identical');
      }
    } on FirebaseAuthException catch (e) {
      AppSnackBars.error(context, title: e.code.replaceAll('-', ' '));
    } catch (e) {
      AppSnackBars.error(context, title: e.toString());
    }
    return false;
  }
}
