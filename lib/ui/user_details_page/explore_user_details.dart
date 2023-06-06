import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:with_you_app/common/material/app_buttons.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/container_widget.dart';
import 'package:with_you_app/common/material/network_image.dart';
import 'package:with_you_app/common/material/rating_bar.dart';
import 'package:with_you_app/common/material/text_styles.dart';
import 'package:with_you_app/common/utils/navigation.dart';
import 'package:with_you_app/domain/models/authentication/user_entity.dart';
import 'package:with_you_app/ui/explore/send_request_page/send_request_page.dart';

class UserDetailsPage extends StatelessWidget {
  final UserEntity user;
  UserDetailsPage({Key? key, required this.user}) : super(key: key);
  final _loggedUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _PageAppBar(
              imagePath: user.image,
            ),
            const SizedBox(
              height: 40,
            ),
            ContainerWidget(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.bold(
                            fontSize: 20, color: AppColors.neutral_500)),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                        '${user.type}  -  ${user.gender}  -  ${user.age} years old',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.bold(
                            fontSize: 12, color: AppColors.neutral_100)),
                    RatingBar(rate: double.tryParse(user.rate) ?? 3),
                  ]),
            ),
            ContainerWidget(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Country : ${user.country}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.regular(
                            // fontSize: 13,
                            color: AppColors.neutral_600)),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                        'Country Of Residence : ${user.countryOfResidence} - City : ${user.city}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.regular(
                            // fontSize: 13,
                            color: AppColors.neutral_600)),
                    const SizedBox(
                      height: 10,
                    ),
                    user.pricePerHour.isNotEmpty
                        ? Text('Price Per Hour : ${user.pricePerHour}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.regular(
                                // fontSize: 13,
                                color: AppColors.neutral_600))
                        : const SizedBox(),
                  ]),
            ),
            ContainerWidget(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Phone Number : : ${user.phoneNumber}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.regular(
                            // fontSize: 13,
                            color: AppColors.neutral_600)),
                    const SizedBox(
                      height: 10,
                    ),
                    Text('Experience : ${user.experience}  year',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.regular(
                            // fontSize: 13,
                            color: AppColors.neutral_600)),
                    const SizedBox(
                      height: 10,
                    ),
                    Text('Languages : ${user.languages.join(' , ')}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.regular(
                            // fontSize: 13,
                            color: AppColors.neutral_600)),
                  ]),
            ),
          ],
        ),
      ),
      floatingActionButton: _loggedUser?.email != user.emailAddress
          ? Container(
              height: 50,
              margin: const EdgeInsets.all(20),
              child: AppButtons.primaryButton(
                text: 'REQUEST  ${user.type}',
                onPressed: () {
                  navigate(
                      context,
                      SendRequestPage(
                        userEntity: user,
                      ));
                },
              ),
            )
          : const SizedBox(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _PageAppBar extends StatelessWidget {
  final String imagePath;
  const _PageAppBar({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .25,
      child: Stack(
        // fit: StackFit.expand,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .2,
            decoration: const BoxDecoration(
                color: AppColors.neutral_700,
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(100))),
          ),
          Positioned(
            bottom: 0,
            left: MediaQuery.of(context).size.width * .1,
            child: Material(
              elevation: .8,
              shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.white, width: 3),
                  borderRadius: BorderRadius.circular(100)),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: AppNetworkImage(
                    path: imagePath,
                    scale: .5,
                    width: MediaQuery.of(context).size.width * .3,
                    height: MediaQuery.of(context).size.width * .3,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 35, 20, 20),
            child: IconButton(
                onPressed: () => pop(context),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  }
}
