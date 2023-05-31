import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:with_you_app/common/firebase_keys/firebase_keys.dart';
import 'package:with_you_app/common/material/app_bars.dart';
import 'package:with_you_app/common/material/app_buttons.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/app_loader.dart';
import 'package:with_you_app/common/widgets/fail_widget.dart';
import 'package:with_you_app/domain/mappers/mappers.dart';
import 'package:with_you_app/domain/models/authentication/register_entity.dart';
import 'package:with_you_app/domain/models/trips/create_trip_entity.dart';
import 'package:with_you_app/domain/models/trips/trip_model.dart';
import 'package:with_you_app/domain/use_cases/trips/book_trip_use_case.dart';
import 'package:with_you_app/ui/my_trips/widgets/trip_page_details_body.dart';

class HomeTripDetails extends StatefulWidget {
  final TripEntity tripEntity;
  const HomeTripDetails({Key? key, required this.tripEntity}) : super(key: key);

  @override
  State<HomeTripDetails> createState() => _HomeTripDetailsState();
}

class _HomeTripDetailsState extends State<HomeTripDetails> {
  final CollectionReference _tripOwnerInfo =
      FirebaseFirestore.instance.collection(FireBaseUserKeys.userCollection);
  final BookTripUseCase _bookTripUseCase = BookTripUseCase();

  bool _isBookingLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: AppBars.defaultAppBar(context, title: "Trip Details"),
      body: FutureBuilder<DocumentSnapshot>(
        future: _tripOwnerInfo.doc(widget.tripEntity.userId).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const FailWidget();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AppLoader();
          }
          if (snapshot.hasData && snapshot.data?.data() != null) {
            UserEntity userInfo = UserDataMapper.convert(snapshot.data!);
            return Scaffold(
              backgroundColor: AppColors.appBackgroundColor,
              body: TripDetailsBody(
                tripEntity: widget.tripEntity,
                user: userInfo,
              ),
              floatingActionButton: Container(
                height: 50,
                margin: const EdgeInsets.all(20),
                child: AppButtons.primaryButton(
                  text: 'Book Trip',
                  isLoading: _isBookingLoading,
                  onPressed: () async {
                    _isBookingLoading = true;
                    setState(() {});
                    await _bookTripUseCase.execute(
                        context,
                        CreateTripEntity(
                          // todo
                          guidedId: widget.tripEntity.userId,
                          tripId: widget.tripEntity.id,
                          userId: userInfo.emailAddress,
                        ));
                    _isBookingLoading = false;
                    setState(() {});
                  },
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
