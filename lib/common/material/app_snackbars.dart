import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'text_styles.dart';

class AppSnackBars extends StatelessWidget {
  const AppSnackBars({
    Key? key,
    this.duration,
    this.icon,
    required this.title,
    this.subTitle,
    this.borderSide,
    this.elevation,
    this.color,
    this.snackBarBehavior,
    this.snackBarPosition,
    this.leadingWidget,
  }) : super(key: key);

  final int? duration;
  final IconData? icon;
  final String title;
  final String? subTitle;
  final BorderSide? borderSide;
  final double? elevation;
  final Color? color;
  final SnackBarBehavior? snackBarBehavior;
  final SnackBarPosition? snackBarPosition;
  final Widget? leadingWidget;

  static void success(context, {required String title, String? subTitle}) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      AppSnackBars(
        title: title,
        subTitle: subTitle,
        icon: Icons.check_circle_outline,
        borderSide: const BorderSide(width: 1.2, color: AppColors.neutral_20),
      ).build(context) as SnackBar,
    );
  }

  static void error(context, {required String title, String? subTitle}) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      AppSnackBars(
        title: title,
        subTitle: subTitle,
        color: AppColors.warningLight,
        icon: Icons.report_gmailerrorred_outlined,
        snackBarPosition: SnackBarPosition.bottom,
        borderSide:  const BorderSide(width: 1, color: AppColors.warning),
      ).build(context) as SnackBar,
    );
  }

  static void warning(context, {required String title, String? subTitle}) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      AppSnackBars(
        title: title,
        subTitle: subTitle,
        color: AppColors.warningLight,
        icon: Icons.warning,
        borderSide: const BorderSide(width: 1, color: AppColors.warning),
      ).build(context) as SnackBar,
    );
  }


  static void hint(context, {required String title}) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      AppSnackBars(
        title: title,
        icon:  Icons.tips_and_updates_outlined,
        borderSide: const BorderSide(width: 1, color: AppColors.neutral_30),
      ).build(context) as SnackBar,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      margin: toastMargin(context, snackBarPosition),
      behavior: snackBarBehavior ?? SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          side: borderSide ?? BorderSide.none),
      duration: Duration(seconds: duration ?? 10),
      backgroundColor: color ?? Colors.white,
      elevation: elevation,
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // const SizedBox(
                //   height: 5,
                // ),
                Text(
                  title,
                  style: TextStyles.medium(
                    color: AppColors.neutral_900,
                  ),
                ),
                subTitle != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Text(
                          subTitle!,
                          style: TextStyles.regular(
                              color: AppColors.neutral_400,
                              height: 1.1),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }


  static const double toastHorizontalMargin = 16;

  EdgeInsetsGeometry? toastMargin(context, SnackBarPosition? snackBarPosition) {
    switch (snackBarPosition) {
      case null:
      case SnackBarPosition.normal:
      case SnackBarPosition.bottom:
        return EdgeInsets.only(
            bottom: (MediaQuery.of(context).viewPadding.bottom + 30),
            right: toastHorizontalMargin,
            left: toastHorizontalMargin);
      case SnackBarPosition.center:
        return EdgeInsets.only(
            bottom: (MediaQuery.of(context).size.height * .46),
            right: toastHorizontalMargin,
            left: toastHorizontalMargin);
      case SnackBarPosition.top:
        return EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height -
                (MediaQuery.of(context).viewPadding.top + kToolbarHeight + 35),
            right: toastHorizontalMargin,
            left: toastHorizontalMargin);
    }
  }
}

enum SnackBarPosition { bottom, center, top, normal }
