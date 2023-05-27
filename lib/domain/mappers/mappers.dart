import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:with_you_app/domain/models/trips/trip_model.dart';

class TripsMapper {
  static List<TripEntity> convert(QuerySnapshot? snapshot) {
    if (snapshot != null) {
      final List<Map<String, dynamic>> data =
          snapshot.docs.map((DocumentSnapshot document) {
        return document.data()! as Map<String, dynamic>;
      }).toList();
      final List<TripEntity> trips =
          data.map((e) => TripEntity.fromJson(e)).toList();
      return trips;
    } else {
      return [];
    }
  }
}
