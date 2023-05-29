import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:with_you_app/common/firebase_keys/firebase_keys.dart';
import 'package:with_you_app/common/material/app_snackbars.dart';
import 'package:with_you_app/domain/models/trips/create_trip_entity.dart';

class BookTripUseCase {
  CollectionReference booking = FirebaseFirestore.instance
      .collection(FireBaseBookingKeys.bookingCollection);
  Future<bool> execute(
    context,
    CreateTripEntity createTripEntity,
  ) async {
    try {
      await booking.add(createTripEntity.toJson(createTripEntity));
      AppSnackBars.success(context, title: 'Trip Booked Successfully');
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
