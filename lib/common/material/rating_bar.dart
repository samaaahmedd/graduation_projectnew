import 'package:flutter/material.dart';
import 'package:with_you_app/common/material/app_colors.dart';

class RatingBar extends StatelessWidget {
  const RatingBar({Key? key, required this.rate}) : super(key: key);

  final double rate;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 10),
        separatorBuilder: (context, index) {
          return const SizedBox(
            width: 1,
          );
        },
        itemBuilder: (context, index) {
          if (index < rate) {
            return const Icon(
              Icons.star,
              color: AppColors.neutral_300,
              size: 19,
            );
          }
          return const Icon(
            Icons.star_border,
            color: AppColors.neutral_300,
            size: 19,
          );
        },
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: 5,
      ),
    );
  }
}
