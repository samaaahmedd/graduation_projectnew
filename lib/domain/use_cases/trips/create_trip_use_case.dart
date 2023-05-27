import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:with_you_app/common/firebase_keys/firebase_keys.dart';
import 'package:with_you_app/common/material/app_snackbars.dart';
import 'package:with_you_app/domain/models/trips/trip_model.dart';

class CreateTripUseCase {
  CollectionReference trips =
      FirebaseFirestore.instance.collection(FireBaseTripKeys.tripsCollection);
  final _user = FirebaseAuth.instance.currentUser;
  final _storageRef = FirebaseStorage.instance.ref();
  final Random _random = Random();
  Future<bool> execute(context, TripEntity tripEntity) async {
    List<String> uploadedImagesPaths = [];
    try {
      // upload images
      for (File image in tripEntity.pickedImages ?? []) {
        int randomNumber = _random.nextInt(100000000);
        final uploadImageResult = await _storageRef
            .child(
                '${FireBaseStorageKeys.tripsImagesCollection}/$randomNumber${image.path.split('/').last}')
            .putFile(
                image,
                SettableMetadata(
                  contentType: "image/jpeg",
                ));
        final uploadPath = await uploadImageResult.ref.getDownloadURL();
        uploadedImagesPaths.add(uploadPath);
      }
      // add trip details to cloud
      await trips.add(tripEntity.toJson(
          _user?.uid ?? tripEntity.userId, uploadedImagesPaths));
      AppSnackBars.success(context, title: 'Trip Created Successfully');
      return true;
    } on Exception catch (e) {
      AppSnackBars.error(context, title: e.toString());
      return false;
    } catch (e) {
      AppSnackBars.error(context, title: e.toString());
      return false;
    }
  }
}
