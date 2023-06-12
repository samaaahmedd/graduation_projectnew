import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'app_colors.dart';
import 'app_text_form_field.dart';
import 'date_picker.dart';
import 'text_styles.dart';

class AppCustomDateField extends StatefulWidget {
  final String label;
  final String hintText;
  final bool obscureText;
  final void Function(DateTime) onchange;
  final TextEditingController textEditingController;
  final DateTime? initialValue;

  const AppCustomDateField(
      {Key? key,
      required this.label,
      required this.hintText,
      required this.onchange,
      this.obscureText = false,
      required this.textEditingController,
      this.initialValue})
      : super(key: key);

  @override
  State<AppCustomDateField> createState() => _AppCustomDateFieldState();
}

class _AppCustomDateFieldState extends State<AppCustomDateField> {
  List<DateTime> selectedEndDateOfCalender = [];
  List<DateTime> selectedDate = [];
  DateTime? _focusedDay;
  DateTime? _selectedDay;

  @override
  void initState() {
    _selectedDay = widget.initialValue;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.initialValue != null) {
        widget.textEditingController.text =
            DateFormat.yMd().format(widget.initialValue!);
      }
    });
    super.initState();
  }

  void _onTableCalenderDayClick(DateTime selectedDay) {
    if (selectedDay.isBefore(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day + 1))) {
      selectedEndDateOfCalender.clear();
      selectedEndDateOfCalender.add(selectedDay);
      _selectedDay = selectedDay;
      widget.onchange(selectedDay);
      widget.textEditingController.text =
          DateFormat.yMd().format(selectedDay).toString().split(' ').first;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label ?? '',
            style: TextStyles.medium(fontSize: 16),
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * .35,
                    child: CupertinoDatePickerModified(
                      onDateTimeChanged: (value) {
                        _onTableCalenderDayClick(value);
                        setState(() {});
                      },
                      mode: CupertinoDatePickerModeModified.date,
                      dateOrder: DatePickerDateOrder.dmy,
                      use24hFormat: true,
                      minimumDate: DateTime.utc(1990, 1, 1),
                      initialDateTime: _selectedDay ?? DateTime.now(),
                      maximumDate: DateTime.utc(2040, 1, 1),
                      validTextStyle:
                          TextStyles.regular(color: CupertinoColors.black),
                      notValidTextStyle: TextStyles.regular(
                          color: CupertinoColors.inactiveGray),
                      additionalSpaceString: 4,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      alignment: Alignment.center,
                      isEnglishNum: true,
                    ),
                  );
                },
              );
            },
            child: AppTextFormField(
                isEnabled: false,
                controller: widget.textEditingController,
                hint: widget.hintText,
                validator: (value) {
                  if (value?.isEmpty ?? false) {
                    return 'date cant be empty';
                  }
                  return null;
                },
                obscureText: false,
                suffix: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Icon(Icons.arrow_drop_down_sharp)),
                textColor: AppColors.neutral_800,
                contentPadding: 12),
          ),
        ],
      ),
    );
  }
}
