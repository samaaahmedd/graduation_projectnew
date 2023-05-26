import 'package:flutter/material.dart';
import 'package:with_you_app/common/material/app_colors.dart';
import 'models/filter_model.dart';


class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final FilterModel? _filterModel = FilterModel.getInstance();
  // UserType? _userType;
  // double? _sliderValue;
  // Gender? _gender;
  // Languages? _language;
  // Country? _country;

  @override
  void initState() {
    // _getFilterValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close)),
          ],
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_rounded)),
          title: const Text(
            "Filter",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: AppColors.neutral_700),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // UserTypeRadioGroupWidget(
              //   value: _userType,
              //   onChanged: (value) {
              //     _userType = UserType.values[value?.index ?? 0];
              //     setState(() {});
              //   },
              // ),
              // SliderWidget(
              //   sliderValue: _sliderValue ?? 0,
              //   onChanged: (value) {
              //     _sliderValue = value;
              //     setState(() {});
              //   },
              // ),
              // CustomDropdownButton(
              //   enumList: Gender.values,
              //   value: _gender,
              //   onChanged: (value) {
              //     _gender = Gender.values[value?.index ?? 0];
              //     setState(() {});
              //   },
              //   label: "Gender",
              //
              // ),
              // CustomDropdownButton(
              //   enumList: Languages.values,
              //   value: _language,
              //   onChanged: (value) {
              //     _language = Languages.values[value?.index ?? 0];
              //     setState(() {});
              //   },
              //   label: "Language",
              // ),
              // CustomDropdownButton(
              //   enumList: Country.values,
              //   value: _country,
              //   onChanged: (value) {
              //     _country = Country.values[value?.index ?? 0];
              //     setState(() {});
              //   },
              //   label: "Country",
              // ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: Container(
      //   padding: const EdgeInsets.symmetric(horizontal: 25),
      //   color: AppColors.sixColor,
      //   width: MediaQuery.of(context).size.width,
      //   child: Row(children: [
      //     Expanded(
      //       child: CustomButton(
      //         text: "Restore Default",
      //         onPressed: _restoreFilterDefaultValues,
      //       ),
      //     ),
      //     const SizedBox(
      //       width: 20,
      //     ),
      //     Expanded(
      //       child: CustomButton(
      //         text: "Apply",
      //         onPressed: _saveFilterValues,
      //       ),
      //     ),
      //   ]),
      // ),
    );
  }

  void _restoreFilterDefaultValues() {
    _filterModel?.emptyAllValues();
    Navigator.of(context).pop(_filterModel);
  }

  // void _getFilterValues() {
  //   if (_filterModel != null) {
  //     _userType = _filterModel?.userType;
  //     _language = _filterModel?.language;
  //     _sliderValue = _filterModel?.sliderValue;
  //     _gender = _filterModel?.gender;
  //     _country = _filterModel?.country;
  //   }
  // }
  //
  // void _saveFilterValues() {
  //   _filterModel?.updateValues(
  //       _userType, _sliderValue, _gender, _language, _country);
  //   Navigator.of(context).pop(_filterModel);
  // }
}
