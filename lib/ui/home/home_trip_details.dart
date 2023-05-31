import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:with_you_app/common/firebase_keys/firebase_keys.dart';
import 'package:with_you_app/common/material/app_bars.dart';
import 'package:with_you_app/common/material/app_buttons.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/app_loader.dart';
import 'package:with_you_app/common/material/text_styles.dart';
import 'package:with_you_app/common/utils/extenstions.dart';
import 'package:with_you_app/common/widgets/fail_widget.dart';
import 'package:with_you_app/domain/mappers/mappers.dart';
import 'package:with_you_app/domain/models/authentication/register_entity.dart';
import 'package:with_you_app/domain/models/trips/create_trip_entity.dart';
import 'package:with_you_app/domain/models/trips/trip_model.dart';
import 'package:with_you_app/domain/use_cases/trips/book_trip_use_case.dart';
import 'package:with_you_app/ui/home/taps/trip_tap_widget.dart';

import 'taps/trip_user_info_tap.dart';

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
              body: _DetailsBody(
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
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: AppBars.defaultAppBar(context, title: "Trip Details"),
      body: FutureBuilder<DocumentSnapshot>(
        future: _tripOwnerInfo.doc(widget.tripEntity.userId).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          print(snapshot.connectionState);
          if (snapshot.hasError) {
            return const FailWidget();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AppLoader();
          }
          if (snapshot.hasData && snapshot.data?.data() != null) {
            UserEntity userInfo = UserDataMapper.convert(snapshot.data!);
            return _DetailsBody(
              tripEntity: widget.tripEntity,
              user: userInfo,
            );
          }
          return const SizedBox();
        },
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
                  userId: widget.tripEntity.id,
                ));
            _isBookingLoading = false;
            setState(() {});
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _DetailsBody extends StatefulWidget {
  final TripEntity tripEntity;
  final UserEntity user;
  const _DetailsBody({Key? key, required this.tripEntity, required this.user})
      : super(key: key);

  @override
  State<_DetailsBody> createState() => _DetailsBodyState();
}

class _DetailsBodyState extends State<_DetailsBody> {
  _TapEnum selectedTap = _TapEnum.tripDetails;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TabBarWidget(
          tapEnum: selectedTap,
          onTap: (value) {
            selectedTap = value;
            setState(() {});
          },
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: IndexedStack(
              index: selectedTap.index,
              children: [
                TripTapWidget(tripEntity: widget.tripEntity),
                TripUserInfoTap(user: widget.user),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TabBarWidget extends StatelessWidget {
  _TabBarWidget({Key? key, required this.tapEnum, required this.onTap})
      : super(key: key);

  final List<String> tapsLabel = ['Details', 'Guide Info'];

  final _TapEnum tapEnum;
  final void Function(_TapEnum) onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: AppColors.forthColor),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        children: tapsLabel
            .mapIndexed((e, i) => Expanded(
                  child: InkWell(
                    onTap: () {
                      onTap(_TapEnum.values[i]);
                    },
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: tapEnum == _TapEnum.values[i]
                              ? AppColors.neutral_500
                              : AppColors.forthColor),
                      child: Text(e,
                          style: TextStyles.bold(
                              color: tapEnum == _TapEnum.values[i]
                                  ? Colors.white
                                  : AppColors.neutral_600)),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

enum _TapEnum { tripDetails, guideInfo }
