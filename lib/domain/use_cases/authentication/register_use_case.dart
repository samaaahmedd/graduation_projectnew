import 'package:firebase_auth/firebase_auth.dart';
import 'package:with_you_app/common/material/app_snackbars.dart';

class RegisterUseCase {
  // final SetUserDataUseCase _setUserDataUseCase = SetUserDataUseCase();
  Future<bool> execute(context,
      {required String email, required String password}) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.sendEmailVerification();
      // await _setUserDataUseCase.execute(context, registerEntity);
      return true;
    } on FirebaseAuthException catch (e) {
      AppSnackBars.error(context, title: e.code.replaceAll('-', ' '));
    } catch (e) {
      AppSnackBars.error(context, title: e.toString());
    }
    return false;
  }
}
