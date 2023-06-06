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
      this.animation})
      : super(key: key);
  final VoidCallback onTap;
  final UserEntity user;

  final AnimationController? animationController;
  final Animation<double>? animation;
  @override
  Widget build(BuildContext context) {
    if (animationController == null) {
      return Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
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
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AppNetworkImage(
                path: user.image,
                width: 55,
                height: 55,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.bold(
                          fontSize: 18, color: AppColors.neutral_100)),
                  RatingBar(rate: double.tryParse(user.rate) ?? 3),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(user.type.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.bold(color: AppColors.neutral_100)),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('${user.countryOfResidence} / ${user.city}',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.regular(color: AppColors.neutral_600)),
                  const SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: [
                      Text(user.gender,
                          overflow: TextOverflow.ellipsis,
                          style:
                              TextStyles.regular(color: AppColors.neutral_600)),
                      const Spacer(),
                      Text('${user.pricePerHour} \$ / h',
                          overflow: TextOverflow.ellipsis,
                          style:
                              TextStyles.regular(color: AppColors.neutral_600)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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
                child: Column(
                  children: [
                    Row(
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
                                      fontSize: 12,
                                      color: AppColors.neutral_100)),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(user.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyles.bold(
                                      fontSize: 20,
                                      color: AppColors.neutral_500)),
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
                                  ? Text(
                                      'Price Per Hour : ${user.pricePerHour}',
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
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
