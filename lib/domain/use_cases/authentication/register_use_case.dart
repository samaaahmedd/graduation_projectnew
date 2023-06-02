import 'package:firebase_auth/firebase_auth.dart';
import 'package:with_you_app/common/material/app_snackbars.dart';
import 'package:with_you_app/domain/models/authentication/user_entity.dart';
import 'package:with_you_app/domain/use_cases/user/set_user_data_use_case.dart';

class RegisterUseCase {
  final SetUserDataUseCase _setUserDataUseCase = SetUserDataUseCase();
  Future<bool> execute(context, UserEntity registerEntity) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: registerEntity.emailAddress,
        password: registerEntity.password,
      );
      await credential.user?.sendEmailVerification();
      await _setUserDataUseCase.execute(context, registerEntity);
      return true;
    } on FirebaseAuthException catch (e) {
      AppSnackBars.error(context, title: e.code.replaceAll('-', ' '));
    } catch (e) {
      AppSnackBars.error(context, title: e.toString());
    }
    return false;
  }
}
