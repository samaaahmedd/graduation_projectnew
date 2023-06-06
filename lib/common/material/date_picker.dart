import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';

// Values derived from https://developer.apple.com/design/resources/ and on iOS
// simulators with "Debug View Hierarchy".
const double _kItemExtent = 32.0;
// From the picker's intrinsic content size constraint.
const double _kPickerWidth = 320.0;
const double _kPickerHeight = 216.0;
const bool _kUseMagnifier = true;
const double _kMagnification = 2.35 / 2.1;
const double _kDatePickerPadSize = 12.0;
// The density of a date picker is different from a generic picker.
// Eyeballed from iOS.
const double _kSqueeze = 1.25;

const TextStyle _kDefaultPickerTextStyle = TextStyle(
  letterSpacing: -0.83,
);

// The item height is 32 and the magnifier height is 34, from
// iOS simulators with "Debug View Hierarchy".
// And the magnified fontSize by [_kTimerPickerMagnification] conforms to the
// iOS 14 native style by eyeball test.
const double _kTimerPickerMagnification = 34 / 32;
// Minimum horizontal padding between [CupertinoTimerPicker]
//
// It shouldn't actually be hard-coded for direct use, and the perfect solution
// should be to calculate the values that match the magnified values by
// offAxisFraction and _kSqueeze.
// Such calculations are complex, so we'll hard-code them for now.
const double _kTimerPickerMinHorizontalPadding = 30;
// Half of the horizontal padding value between the timer picker's columns.
const double _kTimerPickerHalfColumnPadding = 4;
// The horizontal padding between the timer picker's number label and its
// corresponding unit label.
const double _kTimerPickerLabelPadSize = 6;
const double _kTimerPickerLabelFontSize = 17.0;

// The width of each column of the countdown time picker.
const double _kTimerPickerColumnIntrinsicWidth = 106;

//TODO:- textStyle
TextStyle _themeTextStyle(
  BuildContext context, {
  bool isValid = true,
  TextStyle? validTextStyle,
  TextStyle? notValidTextStyle,
}) {
  final TextStyle style =
      CupertinoTheme.of(context).textTheme.dateTimePickerTextStyle;
  return isValid
      ? validTextStyle ??
          style.copyWith(
              color: CupertinoDynamicColor.maybeResolve(style.color, context))
      : notValidTextStyle ??
          style.copyWith(
              color: CupertinoDynamicColor.resolve(
                  CupertinoColors.inactiveGray, context));
}

void _animateColumnControllerToItem(
    FixedExtentScrollController controller, int targetItem) {
  controller.animateToItem(
    targetItem,
    curve: Curves.easeInOut,
    duration: const Duration(milliseconds: 200),
  );
}

const Widget _startSelectionOverlay =
    CupertinoPickerDefaultSelectionOverlay(capEndEdge: false);
const Widget _centerSelectionOverlay = CupertinoPickerDefaultSelectionOverlay(
    capStartEdge: false, capEndEdge: false);
const Widget _endSelectionOverlay =
    CupertinoPickerDefaultSelectionOverlay(capStartEdge: false);

// Lays out the date picker based on how much space each single column needs.
//
// Each column is a child of this delegate, indexed from 0 to number of columns - 1.
// Each column will be padded horizontally by 12.0 both left and right.
//
// The picker will be placed in the center, and the leftmost and rightmost
// column will be extended equally to the remaining width.
class _DatePickerLayoutDelegate extends MultiChildLayoutDelegate {
  _DatePickerLayoutDelegate({
    required this.columnWidths,
    required this.textDirectionFactor,
    required this.maxWidth,
  });

  // The list containing widths of all columns.
  final List<double> columnWidths;

  // textDirectionFactor is 1 if text is written left to right, and -1 if right to left.
  final int textDirectionFactor;

  // The max width the children should reach to avoid bending outwards.
  final double maxWidth;

  @override
  void performLayout(Size size) {
    double remainingWidth = maxWidth < size.width ? maxWidth : size.width;

    double currentHorizontalOffset = (size.width - remainingWidth) / 2;

    for (int i = 0; i < columnWidths.length; i++) {
      remainingWidth -= columnWidths[i] + _kDatePickerPadSize * 2;
    }

    for (int i = 0; i < columnWidths.length; i++) {
      final int index =
          textDirectionFactor == 1 ? i : columnWidths.length - i - 1;

      double childWidth = columnWidths[index] + _kDatePickerPadSize * 2;
      if (index == 0 || index == columnWidths.length - 1) {
        childWidth += remainingWidth / 2;
      }

      // We can't actually assert here because it would break things badly for
      // semantics, which will expect that we laid things out here.
      assert(() {
        if (childWidth < 0) {
          FlutterError.reportError(
            FlutterErrorDetails(
              exception: FlutterError(
                'Insufficient horizontal space to render the '
                'CupertinoDatePickerModified because the parent is too narrow at '
                '${size.width}px.\n'
                'An additional ${-remainingWidth}px is needed to avoid '
                'overlapping columns.',
              ),
            ),
          );
        }
        return true;
      }());
      layoutChild(index,
          BoxConstraints.tight(Size(math.max(0.0, childWidth), size.height)));
      positionChild(index, Offset(currentHorizontalOffset, 0.0));

      currentHorizontalOffset += childWidth;
    }
  }

  @override
  bool shouldRelayout(_DatePickerLayoutDelegate oldDelegate) {
    return columnWidths != oldDelegate.columnWidths ||
        textDirectionFactor != oldDelegate.textDirectionFactor;
  }
}

/// Different display modes of [CupertinoDatePickerModified].
///
/// See also:
///
///  * [CupertinoDatePickerModified], the class that implements different display modes
///    of the iOS-style date picker.
///  * [CupertinoPicker], the class that implements a content agnostic spinner UI.
enum CupertinoDatePickerModeModified {
  /// Mode that shows the date in hour, minute, and (optional) an AM/PM designation.
  /// The AM/PM designation is shown only if [CupertinoDatePickerModified] does not use 24h format.
  /// Column order is subject to internationalization.
  ///
  /// Example: ` 4 | 14 | PM `.
  time,

  /// Mode that shows the date in month, day of month, and year.
  /// Name of month is spelled in full.
  /// Column order is subject to internationalization.
  ///
  /// Example: ` July | 13 | 2012 `.
  date,

  /// Mode that shows the date as day of the week, month, day of month and
  /// the time in hour, minute, and (optional) an AM/PM designation.
  /// The AM/PM designation is shown only if [CupertinoDatePickerModified] does not use 24h format.
  /// Column order is subject to internationalization.
  ///
  /// Example: ` Fri Jul 13 | 4 | 14 | PM `
  dateAndTime,
}

// Different types of column in CupertinoDatePickerModified.
enum _PickerColumnType {
  // Day of month column in date mode.
  dayOfMonth,
  // Month column in date mode.
  month,
  // Year column in date mode.
  year,
  // Medium date column in dateAndTime mode.
  date,
  // Hour column in time and dateAndTime mode.
  hour,
  // minute column in time and dateAndTime mode.
  minute,
  // AM/PM column in time and dateAndTime mode.
  dayPeriod,
}

/// A date picker widget in iOS style.
///
/// There are several modes of the date picker listed in [CupertinoDatePickerModeModified].
///
/// The class will display its children as consecutive columns. Its children
/// order is based on internationalization, or the [dateOrder] property if specified.
///
/// Example of the picker in date mode:
///
///  * US-English: `| July | 13 | 2012 |`
///  * Vietnamese: `| 13 | Tháng 7 | 2012 |`
///
/// Can be used with [showCupertinoModalPopup] to display the picker modally at
/// the bottom of the screen.
///
/// Sizes itself to its parent and may not render correctly if not given the
/// full screen width. Content texts are shown with
/// [CupertinoTextThemeData.dateTimePickerTextStyle].
///
/// {@tool dartpad}
/// This sample shows how to implement CupertinoDatePickerModified with different picker modes.
/// We can provide initial dateTime value for the picker to display. When user changes
/// the drag the date or time wheels, the picker will call onDateTimeChanged callback.
///
/// CupertinoDatePickerModified can be displayed directly on a screen or in a popup.
///
/// ** See code in examples/api/lib/cupertino/date_picker/cupertino_date_picker.0.dart **
/// {@end-tool}
///
/// See also:
///
///  * [CupertinoTimerPicker], the class that implements the iOS-style timer picker.
///  * [CupertinoPicker], the class that implements a content agnostic spinner UI.
///  * <https://developer.apple.com/design/human-interface-guidelines/ios/controls/pickers/>
class CupertinoDatePickerModified extends StatefulWidget {
  /// Constructs an iOS style date picker.
  ///
  /// [mode] is one of the mode listed in [CupertinoDatePickerModeModified] and defaults
  /// to [CupertinoDatePickerModeModified.dateAndTime].
  ///
  /// [onDateTimeChanged] is the callback called when the selected date or time
  /// changes and must not be null. When in [CupertinoDatePickerModeModified.time] mode,
  /// the year, month and day will be the same as [initialDateTime]. When in
  /// [CupertinoDatePickerModeModified.date] mode, this callback will always report the
  /// start time of the currently selected day.
  ///
  /// [initialDateTime] is the initial date time of the picker. Defaults to the
  /// present date and time and must not be null. The present must conform to
  /// the intervals set in [minimumDate], [maximumDate], [minimumYear], and
  /// [maximumYear].
  ///
  /// [minimumDate] is the minimum selectable [DateTime] of the picker. When set
  /// to null, the picker does not limit the minimum [DateTime] the user can pick.
  /// In [CupertinoDatePickerModeModified.time] mode, [minimumDate] should typically be
  /// on the same date as [initialDateTime], as the picker will not limit the
  /// minimum time the user can pick if it's set to a date earlier than that.
  ///
  /// [maximumDate] is the maximum selectable [DateTime] of the picker. When set
  /// to null, the picker does not limit the maximum [DateTime] the user can pick.
  /// In [CupertinoDatePickerModeModified.time] mode, [maximumDate] should typically be
  /// on the same date as [initialDateTime], as the picker will not limit the
  /// maximum time the user can pick if it's set to a date later than that.
  ///
  /// [minimumYear] is the minimum year that the picker can be scrolled to in
  /// [CupertinoDatePickerModeModified.date] mode. Defaults to 1 and must not be null.
  ///
  /// [maximumYear] is the maximum year that the picker can be scrolled to in
  /// [CupertinoDatePickerModeModified.date] mode. Null if there's no limit.
  ///
  /// [minuteInterval] is the granularity of the minute spinner. Must be a
  /// positive integer factor of 60.
  ///
  /// [use24hFormat] decides whether 24 hour format is used. Defaults to false.
  ///
  /// [dateOrder] determines the order of the columns inside [CupertinoDatePickerModified] in date mode.
  /// Defaults to the locale's default date format/order.
  ///
  //TODO:- CupertinoDatePicker properties
  CupertinoDatePickerModified({
    Key? key,
    this.mode = CupertinoDatePickerModeModified.dateAndTime,
    required this.onDateTimeChanged,
    DateTime? initialDateTime,
    this.minimumDate,
    this.maximumDate,
    this.minimumYear = 1,
    this.maximumYear,
    this.minuteInterval = 1,
    this.use24hFormat = false,
    this.dateOrder,
    this.backgroundColor,
    this.showDayOfWeek = false,
    this.validTextStyle,
    this.notValidTextStyle,
    this.additionalSpaceString,
    this.padding,
    this.alignment,
    this.isEnglishNum,
  })  : initialDateTime = initialDateTime ?? DateTime.now(),
        assert(
          minuteInterval > 0 && 60 % minuteInterval == 0,
          'minute interval is not a positive integer factor of 60',
        ),
        super(key: key) {
    assert(
      mode != CupertinoDatePickerModeModified.dateAndTime ||
          minimumDate == null ||
          !this.initialDateTime.isBefore(minimumDate!),
      'initial date is before minimum date',
    );
    assert(
      mode != CupertinoDatePickerModeModified.dateAndTime ||
          maximumDate == null ||
          !this.initialDateTime.isAfter(maximumDate!),
      'initial date is after maximum date',
    );
    assert(
      mode != CupertinoDatePickerModeModified.date ||
          (minimumYear >= 1 && this.initialDateTime.year >= minimumYear),
      'initial year is not greater than minimum year, or minimum year is not positive',
    );
    assert(
      mode != CupertinoDatePickerModeModified.date ||
          maximumYear == null ||
          this.initialDateTime.year <= maximumYear!,
      'initial year is not smaller than maximum year',
    );
    assert(
      mode != CupertinoDatePickerModeModified.date ||
          minimumDate == null ||
          !minimumDate!.isAfter(this.initialDateTime),
      'initial date ${this.initialDateTime} is not greater than or equal to minimumDate $minimumDate',
    );
    assert(
      mode != CupertinoDatePickerModeModified.date ||
          maximumDate == null ||
          !maximumDate!.isBefore(this.initialDateTime),
      'initial date ${this.initialDateTime} is not less than or equal to maximumDate $maximumDate',
    );
    assert(
      this.initialDateTime.minute % minuteInterval == 0,
      'initial minute is not divisible by minute interval',
    );
  }

