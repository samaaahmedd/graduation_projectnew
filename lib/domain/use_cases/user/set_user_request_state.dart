import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:with_you_app/common/firebase_keys/firebase_keys.dart';
import 'package:with_you_app/common/material/app_snackbars.dart';

class SetUserRequestStateUseCase {
  final CollectionReference _requests = FirebaseFirestore.instance
      .collection(FireBaseRequestUserKeys.requestsCollection);
  Future<bool> execute(context, String requestId, String requestState) async {
    try {
      await _requests.doc(requestId).set(
          {FireBaseRequestUserKeys.requestState: requestState},
          SetOptions(merge: true));
      AppSnackBars.success(context, title: 'Request $requestState Success');
      return true;
    } on Exception catch (e) {
      AppSnackBars.error(context, title: e.toString());
      return false;
    } catch (e) {
      AppSnackBars.error(context, title: e.toString());
      return false;
    }
  }
}
