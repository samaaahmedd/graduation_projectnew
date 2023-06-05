import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:with_you_app/common/firebase_keys/firebase_keys.dart';
import 'package:with_you_app/common/material/app_snackbars.dart';
import 'package:with_you_app/domain/models/requests/requests.dart';

class RequestUserUseCase {
  final CollectionReference _requests = FirebaseFirestore.instance
      .collection(FireBaseRequestUserKeys.requestsCollection);
  // final _user = FirebaseAuth.instance.currentUser;
  Future<bool> execute(context, RequestEntity requestEntity) async {
    try {
      await _requests.add(requestEntity.toJson());
      AppSnackBars.success(context, title: 'Request Sent Successfully');
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
