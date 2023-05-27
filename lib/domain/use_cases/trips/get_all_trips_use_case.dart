//
// import 'dart:convert';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:with_you_app/domain/models/trips/trip_model.dart';
//
// class GetAllTripsUseCase{
//   final Stream<QuerySnapshot> _tripsStream = FirebaseFirestore.instance.collection('users').snapshots();
//   Future<TripEntity> execute() async{
//      final data = await _tripsStream.map((event) => TripEntity.fromJson(event)).toList();
//      final List<Map<String,dynamic>> data = json.decode(_tripsStream.data!.docs as String) ;
//      final List<TripEntity> trips = data.map((e) => TripEntity.fromJson(e) ).toList();
//   }
// }