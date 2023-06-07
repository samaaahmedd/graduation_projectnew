import 'package:flutter/material.dart';

import 'app_colors.dart';

Future<T?> appBottomSheet<T>(
  context, {
  required Widget Function(BuildContext context) builder,
  bool checkBorder = true,
  bool useRootNavigator = true,
  Color? barrierColor,
  Color? backgroundColor,
}) async {
  return showModalBottomSheet<T>(
    useRootNavigator: useRootNavigator,
    backgroundColor: backgroundColor ?? AppColors.forthColor,
    clipBehavior: Clip.antiAlias,
    barrierColor: barrierColor,
    shape: RoundedRectangleBorder(
      borderRadius: checkBorder
          ? const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            )
          : BorderRadius.circular(0),
    ),
    isScrollControlled: true,
    context: context,
    builder: builder,
  );
}
