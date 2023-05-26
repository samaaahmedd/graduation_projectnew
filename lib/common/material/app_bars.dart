import 'package:flutter/material.dart';
import 'package:with_you_app/common/common.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/text_styles.dart';

class AppBars extends StatelessWidget {
  const AppBars(
      {Key? key,
      this.title,
      this.backgroundColor,
      this.leadingColor,
      this.autoImplementLeading = false})
      : super(key: key);
  final String? title;
  final Color? backgroundColor;
  final Color? leadingColor;
  final bool autoImplementLeading;

  static AppBar leadingAppBar(context,{Color? iconColor,Color? backgroundColor}) {
    return AppBar(
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: 0,
      leading: IconButton(
          onPressed: () => pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: iconColor ?? AppColors.neutral_700,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: 0,
      leading: IconButton(
          onPressed: () => pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: leadingColor ?? Colors.white,
          )),
      title: title != null
          ? Text(title ?? '', style: TextStyles.bold(fontSize: 18))
          : null,
    );
  }
}