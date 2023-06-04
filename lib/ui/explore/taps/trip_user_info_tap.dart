import 'package:flutter/material.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/text_styles.dart';
import 'package:with_you_app/domain/models/authentication/user_entity.dart';
import 'package:with_you_app/common/material/trip_header_widget.dart';

class TripUserInfoTap extends StatelessWidget {
  final UserEntity user;
  const TripUserInfoTap({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const HeaderRowWidget(
            text: "Name",
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(user.name,
                style: TextStyles.medium(
                    fontSize: 15, color: AppColors.neutral_600, height: 1.3)),
          ),
          const HeaderRowWidget(
            text: "Phone Number",
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(user.phoneNumber,
                style: TextStyles.medium(
                    fontSize: 15, color: AppColors.neutral_600, height: 1.3)),
          ),
          const HeaderRowWidget(
            text: "Email Address",
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(user.emailAddress,
                style: TextStyles.medium(
                    fontSize: 15, color: AppColors.neutral_600, height: 1.3)),
          ),
          const HeaderRowWidget(
            text: "Country",
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(user.country,
                style: TextStyles.medium(
                    fontSize: 15, color: AppColors.neutral_600, height: 1.3)),
          ),
          const HeaderRowWidget(
            text: "Gender",
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(user.gender,
                style: TextStyles.medium(
                    fontSize: 15, color: AppColors.neutral_600, height: 1.3)),
          ),
          const HeaderRowWidget(
            text: "Age",
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(user.age,
                style: TextStyles.medium(
                    fontSize: 15, color: AppColors.neutral_600, height: 1.3)),
          ),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }
}
