import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:with_you_app/common/images_paths/images_paths.dart';
import 'package:with_you_app/common/material/network_image.dart';
import 'package:with_you_app/common/utils/navigation.dart';
import 'package:with_you_app/common/firebase_keys/firebase_keys.dart';
import 'package:with_you_app/common/material/app_buttons.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/app_loader.dart';
import 'package:with_you_app/common/material/text_styles.dart';
import 'package:with_you_app/common/material/fail_widget.dart';
import 'package:with_you_app/domain/mappers/mappers.dart';
import 'package:with_you_app/domain/models/trips/trip_model.dart';
import 'package:with_you_app/ui/my_trips/add_trip_page.dart';
import 'package:with_you_app/ui/my_trips/trip_details_page.dart';

class MyTripsPage extends StatefulWidget {
  const MyTripsPage({Key? key}) : super(key: key);

  @override
  State<MyTripsPage> createState() => _MyTripsPageState();
}

class _MyTripsPageState extends State<MyTripsPage> {
  final Stream<QuerySnapshot> _tripsStream = FirebaseFirestore.instance
      .collection(FireBaseTripKeys.tripsCollection)
      .where(FireBaseTripKeys.userId,
          isEqualTo: FirebaseAuth.instance.currentUser?.email)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      body: StreamBuilder<QuerySnapshot>(
        stream: _tripsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const FailWidget();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AppLoader();
          }
          if (snapshot.hasData) {
            List<TripEntity> trips = TripsMapper.convert(snapshot.data);
            if (trips.isEmpty) {
              return Center(
                  child: Image.asset(
                ImagesPaths.noBooking,
                scale: 3,
              ));
            }
            return ListView.builder(
              itemCount: trips.length,
              itemBuilder: (context, index) {
                return _TripWidget(
                  onTap: () {
                    navigate(
                        context,
                        TripDetailsPage(
                          trip: trips[index],
                        ));
                  },
                  tripDetails: trips[index],
                );
              },
              padding: const EdgeInsets.all(20),
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: Container(
        height: 70,
        padding: const EdgeInsets.only(bottom: 25.0),
        child: AppButtons.primaryButton(
            onPressed: () {
              navigate(context, const AddTripPage());
            },
            isExpanded: false,
            text: "Create Trip"),
      ),
    );
  }
}

class _TripWidget extends StatelessWidget {
  const _TripWidget({Key? key, required this.onTap, required this.tripDetails})
      : super(key: key);
  final VoidCallback onTap;
  final TripEntity tripDetails;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(15),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              borderRadius: BorderRadius.circular(8.0),
              child: AppNetworkImage(
                path: tripDetails.images.first,
                height: 60,
                width: 60,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tripDetails.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.bold(
                          fontSize: 16, color: AppColors.neutral_100)),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(tripDetails.description,
                      style: TextStyles.regular(
                          color: AppColors.neutral_600, height: 1.3)),
                  // const AppDivider(height: 1.5),
                  // Text(tripDetails.activities,
                  //     maxLines: 3,
                  //     style: TextStyles.regular(color: AppColors.neutral_600,height: 1.3)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
