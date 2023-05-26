import 'package:firebase_auth/firebase_auth.dart';
import 'package:with_you_app/common/material/app_snackbars.dart';
import 'package:with_you_app/domain/models/authentication/register_entity.dart';

import 'set_user_information.dart';

class RegisterUseCase {
  final SetUserInformationUseCase _informationUseCase =
      SetUserInformationUseCase();
  Future<bool> execute(context, UserRegisterEntity registerEntity) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: registerEntity.emailAddress,
        password: registerEntity.password,
      );
      await _informationUseCase.execute(context);
      return true;
    } on FirebaseAuthException catch (e) {
      AppSnackBars.error(context, title: e.code.replaceAll('-', ' '));
    } catch (e) {
      AppSnackBars.error(context, title: e.toString());
    }
    return false;
  }
}
