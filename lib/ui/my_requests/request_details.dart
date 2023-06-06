// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:with_you_app/common/firebase_keys/firebase_keys.dart';
import 'package:with_you_app/common/material/app_bars.dart';
import 'package:with_you_app/common/material/app_buttons.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/app_loader.dart';
import 'package:with_you_app/common/material/container_widget.dart';
import 'package:with_you_app/common/material/fail_widget.dart';
import 'package:with_you_app/common/material/network_image.dart';
import 'package:with_you_app/common/material/text_styles.dart';
import 'package:with_you_app/common/utils/navigation.dart';
import 'package:with_you_app/domain/mappers/mappers.dart';
import 'package:with_you_app/domain/models/authentication/user_entity.dart';
import 'package:with_you_app/domain/models/requests/requests.dart';
import 'package:with_you_app/domain/use_cases/user/set_user_request_state.dart';

class RequestDetailsPage extends StatelessWidget {
  final RequestEntity requestEntity;
  final bool canAccept;
  RequestDetailsPage(
      {Key? key, required this.requestEntity, this.canAccept = true})
      : super(key: key);

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
        stream: _user.doc(requestEntity.userId).snapshots(),
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
                  ContainerWidget(
                    child: Text('Request State : ${requestEntity.requestState}',
                        style:
                            TextStyles.regular(color: AppColors.neutral_600)),
                  ),
                  ContainerWidget(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '${userInfo.type}  -  ${userInfo.gender}  -  ${userInfo.age} years old',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyles.bold(
                                      fontSize: 12,
                                      color: AppColors.neutral_100)),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(userInfo.name,
                                  style: TextStyles.bold(
                                      fontSize: 20,
                                      color: AppColors.neutral_500)),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                  'Country Of Residence : ${userInfo.countryOfResidence}',
                                  style: TextStyles.regular(
                                      color: AppColors.neutral_600)),
                              const SizedBox(
                                height: 10,
                              ),
                              Text('Phone Number : ${userInfo.phoneNumber}',
                                  style: TextStyles.regular(
                                      color: AppColors.neutral_600)),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                  'Languages : ${userInfo.languages.join(' , ')}',
                                  style: TextStyles.regular(
                                      color: AppColors.neutral_600)),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: AppNetworkImage(
                            path: userInfo.image,
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ContainerWidget(
                    child: Text('Date : ${requestEntity.date}',
                        style:
                            TextStyles.regular(color: AppColors.neutral_600)),
                  ),
                  ContainerWidget(
                    child: Text(
                        'Number Of Persons : ${requestEntity.numberOfPersons}',
                        style:
                            TextStyles.regular(color: AppColors.neutral_600)),
                  ),
                  requestEntity.expectedPrice.isNotEmpty
                      ? ContainerWidget(
                          child: Text(
                              'Expected Price : ${requestEntity.expectedPrice}',
                              style: TextStyles.regular(
                                  color: AppColors.neutral_600)),
                        )
                      : const SizedBox(),
                  ContainerWidget(
                    child: Text(
                        'Booking Duration : ${requestEntity.bookingDuration}  day',
                        style:
                            TextStyles.regular(color: AppColors.neutral_600)),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
      bottomNavigationBar:
          (requestEntity.requestState == FireBaseRequestUserKeys.waitingState &&
                  canAccept)
              ? Container(
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
                              final result =
                                  await _setUserRequestStateUseCase.execute(
                                      context,
                                      requestEntity.requestId,
                                      FireBaseRequestUserKeys.canceledState);
                              if (result) {
                                pop(context);
                              }
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
                              final result =
                                  await _setUserRequestStateUseCase.execute(
                                      context,
                                      requestEntity.requestId,
                                      FireBaseRequestUserKeys.acceptedState);
                              if (result) {
                                pop(context);
                              }
                              _isAcceptLoading.value = false;
                            },
                          );
                        },
                      )),
                    ],
                  ),
                )
              : const SizedBox(),
    );
  }
}
