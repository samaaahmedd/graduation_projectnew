import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:with_you_app/common/utils/navigation.dart';
import 'package:with_you_app/common/firebase_keys/firebase_keys.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/app_loader.dart';
import 'package:with_you_app/common/material/fail_widget.dart';
import 'package:with_you_app/domain/mappers/mappers.dart';
import 'package:with_you_app/domain/models/trips/trip_model.dart';
import 'explore_trip_card.dart';
import 'explore_trip_details.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with TickerProviderStateMixin {
  final Stream<QuerySnapshot> _tripsStream = FirebaseFirestore.instance
      .collection(FireBaseTripKeys.tripsCollection)
      .snapshots();
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
          if (snapshot.hasData && snapshot.data != null) {
            List<TripEntity> trips = TripsMapper.convert(snapshot.data);
            return ListView.builder(
              itemCount: trips.length,
              itemBuilder: (context, index) {
                final int count = trips.length;
                final Animation<double> animation =
                    Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: _animationController!,
                    curve: Interval((1 / count) * index, 1.0,
                        curve: Curves.fastOutSlowIn),
                  ),
                );
                _animationController?.forward();
                return ExploreTripCard(
                  onTap: () {
                    navigate(
                        context,
                        ExploreTripDetails(
                          tripEntity: trips[index],
                        ));
                  },
                  animation: animation,
                  animationController: _animationController,
                  tripDetails: trips[index],
                );
              },
              padding: const EdgeInsets.all(20),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
