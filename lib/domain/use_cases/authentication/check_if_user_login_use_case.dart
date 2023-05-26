import 'package:firebase_auth/firebase_auth.dart';

class CheckIfUserLogInUseCase {
  bool execute() {
    User? result = FirebaseAuth.instance.currentUser;

    if (result != null) {
      return true;
    } else {
      return false;
    }
  }
}
