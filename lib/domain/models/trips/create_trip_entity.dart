import 'package:with_you_app/common/firebase_keys/firebase_keys.dart';

class CreateTripEntity{
  final String userId;
  final String guidedId;
  final String tripId;

  CreateTripEntity({required this.userId,required this.guidedId,required this.tripId});

  Map<String,dynamic> toJson(CreateTripEntity entity){
    return {
      FireBaseBookingKeys.userId : entity.userId,
      FireBaseBookingKeys.guideId : entity.guidedId,
      FireBaseBookingKeys.tripId : entity.tripId,
    };
  }
}