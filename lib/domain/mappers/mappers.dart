
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:with_you_app/domain/models/authentication/register_entity.dart';
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
}
