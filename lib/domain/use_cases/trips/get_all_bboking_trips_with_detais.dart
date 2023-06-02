import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:with_you_app/common/firebase_keys/firebase_keys.dart';
import 'package:with_you_app/common/utils/extenstions.dart';
import 'package:with_you_app/domain/mappers/mappers.dart';
import 'package:with_you_app/domain/models/authentication/user_entity.dart';
import 'package:with_you_app/domain/models/trips/booking_model.dart';
import 'package:with_you_app/domain/models/trips/trip_model.dart';

class GetAllBookingTripsWithDetails {
  Future<List<MyBookingEntity>> execute(List<BookingResultModel> bookingResult) async {
    final trips = await FirebaseFirestore.instance
        .collection(FireBaseTripKeys.tripsCollection)
        .get();
    List<TripEntity> tripsEntities = TripsMapper.convert(trips);
    final users = await FirebaseFirestore.instance
        .collection(FireBaseUserKeys.userCollection)
        .get();
    List<UserEntity> usersEntities = UserDataMapper.convertList(users);

    List<MyBookingEntity> myBooking = [];
    if (tripsEntities.isNotEmpty && usersEntities.isNotEmpty) {
      for (BookingResultModel item in bookingResult) {

        // get trip data
        TripEntity? currentTrip;
        int? currentTripIndex = tripsEntities
            .firstIndexWhere((element) => element.id == item.tripId);
        if(currentTripIndex != null){
          currentTrip = tripsEntities[currentTripIndex];
        }

        // get trip data
        UserEntity? currentUser;
        int? currentUserIndex = usersEntities
            .firstIndexWhere((element) => element.emailAddress == item.userId);
        if(currentUserIndex != null){
          currentUser = usersEntities[currentUserIndex];
        }

        if(currentUser != null && currentTrip != null){

        // set current booking model
        MyBookingEntity currentBooking = MyBookingEntity(
          guideId: item.guideId,
          tripId: item.tripId,
          userId: item.userId,
          trip: currentTrip,
          user: currentUser
        );
          myBooking.add(currentBooking);
        }

      }
    }
    return myBooking;
  }
}
