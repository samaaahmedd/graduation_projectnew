
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:with_you_app/domain/models/authentication/user_entity.dart';
import 'package:with_you_app/domain/models/trips/booking_model.dart';
import 'package:with_you_app/domain/models/trips/trip_model.dart';

class TripsMapper {
  static List<TripEntity> convert(QuerySnapshot? snapshot) {
    if (snapshot != null) {
      final List<Map<String, dynamic>> data =
          snapshot.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> item =  document.data()! as Map<String, dynamic>;
        item.putIfAbsent('id', () => document.id);
        return item;
      }).toList();
      final List<TripEntity> trips =
          data.map((e) => TripEntity.fromJson(e)).toList();
      return trips;
    } else {
      return [];
    }
  }
}

class UserDataMapper{
  static UserEntity convert(DocumentSnapshot snapshot){
    Map<String, dynamic> data =
    snapshot.data() as Map<String, dynamic>;
    return UserEntity.fromJson(data);
  }

  static UserEntity convertQuery(QuerySnapshot snapshot){
    Map<String, dynamic> data =
    snapshot as Map<String, dynamic>;
    return UserEntity.fromJson(data);
  }

  static List<UserEntity> convertList(QuerySnapshot? snapshot) {
    if (snapshot != null) {
      final List<Map<String, dynamic>> data =
      snapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> item =  document.data()! as Map<String, dynamic>;
        return item;
      }).toList();
      final List<UserEntity> trips =
      data.map((e) => UserEntity.fromJson(e)).toList();
      return trips;
    } else {
      return [];
    }
  }
}

class BookingResultMapper{
  static List<BookingResultModel> convert(QuerySnapshot? snapshot){
    if (snapshot != null) {
      final List<Map<String, dynamic>> data =
      snapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> item =  document.data()! as Map<String, dynamic>;
        return item;
      }).toList();
      final List<BookingResultModel> listData =
      data.map((e) => BookingResultModel.fromJson(e)).toList();
      return listData;
    } else {
      return [];
    }
  }
}

