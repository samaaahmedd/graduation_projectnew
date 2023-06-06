import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:with_you_app/common/firebase_keys/firebase_keys.dart';
import 'package:with_you_app/common/images_paths/images_paths.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/app_loader.dart';
import 'package:with_you_app/common/material/fail_widget.dart';
import 'package:with_you_app/domain/models/requests/requests.dart';
import 'widgets/border_tab_inductor.dart';
import 'widgets/requests_card.dart';

class MyRequestsPage extends StatefulWidget {
  const MyRequestsPage({Key? key}) : super(key: key);

  @override
  State<MyRequestsPage> createState() => _MyRequestsPageState();
}

class _MyRequestsPageState extends State<MyRequestsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final ValueNotifier<int> _tabIndex = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      _tabIndex.value = _tabController.index;
    });
  }

  final Stream<QuerySnapshot> _requestsStream = FirebaseFirestore.instance
      .collection(FireBaseRequestUserKeys.requestsCollection)
      .where(FireBaseTripKeys.userId,
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
            List<RequestEntity> waitingList = [];
            List<RequestEntity> acceptedList = [];
            List<RequestEntity> canceledList = [];
            for (var request in requests) {
              if (request.requestState ==
                  FireBaseRequestUserKeys.waitingState) {
                waitingList.add(request);
              } else if (request.requestState ==
                  FireBaseRequestUserKeys.acceptedState) {
                acceptedList.add(request);
              } else if (request.requestState ==
                  FireBaseRequestUserKeys.canceledState) {
                canceledList.add(request);
              }
            }
            if (requests.isEmpty) {
              return Center(
                  child: Image.asset(
                ImagesPaths.noBooking,
                scale: 3,
              ));
            }
            return Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: AppColors.neutral_50, blurRadius: 5)
                      ],
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(35),
                      )),
                  child: CustomTabBar(
                    tabController: _tabController,
                  ),
                ),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: _tabIndex,
                    builder: (context, value, child) {
                      return IndexedStack(
                        index: value,
                        children: [
                          RequestCardBuilder(
                            requests: waitingList,
                          ),
                          RequestCardBuilder(
                            requests: acceptedList,
                          ),
                          RequestCardBuilder(
                            requests: canceledList,
                          ),
                        ],
                      );
                    },
                  ),
                )
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
