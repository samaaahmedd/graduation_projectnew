import 'package:firebase_auth/firebase_auth.dart';
import 'package:with_you_app/common/material/app_snackbars.dart';

class UpdatePasswordUseCase {
  Future<bool> execute(context,
      {required String password, required String confirmPassword}) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (confirmPassword == password) {
        await user?.updatePassword(password);
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
