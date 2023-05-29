import 'package:firebase_auth/firebase_auth.dart';
import 'package:with_you_app/common/material/app_snackbars.dart';
import 'package:with_you_app/domain/models/authentication/register_entity.dart';
import 'package:with_you_app/domain/use_cases/user/add_user_data_use_case.dart';

import 'set_user_information.dart';

class RegisterUseCase {
  final SetUserInformationUseCase _informationUseCase =
      SetUserInformationUseCase();
  final AddUserDataUseCase _addUserDataUseCase = AddUserDataUseCase();
  Future<bool> execute(context, UserEntity registerEntity) async {
    try {
      final credential  = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: registerEntity.emailAddress,
        password: registerEntity.password,
      );
      await credential.user?.sendEmailVerification();
      await _addUserDataUseCase.execute(context, registerEntity);
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
