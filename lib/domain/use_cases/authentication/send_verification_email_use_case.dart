import 'package:firebase_auth/firebase_auth.dart';
import 'package:with_you_app/common/material/app_snackbars.dart';

class SendVerificationEmail {
  Future<bool> execute(context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final emailVerified = user.emailVerified;
        if (!emailVerified) {
          await user.reload();
          await user.sendEmailVerification();
          AppSnackBars.success(context, title: 'Verification Email Sent');
          return false;
        } else {
          return true;
        }
      }
      return false;
    } on FirebaseAuthException catch (e) {
      AppSnackBars.error(context, title: e.code.replaceAll('-', ' '));
    } catch (e) {
      AppSnackBars.error(context, title: e.toString());
    }
    return false;
  }
}
