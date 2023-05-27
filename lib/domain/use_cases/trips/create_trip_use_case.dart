import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:with_you_app/common/firebase_keys/firebase_keys.dart';
import 'package:with_you_app/common/material/app_snackbars.dart';
import 'package:with_you_app/domain/models/trips/trip_model.dart';

class CreateTripUseCase {
  CollectionReference trips =
      FirebaseFirestore.instance.collection(FireBaseTripKeys.tripsCollection);
  final user = FirebaseAuth.instance.currentUser;
  Future<bool> execute(context, TripEntity tripEntity) async {
  return  await trips.add(tripEntity.toJson(user?.uid ?? tripEntity.userId)).then((value) {
      AppSnackBars.success(context, title: 'Trip Created Successfully');
      return true;
    }).catchError((error) {
      AppSnackBars.error(context, title: error);
      return false;
    });
  }
}
