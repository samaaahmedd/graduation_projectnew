import 'package:equatable/equatable.dart';
import 'package:with_you_app/common/firebase_keys/firebase_keys.dart';
import 'package:with_you_app/domain/models/authentication/user_entity.dart';
import 'package:with_you_app/domain/models/trips/trip_model.dart';

class BookingResultModel {
  final String userId;
  final String tripId;
  final String guideId;

  BookingResultModel(
      {required this.userId, required this.tripId, required this.guideId});

  static BookingResultModel fromJson(Map<String, dynamic> json) {
    return BookingResultModel(
      userId: json[FireBaseBookingKeys.userId].toString(),
      tripId: json[FireBaseBookingKeys.tripId].toString(),
      guideId: json[FireBaseBookingKeys.guideId].toString(),
    );
  }
}

class MyBookingEntity extends Equatable {
  final String userId;
  final String tripId;
  final String guideId;
  final UserEntity user;
  final TripEntity trip;

  const MyBookingEntity(
      {required this.userId,required this.tripId,required this.guideId,required this.user,required this.trip});

  @override
  List<Object?> get props => throw UnimplementedError();
}
