import 'package:flutter/material.dart';

import '../app_colors.dart';

class AppRadioTile<T> extends StatelessWidget {
  final T? value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final Widget title;
  final EdgeInsetsGeometry? paddingInsets;
  final Color? unSelectedColor;

  const AppRadioTile(
      {super.key,
      this.value,
      this.groupValue,
      this.onChanged,
      required this.title,
      this.paddingInsets,
      this.unSelectedColor});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          unselectedWidgetColor: unSelectedColor ?? AppColors.neutral_50,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: AppColors.neutral_20,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          listTileTheme: const ListTileThemeData(
            horizontalTitleGap: 5,
          ),
          radioTheme: const RadioThemeData(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          )),
      child: RadioListTile<T?>(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        activeColor: AppColors.neutral_500,
        contentPadding: paddingInsets,
        title: title,
      ),
    );
  }
}

class GroupRadioButton<T> extends StatelessWidget {
  final List? values;
  final List<String> textList;
  final void Function(T?)? onChanged;
  final T? value;

  const GroupRadioButton({
    Key? key,
    this.values,
    required this.textList,
    this.onChanged,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: textList.length,
      itemBuilder: (context, index) {
        final itemValue = values != null ? values![index] : textList[index];
        return AppRadioTile<T>(
            groupValue: value,
            unSelectedColor: AppColors.neutral_300,
            title: Text(
              textList[index],
              style: const TextStyle(
                fontSize: 16.0,
                color: AppColors.neutral_900,
              ),
            ),
            value: itemValue,
            onChanged: onChanged);
      },
    );
  }
}
