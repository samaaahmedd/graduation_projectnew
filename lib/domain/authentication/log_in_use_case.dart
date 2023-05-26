import 'package:firebase_auth/firebase_auth.dart';
import 'package:with_you_app/common/material/app_snackbars.dart';

class LogInUseCase {
  Future<bool> execute(context,
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      AppSnackBars.error(context, title: e.code.replaceAll('-', ' '));
    } catch (e) {
      AppSnackBars.error(context, title: e.toString());
    }
    return false;
  }
}
