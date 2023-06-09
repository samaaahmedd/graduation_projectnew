import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:with_you_app/common/firebase_keys/firebase_keys.dart';
import 'package:with_you_app/common/images_paths/images_paths.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/app_loader.dart';
import 'package:with_you_app/common/material/fail_widget.dart';
import 'package:with_you_app/common/material/text_styles.dart';
import 'package:with_you_app/common/utils/navigation.dart';
import 'package:with_you_app/domain/models/requests/requests.dart';
import 'package:with_you_app/ui/my_requests/request_details.dart';

class MyBookingPage extends StatefulWidget {
  const MyBookingPage({Key? key}) : super(key: key);

  @override
  State<MyBookingPage> createState() => _MyBookingPageState();
}

class _MyBookingPageState extends State<MyBookingPage> {
  final Stream<QuerySnapshot> _requestsStream = FirebaseFirestore.instance
      .collection(FireBaseRequestUserKeys.requestsCollection)
      .where(FireBaseRequestUserKeys.userId,
          isEqualTo: FirebaseAuth.instance.currentUser?.email)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      body: StreamBuilder<QuerySnapshot>(
        stream: _requestsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const FailWidget();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AppLoader();
          }
          if (snapshot.hasData && snapshot.data?.docs != null) {
            List<RequestEntity> requests = snapshot.data?.docs
                    .map((e) => RequestEntity.fromJson(
                        e.data() as Map<String, dynamic>,
                        requestId: e.id))
                    .toList() ??
                [];
            if (requests.isEmpty) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    ImagesPaths.tripIllustrator,
                    scale: 3,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text("You Don't Book Any Trip Yet",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.bold(
                          fontSize: 20, color: AppColors.neutral_500)),
                ],
              ));
            }
            return ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final requestEntity = requests[index];
                return InkWell(
                  onTap: () {
                    navigate(
                        context,
                        RequestDetailsPage(
                          requestEntity: requestEntity,
                          canAccept: false,fromBooking: true,
                        ));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.fromLTRB(25, 15, 15, 15),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(20),
                      ),
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Date : ${requestEntity.date}  -  No.Persons : ${requestEntity.numberOfPersons}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.bold(
                                fontSize: 12, color: AppColors.neutral_100)),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(requestEntity.requestedUserId.split('@').first,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.bold(
                                fontSize: 20, color: AppColors.neutral_500)),
                        const SizedBox(
                          height: 14,
                        ),
                        Text('Request State : ${requestEntity.requestState}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.bold(
                                fontSize: 12, color: AppColors.neutral_100)),
                      ],
                    ),
                  ),
                );
              },
              padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 20, 40),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
