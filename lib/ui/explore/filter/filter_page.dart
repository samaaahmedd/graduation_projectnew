import 'package:flutter/material.dart';
import 'package:with_you_app/common/common.dart';
import 'package:with_you_app/common/material/app_buttons.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'package:with_you_app/common/material/drop_down_menu_single_select.dart';
import 'package:with_you_app/common/material/languages_drop_down.dart';
import 'package:with_you_app/common/material/radio_button/radio_button.dart';
import 'package:with_you_app/common/material/text_styles.dart';
import 'package:with_you_app/common/utils/navigation.dart';
import 'filter_model.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key, required this.filterModel}) : super(key: key);
  final FilterModel filterModel;
  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  late FilterModel _filterModel;
  @override
  void initState() {
    _filterModel = widget.filterModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text("Filter By :",
                    style: TextStyles.bold(
                        color: AppColors.neutral_300, fontSize: 20)),
              ),
            ),
            IconButton(
                onPressed: () => pop(context),
                icon: const Icon(
                  Icons.close,
                ))
          ],
        ),
        const Divider(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GroupRadioButton(
                  textList: userFilterTypeList,
                  value: _filterModel.userType,
                  onChanged: (userType) {
                    _filterModel = _filterModel.modify(userType: userType);
                    setState(() {});
                  },
                ),
                const Divider(),
                SingleSelectDropDown<String>(
                  onChanged: (genderValue) {
                    _filterModel = _filterModel.modify(gender: genderValue);
                    setState(() {});
                  },
                  itemsValues: filterGenderList,
                  showItems: filterGenderList,
                  hint: "Gender",
                  label: 'Gender :',
                  value: _filterModel.gender,
                  selectedText: _filterModel.gender,
                ),
                const SizedBox(
                  height: 10,
                ),
                SingleSelectDropDown<String?>(
                  onChanged: (selectedItem) {
                    _filterModel = _filterModel.modify(country: selectedItem);
                    setState(() {});
                  },
                  itemsValues: countries,
                  showItems: countries,
                  hint: "Country Of Residence",
                  value: _filterModel.country,
                  label: 'Country Of Residence :',
                  selectedText: _filterModel.country,
                ),
                const SizedBox(
                  height: 10,
                ),
                LanguagesDropDown(
                  initialValues: _filterModel.languages,
                  label: 'Languages',
                  onchange: (languages) {
                    _filterModel = _filterModel.modify(languages: languages);
                    setState(() {});
                  },
                ),
                // SliderWidget(
                //   sliderValue:
                //       double.tryParse(_filterModel.priceRange ?? '') ?? 0,
                //   onChanged: (value) {
                //     _filterModel =
                //         _filterModel.modify(priceRange: value.toString());
                //     setState(() {});
                //   },
                // )
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(22),
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Expanded(
                child: AppButtons.outline(
                  text: 'Reset',
                  onPressed: () {
                    Navigator.of(context).pop(FilterModel.initial());
                  },
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: AppButtons.primaryButton(
                  text: 'Filter',
                  onPressed: () {
                    Navigator.of(context).pop(_filterModel);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
