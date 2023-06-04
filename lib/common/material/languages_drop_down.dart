import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:with_you_app/common/material/text_styles.dart';

import 'app_colors.dart';

class LanguagesDropDown extends StatefulWidget {
  final List<String> initialValues;
  final bool isEnabled;
  final String? label;
  const LanguagesDropDown(
      {Key? key,
      required this.onchange,
      required this.initialValues,
      this.isEnabled = true,
      this.label})
      : super(key: key);
  final void Function(List<String>) onchange;

  @override
  State<LanguagesDropDown> createState() => _LanguagesDropDownState();
}

class _LanguagesDropDownState extends State<LanguagesDropDown> {
  final List<String> languages = [
    'Arabic',
    'English',
    "Japan",
    "Chinese",
    "Spanish",
    "Francis"
  ];
  List<String> selectedItems = [];

  @override
  void initState() {
    selectedItems = widget.initialValues;
    setState(() {});
    super.initState();
  }

  int progressIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
            visible: widget.label != null,
            replacement: const SizedBox(),
            child: Column(
              children: [
                Text(
                  widget.label ?? "",
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
            visible: widget.isEnabled,
            replacement: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: Text(
                selectedItems.map((e) => e).toString(),
                style: TextStyles.regular(),
                maxLines: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  isExpanded: true,
                  hint: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      'Languages',
                      style: TextStyles.regular(
                        color: AppColors.textPrimaryColor.withOpacity(.5),
                      ),
                    ),
                  ),
                  items: languages.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      //disable default onTap to avoid closing menu when selecting an item
                      enabled: false,
                      child: StatefulBuilder(
                        builder: (context, menuSetState) {
                          final isSelected = selectedItems.contains(item);
                          return GestureDetector(
                            onTap: () {
                              isSelected
                                  ? selectedItems.remove(item)
                                  : selectedItems.add(item);
                              setState(() {});
                              menuSetState(() {});
                              widget.onchange(selectedItems);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: isSelected
                                    ? AppColors.neutral_30
                                    : AppColors.forthColor,
                              ),
                              height: 100,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(item,
                                      style: TextStyles.regular(
                                          color: AppColors.neutral_700)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                  value: selectedItems.isEmpty ? null : selectedItems.last,
                  onChanged: (value) {},
                  selectedItemBuilder: (context) {
                    return languages.map(
                      (item) {
                        return SizedBox(
                          height: 50,
                          child: ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: selectedItems.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  selectedItems.removeAt(index);
                                  setState(() {});
                                  widget.onchange(selectedItems);
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                      color: AppColors.neutral_10,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        width: 1,
                                        color: AppColors.neutral_70,
                                      )),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(selectedItems[index],
                                          style: TextStyles.regular(
                                              color: AppColors.neutral_300)),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Icon(Icons.close,
                                          size: 15,
                                          color: AppColors.neutral_300),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ).toList();
                  },
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: MediaQuery.of(context).size.height * .3,
                    elevation: 1,
                    scrollbarTheme: ScrollbarThemeData(
                      thumbColor: MaterialStateProperty.all<Color>(
                          AppColors.primaryColor),
                      thickness: MaterialStateProperty.all<double>(8),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.forthColor,
                      border: Border.all(width: 1, color: AppColors.neutral_30),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  buttonStyleData: ButtonStyleData(
                    decoration: BoxDecoration(
                      color: AppColors.forthColor,
                      border: Border.all(color: AppColors.neutral_40),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
