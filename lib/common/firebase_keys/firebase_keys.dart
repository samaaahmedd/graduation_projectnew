class FireBaseUserKeys {
  static const String userCollection = 'users';
  static const String email = 'email';
  static const String password = 'password';
  static const String name = 'name';
  static const String age = 'age';
  static const String country = 'country';
  static const String phone = 'phone';
  static const String gender = 'gender';
  static const String languages = 'languages';
  static const String experience = 'experience';
  static const String countryOfResidence = 'countryOfResidence';
  static const String image = 'image';
  static const String pricePerHour = 'pricePerHour';
  static const String city = 'city';
  static const String rate = 'rate';
  static const String type = 'type';
}

class FireBaseTripKeys {
  static const String tripsCollection = 'trips';
  static const String userId = 'userId';
  static const String title = 'title';
  static const String price = 'price';
  static const String activities = 'activities';
  static const String description = 'description';
  static const String meetingPoint = 'meetingPoint';
  static const String noPersons = 'noPersons';
  static const String contactPhone = 'contactPhone';
  static const String notes = 'notes';
  static const String notAllowed = 'notAllowedHints';
  static const String durationInDays = 'durationInDays';
  static const String id = 'id';
  static const String images = 'images';
}

class FireBaseStorageKeys {
  static const String usersImagesCollection = 'usersImages';
  static const String tripsImagesCollection = 'tripsImages';
}

class FireBaseBookingKeys {
  static const String bookingCollection = 'booking';
  static const String guideId = 'guideId';
  static const String userId = 'userId';
  static const String tripId = 'tripId';
}

class FireBaseRequestUserKeys {
  static const String requestsCollection = 'requests';
  static const String userId = 'userId';
  static const String requestedUserId = 'requestedUserId';
  static const String date = 'date';
  static const String numberOfPersons = 'numberOfPersons';
  static const String requestState = 'requestState';
  static const String expectedPrice = 'expectedPrice';
  static const String bookingDuration = 'bookingDuration';
  static const String waitingState = 'Waiting';
  static const String acceptedState = 'Accepted';
  static const String canceledState = 'Canceled';
}
