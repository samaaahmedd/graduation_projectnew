import 'package:flutter/material.dart';
import 'package:with_you_app/common/images_paths/images_paths.dart';
import 'package:with_you_app/common/material/app_buttons.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/text_styles.dart';

class FailWidget extends StatelessWidget {
  const FailWidget({Key? key, this.onRetry}) : super(key: key);
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(ImagesPaths.animatedError, scale: 4),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text('Failed To Load , Check Your Internet Connection',
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.bold(
                    height: 1.5, fontSize: 18, color: AppColors.neutral_400)),
          ),
          const SizedBox(
            height: 25,
          ),
          Visibility(
              replacement: const SizedBox(),
              visible: onRetry != null,
              child: AppButtons.primaryButton(
                  text: 'Reload', onPressed: onRetry, isExpanded: false)),
        ],
      ),
    );
  }
}
