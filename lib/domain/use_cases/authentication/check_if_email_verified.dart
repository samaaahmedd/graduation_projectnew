import 'package:firebase_auth/firebase_auth.dart';
import 'package:with_you_app/common/material/app_snackbars.dart';

class CheckIfEmailVerified {
  Future<bool> execute(context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final emailVerified = user.emailVerified;
        if (!emailVerified) {
          AppSnackBars.hint(context, title: 'Please Verify Email First');
          return false;
        }
      }
      return true;
    } on FirebaseAuthException catch (e) {
      AppSnackBars.error(context, title: e.code.replaceAll('-', ' '));
    } catch (e) {
      AppSnackBars.error(context, title: e.toString());
    }
    return false;
  }
}
