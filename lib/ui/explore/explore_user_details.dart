import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:with_you_app/common/firebase_keys/firebase_keys.dart';
import 'package:with_you_app/common/material/app_bars.dart';
import 'package:with_you_app/common/material/app_buttons.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/app_loader.dart';
import 'package:with_you_app/common/material/fail_widget.dart';
import 'package:with_you_app/common/material/network_image.dart';
import 'package:with_you_app/common/material/rating_bar.dart';
import 'package:with_you_app/common/material/text_styles.dart';
import 'package:with_you_app/domain/mappers/mappers.dart';
import 'package:with_you_app/domain/models/authentication/user_entity.dart';
import 'package:with_you_app/domain/use_cases/trips/book_trip_use_case.dart';
import 'package:with_you_app/common/material/trip_header_widget.dart';

class ExploreUserDetails extends StatefulWidget {
  final UserEntity user;
  const ExploreUserDetails({Key? key, required this.user}) : super(key: key);

  @override
  State<ExploreUserDetails> createState() => _ExploreUserDetailsState();
}

class _ExploreUserDetailsState extends State<ExploreUserDetails> {
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
        future: _tripOwnerInfo.doc(widget.user.emailAddress).get(),
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
              body: UserInfoPreview(
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
                    // await _bookTripUseCase.execute(
                    //     context,
                    //     CreateTripEntity(
                    //       // todo
                    //       guidedId: widget.tripEntity.userId,
                    //       tripId: widget.tripEntity.id,
                    //       userId: userInfo.emailAddress,
                    //     ));
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
  }
}

class UserInfoPreview extends StatelessWidget {
  final UserEntity user;
  const UserInfoPreview({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: const EdgeInsets.all(15),
                    height: MediaQuery.of(context).size.width * .35,
                    width: MediaQuery.of(context).size.width * .35,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: AppNetworkImage(
                      path: user.image,
                      scale: 2.5,
                    )),
                Text(user.name.toUpperCase(),
                    style: TextStyles.bold(
                        fontSize: 22,
                        color: AppColors.neutral_500,
                        height: 1.3)),
                const SizedBox(
                  height: 10,
                ),
                Text(user.emailAddress,
                    style: TextStyles.medium(
                        fontSize: 18,
                        color: AppColors.neutral_500,
                        height: 1.3)),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          HeaderRowWidget(
            text: '\t${user.type.toUpperCase()}',
          ),
          const HeaderRowWidget(
            text: "Price ( per hour ) 50",
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: Text('${user.pricePerHour} \$ / h',
                style: TextStyles.medium(
                    fontSize: 15, color: AppColors.neutral_600, height: 1.3)),
          ),
          const HeaderRowWidget(
            text: "Details",
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: Text('Phone Number : ${user.phoneNumber}',
                style: TextStyles.medium(
                    fontSize: 15, color: AppColors.neutral_600, height: 1.3)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Rating : ',
                    style: TextStyles.medium(
                        fontSize: 15,
                        color: AppColors.neutral_600,
                        height: 1.3)),
                RatingBar(
                  rate: double.tryParse(user.rate) ?? 2,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: Text('Languages : ${user.languages.toString()}',
                style: TextStyles.medium(
                    fontSize: 15, color: AppColors.neutral_600, height: 1.3)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: Text('Gender : ${user.gender.toString()}',
                style: TextStyles.medium(
                    fontSize: 15, color: AppColors.neutral_600, height: 1.3)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: Text('Age : ${user.age.toString()}',
                style: TextStyles.medium(
                    fontSize: 15, color: AppColors.neutral_600, height: 1.3)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: Text('Experience : ${user.experience.toString()}',
                style: TextStyles.medium(
                    fontSize: 15, color: AppColors.neutral_600, height: 1.3)),
          ),
          const HeaderRowWidget(
            text: "Address Details",
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: Text('Country : ${user.country.toString()}',
                style: TextStyles.medium(
                    fontSize: 15, color: AppColors.neutral_600, height: 1.3)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: Text(
                'Country Of Residence : ${user.countryOfResidence.toString()}',
                style: TextStyles.medium(
                    fontSize: 15, color: AppColors.neutral_600, height: 1.3)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: Text('City : ${user.city.toString()}',
                style: TextStyles.medium(
                    fontSize: 15, color: AppColors.neutral_600, height: 1.3)),
          ),
          const SizedBox(
            height: 150,
          ),
        ],
      ),
    );
  }
}
