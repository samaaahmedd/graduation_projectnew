// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:with_you_app/common/material/app_snackbars.dart';
//
// class SetUserInformationUseCase {
//   Future<bool> execute(context) async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       await user?.updateDisplayName("Magdy Ebrahim");
//       return true;
//     } on FirebaseAuthException catch (e) {
//       AppSnackBars.error(context, title: e.code.replaceAll('-', ' '));
//     } catch (e) {
//       AppSnackBars.error(context, title: e.toString());
//     }
//     return false;
//   }
// }
