import 'package:flutter/material.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/network_image.dart';
import 'package:with_you_app/common/material/rating_bar.dart';
import 'package:with_you_app/common/material/text_styles.dart';
import 'package:with_you_app/domain/models/authentication/user_entity.dart';

class UserCard extends StatelessWidget {
  const UserCard(
      {Key? key,
      required this.onTap,
      required this.user,
      this.animationController,
      this.animation,
      this.padding})
      : super(key: key);
  final VoidCallback onTap;
  final UserEntity user;
  final double? padding;

  final AnimationController? animationController;
  final Animation<double>? animation;
  @override
  Widget build(BuildContext context) {
    if (animationController == null) {
      return _CardDesign(
        verticalPadding: padding,
        user: user,
      );
    }
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation!.value), 0.0),
            child: InkWell(
              onTap: onTap,
              child: _CardDesign(user: user),
            ),
          ),
        );
      },
    );
  }
}

class _CardDesign extends StatelessWidget {
  const _CardDesign({Key? key, required this.user, this.verticalPadding})
      : super(key: key);

  final double? verticalPadding;
  final UserEntity user;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin:
          EdgeInsets.symmetric(horizontal: verticalPadding ?? 12, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
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
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    '${user.type}  -  ${user.gender}  -  ${user.age} years old',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.bold(
                        fontSize: 12, color: AppColors.neutral_100)),
                const SizedBox(
                  height: 10,
                ),
                Text(user.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.bold(
                        fontSize: 20, color: AppColors.neutral_500)),
                const SizedBox(
                  height: 10,
                ),
                Text(
                    'Detailed Address : ${user.countryOfResidence} / ${user.city}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.regular(
                        // fontSize: 13,
                        color: AppColors.neutral_600)),
                RatingBar(rate: double.tryParse(user.rate) ?? 3),
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
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: AppNetworkImage(
              path: user.image,
              width: 50,
              height: 50,
            ),
          ),
        ],
      ),
    );
  }
}
