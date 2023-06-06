import 'package:equatable/equatable.dart';
import 'package:with_you_app/common/firebase_keys/firebase_keys.dart';

class RequestEntity extends Equatable {
  final String requestId;
  final String userId;
  final String requestedUserId;
  final String date;
  final String numberOfPersons;
  final String bookingDuration;
  final String expectedPrice;
  final String requestState;

  const RequestEntity({
    this.requestId = '',
    required this.bookingDuration,
    required this.expectedPrice,
    required this.userId,
    required this.requestedUserId,
    required this.date,
    required this.numberOfPersons,
    required this.requestState,
  });

  static RequestEntity fromJson(Map<String, dynamic> json,
      {String? requestId}) {
    return RequestEntity(
      requestId: requestId ?? '',
      userId: json[FireBaseRequestUserKeys.userId].toString(),
      requestedUserId: json[FireBaseRequestUserKeys.requestedUserId].toString(),
      date: json[FireBaseRequestUserKeys.date].toString(),
      numberOfPersons: json[FireBaseRequestUserKeys.numberOfPersons].toString(),
      requestState: json[FireBaseRequestUserKeys.requestState].toString(),
      bookingDuration: json[FireBaseRequestUserKeys.bookingDuration].toString(),
      expectedPrice: json[FireBaseRequestUserKeys.expectedPrice].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      FireBaseRequestUserKeys.userId: userId,
      FireBaseRequestUserKeys.requestedUserId: requestedUserId,
      FireBaseRequestUserKeys.date: date,
      FireBaseRequestUserKeys.numberOfPersons: numberOfPersons,
      FireBaseRequestUserKeys.requestState: requestState,
      FireBaseRequestUserKeys.expectedPrice: expectedPrice,
      FireBaseRequestUserKeys.bookingDuration: bookingDuration,
    };
  }

  @override
  List<Object?> get props => [
        userId,
        requestedUserId,
        date,
        numberOfPersons,
        requestState,
        expectedPrice,
        bookingDuration
      ];
}