  /// The mode of the date picker as one of [CupertinoDatePickerModeModified].
  /// Defaults to [CupertinoDatePickerModeModified.dateAndTime]. Cannot be null and
  /// value cannot change after initial build.
  final CupertinoDatePickerModeModified mode;

  /// The initial date and/or time of the picker. Defaults to the present date
  /// and time and must not be null. The present must conform to the intervals
  /// set in [minimumDate], [maximumDate], [minimumYear], and [maximumYear].
  ///
  /// Changing this value after the initial build will not affect the currently
  /// selected date time.
  final DateTime initialDateTime;

  /// The minimum selectable date that the picker can settle on.
  ///
  /// When non-null, the user can still scroll the picker to [DateTime]s earlier
  /// than [minimumDate], but the [onDateTimeChanged] will not be called on
  /// these [DateTime]s. Once let go, the picker will scroll back to [minimumDate].
  ///
  /// In [CupertinoDatePickerModeModified.time] mode, a time becomes unselectable if the
  /// [DateTime] produced by combining that particular time and the date part of
  /// [initialDateTime] is earlier than [minimumDate]. So typically [minimumDate]
  /// needs to be set to a [DateTime] that is on the same date as [initialDateTime].
  ///
  /// Defaults to null. When set to null, the picker does not impose a limit on
  /// the earliest [DateTime] the user can select.
  final DateTime? minimumDate;

  /// The maximum selectable date that the picker can settle on.
  ///
  /// When non-null, the user can still scroll the picker to [DateTime]s later
  /// than [maximumDate], but the [onDateTimeChanged] will not be called on
  /// these [DateTime]s. Once let go, the picker will scroll back to [maximumDate].
  ///
  /// In [CupertinoDatePickerModeModified.time] mode, a time becomes unselectable if the
  /// [DateTime] produced by combining that particular time and the date part of
  /// [initialDateTime] is later than [maximumDate]. So typically [maximumDate]
  /// needs to be set to a [DateTime] that is on the same date as [initialDateTime].
  ///
  /// Defaults to null. When set to null, the picker does not impose a limit on
  /// the latest [DateTime] the user can select.
  final DateTime? maximumDate;

  /// Minimum year that the picker can be scrolled to in
  /// [CupertinoDatePickerModeModified.date] mode. Defaults to 1 and must not be null.
  final int minimumYear;

  final TextStyle? validTextStyle;

  final TextStyle? notValidTextStyle;

  final int? additionalSpaceString;

  final EdgeInsetsGeometry? padding;

  final AlignmentGeometry? alignment;

  final bool? isEnglishNum;

  /// Maximum year that the picker can be scrolled to in
  /// [CupertinoDatePickerModeModified.date] mode. Null if there's no limit.
  final int? maximumYear;

  /// The granularity of the minutes spinner, if it is shown in the current mode.
  /// Must be an integer factor of 60.
  final int minuteInterval;

  /// Whether to use 24 hour format. Defaults to false.
  final bool use24hFormat;

  /// Determines the order of the columns inside [CupertinoDatePickerModified] in date mode.
  /// Defaults to the locale's default date format/order.
  final DatePickerDateOrder? dateOrder;

  /// Callback called when the selected date and/or time changes. If the new
  /// selected [DateTime] is not valid, or is not in the [minimumDate] through
  /// [maximumDate] range, this callback will not be called.
  ///
  /// Must not be null.
  final ValueChanged<DateTime> onDateTimeChanged;

  /// Background color of date picker.
  ///
  /// Defaults to null, which disables background painting entirely.
  final Color? backgroundColor;

  /// Whether to to show day of week alongside day. Defaults to false.
  final bool showDayOfWeek;

  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state, https://github.com/flutter/flutter/issues/70499
    // The `time` mode and `dateAndTime` mode of the picker share the time
    // columns, so they are placed together to one state.
    // The `date` mode has different children and is implemented in a different
    // state.
    switch (mode) {
      case CupertinoDatePickerModeModified.time:
      case CupertinoDatePickerModeModified.dateAndTime:
        return _CupertinoDatePickerDateTimeState();
      case CupertinoDatePickerModeModified.date:
        return _CupertinoDatePickerDateState(dateOrder: dateOrder);
    }
  }

  // Estimate the minimum width that each column needs to layout its content.

  //TODO:- Column width
  static double _getColumnWidth(
    _PickerColumnType columnType,
    CupertinoLocalizations localizations,
    BuildContext context,
    bool showDayOfWeek, {
    TextStyle? validTextStyle,
    TextStyle? notValidTextStyle,
    int? additionalSpaceWidth,
  }) {
    String longestText = '';

    switch (columnType) {
      case _PickerColumnType.date:
        // Measuring the length of all possible date is impossible, so here
        // just some dates are measured.
        for (int i = 1; i <= 12; i++) {
          // An arbitrary date.
          final String date =
              localizations.datePickerMediumDate(DateTime(2018, i, 25));
          if (longestText.length < date.length) {
            longestText = date;
          }
        }
        break;
      case _PickerColumnType.hour:
        for (int i = 0; i < 24; i++) {
          final String hour = localizations.datePickerHour(i);
          if (longestText.length < hour.length) {
            longestText = hour;
          }
        }
        break;
      case _PickerColumnType.minute:
        for (int i = 0; i < 60; i++) {
          final String minute = localizations.datePickerMinute(i);
          if (longestText.length < minute.length) {
            longestText = minute;
          }
        }
        break;
      case _PickerColumnType.dayPeriod:
        longestText = localizations.anteMeridiemAbbreviation.length >
                localizations.postMeridiemAbbreviation.length
            ? localizations.anteMeridiemAbbreviation
            : localizations.postMeridiemAbbreviation;
        break;
      case _PickerColumnType.dayOfMonth:
        int longestDayOfMonth = 1;
        for (int i = 1; i <= 31; i++) {
          final String dayOfMonth = localizations.datePickerDayOfMonth(i);
          if (longestText.length < dayOfMonth.length) {
            longestText = dayOfMonth;
            longestDayOfMonth = i;
          }
        }
        if (showDayOfWeek) {
          for (int wd = 1; wd < DateTime.daysPerWeek; wd++) {
            final String dayOfMonth =
                localizations.datePickerDayOfMonth(longestDayOfMonth, wd);
            if (longestText.length < dayOfMonth.length) {
              longestText = dayOfMonth;
            }
          }
        }
        break;
      case _PickerColumnType.month:
        for (int i = 1; i <= 12; i++) {
          final String month = localizations.datePickerMonth(i);
          if (longestText.length < month.length) {
            longestText = month;
          }
        }
        break;
      case _PickerColumnType.year:
        longestText = localizations.datePickerYear(2018);
    }

    assert(longestText != '', 'column type is not appropriate');

    String? _spaceString = '';

    for (int i = 0; i < (additionalSpaceWidth ?? 0); i++) {
      _spaceString = '$_spaceString ';
    }

    return TextPainter.computeMaxIntrinsicWidth(
      text: TextSpan(
        style: _themeTextStyle(context,
            validTextStyle: validTextStyle,
            notValidTextStyle: notValidTextStyle),
        text: additionalSpaceWidth == null
            ? '$longestText  '
            : '$longestText$_spaceString',
      ),
      textDirection: Directionality.of(context),
    );
  }
}

typedef _ColumnBuilder = Widget Function(double offAxisFraction,
    TransitionBuilder itemPositioningBuilder, Widget selectionOverlay);

