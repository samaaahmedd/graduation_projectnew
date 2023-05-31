import 'package:flutter/material.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/text_styles.dart';

class TripIconTileWidget extends StatelessWidget {
  const TripIconTileWidget({Key? key, required this.icon, required this.text})
      : super(key: key);
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
      child: Row(
        children: [
          Icon(icon, color: AppColors.neutral_300, size: 22),
          const SizedBox(
            width: 10,
          ),
          Text(text,
              maxLines: 3,
              style: TextStyles.regular(
                  color: AppColors.neutral_600, fontSize: 16)),
        ],
      ),
    );
  }
}
