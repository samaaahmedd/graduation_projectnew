import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:with_you_app/common/common.dart';
import 'package:with_you_app/common/firebase_keys/firebase_keys.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/app_loader.dart';
import 'package:with_you_app/common/material/text_styles.dart';
import 'package:with_you_app/common/widgets/fail_widget.dart';
import 'package:with_you_app/domain/mappers/mappers.dart';
import 'package:with_you_app/domain/models/trips/booking_model.dart';
import 'package:with_you_app/domain/use_cases/trips/get_all_bboking_trips_with_detais.dart';

import 'booking_details_page.dart';

class MyBookingPage extends StatefulWidget {
  const MyBookingPage({Key? key}) : super(key: key);

  @override
  State<MyBookingPage> createState() => _MyBookingPageState();
}

class _MyBookingPageState extends State<MyBookingPage> {
  final Stream<QuerySnapshot> _bookingStream = FirebaseFirestore.instance
      .collection(FireBaseBookingKeys.bookingCollection)
      .where(FireBaseBookingKeys.userId,
          isEqualTo: FirebaseAuth.instance.currentUser?.email)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      body: StreamBuilder(
        stream: _bookingStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const FailWidget();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AppLoader();
          }
          if (snapshot.hasData) {
            List<BookingResultModel> booking =
                BookingResultMapper.convert(snapshot.data);
            return BookingPageBody(
              bookingData: booking,
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class BookingPageBody extends StatefulWidget {
  const BookingPageBody({Key? key, required this.bookingData})
      : super(key: key);
  final List<BookingResultModel> bookingData;

  @override
  State<BookingPageBody> createState() => _BookingPageBodyState();
}

class _BookingPageBodyState extends State<BookingPageBody>
    with TickerProviderStateMixin {
  final GetAllBookingTripsWithDetails _allBookingTripsWithDetails =
      GetAllBookingTripsWithDetails();

  Future<List<MyBookingEntity>> getData() async {
    return await _allBookingTripsWithDetails.execute(widget.bookingData);
  }

  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MyBookingEntity>>(
      future: getData(),
      builder: (BuildContext context,
          AsyncSnapshot<List<MyBookingEntity>> snapshot) {
        if (snapshot.hasError) {
          return const FailWidget();
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AppLoader();
        }
        if (snapshot.hasData) {
          final data = snapshot.data;
          if (data != null) {
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: data.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: .65,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10),
              itemBuilder: (BuildContext context, int index) {
                final int count = data.length;
                final Animation<double> animation =
                    Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: _animationController!,
                    curve: Interval((1 / count) * index, 1.0,
                        curve: Curves.fastOutSlowIn),
                  ),
                );
                _animationController?.forward();
                return _TripWidget(
                  animation: animation,
                  animationController: _animationController,
                  bookingDetails: data[index],
                );
              },
            );
          }

          return const SizedBox();
        }
        return const SizedBox();
      },
    );
  }
}

class _TripWidget extends StatelessWidget {
  const _TripWidget(
      {Key? key,
      required this.bookingDetails,
      this.animationController,
      this.animation})
      : super(key: key);
  final MyBookingEntity bookingDetails;

  final AnimationController? animationController;
  final Animation<double>? animation;
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation!.value), 0.0),
            child: InkWell(
              onTap: () {
                navigate(
                    context,
                    BookingDetailsPage(
                      bookingEntity: bookingDetails,
                    ));
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(vertical: 8),
                // padding: const EdgeInsets.all(15),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  border: Border.all(color: AppColors.neutral_30),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.neutral_30,
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(1, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        borderRadius: BorderRadius.circular(8.0),
                        child: FadeInImage.assetNetwork(
                          image: bookingDetails.trip.images.first,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          placeholder: ' ',
                          placeholderErrorBuilder:
                              (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.withOpacity(.3),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(bookingDetails.trip.title,
                              style: TextStyles.medium(
                                  fontSize: 16,
                                  color: AppColors.neutral_600,
                                  height: 1.3)),
                          // const AppDivider(
                          //     height: 1, horizontalPadding: 0, verticalPadding: 5),
                          // Text(bookingDetails.user.name,
                          //     style: TextStyles.medium(
                          //         fontSize: 16, color: AppColors.neutral_600, height: 1.3)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
