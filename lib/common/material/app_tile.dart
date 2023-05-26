import 'package:flutter/material.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/text_styles.dart';

class AppTile extends StatelessWidget {
  const AppTile(
      {Key? key,
      required this.onTap,
      required this.icon,
      required this.text,
      this.useDivider = false,
      this.trailing, this.isLoading = false})
      : super(key: key);
  final VoidCallback onTap;
  final IconData icon;
  final String text;
  final Icon? trailing;
  final bool useDivider;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          trailing: isLoading
              ? const SizedBox(
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                    strokeWidth: 3,
                  ),
                )
              : trailing ??
                  const Icon(Icons.arrow_forward_ios_rounded, size: 18),
          onTap: onTap,
          minLeadingWidth: 24,
          leading: Icon(
            icon,
            color: AppColors.neutral_700,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: Text(text,
              style: TextStyles.medium(
                fontSize: 18,
                color: AppColors.neutral_700,
              )),
        ),
        useDivider
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Divider(color: AppColors.neutral_50, height: 2),
              )
            : const SizedBox(),
      ],
    );
  }
}
