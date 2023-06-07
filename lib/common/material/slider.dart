import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'text_styles.dart';

class SliderWidget extends StatelessWidget {
  final double sliderValue;
  final void Function(double)? onChanged;
  const SliderWidget({Key? key, required this.sliderValue, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price Range',
            style: TextStyles.medium(
              color: AppColors.neutral_800,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Theme(
            data: ThemeData(
                sliderTheme: const SliderThemeData(
              showValueIndicator: ShowValueIndicator.always,
            )),
            child: Slider(
                value: sliderValue,
                activeColor: AppColors.neutral_500,
                inactiveColor: AppColors.neutral_50,
                min: 0,
                max: 10000,
                label: sliderValue.round().toString(),
                onChanged: onChanged),
          ),
        ],
      ),
    );
  }
}
