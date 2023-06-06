import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:with_you_app/common/firebase_keys/firebase_keys.dart';
import 'package:with_you_app/common/material/app_bars.dart';
import 'package:with_you_app/common/material/app_buttons.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/app_loader.dart';
import 'package:with_you_app/common/material/fail_widget.dart';
import 'package:with_you_app/common/material/network_image.dart';
import 'package:with_you_app/common/material/text_styles.dart';
import 'package:with_you_app/domain/mappers/mappers.dart';
import 'package:with_you_app/domain/models/authentication/user_entity.dart';
import 'package:with_you_app/domain/models/requests/requests.dart';
import 'package:with_you_app/domain/use_cases/user/set_user_request_state.dart';

class RequestDetailsPage extends StatefulWidget {
  final RequestEntity requestEntity;
  const RequestDetailsPage({Key? key, required this.requestEntity})
      : super(key: key);

  @override
  State<RequestDetailsPage> createState() => _RequestDetailsPageState();
}

class _RequestDetailsPageState extends State<RequestDetailsPage> {
  final _user =
      FirebaseFirestore.instance.collection(FireBaseUserKeys.userCollection);

  final SetUserRequestStateUseCase _setUserRequestStateUseCase =
      SetUserRequestStateUseCase();

  final ValueNotifier<bool> _isAcceptLoading = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isCancelLoading = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: AppBars.defaultAppBar(context, title: 'Request Details'),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: _user.doc(widget.requestEntity.requestedUserId).snapshots(),
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
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      children: [
                        Container(
                          width: 65,
                          height: 65,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                              color: AppColors.neutral_30,
                              borderRadius: BorderRadius.circular(50)),
                          child: AppNetworkImage(path: userInfo.image),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(userInfo.name,
                                style: TextStyles.bold(fontSize: 18)),
                            const SizedBox(
                              height: 7,
                            ),
                            Text(userInfo.emailAddress,
                                style: TextStyles.medium(fontSize: 15)),
                          ],
                        ))
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
      bottomNavigationBar: Container(
        height: 50,
        margin: const EdgeInsets.fromLTRB(25, 10, 25, 30),
        child: Row(
          children: [
            Expanded(
                child: ValueListenableBuilder(
              valueListenable: _isCancelLoading,
              builder: (context, value, child) {
                return AppButtons.outline(
                  text: 'Reject',
                  isLoading: value,
                  onPressed: () async {
                    _isCancelLoading.value = true;
                    final result = await _setUserRequestStateUseCase.execute(
                        context,
                        widget.requestEntity.requestId,
                        FireBaseRequestUserKeys.canceledState);
                    _isCancelLoading.value = false;
                  },
                );
              },
            )),
            const SizedBox(
              width: 15,
            ),
            Expanded(
                child: ValueListenableBuilder(
              valueListenable: _isAcceptLoading,
              builder: (context, value, child) {
                return AppButtons.primaryButton(
                  text: 'Accept',
                  isLoading: value,
                  onPressed: () async {
                    _isAcceptLoading.value = true;
                    final result = await _setUserRequestStateUseCase.execute(
                        context,
                        widget.requestEntity.requestId,
                        FireBaseRequestUserKeys.acceptedState);
                    _isAcceptLoading.value = false;
                  },
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}
