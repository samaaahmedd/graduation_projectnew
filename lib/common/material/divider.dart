import 'package:flutter/material.dart';
import 'package:with_you_app/common/material/app_colors.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({Key? key, this.horizontalPadding, this.verticalPadding})
      : super(key: key);
  final double? horizontalPadding;
  final double? verticalPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: horizontalPadding ?? 0, vertical: verticalPadding ?? 15),
      width: MediaQuery.of(context).size.width,
      height: 2.5,
      color: AppColors.neutral_30,
    );
  }
}
