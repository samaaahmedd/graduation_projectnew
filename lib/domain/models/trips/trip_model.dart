import 'dart:convert';
import 'dart:io';

import 'package:with_you_app/common/firebase_keys/firebase_keys.dart';

class TripEntity {
  final String userId;
  final String title;
  final String price;
  final String activities;
  final String description;
  final String meetingPoint;
  final String noPersons;
  final String duration;
  final String phoneNumber;
  final String notes;
  final String notAllowed;
  final List<String> images;
  final List<File>? pickedImages;

  TripEntity( {this.pickedImages,
    this.userId = '',
    required this.title,
    required this.price,
    required this.activities,
    required this.description,
    required this.meetingPoint,
    required this.noPersons,
    required this.duration,
    required this.phoneNumber,
    required this.notes,
    required this.notAllowed,
    required this.images,
  });

  Map<String, dynamic> toJson(userId,List<String> uploadedImagesPaths) {
    return {
      FireBaseTripKeys.userId: userId,
      FireBaseTripKeys.title: title,
      FireBaseTripKeys.price: price,
      FireBaseTripKeys.description: description,
      FireBaseTripKeys.meetingPoint: meetingPoint,
      FireBaseTripKeys.noPersons: noPersons,
      FireBaseTripKeys.durationInDays: duration,
      FireBaseTripKeys.contactPhone: phoneNumber,
      FireBaseTripKeys.notAllowed: notAllowed,
      FireBaseTripKeys.activities: activities,
      FireBaseTripKeys.notes: notes,
      FireBaseTripKeys.images: uploadedImagesPaths,
    };
  }

  static TripEntity fromJson(Map<String, dynamic> json) {
    List<String> imagesConverted = (json[FireBaseTripKeys.images] as List).map((e)=> e as String).toList();
    return TripEntity(
      userId: json[FireBaseTripKeys.userId].toString(),
      title: json[FireBaseTripKeys.title].toString(),
      price: json[FireBaseTripKeys.price].toString(),
      activities: json[FireBaseTripKeys.activities].toString(),
      description: json[FireBaseTripKeys.description].toString(),
      meetingPoint: json[FireBaseTripKeys.meetingPoint].toString(),
      noPersons: json[FireBaseTripKeys.noPersons].toString(),
      duration: json[FireBaseTripKeys.durationInDays].toString(),
      phoneNumber: json[FireBaseTripKeys.contactPhone].toString(),
      notes: json[FireBaseTripKeys.notes].toString(),
      notAllowed: json[FireBaseTripKeys.notAllowed].toString(),
      images: imagesConverted,
    );
  }
}
