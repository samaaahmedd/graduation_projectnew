import 'package:firebase_auth/firebase_auth.dart';
import 'package:with_you_app/common/material/app_snackbars.dart';
import 'package:with_you_app/domain/models/authentication/user_auth_state.dart';

class LogInUseCase {
  Future<UserAuthStateEnum> execute(context,
      {required String email, required String password}) async {
    try {
      final result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      bool? isEmailVerified = result.user?.emailVerified;
      if (isEmailVerified == true) {
        return UserAuthStateEnum.isVerified;
      } else if (isEmailVerified == false) {
        await result.user?.sendEmailVerification();
        // AppSnackBars.hint(context,
        //     title: 'Please Check Your Mail Then Verify Your Email First.');
        return UserAuthStateEnum.unVerified;
      } else {
        return UserAuthStateEnum.isVerified;
      }
    } on FirebaseAuthException catch (e) {
      AppSnackBars.error(context, title: e.code.replaceAll('-', ' '));
    } catch (e) {
      AppSnackBars.error(context, title: e.toString());
    }
    return UserAuthStateEnum.unAuthenticated;
  }
}
