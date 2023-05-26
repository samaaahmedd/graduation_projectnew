import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'text_styles.dart';

class AppButtons extends StatelessWidget {
  const AppButtons({
    Key? key,
    this.onPressed,
    this.buttonColor,
    this.elevation,
    this.padding,
    this.height,
    this.shape,
    this.child,
    this.text,
    this.disabledButtonColor,
    this.minWidth,
    this.textStyle,
    this.isLoading = false,
    this.isExpanded = true,
    this.textColor,
    this.fontSize,
    this.disabledTextColor,
    this.textDecoration,
    this.margin,
  }) : super(key: key);
  final void Function()? onPressed;
  final Color? buttonColor;
  final String? text;
  final Color? textColor;
  final Color? disabledTextColor;
  final double? fontSize;
  final TextStyle? textStyle;
  final Color? disabledButtonColor;
  final double? elevation;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? height;
  final ShapeBorder? shape;
  final Widget? child;
  final double? minWidth;
  final bool isLoading;
  final bool isExpanded;
  final TextDecoration? textDecoration;

  static AppButtons primaryButton(
      {required String text,
      void Function()? onPressed,
      bool? useAnimation,
      bool? isExpanded,
      EdgeInsetsGeometry? margin,
      bool? isLoading,
      double? height,
      double? fontSize,
      TextDecoration? textDecoration}) {
    return AppButtons(
      margin: margin,
      text: text,
      fontSize: fontSize,
      height: height,
      isExpanded: isExpanded ?? true,
      onPressed: onPressed,
      isLoading: isLoading ?? false,
    );
  }

  static AppButtons textButton({
    required String text,
    double? fontSize,
    void Function()? onPressed,
    TextStyle? textStyle,
    TextDecoration? textDecoration,
    Color? disabledTextColor,
    Color? textColor,
    double? height,
    bool? isLoading,
    EdgeInsetsGeometry? padding,
  }) {
    return AppButtons(
      text: text,
      height: height,
      onPressed: onPressed,
      padding: padding,
      disabledTextColor: disabledTextColor ?? AppColors.buttonPrimaryColor,
      buttonColor: Colors.transparent,
      disabledButtonColor: Colors.transparent,
      elevation: 0,
      isExpanded: false,
      textColor: textColor ?? AppColors.textPrimaryColor,
      textDecoration: textDecoration,
      fontSize: fontSize,
      isLoading: isLoading ?? false,
    );
  }

  static AppButtons outline({
    required String text,
    double? fontSize,
    void Function()? onPressed,
    TextStyle? textStyle,
    TextDecoration? textDecoration,
    Color? disabledTextColor,
    Color? textColor,
    bool isExpanded = false,
    double? height,
  }) {
    return AppButtons(
      text: text,
      height: height,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: const BorderSide(width: 1, color: AppColors.borderColor)),
      onPressed: onPressed,
      disabledTextColor: disabledTextColor ?? AppColors.textSecondaryColor,
      buttonColor: Colors.transparent,
      disabledButtonColor: Colors.transparent,
      elevation: 0,
      isExpanded: isExpanded,
      textColor: textColor ?? AppColors.textPrimaryColor,
      textDecoration: textDecoration,
      fontSize: fontSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: MaterialButton(
        onPressed: isLoading ? null : onPressed,
        focusColor: buttonColor ?? AppColors.neutral_90,
        disabledColor: disabledButtonColor ?? AppColors.buttonTertiaryColor,
        splashColor: Colors.transparent,
        textColor: textColor ?? AppColors.forthColor,
        color: buttonColor ?? AppColors.neutral_600,
        elevation: elevation ?? 0,
        highlightColor: Colors.transparent,
        focusElevation: 0,
        highlightElevation: 0,
        padding: padding,
        height: height ?? 48,
        disabledTextColor: disabledTextColor ?? AppColors.forthColor,
        disabledElevation: elevation,
        minWidth: minWidth,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: shape ??
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
        child: Row(
          mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 12,
            ),
            Visibility(
                visible: isExpanded,
                replacement: Center(
                    child: child ??
                        Text(
                          key: ValueKey(text),
                          text ?? 'Enter text parameter',
                          style: textStyle ??
                              TextStyles.bold(
                                color: textColor ?? AppColors.forthColor,
                                fontSize: fontSize ?? 15,
                              ),
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          softWrap: true,
                        )),
                child: Expanded(
                  child: Center(
                      child: child ??
                          Text(
                            key: ValueKey(text),
                            text ?? 'Enter text parameter',
                            style: textStyle ??
                                TextStyles.bold(
                                  color: textColor ?? AppColors.forthColor,
                                  fontSize: fontSize ?? 15,
                                ),
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            softWrap: true,
                          )),
                )),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              key: ValueKey(isLoading),
              child: isLoading
                  ? const SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                        strokeWidth: 2,
                      ),
                    )
                  : const SizedBox(
                      width: 10,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
