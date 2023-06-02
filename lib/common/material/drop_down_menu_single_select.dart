import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:with_you_app/common/utils/extenstions.dart';

import 'app_colors.dart';
import 'text_styles.dart';

// ignore: must_be_immutable
class SingleSelectDropDown<T> extends StatelessWidget {
  final List<T> itemsValues;
  final List<String> showItems;
  final String? selectedText;
  final String hint;
  T? value;
  String? label;
  final void Function(T? selectedItem) onChanged;
  final bool isEnabled;

  SingleSelectDropDown(
      {Key? key,
      required this.itemsValues,
      required this.showItems,
      required this.onChanged,
      required this.hint,
      this.value,
      this.label,
      this.selectedText,
      this.isEnabled = true})
      : super(key: key);

  int? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
                visible: label != null,
                replacement: const SizedBox(),
                child: Column(
                  children: [
                    Text(
                      label ?? "",
                      style: TextStyles.medium(
                        color: AppColors.neutral_800,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                )),
            Visibility(
              visible: isEnabled,
              replacement: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  selectedText ?? hint,
                  style: TextStyles.regular(),
                  maxLines: 1,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<T>(
                  isExpanded: true,
                  hint: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      hint,
                      style: TextStyles.regular(
                        color: AppColors.neutral_100,
                      ),
                    ),
                  ),
                  items: showItems.mapIndexed((item, index) {
                    final itemValue = itemsValues[index];
                    return DropdownMenuItem<T>(
                      value: itemValue,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          color: (value != itemValue)
                              ? AppColors.forthColor
                              : AppColors.neutral_50,
                        ),
                        child: Text(item,
                            style: TextStyles.regular(
                                color: AppColors.neutral_700)),
                      ),
                    );
                  }).toList(),
                  value: value,
                  onChanged: onChanged,
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: MediaQuery.of(context).size.height * .35,
                    elevation: 1,
                    scrollbarTheme: ScrollbarThemeData(
                      thumbColor: MaterialStateProperty.all<Color>(
                          AppColors.primaryColor),
                      thickness: MaterialStateProperty.all<double>(8),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.forthColor,
                      border: Border.all(width: 1, color: AppColors.neutral_30),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  buttonStyleData: ButtonStyleData(
                      decoration: BoxDecoration(
                        color: AppColors.forthColor,
                        border: Border.all(color: AppColors.neutral_60),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      overlayColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.white)),
                  selectedItemBuilder: (context) {
                    return showItems.map(
                      (item) {
                        return Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(
                            selectedText ?? hint,
                            style: TextStyles.regular(),
                            maxLines: 1,
                          ),
                        );
                      },
                    ).toList();
                  },
                  menuItemStyleData: const MenuItemStyleData(
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
