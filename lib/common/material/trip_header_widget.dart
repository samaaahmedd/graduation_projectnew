import 'package:flutter/material.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/text_styles.dart';

class HeaderRowWidget extends StatelessWidget {
  const HeaderRowWidget({Key? key, required this.text, this.margin = 15})
      : super(key: key);

  final String text;
  final double margin;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.forthColor,
      padding: const EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: margin),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Text(text,
            maxLines: 3,
            style: TextStyles.bold(
              fontSize: 16,
              color: AppColors.neutral_500,
            )),
      ),
    );
  }
}
