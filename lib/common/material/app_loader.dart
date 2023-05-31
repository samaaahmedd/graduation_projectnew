
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:with_you_app/common/material/app_colors.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: LoadingAnimationWidget.fourRotatingDots(
        color: AppColors.neutral_600,
        size: 55,
    ));
  }
}