class _CupertinoDatePickerDateTimeState
    extends State<CupertinoDatePickerModified> {
  // Fraction of the farthest column's vanishing point vs its width. Eyeballed
  // vs iOS.
  static const double _kMaximumOffAxisFraction = 0.45;

  late int textDirectionFactor;
  late CupertinoLocalizations localizations;

  // Alignment based on text direction. The variable name is self descriptive,
  // however, when text direction is rtl, alignment is reversed.
  late Alignment alignCenterLeft;
  late Alignment alignCenterRight;

  // Read this out when the state is initially created. Changes in initialDateTime
  // in the widget after first build is ignored.
  late DateTime initialDateTime;

  // The difference in days between the initial date and the currently selected date.
  // 0 if the current mode does not involve a date.
  int get selectedDayFromInitial {
    switch (widget.mode) {
      case CupertinoDatePickerModeModified.dateAndTime:
        return dateController.hasClients ? dateController.selectedItem : 0;
      case CupertinoDatePickerModeModified.time:
        return 0;
      case CupertinoDatePickerModeModified.date:
        break;
    }
    assert(
      false,
      '$runtimeType is only meant for dateAndTime mode or time mode',
    );
    return 0;
  }

  // The controller of the date column.
  late FixedExtentScrollController dateController;

  // The current selection of the hour picker. Values range from 0 to 23.
  int get selectedHour => _selectedHour(selectedAmPm, _selectedHourIndex);

  int get _selectedHourIndex => hourController.hasClients
      ? hourController.selectedItem % 24
      : initialDateTime.hour;

  // Calculates the selected hour given the selected indices of the hour picker
  // and the meridiem picker.
  int _selectedHour(int selectedAmPm, int selectedHour) {
    return _isHourRegionFlipped(selectedAmPm)
        ? (selectedHour + 12) % 24
        : selectedHour;
  }

  // The controller of the hour column.
  late FixedExtentScrollController hourController;

  // The current selection of the minute picker. Values range from 0 to 59.
  int get selectedMinute {
    return minuteController.hasClients
        ? minuteController.selectedItem * widget.minuteInterval % 60
        : initialDateTime.minute;
  }

  // The controller of the minute column.
  late FixedExtentScrollController minuteController;

  // Whether the current meridiem selection is AM or PM.
  //
  // We can't use the selectedItem of meridiemController as the source of truth
  // because the meridiem picker can be scrolled **animatedly** by the hour picker
  // (e.g. if you scroll from 12 to 1 in 12h format), but the meridiem change
  // should take effect immediately, **before** the animation finishes.
  late int selectedAmPm;

  // Whether the physical-region-to-meridiem mapping is flipped.
  bool get isHourRegionFlipped => _isHourRegionFlipped(selectedAmPm);

  bool _isHourRegionFlipped(int selectedAmPm) => selectedAmPm != meridiemRegion;

  // The index of the 12-hour region the hour picker is currently in.
  //
  // Used to determine whether the meridiemController should start animating.
  // Valid values are 0 and 1.
  //
  // The AM/PM correspondence of the two regions flips when the meridiem picker
  // scrolls. This variable is to keep track of the selected "physical"
  // (meridiem picker invariant) region of the hour picker. The "physical" region
  // of an item of index `i` is `i ~/ 12`.
  late int meridiemRegion;

  // The current selection of the AM/PM picker.
  //
  // - 0 means AM
  // - 1 means PM
  late FixedExtentScrollController meridiemController;

  bool isDatePickerScrolling = false;
  bool isHourPickerScrolling = false;
  bool isMinutePickerScrolling = false;
  bool isMeridiemPickerScrolling = false;

  bool get isScrolling {
    return isDatePickerScrolling ||
        isHourPickerScrolling ||
        isMinutePickerScrolling ||
        isMeridiemPickerScrolling;
  }

  // The estimated width of columns.
  final Map<int, double> estimatedColumnWidths = <int, double>{};

  @override
  void initState() {
    super.initState();
    initialDateTime = widget.initialDateTime;

    // Initially each of the "physical" regions is mapped to the meridiem region
    // with the same number, e.g., the first 12 items are mapped to the first 12
    // hours of a day. Such mapping is flipped when the meridiem picker is scrolled
    // by the user, the first 12 items are mapped to the last 12 hours of a day.
    selectedAmPm = initialDateTime.hour ~/ 12;
    meridiemRegion = selectedAmPm;

    meridiemController = FixedExtentScrollController(initialItem: selectedAmPm);
    hourController =
        FixedExtentScrollController(initialItem: initialDateTime.hour);
    minuteController = FixedExtentScrollController(
        initialItem: initialDateTime.minute ~/ widget.minuteInterval);
    dateController = FixedExtentScrollController();

    PaintingBinding.instance.systemFonts.addListener(_handleSystemFontsChange);
  }

  void _handleSystemFontsChange() {
    setState(() {
      // System fonts change might cause the text layout width to change.
      // Clears cached width to ensure that they get recalculated with the
      // new system fonts.
      estimatedColumnWidths.clear();
    });
  }

  @override
  void dispose() {
    dateController.dispose();
    hourController.dispose();
    minuteController.dispose();
    meridiemController.dispose();

    PaintingBinding.instance.systemFonts
        .removeListener(_handleSystemFontsChange);
    super.dispose();
  }

  @override
  void didUpdateWidget(CupertinoDatePickerModified oldWidget) {
    super.didUpdateWidget(oldWidget);

    assert(
      oldWidget.mode == widget.mode,
      "The $runtimeType's mode cannot change once it's built.",
    );

    if (!widget.use24hFormat && oldWidget.use24hFormat) {
      // Thanks to the physical and meridiem region mapping, the only thing we
      // need to update is the meridiem controller, if it's not previously attached.
      meridiemController.dispose();
      meridiemController =
          FixedExtentScrollController(initialItem: selectedAmPm);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    textDirectionFactor =
        Directionality.of(context) == TextDirection.ltr ? 1 : -1;
    localizations = CupertinoLocalizations.of(context);

    alignCenterLeft =
        textDirectionFactor == 1 ? Alignment.centerLeft : Alignment.centerRight;
    alignCenterRight =
        textDirectionFactor == 1 ? Alignment.centerRight : Alignment.centerLeft;

    estimatedColumnWidths.clear();
  }

  // Lazily calculate the column width of the column being displayed only.
  double _getEstimatedColumnWidth(_PickerColumnType columnType) {
    if (estimatedColumnWidths[columnType.index] == null) {
      estimatedColumnWidths[columnType.index] =
          CupertinoDatePickerModified._getColumnWidth(
        columnType,
        localizations,
        context,
        widget.showDayOfWeek,
        notValidTextStyle: widget.notValidTextStyle,
        validTextStyle: widget.validTextStyle,
        additionalSpaceWidth: widget.additionalSpaceString,
      );
    }

    return estimatedColumnWidths[columnType.index]!;
  }

  // Gets the current date time of the picker.
  DateTime get selectedDateTime {
    return DateTime(
      initialDateTime.year,
      initialDateTime.month,
      initialDateTime.day + selectedDayFromInitial,
      selectedHour,
      selectedMinute,
    );
  }

  // Only reports datetime change when the date time is valid.
  void _onSelectedItemChange(int index) {
    final DateTime selected = selectedDateTime;

    final bool isDateInvalid =
        (widget.minimumDate?.isAfter(selected) ?? false) ||
            (widget.maximumDate?.isBefore(selected) ?? false);

    if (isDateInvalid) {
      return;
    }

    widget.onDateTimeChanged(selected);
  }

  // Builds the date column. The date is displayed in medium date format (e.g. Fri Aug 31).
  Widget _buildMediumDatePicker(double offAxisFraction,
      TransitionBuilder itemPositioningBuilder, Widget selectionOverlay) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          isDatePickerScrolling = true;
        } else if (notification is ScrollEndNotification) {
          isDatePickerScrolling = false;
          _pickerDidStopScrolling();
        }

        return false;
      },
      child: CupertinoPicker.builder(
        scrollController: dateController,
        offAxisFraction: offAxisFraction,
        itemExtent: _kItemExtent,
        useMagnifier: _kUseMagnifier,
        magnification: _kMagnification,
        backgroundColor: widget.backgroundColor,
        squeeze: _kSqueeze,
        onSelectedItemChanged: (int index) {
          _onSelectedItemChange(index);
        },
        itemBuilder: (BuildContext context, int index) {
          final DateTime rangeStart = DateTime(
            initialDateTime.year,
            initialDateTime.month,
            initialDateTime.day + index,
          );

          // Exclusive.
          final DateTime rangeEnd = DateTime(
            initialDateTime.year,
            initialDateTime.month,
            initialDateTime.day + index + 1,
          );

          final DateTime now = DateTime.now();

          if (widget.minimumDate?.isBefore(rangeEnd) == false) {
            return null;
          }
          if (widget.maximumDate?.isAfter(rangeStart) == false) {
            return null;
          }

          final String dateText =
              rangeStart == DateTime(now.year, now.month, now.day)
                  ? localizations.todayLabel
                  : localizations.datePickerMediumDate(rangeStart);

          return itemPositioningBuilder(
            context,
            Text(dateText,
                style: _themeTextStyle(context,
                    validTextStyle: widget.validTextStyle,
                    notValidTextStyle: widget.notValidTextStyle)),
          );
        },
        selectionOverlay: selectionOverlay,
      ),
    );
  }

  // With the meridiem picker set to `meridiemIndex`, and the hour picker set to
  // `hourIndex`, is it possible to change the value of the minute picker, so
  // that the resulting date stays in the valid range.
  bool _isValidHour(int meridiemIndex, int hourIndex) {
    final DateTime rangeStart = DateTime(
      initialDateTime.year,
      initialDateTime.month,
      initialDateTime.day + selectedDayFromInitial,
      _selectedHour(meridiemIndex, hourIndex),
    );

    // The end value of the range is exclusive, i.e. [rangeStart, rangeEnd).
    final DateTime rangeEnd = rangeStart.add(const Duration(hours: 1));

    return (widget.minimumDate?.isBefore(rangeEnd) ?? true) &&
        !(widget.maximumDate?.isBefore(rangeStart) ?? false);
  }

  Widget _buildHourPicker(double offAxisFraction,
      TransitionBuilder itemPositioningBuilder, Widget selectionOverlay) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          isHourPickerScrolling = true;
        } else if (notification is ScrollEndNotification) {
          isHourPickerScrolling = false;
          _pickerDidStopScrolling();
        }

        return false;
      },
      child: CupertinoPicker(
        scrollController: hourController,
        offAxisFraction: offAxisFraction,
        itemExtent: _kItemExtent,
        useMagnifier: _kUseMagnifier,
        magnification: _kMagnification,
        backgroundColor: widget.backgroundColor,
        squeeze: _kSqueeze,
        onSelectedItemChanged: (int index) {
          final bool regionChanged = meridiemRegion != index ~/ 12;
          final bool debugIsFlipped = isHourRegionFlipped;

          if (regionChanged) {
            meridiemRegion = index ~/ 12;
            selectedAmPm = 1 - selectedAmPm;
          }

          if (!widget.use24hFormat && regionChanged) {
            // Scroll the meridiem column to adjust AM/PM.
            //
            // _onSelectedItemChanged will be called when the animation finishes.
            //
            // Animation values obtained by comparing with iOS version.
            meridiemController.animateToItem(
              selectedAmPm,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          } else {
            _onSelectedItemChange(index);
          }

          assert(debugIsFlipped == isHourRegionFlipped);
        },
        looping: true,
        selectionOverlay: selectionOverlay,
        children: List<Widget>.generate(24, (int index) {
          final int hour = isHourRegionFlipped ? (index + 12) % 24 : index;
          final int displayHour =
              widget.use24hFormat ? hour : (hour + 11) % 12 + 1;

          return itemPositioningBuilder(
            context,
            Text(
              localizations.datePickerHour(displayHour),
              semanticsLabel:
                  localizations.datePickerHourSemanticsLabel(displayHour),
              style: _themeTextStyle(context,
                  isValid: _isValidHour(selectedAmPm, index),
                  validTextStyle: widget.validTextStyle,
                  notValidTextStyle: widget.notValidTextStyle),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMinutePicker(double offAxisFraction,
      TransitionBuilder itemPositioningBuilder, Widget selectionOverlay) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          isMinutePickerScrolling = true;
        } else if (notification is ScrollEndNotification) {
          isMinutePickerScrolling = false;
          _pickerDidStopScrolling();
        }

        return false;
      },
      child: CupertinoPicker(
        scrollController: minuteController,
        offAxisFraction: offAxisFraction,
        itemExtent: _kItemExtent,
        useMagnifier: _kUseMagnifier,
        magnification: _kMagnification,
        backgroundColor: widget.backgroundColor,
        squeeze: _kSqueeze,
        onSelectedItemChanged: _onSelectedItemChange,
        looping: true,
        selectionOverlay: selectionOverlay,
        children:
            List<Widget>.generate(60 ~/ widget.minuteInterval, (int index) {
          final int minute = index * widget.minuteInterval;

          final DateTime date = DateTime(
            initialDateTime.year,
            initialDateTime.month,
            initialDateTime.day + selectedDayFromInitial,
            selectedHour,
            minute,
          );

          final bool isInvalidMinute =
              (widget.minimumDate?.isAfter(date) ?? false) ||
                  (widget.maximumDate?.isBefore(date) ?? false);

          return itemPositioningBuilder(
            context,
            Text(
              localizations.datePickerMinute(minute),
              semanticsLabel:
                  localizations.datePickerMinuteSemanticsLabel(minute),
              style: _themeTextStyle(context,
                  isValid: !isInvalidMinute,
                  validTextStyle: widget.validTextStyle,
                  notValidTextStyle: widget.notValidTextStyle),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildAmPmPicker(double offAxisFraction,
      TransitionBuilder itemPositioningBuilder, Widget selectionOverlay) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          isMeridiemPickerScrolling = true;
        } else if (notification is ScrollEndNotification) {
          isMeridiemPickerScrolling = false;
          _pickerDidStopScrolling();
        }

        return false;
      },
      child: CupertinoPicker(
        scrollController: meridiemController,
        offAxisFraction: offAxisFraction,
        itemExtent: _kItemExtent,
        useMagnifier: _kUseMagnifier,
        magnification: _kMagnification,
        backgroundColor: widget.backgroundColor,
        squeeze: _kSqueeze,
        onSelectedItemChanged: (int index) {
          selectedAmPm = index;
          assert(selectedAmPm == 0 || selectedAmPm == 1);
          _onSelectedItemChange(index);
        },
        selectionOverlay: selectionOverlay,
        children: List<Widget>.generate(2, (int index) {
          return itemPositioningBuilder(
            context,
            Text(
              index == 0
                  ? localizations.anteMeridiemAbbreviation
                  : localizations.postMeridiemAbbreviation,
              style: _themeTextStyle(context,
                  isValid: _isValidHour(index, _selectedHourIndex),
                  validTextStyle: widget.validTextStyle,
                  notValidTextStyle: widget.notValidTextStyle),
            ),
          );
        }),
      ),
    );
  }

  // One or more pickers have just stopped scrolling.
  void _pickerDidStopScrolling() {
    // Call setState to update the greyed out date/hour/minute/meridiem.
    setState(() {});

    if (isScrolling) {
      return;
    }

    // Whenever scrolling lands on an invalid entry, the picker
    // automatically scrolls to a valid one.
    final DateTime selectedDate = selectedDateTime;

    final bool minCheck = widget.minimumDate?.isAfter(selectedDate) ?? false;
    final bool maxCheck = widget.maximumDate?.isBefore(selectedDate) ?? false;

    if (minCheck || maxCheck) {
      // We have minCheck === !maxCheck.
      final DateTime targetDate =
          minCheck ? widget.minimumDate! : widget.maximumDate!;
      _scrollToDate(targetDate, selectedDate, minCheck);
    }
  }

  void _scrollToDate(DateTime newDate, DateTime fromDate, bool minCheck) {
    SchedulerBinding.instance.addPostFrameCallback((Duration timestamp) {
      if (fromDate.year != newDate.year ||
          fromDate.month != newDate.month ||
          fromDate.day != newDate.day) {
        _animateColumnControllerToItem(dateController, selectedDayFromInitial);
      }

      if (fromDate.hour != newDate.hour) {
        final bool needsMeridiemChange =
            !widget.use24hFormat && fromDate.hour ~/ 12 != newDate.hour ~/ 12;
        // In AM/PM mode, the pickers should not scroll all the way to the other hour region.
        if (needsMeridiemChange) {
          _animateColumnControllerToItem(
              meridiemController, 1 - meridiemController.selectedItem);

          // Keep the target item index in the current 12-h region.
          final int newItem = (hourController.selectedItem ~/ 12) * 12 +
              (hourController.selectedItem + newDate.hour - fromDate.hour) % 12;
          _animateColumnControllerToItem(hourController, newItem);
        } else {
          _animateColumnControllerToItem(
            hourController,
            hourController.selectedItem + newDate.hour - fromDate.hour,
          );
        }
      }

      if (fromDate.minute != newDate.minute) {
        final double positionDouble = newDate.minute / widget.minuteInterval;
        final int position =
            minCheck ? positionDouble.ceil() : positionDouble.floor();
        _animateColumnControllerToItem(minuteController, position);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Widths of the columns in this picker, ordered from left to right.
    final List<double> columnWidths = <double>[
      _getEstimatedColumnWidth(_PickerColumnType.hour),
      _getEstimatedColumnWidth(_PickerColumnType.minute),
    ];

    // Swap the hours and minutes if RTL to ensure they are in the correct position.
    final List<_ColumnBuilder> pickerBuilders =
        Directionality.of(context) == TextDirection.rtl
            ? <_ColumnBuilder>[_buildMinutePicker, _buildHourPicker]
            : <_ColumnBuilder>[_buildHourPicker, _buildMinutePicker];

    // Adds am/pm column if the picker is not using 24h format.
    if (!widget.use24hFormat) {
      if (localizations.datePickerDateTimeOrder ==
              DatePickerDateTimeOrder.date_time_dayPeriod ||
          localizations.datePickerDateTimeOrder ==
              DatePickerDateTimeOrder.time_dayPeriod_date) {
        pickerBuilders.add(_buildAmPmPicker);
        columnWidths.add(_getEstimatedColumnWidth(_PickerColumnType.dayPeriod));
      } else {
        pickerBuilders.insert(0, _buildAmPmPicker);
        columnWidths.insert(
            0, _getEstimatedColumnWidth(_PickerColumnType.dayPeriod));
      }
    }

    // Adds medium date column if the picker's mode is date and time.
    if (widget.mode == CupertinoDatePickerModeModified.dateAndTime) {
      if (localizations.datePickerDateTimeOrder ==
              DatePickerDateTimeOrder.time_dayPeriod_date ||
          localizations.datePickerDateTimeOrder ==
              DatePickerDateTimeOrder.dayPeriod_time_date) {
        pickerBuilders.add(_buildMediumDatePicker);
        columnWidths.add(_getEstimatedColumnWidth(_PickerColumnType.date));
      } else {
        pickerBuilders.insert(0, _buildMediumDatePicker);
        columnWidths.insert(
            0, _getEstimatedColumnWidth(_PickerColumnType.date));
      }
    }

    final List<Widget> pickers = <Widget>[];
    double totalColumnWidths = 4 * _kDatePickerPadSize;

    for (int i = 0; i < columnWidths.length; i++) {
      double offAxisFraction = 0.0;
      Widget selectionOverlay = _centerSelectionOverlay;
      if (i == 0) {
        offAxisFraction = -_kMaximumOffAxisFraction * textDirectionFactor;
        selectionOverlay = _startSelectionOverlay;
      } else if (i >= 2 || columnWidths.length == 2) {
        offAxisFraction = _kMaximumOffAxisFraction * textDirectionFactor;
      }

      EdgeInsets padding = const EdgeInsets.only(right: _kDatePickerPadSize);
      if (i == columnWidths.length - 1) {
        padding = padding.flipped;
        selectionOverlay = _endSelectionOverlay;
      }
      if (textDirectionFactor == -1) {
        padding = padding.flipped;
      }

      totalColumnWidths += columnWidths[i] + (2 * _kDatePickerPadSize);

      pickers.add(LayoutId(
        id: i,
        child: pickerBuilders[i](
          offAxisFraction,
          (BuildContext context, Widget? child) {
            return Container(
              alignment: i == columnWidths.length - 1
                  ? alignCenterLeft
                  : alignCenterRight,
              padding: padding,
              child: Container(
                alignment: i == columnWidths.length - 1
                    ? alignCenterLeft
                    : alignCenterRight,
                width: i == 0 || i == columnWidths.length - 1
                    ? null
                    : columnWidths[i] + _kDatePickerPadSize,
                child: child,
              ),
            );
          },
          selectionOverlay,
        ),
      ));
    }

    final double maxPickerWidth =
        totalColumnWidths > _kPickerWidth ? totalColumnWidths : _kPickerWidth;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: DefaultTextStyle.merge(
        style: _kDefaultPickerTextStyle,
        child: CustomMultiChildLayout(
          delegate: _DatePickerLayoutDelegate(
            columnWidths: columnWidths,
            textDirectionFactor: textDirectionFactor,
            maxWidth: maxPickerWidth,
          ),
          children: pickers,
        ),
      ),
    );
  }
}

class _CupertinoDatePickerDateState extends State<CupertinoDatePickerModified> {
  _CupertinoDatePickerDateState({
    required this.dateOrder,
  });

  final DatePickerDateOrder? dateOrder;

  late int textDirectionFactor;
  late CupertinoLocalizations localizations;

  // Alignment based on text direction. The variable name is self descriptive,
  // however, when text direction is rtl, alignment is reversed.
  late Alignment alignCenterLeft;
  late Alignment alignCenterRight;

  // The currently selected values of the picker.
  late int selectedDay;
  late int selectedMonth;
  late int selectedYear;

  // The controller of the day picker. There are cases where the selected value
  // of the picker is invalid (e.g. February 30th 2018), and this dayController
  // is responsible for jumping to a valid value.
  late FixedExtentScrollController dayController;
  late FixedExtentScrollController monthController;
  late FixedExtentScrollController yearController;

  bool isDayPickerScrolling = false;
  bool isMonthPickerScrolling = false;
  bool isYearPickerScrolling = false;

  bool get isScrolling =>
      isDayPickerScrolling || isMonthPickerScrolling || isYearPickerScrolling;

  // Estimated width of columns.
  Map<int, double> estimatedColumnWidths = <int, double>{};

  @override
  void initState() {
    super.initState();
    selectedDay = widget.initialDateTime.day;
    selectedMonth = widget.initialDateTime.month;
    selectedYear = widget.initialDateTime.year;

    dayController = FixedExtentScrollController(initialItem: selectedDay - 1);
    monthController =
        FixedExtentScrollController(initialItem: selectedMonth - 1);
    yearController = FixedExtentScrollController(initialItem: selectedYear);

    PaintingBinding.instance.systemFonts.addListener(_handleSystemFontsChange);
  }

  void _handleSystemFontsChange() {
    setState(() {
      // System fonts change might cause the text layout width to change.
      _refreshEstimatedColumnWidths();
    });
  }

  @override
  void dispose() {
    dayController.dispose();
    monthController.dispose();
    yearController.dispose();

    PaintingBinding.instance.systemFonts
        .removeListener(_handleSystemFontsChange);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    textDirectionFactor =
        Directionality.of(context) == TextDirection.ltr ? 1 : -1;
    localizations = CupertinoLocalizations.of(context);

    alignCenterLeft =
        textDirectionFactor == 1 ? Alignment.centerLeft : Alignment.centerRight;
    alignCenterRight =
        textDirectionFactor == 1 ? Alignment.centerRight : Alignment.centerLeft;

    _refreshEstimatedColumnWidths();
  }

  void _refreshEstimatedColumnWidths() {
    estimatedColumnWidths[_PickerColumnType.dayOfMonth.index] =
        CupertinoDatePickerModified._getColumnWidth(
      _PickerColumnType.dayOfMonth,
      localizations,
      context,
      widget.showDayOfWeek,
      notValidTextStyle: widget.notValidTextStyle,
      validTextStyle: widget.validTextStyle,
      additionalSpaceWidth: widget.additionalSpaceString,
    );
    estimatedColumnWidths[_PickerColumnType.month.index] =
        CupertinoDatePickerModified._getColumnWidth(
      _PickerColumnType.month,
      localizations,
      context,
      widget.showDayOfWeek,
      notValidTextStyle: widget.notValidTextStyle,
      validTextStyle: widget.validTextStyle,
      additionalSpaceWidth: widget.additionalSpaceString,
    );
    estimatedColumnWidths[_PickerColumnType.year.index] =
        CupertinoDatePickerModified._getColumnWidth(
      _PickerColumnType.year,
      localizations,
      context,
      widget.showDayOfWeek,
      notValidTextStyle: widget.notValidTextStyle,
      validTextStyle: widget.validTextStyle,
      additionalSpaceWidth: widget.additionalSpaceString,
    );
  }

  // The DateTime of the last day of a given month in a given year.
  // Let `DateTime` handle the year/month overflow.
  DateTime _lastDayInMonth(int year, int month) => DateTime(year, month + 1, 0);

  Widget _buildDayPicker(double offAxisFraction,
      TransitionBuilder itemPositioningBuilder, Widget selectionOverlay) {
    final int daysInCurrentMonth =
        _lastDayInMonth(selectedYear, selectedMonth).day;
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          isDayPickerScrolling = true;
        } else if (notification is ScrollEndNotification) {
          isDayPickerScrolling = false;
          _pickerDidStopScrolling();
        }

        return false;
      },
      child: CupertinoPicker(
        scrollController: dayController,
        offAxisFraction: offAxisFraction,
        itemExtent: _kItemExtent,
        useMagnifier: _kUseMagnifier,
        magnification: _kMagnification,
        backgroundColor: widget.backgroundColor,
        squeeze: _kSqueeze,
        onSelectedItemChanged: (int index) {
          selectedDay = index + 1;
          if (_isCurrentDateValid) {
            widget.onDateTimeChanged(
                DateTime(selectedYear, selectedMonth, selectedDay));
          }
        },
        looping: true,
        selectionOverlay: selectionOverlay,
        children: List<Widget>.generate(31, (int index) {
          final int day = index + 1;
          final int? dayOfWeek = widget.showDayOfWeek
              ? DateTime(selectedYear, selectedMonth, day).weekday
              : null;
          return itemPositioningBuilder(
            context,
            Text(
              widget.isEnglishNum ?? false
                  ? '$day'
                  : localizations.datePickerDayOfMonth(day, dayOfWeek),
              style: _themeTextStyle(context,
                  isValid: day <= daysInCurrentMonth,
                  validTextStyle: widget.validTextStyle,
                  notValidTextStyle: widget.notValidTextStyle),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMonthPicker(double offAxisFraction,
      TransitionBuilder itemPositioningBuilder, Widget selectionOverlay) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          isMonthPickerScrolling = true;
        } else if (notification is ScrollEndNotification) {
          isMonthPickerScrolling = false;
          _pickerDidStopScrolling();
        }

        return false;
      },
      child: CupertinoPicker(
        scrollController: monthController,
        offAxisFraction: offAxisFraction,
        itemExtent: _kItemExtent,
        useMagnifier: _kUseMagnifier,
        magnification: _kMagnification,
        backgroundColor: widget.backgroundColor,
        squeeze: _kSqueeze,
        onSelectedItemChanged: (int index) {
          selectedMonth = index + 1;
          if (_isCurrentDateValid) {
            widget.onDateTimeChanged(
                DateTime(selectedYear, selectedMonth, selectedDay));
          }
        },
        looping: true,
        selectionOverlay: selectionOverlay,
        children: List<Widget>.generate(12, (int index) {
          final int month = index + 1;
          final bool isInvalidMonth =
              (widget.minimumDate?.year == selectedYear &&
                      widget.minimumDate!.month > month) ||
                  (widget.maximumDate?.year == selectedYear &&
                      widget.maximumDate!.month < month);

          return itemPositioningBuilder(
            context,
            Text(
              localizations.datePickerMonth(month),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: _themeTextStyle(context,
                  isValid: !isInvalidMonth,
                  validTextStyle: widget.validTextStyle,
                  notValidTextStyle: widget.notValidTextStyle),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildYearPicker(double offAxisFraction,
      TransitionBuilder itemPositioningBuilder, Widget selectionOverlay) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          isYearPickerScrolling = true;
        } else if (notification is ScrollEndNotification) {
          isYearPickerScrolling = false;
          _pickerDidStopScrolling();
        }

        return false;
      },
      child: CupertinoPicker.builder(
        scrollController: yearController,
        itemExtent: _kItemExtent,
        offAxisFraction: offAxisFraction,
        useMagnifier: _kUseMagnifier,
        magnification: _kMagnification,
        backgroundColor: widget.backgroundColor,
        onSelectedItemChanged: (int index) {
          selectedYear = index;
          if (_isCurrentDateValid) {
            widget.onDateTimeChanged(
                DateTime(selectedYear, selectedMonth, selectedDay));
          }
        },
        itemBuilder: (BuildContext context, int year) {
          if (year < widget.minimumYear) {
            return null;
          }

          if (widget.maximumYear != null && year > widget.maximumYear!) {
            return null;
          }

          final bool isValidYear = (widget.minimumDate == null ||
                  widget.minimumDate!.year <= year) &&
              (widget.maximumDate == null || widget.maximumDate!.year >= year);

          return itemPositioningBuilder(
            context,
            Text(
              widget.isEnglishNum ?? false
                  ? '$year'
                  : localizations.datePickerYear(year),
              textDirection: TextDirection.rtl,
              style: _themeTextStyle(context,
                  isValid: isValidYear,
                  validTextStyle: widget.validTextStyle,
                  notValidTextStyle: widget.notValidTextStyle),
            ),
          );
        },
        selectionOverlay: selectionOverlay,
      ),
    );
  }

  bool get _isCurrentDateValid {
    // The current date selection represents a range [minSelectedData, maxSelectDate].
    final DateTime minSelectedDate =
        DateTime(selectedYear, selectedMonth, selectedDay);
    final DateTime maxSelectedDate =
        DateTime(selectedYear, selectedMonth, selectedDay + 1);

    final bool minCheck = widget.minimumDate?.isBefore(maxSelectedDate) ?? true;
    final bool maxCheck =
        widget.maximumDate?.isBefore(minSelectedDate) ?? false;

    return minCheck && !maxCheck && minSelectedDate.day == selectedDay;
  }

  // One or more pickers have just stopped scrolling.
  void _pickerDidStopScrolling() {
    // Call setState to update the greyed out days/months/years, as the currently
    // selected year/month may have changed.
    setState(() {});

    if (isScrolling) {
      return;
    }

    // Whenever scrolling lands on an invalid entry, the picker
    // automatically scrolls to a valid one.
    final DateTime minSelectDate =
        DateTime(selectedYear, selectedMonth, selectedDay);
    final DateTime maxSelectDate =
        DateTime(selectedYear, selectedMonth, selectedDay + 1);

    final bool minCheck = widget.minimumDate?.isBefore(maxSelectDate) ?? true;
    final bool maxCheck = widget.maximumDate?.isBefore(minSelectDate) ?? false;

    if (!minCheck || maxCheck) {
      // We have minCheck === !maxCheck.
      final DateTime targetDate =
          minCheck ? widget.maximumDate! : widget.minimumDate!;
      _scrollToDate(targetDate);
      return;
    }

    // Some months have less days (e.g. February). Go to the last day of that month
    // if the selectedDay exceeds the maximum.
    if (minSelectDate.day != selectedDay) {
      final DateTime lastDay = _lastDayInMonth(selectedYear, selectedMonth);
      _scrollToDate(lastDay);
    }
  }

  void _scrollToDate(DateTime newDate) {
    SchedulerBinding.instance.addPostFrameCallback((Duration timestamp) {
      if (selectedYear != newDate.year) {
        _animateColumnControllerToItem(yearController, newDate.year);
      }

      if (selectedMonth != newDate.month) {
        _animateColumnControllerToItem(monthController, newDate.month - 1);
      }

      if (selectedDay != newDate.day) {
        _animateColumnControllerToItem(dayController, newDate.day - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<_ColumnBuilder> pickerBuilders = <_ColumnBuilder>[];
    List<double> columnWidths = <double>[];

    final DatePickerDateOrder datePickerDateOrder =
        dateOrder ?? localizations.datePickerDateOrder;

    switch (datePickerDateOrder) {
      case DatePickerDateOrder.mdy:
        pickerBuilders = <_ColumnBuilder>[
          _buildMonthPicker,
          _buildDayPicker,
          _buildYearPicker
        ];
        columnWidths = <double>[
          estimatedColumnWidths[_PickerColumnType.month.index]!,
          estimatedColumnWidths[_PickerColumnType.dayOfMonth.index]!,
          estimatedColumnWidths[_PickerColumnType.year.index]!,
        ];
        break;

      case DatePickerDateOrder.dmy:
        pickerBuilders = <_ColumnBuilder>[
          _buildDayPicker,
          _buildMonthPicker,
          _buildYearPicker
        ];
        columnWidths = <double>[
          estimatedColumnWidths[_PickerColumnType.dayOfMonth.index]!,
          estimatedColumnWidths[_PickerColumnType.month.index]!,
          estimatedColumnWidths[_PickerColumnType.year.index]!,
        ];
        break;

      case DatePickerDateOrder.ymd:
        pickerBuilders = <_ColumnBuilder>[
          _buildYearPicker,
          _buildMonthPicker,
          _buildDayPicker
        ];
        columnWidths = <double>[
          estimatedColumnWidths[_PickerColumnType.year.index]!,
          estimatedColumnWidths[_PickerColumnType.month.index]!,
          estimatedColumnWidths[_PickerColumnType.dayOfMonth.index]!,
        ];
        break;
      case DatePickerDateOrder.ydm:
        pickerBuilders = <_ColumnBuilder>[
          _buildYearPicker,
          _buildDayPicker,
          _buildMonthPicker
        ];
        columnWidths = <double>[
          estimatedColumnWidths[_PickerColumnType.year.index]!,
          estimatedColumnWidths[_PickerColumnType.dayOfMonth.index]!,
          estimatedColumnWidths[_PickerColumnType.month.index]!,
        ];
        break;
    }

    //TODO: - build widget
    final List<Widget> pickers = <Widget>[];
    double totalColumnWidths = 4 * _kDatePickerPadSize;

    for (int i = 0; i < columnWidths.length; i++) {
      final double offAxisFraction = (i - 1) * 0.3 * textDirectionFactor;

      EdgeInsets padding = const EdgeInsets.only(right: _kDatePickerPadSize);
      if (textDirectionFactor == -1) {
        padding = const EdgeInsets.only(left: _kDatePickerPadSize);
      }

      Widget selectionOverlay = _centerSelectionOverlay;
      if (i == 0) {
        selectionOverlay = _startSelectionOverlay;
      } else if (i == columnWidths.length - 1) {
        selectionOverlay = _endSelectionOverlay;
      }

      totalColumnWidths += columnWidths[i] + (2 * _kDatePickerPadSize);

      pickers.add(LayoutId(
        id: i,
        child: pickerBuilders[i](
          offAxisFraction,
          (BuildContext context, Widget? child) {
            return Container(
              alignment: i == columnWidths.length - 1
                  ? alignCenterLeft
                  : alignCenterRight,
              padding: widget.padding ?? (i == 0 ? null : padding),
              child: Container(
                alignment: widget.alignment ??
                    (i == 0 ? alignCenterLeft : alignCenterRight),
                width: columnWidths[i] + _kDatePickerPadSize,
                child: child,
              ),
            );
          },
          selectionOverlay,
        ),
      ));
    }

    final double maxPickerWidth =
        totalColumnWidths > _kPickerWidth ? totalColumnWidths : _kPickerWidth;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: DefaultTextStyle.merge(
        style: _kDefaultPickerTextStyle,
        child: CustomMultiChildLayout(
          delegate: _DatePickerLayoutDelegate(
            columnWidths: columnWidths,
            textDirectionFactor: textDirectionFactor,
            maxWidth: maxPickerWidth,
          ),
          children: pickers,
        ),
      ),
    );
  }
}

// The iOS date picker and timer picker has their width fixed to 320.0 in all
// modes. The only exception is the hms mode (which doesn't have a native counterpart),
// with a fixed width of 330.0 px.
//
// For date pickers, if the maximum width given to the picker is greater than
// 320.0, the leftmost and rightmost column will be extended equally so that the
// widths match, and the picker is in the center.
//
// For timer pickers, if the maximum width given to the picker is greater than
// its intrinsic width, it will keep its intrinsic size and position itself in the
// parent using its alignment parameter.
//
// If the maximum width given to the picker is smaller than 320.0, the picker's
// layout will be broken.

/// Different modes of [CupertinoTimerPicker].
///
/// See also:
///
///  * [CupertinoTimerPicker], the class that implements the iOS-style timer picker.
///  * [CupertinoPicker], the class that implements a content agnostic spinner UI.
enum CupertinoTimerPickerMode {
  /// Mode that shows the timer duration in hour and minute.
  ///
  /// Examples: 16 hours | 14 min.
  hm,

  /// Mode that shows the timer duration in minute and second.
  ///
  /// Examples: 14 min | 43 sec.
  ms,

  /// Mode that shows the timer duration in hour, minute, and second.
  ///
  /// Examples: 16 hours | 14 min | 43 sec.
  hms,
}

/// A countdown timer picker in iOS style.
///
/// This picker shows a countdown duration with hour, minute and second spinners.
/// The duration is bound between 0 and 23 hours 59 minutes 59 seconds.
///
/// There are several modes of the timer picker listed in [CupertinoTimerPickerMode].
///
/// The picker has a fixed size of 320 x 216, in logical pixels, with the exception
/// of [CupertinoTimerPickerMode.hms], which is 330 x 216. If the parent widget
/// provides more space than it needs, the picker will position itself according
/// to its [alignment] property.
///
/// {@tool dartpad}
/// This example shows a [CupertinoTimerPicker] that returns a countdown duration.
///
/// ** See code in examples/api/lib/cupertino/date_picker/cupertino_timer_picker.0.dart **
/// {@end-tool}
///
/// See also:
///
///  * [CupertinoDatePickerModified], the class that implements different display modes
///    of the iOS-style date picker.
///  * [CupertinoPicker], the class that implements a content agnostic spinner UI.
///  * <https://developer.apple.com/design/human-interface-guidelines/ios/controls/pickers/>
class CupertinoTimerPicker extends StatefulWidget {
  /// Constructs an iOS style countdown timer picker.
  ///
  /// [mode] is one of the modes listed in [CupertinoTimerPickerMode] and
  /// defaults to [CupertinoTimerPickerMode.hms].
  ///
  /// [onTimerDurationChanged] is the callback called when the selected duration
  /// changes and must not be null.
  ///
  /// [initialTimerDuration] defaults to 0 second and is limited from 0 second
  /// to 23 hours 59 minutes 59 seconds.
  ///
  /// [minuteInterval] is the granularity of the minute spinner. Must be a
  /// positive integer factor of 60.
  ///
  /// [secondInterval] is the granularity of the second spinner. Must be a
  /// positive integer factor of 60.
  CupertinoTimerPicker({
    Key? key,
    this.mode = CupertinoTimerPickerMode.hms,
    this.initialTimerDuration = Duration.zero,
    this.minuteInterval = 1,
    this.secondInterval = 1,
    this.alignment = Alignment.center,
    this.backgroundColor,
    required this.onTimerDurationChanged,
  })  : assert(initialTimerDuration >= Duration.zero),
        assert(initialTimerDuration < const Duration(days: 1)),
        assert(minuteInterval > 0 && 60 % minuteInterval == 0),
        assert(secondInterval > 0 && 60 % secondInterval == 0),
        assert(initialTimerDuration.inMinutes % minuteInterval == 0),
        assert(initialTimerDuration.inSeconds % secondInterval == 0),
        super(key: key);

  /// The mode of the timer picker.
  final CupertinoTimerPickerMode mode;

  /// The initial duration of the countdown timer.
  final Duration initialTimerDuration;

  /// The granularity of the minute spinner. Must be a positive integer factor
  /// of 60.
  final int minuteInterval;

  /// The granularity of the second spinner. Must be a positive integer factor
  /// of 60.
  final int secondInterval;

  /// Callback called when the timer duration changes.
  final ValueChanged<Duration> onTimerDurationChanged;

  /// Defines how the timer picker should be positioned within its parent.
  ///
  /// This property must not be null. It defaults to [Alignment.center].
  final AlignmentGeometry alignment;

  /// Background color of timer picker.
  ///
  /// Defaults to null, which disables background painting entirely.
  final Color? backgroundColor;

  @override
  State<StatefulWidget> createState() => _CupertinoTimerPickerState();
}

class _CupertinoTimerPickerState extends State<CupertinoTimerPicker> {
  late TextDirection textDirection;
  late CupertinoLocalizations localizations;

  int get textDirectionFactor {
    switch (textDirection) {
      case TextDirection.ltr:
        return 1;
      case TextDirection.rtl:
        return -1;
    }
  }

  // The currently selected values of the picker.
  int? selectedHour;
  late int selectedMinute;
  int? selectedSecond;

  // On iOS the selected values won't be reported until the scrolling fully stops.
  // The values below are the latest selected values when the picker comes to a full stop.
  int? lastSelectedHour;
  int? lastSelectedMinute;
  int? lastSelectedSecond;

  final TextPainter textPainter = TextPainter();
  final List<String> numbers = List<String>.generate(10, (int i) => '${9 - i}');
  late double numberLabelWidth;
  late double numberLabelHeight;
  late double numberLabelBaseline;

  late double hourLabelWidth;
  late double minuteLabelWidth;
  late double secondLabelWidth;

  late double totalWidth;
  late double pickerColumnWidth;

  @override
  void initState() {
    super.initState();

    selectedMinute = widget.initialTimerDuration.inMinutes % 60;

    if (widget.mode != CupertinoTimerPickerMode.ms) {
      selectedHour = widget.initialTimerDuration.inHours;
    }

    if (widget.mode != CupertinoTimerPickerMode.hm) {
      selectedSecond = widget.initialTimerDuration.inSeconds % 60;
    }

    PaintingBinding.instance.systemFonts.addListener(_handleSystemFontsChange);
  }

  void _handleSystemFontsChange() {
    setState(() {
      // System fonts change might cause the text layout width to change.
      textPainter.markNeedsLayout();
      _measureLabelMetrics();
    });
  }

  @override
  void dispose() {
    PaintingBinding.instance.systemFonts
        .removeListener(_handleSystemFontsChange);
    textPainter.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CupertinoTimerPicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    assert(
      oldWidget.mode == widget.mode,
      "The CupertinoTimerPicker's mode cannot change once it's built",
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    textDirection = Directionality.of(context);
    localizations = CupertinoLocalizations.of(context);

    _measureLabelMetrics();
  }

  void _measureLabelMetrics() {
    textPainter.textDirection = textDirection;
    final TextStyle textStyle =
        _textStyleFrom(context, _kTimerPickerMagnification);

    double maxWidth = double.negativeInfinity;
    String? widestNumber;

    // Assumes that:
    // - 2-digit numbers are always wider than 1-digit numbers.
    // - There's at least one number in 1-9 that's wider than or equal to 0.
    // - The widest 2-digit number is composed of 2 same 1-digit numbers
    //   that has the biggest width.
    // - If two different 1-digit numbers are of the same width, their corresponding
    //   2 digit numbers are of the same width.
    for (final String input in numbers) {
      textPainter.text = TextSpan(
        text: input,
        style: textStyle,
      );
      textPainter.layout();

      if (textPainter.maxIntrinsicWidth > maxWidth) {
        maxWidth = textPainter.maxIntrinsicWidth;
        widestNumber = input;
      }
    }

    textPainter.text = TextSpan(
      text: '$widestNumber$widestNumber',
      style: textStyle,
    );

    textPainter.layout();
    numberLabelWidth = textPainter.maxIntrinsicWidth;
    numberLabelHeight = textPainter.height;
    numberLabelBaseline =
        textPainter.computeDistanceToActualBaseline(TextBaseline.alphabetic);

    minuteLabelWidth = _measureLabelsMaxWidth(
        localizations.timerPickerMinuteLabels, textStyle);

    if (widget.mode != CupertinoTimerPickerMode.ms) {
      hourLabelWidth = _measureLabelsMaxWidth(
          localizations.timerPickerHourLabels, textStyle);
    }

    if (widget.mode != CupertinoTimerPickerMode.hm) {
      secondLabelWidth = _measureLabelsMaxWidth(
          localizations.timerPickerSecondLabels, textStyle);
    }
  }

  // Measures all possible time text labels and return maximum width.
  double _measureLabelsMaxWidth(List<String?> labels, TextStyle style) {
    double maxWidth = double.negativeInfinity;
    for (int i = 0; i < labels.length; i++) {
      final String? label = labels[i];
      if (label == null) {
        continue;
      }

      textPainter.text = TextSpan(text: label, style: style);
      textPainter.layout();
      textPainter.maxIntrinsicWidth;
      if (textPainter.maxIntrinsicWidth > maxWidth) {
        maxWidth = textPainter.maxIntrinsicWidth;
      }
    }

    return maxWidth;
  }

  // Builds a text label with scale factor 1.0 and font weight semi-bold.
  // `pickerPadding ` is the additional padding the corresponding picker has to apply
  // around the `Text`, in order to extend its separators towards the closest
  // horizontal edge of the encompassing widget.
  Widget _buildLabel(String text, EdgeInsetsDirectional pickerPadding) {
    final EdgeInsetsDirectional padding = EdgeInsetsDirectional.only(
      start: numberLabelWidth + _kTimerPickerLabelPadSize + pickerPadding.start,
    );

    return IgnorePointer(
      child: Container(
        alignment: AlignmentDirectional.centerStart.resolve(textDirection),
        padding: padding.resolve(textDirection),
        child: SizedBox(
          height: numberLabelHeight,
          child: Baseline(
            baseline: numberLabelBaseline,
            baselineType: TextBaseline.alphabetic,
            child: Text(
              text,
              style: const TextStyle(
                fontSize: _kTimerPickerLabelFontSize,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              softWrap: false,
            ),
          ),
        ),
      ),
    );
  }

  // The picker has to be wider than its content, since the separators
  // are part of the picker.
  Widget _buildPickerNumberLabel(String text, EdgeInsetsDirectional padding) {
    return Container(
      width: _kTimerPickerColumnIntrinsicWidth + padding.horizontal,
      padding: padding.resolve(textDirection),
      alignment: AlignmentDirectional.centerStart.resolve(textDirection),
      child: Container(
        width: numberLabelWidth,
        alignment: AlignmentDirectional.centerEnd.resolve(textDirection),
        child: Text(text,
            softWrap: false, maxLines: 1, overflow: TextOverflow.visible),
      ),
    );
  }

  Widget _buildHourPicker(
      EdgeInsetsDirectional additionalPadding, Widget selectionOverlay) {
    return CupertinoPicker(
      scrollController: FixedExtentScrollController(initialItem: selectedHour!),
      magnification: _kMagnification,
      offAxisFraction: _calculateOffAxisFraction(additionalPadding.start, 0),
      itemExtent: _kItemExtent,
      backgroundColor: widget.backgroundColor,
      squeeze: _kSqueeze,
      onSelectedItemChanged: (int index) {
        setState(() {
          selectedHour = index;
          widget.onTimerDurationChanged(
            Duration(
              hours: selectedHour!,
              minutes: selectedMinute,
              seconds: selectedSecond ?? 0,
            ),
          );
        });
      },
      selectionOverlay: selectionOverlay,
      children: List<Widget>.generate(24, (int index) {
        final String label = localizations.timerPickerHourLabel(index) ?? '';
        final String semanticsLabel = textDirectionFactor == 1
            ? localizations.timerPickerHour(index) + label
            : label + localizations.timerPickerHour(index);

        return Semantics(
          label: semanticsLabel,
          excludeSemantics: true,
          child: _buildPickerNumberLabel(
              localizations.timerPickerHour(index), additionalPadding),
        );
      }),
    );
  }

  Widget _buildHourColumn(
      EdgeInsetsDirectional additionalPadding, Widget selectionOverlay) {
    additionalPadding = EdgeInsetsDirectional.only(
      start: math.max(additionalPadding.start, 0),
      end: math.max(additionalPadding.end, 0),
    );

    return Stack(
      children: <Widget>[
        NotificationListener<ScrollEndNotification>(
          onNotification: (ScrollEndNotification notification) {
            setState(() {
              lastSelectedHour = selectedHour;
            });
            return false;
          },
          child: _buildHourPicker(additionalPadding, selectionOverlay),
        ),
        _buildLabel(
          localizations
                  .timerPickerHourLabel(lastSelectedHour ?? selectedHour!) ??
              '',
          additionalPadding,
        ),
      ],
    );
  }

  Widget _buildMinutePicker(
      EdgeInsetsDirectional additionalPadding, Widget selectionOverlay) {
    return CupertinoPicker(
      scrollController: FixedExtentScrollController(
        initialItem: selectedMinute ~/ widget.minuteInterval,
      ),
      magnification: _kMagnification,
      offAxisFraction: _calculateOffAxisFraction(
        additionalPadding.start,
        widget.mode == CupertinoTimerPickerMode.ms ? 0 : 1,
      ),
      itemExtent: _kItemExtent,
      backgroundColor: widget.backgroundColor,
      squeeze: _kSqueeze,
      looping: true,
      onSelectedItemChanged: (int index) {
        setState(() {
          selectedMinute = index * widget.minuteInterval;
          widget.onTimerDurationChanged(
            Duration(
              hours: selectedHour ?? 0,
              minutes: selectedMinute,
              seconds: selectedSecond ?? 0,
            ),
          );
        });
      },
      selectionOverlay: selectionOverlay,
      children: List<Widget>.generate(60 ~/ widget.minuteInterval, (int index) {
        final int minute = index * widget.minuteInterval;
        final String label = localizations.timerPickerMinuteLabel(minute) ?? '';
        final String semanticsLabel = textDirectionFactor == 1
            ? localizations.timerPickerMinute(minute) + label
            : label + localizations.timerPickerMinute(minute);

        return Semantics(
          label: semanticsLabel,
          excludeSemantics: true,
          child: _buildPickerNumberLabel(
              localizations.timerPickerMinute(minute), additionalPadding),
        );
      }),
    );
  }

  Widget _buildMinuteColumn(
      EdgeInsetsDirectional additionalPadding, Widget selectionOverlay) {
    additionalPadding = EdgeInsetsDirectional.only(
      start: math.max(additionalPadding.start, 0),
      end: math.max(additionalPadding.end, 0),
    );

    return Stack(
      children: <Widget>[
        NotificationListener<ScrollEndNotification>(
          onNotification: (ScrollEndNotification notification) {
            setState(() {
              lastSelectedMinute = selectedMinute;
            });
            return false;
          },
          child: _buildMinutePicker(additionalPadding, selectionOverlay),
        ),
        _buildLabel(
          localizations.timerPickerMinuteLabel(
                  lastSelectedMinute ?? selectedMinute) ??
              '',
          additionalPadding,
        ),
      ],
    );
  }

  Widget _buildSecondPicker(
      EdgeInsetsDirectional additionalPadding, Widget selectionOverlay) {
    return CupertinoPicker(
      scrollController: FixedExtentScrollController(
        initialItem: selectedSecond! ~/ widget.secondInterval,
      ),
      magnification: _kMagnification,
      offAxisFraction: _calculateOffAxisFraction(
        additionalPadding.start,
        widget.mode == CupertinoTimerPickerMode.ms ? 1 : 2,
      ),
      itemExtent: _kItemExtent,
      backgroundColor: widget.backgroundColor,
      squeeze: _kSqueeze,
      looping: true,
      onSelectedItemChanged: (int index) {
        setState(() {
          selectedSecond = index * widget.secondInterval;
          widget.onTimerDurationChanged(
            Duration(
              hours: selectedHour ?? 0,
              minutes: selectedMinute,
              seconds: selectedSecond!,
            ),
          );
        });
      },
      selectionOverlay: selectionOverlay,
      children: List<Widget>.generate(60 ~/ widget.secondInterval, (int index) {
        final int second = index * widget.secondInterval;
        final String label = localizations.timerPickerSecondLabel(second) ?? '';
        final String semanticsLabel = textDirectionFactor == 1
            ? localizations.timerPickerSecond(second) + label
            : label + localizations.timerPickerSecond(second);

        return Semantics(
          label: semanticsLabel,
          excludeSemantics: true,
          child: _buildPickerNumberLabel(
              localizations.timerPickerSecond(second), additionalPadding),
        );
      }),
    );
  }

  Widget _buildSecondColumn(
      EdgeInsetsDirectional additionalPadding, Widget selectionOverlay) {
    additionalPadding = EdgeInsetsDirectional.only(
      start: math.max(additionalPadding.start, 0),
      end: math.max(additionalPadding.end, 0),
    );

    return Stack(
      children: <Widget>[
        NotificationListener<ScrollEndNotification>(
          onNotification: (ScrollEndNotification notification) {
            setState(() {
              lastSelectedSecond = selectedSecond;
            });
            return false;
          },
          child: _buildSecondPicker(additionalPadding, selectionOverlay),
        ),
        _buildLabel(
          localizations.timerPickerSecondLabel(
                  lastSelectedSecond ?? selectedSecond!) ??
              '',
          additionalPadding,
        ),
      ],
    );
  }

  // Returns [CupertinoTextThemeData.pickerTextStyle] and magnifies the fontSize
  // by [magnification].
  TextStyle _textStyleFrom(BuildContext context, [double magnification = 1.0]) {
    final TextStyle textStyle =
        CupertinoTheme.of(context).textTheme.pickerTextStyle;
    return textStyle.copyWith(
      color: CupertinoDynamicColor.maybeResolve(textStyle.color, context),
      fontSize: textStyle.fontSize! * magnification,
    );
  }

  // Calculate the number label center point by padding start and position to
  // get a reasonable offAxisFraction.
  double _calculateOffAxisFraction(double paddingStart, int position) {
    final double centerPoint = paddingStart + (numberLabelWidth / 2);

    // Compute the offAxisFraction needed to be straight within the pickerColumn.
    final double pickerColumnOffAxisFraction =
        0.5 - centerPoint / pickerColumnWidth;
    // Position is to calculate the reasonable offAxisFraction in the picker.
    final double timerPickerOffAxisFraction =
        0.5 - (centerPoint + pickerColumnWidth * position) / totalWidth;
    return (pickerColumnOffAxisFraction - timerPickerOffAxisFraction) *
        textDirectionFactor;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // The timer picker can be divided into columns corresponding to hour,
        // minute, and second. Each column consists of a scrollable and a fixed
        // label on top of it.
        List<Widget> columns;

        if (widget.mode == CupertinoTimerPickerMode.hms) {
          // Pad the widget to make it as wide as `_kPickerWidth`.
          pickerColumnWidth = _kTimerPickerColumnIntrinsicWidth +
              (_kTimerPickerHalfColumnPadding * 2);
          totalWidth = pickerColumnWidth * 3;
        } else {
          // The default totalWidth for 2-column modes.
          totalWidth = _kPickerWidth;
          pickerColumnWidth = totalWidth / 2;
        }

        if (constraints.maxWidth < totalWidth) {
          totalWidth = constraints.maxWidth;
          pickerColumnWidth = totalWidth /
              (widget.mode == CupertinoTimerPickerMode.hms ? 3 : 2);
        }

        final double baseLabelContentWidth =
            numberLabelWidth + _kTimerPickerLabelPadSize;
        final double minuteLabelContentWidth =
            baseLabelContentWidth + minuteLabelWidth;

        switch (widget.mode) {
          case CupertinoTimerPickerMode.hm:
            // Pad the widget to make it as wide as `_kPickerWidth`.
            final double hourLabelContentWidth =
                baseLabelContentWidth + hourLabelWidth;
            double hourColumnStartPadding = pickerColumnWidth -
                hourLabelContentWidth -
                _kTimerPickerHalfColumnPadding;
            if (hourColumnStartPadding < _kTimerPickerMinHorizontalPadding) {
              hourColumnStartPadding = _kTimerPickerMinHorizontalPadding;
            }

            double minuteColumnEndPadding = pickerColumnWidth -
                minuteLabelContentWidth -
                _kTimerPickerHalfColumnPadding;
            if (minuteColumnEndPadding < _kTimerPickerMinHorizontalPadding) {
              minuteColumnEndPadding = _kTimerPickerMinHorizontalPadding;
            }

            columns = <Widget>[
              _buildHourColumn(
                EdgeInsetsDirectional.only(
                  start: hourColumnStartPadding,
                  end: pickerColumnWidth -
                      hourColumnStartPadding -
                      hourLabelContentWidth,
                ),
                _startSelectionOverlay,
              ),
              _buildMinuteColumn(
                EdgeInsetsDirectional.only(
                  start: pickerColumnWidth -
                      minuteColumnEndPadding -
                      minuteLabelContentWidth,
                  end: minuteColumnEndPadding,
                ),
                _endSelectionOverlay,
              ),
            ];
            break;
          case CupertinoTimerPickerMode.ms:
            final double secondLabelContentWidth =
                baseLabelContentWidth + secondLabelWidth;
            double secondColumnEndPadding = pickerColumnWidth -
                secondLabelContentWidth -
                _kTimerPickerHalfColumnPadding;
            if (secondColumnEndPadding < _kTimerPickerMinHorizontalPadding) {
              secondColumnEndPadding = _kTimerPickerMinHorizontalPadding;
            }

            double minuteColumnStartPadding = pickerColumnWidth -
                minuteLabelContentWidth -
                _kTimerPickerHalfColumnPadding;
            if (minuteColumnStartPadding < _kTimerPickerMinHorizontalPadding) {
              minuteColumnStartPadding = _kTimerPickerMinHorizontalPadding;
            }

            columns = <Widget>[
              _buildMinuteColumn(
                EdgeInsetsDirectional.only(
                  start: minuteColumnStartPadding,
                  end: pickerColumnWidth -
                      minuteColumnStartPadding -
                      minuteLabelContentWidth,
                ),
                _startSelectionOverlay,
              ),
              _buildSecondColumn(
                EdgeInsetsDirectional.only(
                  start: pickerColumnWidth -
                      secondColumnEndPadding -
                      minuteLabelContentWidth,
                  end: secondColumnEndPadding,
                ),
                _endSelectionOverlay,
              ),
            ];
            break;
          case CupertinoTimerPickerMode.hms:
            final double hourColumnEndPadding = pickerColumnWidth -
                baseLabelContentWidth -
                hourLabelWidth -
                _kTimerPickerMinHorizontalPadding;
            final double minuteColumnPadding =
                (pickerColumnWidth - minuteLabelContentWidth) / 2;
            final double secondColumnStartPadding = pickerColumnWidth -
                baseLabelContentWidth -
                secondLabelWidth -
                _kTimerPickerMinHorizontalPadding;

            columns = <Widget>[
              _buildHourColumn(
                EdgeInsetsDirectional.only(
                  start: _kTimerPickerMinHorizontalPadding,
                  end: math.max(hourColumnEndPadding, 0),
                ),
                _startSelectionOverlay,
              ),
              _buildMinuteColumn(
                EdgeInsetsDirectional.only(
                  start: minuteColumnPadding,
                  end: minuteColumnPadding,
                ),
                _centerSelectionOverlay,
              ),
              _buildSecondColumn(
                EdgeInsetsDirectional.only(
                  start: math.max(secondColumnStartPadding, 0),
                  end: _kTimerPickerMinHorizontalPadding,
                ),
                _endSelectionOverlay,
              ),
            ];
        }
        final CupertinoThemeData themeData = CupertinoTheme.of(context);
        return MediaQuery(
          // The native iOS picker's text scaling is fixed, so we will also fix it
          // as well in our picker.
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: CupertinoTheme(
            data: themeData.copyWith(
              textTheme: themeData.textTheme.copyWith(
                pickerTextStyle:
                    _textStyleFrom(context, _kTimerPickerMagnification),
              ),
            ),
            child: Align(
              alignment: widget.alignment,
              child: Container(
                color: CupertinoDynamicColor.maybeResolve(
                    widget.backgroundColor, context),
                width: totalWidth,
                height: _kPickerHeight,
                child: DefaultTextStyle(
                  style: _textStyleFrom(context),
                  child: Row(
                      children: columns
                          .map((Widget child) => Expanded(child: child))
                          .toList(growable: false)),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}