
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:with_you_app/common/common.dart';
import 'package:with_you_app/common/firebase_keys/firebase_keys.dart';
import 'package:with_you_app/common/material/app_buttons.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/domain/mappers/mappers.dart';
import 'package:with_you_app/domain/models/trips/trip_model.dart';
import 'package:with_you_app/ui/my_trips/add_trip_page.dart';

class MyTripsPage extends StatefulWidget {
  const MyTripsPage({Key? key}) : super(key: key);

  @override
  State<MyTripsPage> createState() => _MyTripsPageState();
}

class _MyTripsPageState extends State<MyTripsPage> {

  final Stream<QuerySnapshot> _tripsStream = FirebaseFirestore.instance.collection(FireBaseTripKeys.tripsCollection).snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      body: StreamBuilder<QuerySnapshot>(
      stream: _tripsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }


        if (snapshot.hasData) {
          print('===================================');
          List<TripEntity> trips = TripsMapper.convert(snapshot.data);
          print(trips.length);
          print('-------------------------------');
            return ListView.builder(itemCount: trips.length,itemBuilder: (context, index) {
            return Text(trips[index].title.toString());
          },);
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
