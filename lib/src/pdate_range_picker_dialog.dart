import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/src/date/shamsi_date.dart';

import 'pcalendar_date_range_picker.dart';
import 'pdate_picker_common.dart';
import 'pdate_picker_header.dart';
import 'pdate_utils.dart' as utils;
import 'pinput_date_range_picker.dart';
import 'slider/custom_slider_thumb_circle.dart';

const Size _inputPortraitDialogSize = Size(330.0, 270.0);
const Size _inputLandscapeDialogSize = Size(496, 164.0);
const Duration _dialogSizeAnimationDuration = Duration(milliseconds: 200);
const double _inputFormPortraitHeight = 98.0;
const double _inputFormLandscapeHeight = 108.0;

/// Shows a full screen modal dialog containing a Material Design date range
/// picker.
///
/// The returned [Future] resolves to the [JalaliRange] selected by the user
/// when the user saves their selection. If the user cancels the dialog, null is
/// returned.
///
/// If [initialDateRange] is non-null, then it will be used as the initially
/// selected date range. If it is provided, [initialDateRange.start] must be
/// before or on [initialDateRange.end].
///
/// The [firstDate] is the earliest allowable date. The [lastDate] is the latest
/// allowable date. Both must be non-null.
///
/// If an initial date range is provided, [initialDateRange.start]
/// and [initialDateRange.end] must both fall between or on [firstDate] and
/// [lastDate]. For all of these [Jalali] values, only their dates are
/// considered. Their time fields are ignored.
///
/// The [currentDate] represents the current day (i.e. today). This
/// date will be highlighted in the day grid. If null, the date of
/// `Jalali.now()` will be used.
///
/// An optional [initialEntryMode] argument can be used to display the date
/// picker in the [PDatePickerEntryMode.calendar] (a scrollable calendar month
/// grid) or [PDatePickerEntryMode.input] (two text input fields) mode.
/// It defaults to [PDatePickerEntryMode.calendar] and must be non-null.
///
/// The following optional string parameters allow you to override the default
/// text used for various parts of the dialog:
///
///   * [helpText], the label displayed at the top of the dialog.
///   * [cancelText], the label on the cancel button for the text input mode.
///   * [confirmText],the  label on the ok button for the text input mode.
///   * [saveText], the label on the save button for the fullscreen calendar
///     mode.
///   * [errorFormatText], the message used when an input text isn't in a proper
///     date format.
///   * [errorInvalidText], the message used when an input text isn't a
///     selectable date.
///   * [errorInvalidRangeText], the message used when the date range is
///     invalid (e.g. start date is after end date).
///   * [fieldStartHintText], the text used to prompt the user when no text has
///     been entered in the start field.
///   * [fieldEndHintText], the text used to prompt the user when no text has
///     been entered in the end field.
///   * [fieldStartLabelText], the label for the start date text input field.
///   * [fieldEndLabelText], the label for the end date text input field.
///
/// An optional [locale] argument can be used to set the locale for the date
/// picker. It defaults to the ambient locale provided by [Localizations].
///
/// An optional [textDirection] argument can be used to set the text direction
/// ([TextDirection.ltr] or [TextDirection.rtl]) for the date picker. It
/// defaults to the ambient text direction provided by [Directionality]. If both
/// [locale] and [textDirection] are non-null, [textDirection] overrides the
/// direction chosen for the [locale].
///
/// The [context], [useRootNavigator] and [routeSettings] arguments are passed
/// to [showDialog], the documentation for which discusses how it is used.
/// [context] and [useRootNavigator] must be non-null.
///
/// The [builder] parameter can be used to wrap the dialog widget
/// to add inherited widgets like [Theme].
///
/// See also:
///
///  * [showDatePicker], which shows a material design date picker used to
///    select a single date.
///  * [JalaliRange], which is used to describe a date range.
///
Future<JalaliRange?> showPersianDateRangePicker({
  required BuildContext context,
  JalaliRange? initialDateRange,
  required Jalali firstDate,
  required Jalali lastDate,
  Jalali? currentDate,
  PDatePickerEntryMode initialEntryMode = PDatePickerEntryMode.calendar,
  String? helpText,
  bool? showEntryModeIcon,
  String? cancelText,
  String? confirmText,
  String? saveText,
  String? clearText,
  String? errorFormatText,
  String? errorInvalidText,
  String? errorInvalidRangeText,
  String? fieldStartHintText,
  String? fieldEndHintText,
  String? fieldStartLabelText,
  String? fieldEndLabelText,
  Locale? locale,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  TextDirection? textDirection,
  TransitionBuilder? builder,
}) async {
  assert(context != null);
  assert(
  initialDateRange == null || (initialDateRange.start != null && initialDateRange.end != null),
  'initialDateRange must be null or have non-null start and end dates.',
  );
  assert(
  initialDateRange == null || !initialDateRange.start.isAfter(initialDateRange.end),
  "initialDateRange's start date must not be after it's end date.",
  );
  initialDateRange = initialDateRange == null ? null : initialDateRange;
  assert(firstDate != null);
  firstDate = firstDate;
  assert(lastDate != null);
  lastDate = lastDate;
  assert(
  !lastDate.isBefore(firstDate),
  'lastDate $lastDate must be on or after firstDate $firstDate.',
  );
  assert(
  initialDateRange == null || !initialDateRange.start.isBefore(firstDate),
  "initialDateRange's start date must be on or after firstDate $firstDate.",
  );
  assert(
  initialDateRange == null || !initialDateRange.end.isBefore(firstDate),
  "initialDateRange's end date must be on or after firstDate $firstDate.",
  );
  assert(
  initialDateRange == null || !initialDateRange.start.isAfter(lastDate),
  "initialDateRange's start date must be on or before lastDate $lastDate.",
  );
  assert(
  initialDateRange == null || !initialDateRange.end.isAfter(lastDate),
  "initialDateRange's end date must be on or before lastDate $lastDate.",
  );
  currentDate = currentDate ?? Jalali.now();
  assert(initialEntryMode != null);
  assert(useRootNavigator != null);

  Widget dialog = _DateRangePickerDialog(
    initialDateRange: initialDateRange,
    firstDate: firstDate,
    lastDate: lastDate,
    currentDate: currentDate,
    initialEntryMode: initialEntryMode,
    helpText: helpText,
    showEntryModeIcon: showEntryModeIcon,
    cancelText: cancelText,
    confirmText: confirmText,
    saveText: saveText,
    clearText: clearText,
    errorFormatText: errorFormatText,
    errorInvalidText: errorInvalidText,
    errorInvalidRangeText: errorInvalidRangeText,
    fieldStartHintText: fieldStartHintText,
    fieldEndHintText: fieldEndHintText,
    fieldStartLabelText: fieldStartLabelText,
    fieldEndLabelText: fieldEndLabelText,
  );

  if (textDirection != null) {
    dialog = Directionality(
      textDirection: textDirection,
      child: dialog,
    );
  }

  if (locale != null) {
    dialog = Localizations.override(
      context: context,
      locale: locale,
      child: dialog,
    );
  }

  return showDialog<JalaliRange>(
    context: context,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    useSafeArea: false,
    builder: (BuildContext context) {
      return builder == null ? dialog : builder(context, dialog);
    },
  );
}

class _DateRangePickerDialog extends StatefulWidget {
  const _DateRangePickerDialog({
    Key? key,
    this.initialDateRange,
    required this.firstDate,
    required this.lastDate,
    this.currentDate,
    this.initialEntryMode = PDatePickerEntryMode.calendar,
    this.helpText,
    this.showEntryModeIcon,
    this.cancelText,
    this.confirmText,
    this.saveText,
    this.clearText,
    this.errorInvalidRangeText,
    this.errorFormatText,
    this.errorInvalidText,
    this.fieldStartHintText,
    this.fieldEndHintText,
    this.fieldStartLabelText,
    this.fieldEndLabelText,
  }) : super(key: key);

  final JalaliRange? initialDateRange;
  final Jalali firstDate;
  final Jalali lastDate;
  final Jalali? currentDate;
  final PDatePickerEntryMode initialEntryMode;
  final String? cancelText;
  final String? confirmText;
  final String? saveText;
  final String? clearText;
  final String? helpText;
  final bool? showEntryModeIcon;
  final String? errorInvalidRangeText;
  final String? errorFormatText;
  final String? errorInvalidText;
  final String? fieldStartHintText;
  final String? fieldEndHintText;
  final String? fieldStartLabelText;
  final String? fieldEndLabelText;

  @override
  _DateRangePickerDialogState createState() => _DateRangePickerDialogState();
}

class _DateRangePickerDialogState extends State<_DateRangePickerDialog> {
  PDatePickerEntryMode? _entryMode;
  Jalali? _selectedStart;
  Jalali? _selectedEnd;
  double? _selectedStartTime;
  double? _selectedEndTime;
  late bool _autoValidate;
  final GlobalKey _calendarPickerKey = GlobalKey();
  final GlobalKey<PInputDateRangePickerState> _inputPickerKey = GlobalKey<PInputDateRangePickerState>();

  @override
  void initState() {
    super.initState();
    _selectedStart = widget.initialDateRange?.start;
    _selectedEnd = widget.initialDateRange?.end;

    //if _selectedStart == null set default value
    (_selectedStart == null) ? _selectedStartTime = 7 : _selectedStartTime = _selectedStart!.hour.toDouble();

    //if _selectedEnd == null set default value
    (_selectedEnd == null) ? _selectedEndTime = 18 : _selectedEndTime = _selectedEnd!.hour.toDouble();

    _entryMode = widget.initialEntryMode;
    _autoValidate = false;
  }

  void _handleOk() {
    if (_entryMode == PDatePickerEntryMode.input) {
      final PInputDateRangePickerState picker = _inputPickerKey.currentState!;
      if (!picker.validate()) {
        setState(() {
          _autoValidate = true;
        });
        return;
      }
    }
    if (_selectedStart == Jalali.now() &&
        _selectedStartTime!.round() <= DateTime
            .now()
            .add(const Duration(hours: 4))
            .hour) {
      showDialog(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    const IconData(0xe816, fontFamily: 'MyIcons'),
                    size: 98,
                    color: Theme
                        .of(context)
                        .colorScheme
                        .onSurfaceVariant,
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'ساعت تحویل خودرو باید چهار ساعت از زمان جاری جلوتر باشد',
                    style:
                    Theme
                        .of(context)
                        .textTheme
                        .bodyLarge!
                        .apply(color: Theme
                        .of(context)
                        .colorScheme
                        .onBackground),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      elevation: 0,
                      primary: Theme
                          .of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.1),
                    ),
                    child: Text('باشه',
                        style: Theme
                            .of(context)
                            .textTheme
                            .titleMedium!
                            .apply(color: Theme
                            .of(context)
                            .colorScheme
                            .primary)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            );
          });
    } else {
      final JalaliRange? selectedRange = _hasSelectedDateRange
          ? JalaliRange(
          start:
          Jalali(_selectedStart!.year, _selectedStart!.month, _selectedStart!.day, _selectedStartTime!.round()),
          end: Jalali(_selectedEnd!.year, _selectedEnd!.month, _selectedEnd!.day, _selectedEndTime!.round()))
          : null;
      //todo add time to selectedRange
      print("return:: $selectedRange");
      Navigator.pop(context, selectedRange);
    }
  }

  void _handleCancel() {
    Navigator.pop(context);
  }

  void _handleEntryModeToggle() {
    setState(() {
      switch (_entryMode) {
        case PDatePickerEntryMode.calendar:
          _autoValidate = false;
          _entryMode = PDatePickerEntryMode.input;
          break;

        case PDatePickerEntryMode.input:
        // If invalid range (start after end), then just use the start date
          if (_selectedStart != null && _selectedEnd != null && _selectedStart!.isAfter(_selectedEnd!)) {
            _selectedEnd = null;
          }
          _entryMode = PDatePickerEntryMode.calendar;
          break;
        default:
          break;
      }
    });
  }

  void _handleStartDateChanged(Jalali? date) {
    setState(() => _selectedStart = date);
  }

  void _handleEndDateChanged(Jalali? date) {
    setState(() => _selectedEnd = date);
  }

  void _handleStartTimeChanged(double? hour) {
    _selectedStartTime = hour;
  }

  void _handleEndTimeChanged(double? hour) {
    _selectedEndTime = hour;
  }

  bool get _hasSelectedDateRange => _selectedStart != null && _selectedEnd != null;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final Orientation orientation = mediaQuery.orientation;
    final double textScaleFactor = math.min(mediaQuery.textScaleFactor, 1.3);

    late Widget contents;
    late Size size;
    ShapeBorder? shape;
    double? elevation;
    EdgeInsets? insetPadding;
    switch (_entryMode) {
      case PDatePickerEntryMode.calendar:
        contents = _CalendarRangePickerDialog(
          key: _calendarPickerKey,
          selectedStartDate: _selectedStart,
          selectedEndDate: _selectedEnd,
          selectedStartTime: _selectedStartTime,
          selectedEndTime: _selectedEndTime,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          currentDate: widget.currentDate,
          onStartDateChanged: _handleStartDateChanged,
          onEndDateChanged: _handleEndDateChanged,
          onStartTimeChanged: _handleStartTimeChanged,
          onEndTimeChanged: _handleEndTimeChanged,
          onConfirm: _hasSelectedDateRange ? _handleOk : null,
          onCancel: _handleCancel,
          onToggleEntryMode: _handleEntryModeToggle,
          confirmText: widget.saveText ?? "تایید",
          clearText: widget.saveText ?? "پاک کردن",
          helpText: widget.helpText ?? "انتخاب تاریخ",
          showEntryModeIcon: widget.showEntryModeIcon ?? true,
        );
        size = mediaQuery.size;
        insetPadding = const EdgeInsets.all(0.0);
        shape = const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero));
        elevation = 0;
        break;

      case PDatePickerEntryMode.input:
        contents = _PInputDateRangePickerDialog(
          selectedStartDate: _selectedStart,
          selectedEndDate: _selectedEnd,
          currentDate: widget.currentDate,
          picker: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            height: orientation == Orientation.portrait ? _inputFormPortraitHeight : _inputFormLandscapeHeight,
            child: Column(
              children: <Widget>[
                const Spacer(),
                PInputDateRangePicker(
                  key: _inputPickerKey,
                  initialStartDate: _selectedStart,
                  initialEndDate: _selectedEnd,
                  firstDate: widget.firstDate,
                  lastDate: widget.lastDate,
                  onStartDateChanged: _handleStartDateChanged,
                  onEndDateChanged: _handleEndDateChanged,
                  autofocus: true,
                  autovalidate: _autoValidate,
                  helpText: widget.helpText,
                  errorInvalidRangeText: widget.errorInvalidRangeText,
                  errorFormatText: widget.errorFormatText,
                  errorInvalidText: widget.errorInvalidText,
                  fieldStartHintText: widget.fieldStartHintText,
                  fieldEndHintText: widget.fieldEndHintText,
                  fieldStartLabelText: widget.fieldStartLabelText,
                  fieldEndLabelText: widget.fieldEndLabelText,
                ),
                const Spacer(),
              ],
            ),
          ),
          onConfirm: _handleOk,
          onCancel: _handleCancel,
          onToggleEntryMode: _handleEntryModeToggle,
          confirmText: widget.confirmText ?? 'تایید',
          cancelText: widget.cancelText ?? 'لغو',
          helpText: widget.helpText ?? 'انتخاب تاریخ',
        );
        final DialogTheme dialogTheme = Theme
            .of(context)
            .dialogTheme;
        size = orientation == Orientation.portrait ? _inputPortraitDialogSize : _inputLandscapeDialogSize;
        insetPadding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0);
        shape = dialogTheme.shape;
        elevation = dialogTheme.elevation ?? 24;
        break;
      default:
        break;
    }

    return Dialog(
      insetPadding: insetPadding,
      shape: shape,
      elevation: elevation,
      clipBehavior: Clip.antiAlias,
      child: AnimatedContainer(
        width: size.width,
        height: size.height,
        duration: _dialogSizeAnimationDuration,
        curve: Curves.easeIn,
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: textScaleFactor,
          ),
          child: Builder(builder: (BuildContext context) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: contents,
            );
          }),
        ),
      ),
    );
  }
}

class _CalendarRangePickerDialog extends StatefulWidget {
  final Jalali? selectedStartDate;
  final Jalali? selectedEndDate;
  final double? selectedStartTime;
  final double? selectedEndTime;
  final Jalali firstDate;
  final Jalali lastDate;
  final Jalali? currentDate;
  final ValueChanged<Jalali?> onStartDateChanged;
  final ValueChanged<Jalali?> onEndDateChanged;
  final ValueChanged<double?> onStartTimeChanged;
  final ValueChanged<double?> onEndTimeChanged;
  final VoidCallback? onConfirm;
  final VoidCallback onCancel;
  final VoidCallback onToggleEntryMode;
  final String confirmText;
  final String clearText;
  final String helpText;
  final bool showEntryModeIcon;

  const _CalendarRangePickerDialog({
    Key? key,
    required this.selectedStartDate,
    required this.selectedEndDate,
    required this.selectedStartTime,
    required this.selectedEndTime,
    required this.firstDate,
    required this.lastDate,
    required this.currentDate,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.onStartTimeChanged,
    required this.onEndTimeChanged,
    required this.onConfirm,
    required this.onCancel,
    required this.onToggleEntryMode,
    required this.confirmText,
    required this.clearText,
    required this.helpText,
    required this.showEntryModeIcon,
  }) : super(key: key);

  @override
  _CalendarRangePickerDialogState createState() => _CalendarRangePickerDialogState();
}

class _CalendarRangePickerDialogState extends State<_CalendarRangePickerDialog> {
  double _valueSliderPickUp = 7;
  double _valueSliderDropOff = 18;

  @override
  void initState() {
    _valueSliderPickUp = widget.selectedStartTime!;
    _valueSliderDropOff = widget.selectedEndTime!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final Orientation orientation = MediaQuery
        .of(context)
        .orientation;
    final TextTheme textTheme = theme.textTheme;
    final Color headerForeground = colorScheme.onBackground;
    final Color headerDisabledForeground = headerForeground.withOpacity(0.38);
    final String startDateText =
    utils.formatRangeStartDate(localizations, widget.selectedStartDate, widget.selectedEndDate);
    final String endDateText =
    utils.formatRangeEndDate(localizations, widget.selectedStartDate, widget.selectedEndDate, Jalali.now());
    final TextStyle? headlineStyle = textTheme.bodyMedium;
    final TextStyle? startDateStyle =
    headlineStyle?.apply(color: widget.selectedStartDate != null ? headerForeground : headerDisabledForeground);
    final TextStyle? endDateStyle =
    headlineStyle?.apply(color: widget.selectedEndDate != null ? headerForeground : headerDisabledForeground);
    final TextStyle saveButtonStyle =
    textTheme.button!.apply(color: widget.onConfirm != null ? headerForeground : headerDisabledForeground);
    final TextStyle titleTextStyle = textTheme.bodyLarge!.apply(color: colorScheme.onBackground);
    final TextStyle clearButtonStyle = textTheme.labelLarge!
        .apply(color: widget.onConfirm != null ? colorScheme.primary : colorScheme.primary.withOpacity(0.5));
    Jalali? startDate = widget.selectedStartDate;
    Jalali? endDate = widget.selectedEndDate;

    final IconButton entryModeIcon = IconButton(
      padding: EdgeInsets.zero,
      color: headerForeground,
      icon: const Icon(IconData(0xe830, fontFamily: 'MyIcons')),
      tooltip: 'ورود تاریخ',
      onPressed: widget.onToggleEntryMode,
    );

    return SafeArea(
      top: false,
      left: false,
      right: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorScheme.background,
          // leading: CloseButton(
          //   color: colorScheme.onBackground,
          //   onPressed: widget.onCancel,
          // ),
          leading: IconButton(
            icon: const Icon(IconData(0xe8c1, fontFamily: 'MyIcons')),
            color: colorScheme.onBackground,
            tooltip: "بستن پنجره",
            onPressed: widget.onCancel,
          ),
          title: Text(widget.helpText, style: titleTextStyle),
          actions: <Widget>[
            ButtonTheme(
              minWidth: 64,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    widget.onStartDateChanged.call(null);
                    widget.onEndDateChanged.call(null);
                    startDate = null;
                    endDate = null;
                  });
                },
                child: Text(widget.clearText, style: clearButtonStyle),
              ),
            ),
            const SizedBox(width: 8),
          ],
          bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 48),
            child: Semantics(
              label: '${widget.helpText} $startDateText to $endDateText',
              excludeSemantics: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "$startDateText\n"
                            "${_valueSliderPickUp.round()}:00",
                        style: startDateStyle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Icon(
                        const IconData(0xe806, fontFamily: 'MyIcons'),
                        size: 18,
                        color: colorScheme.onSurface,
                      ),
                      Text(
                        "$endDateText\n"
                            "${_valueSliderDropOff.round()}:00",
                        style: endDateStyle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: PCalendarDateRangePicker(
                initialStartDate: startDate,
                initialEndDate: endDate,
                firstDate: widget.firstDate,
                lastDate: widget.lastDate,
                currentDate: widget.currentDate,
                onStartDateChanged: widget.onStartDateChanged,
                onEndDateChanged: widget.onEndDateChanged,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 26, vertical: 20),
              decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .colorScheme
                    .background,
                boxShadow: [
                  BoxShadow(
                    color: Theme
                        .of(context)
                        .shadowColor
                        .withOpacity(0.25),
                    spreadRadius: 0,
                    blurRadius: 3,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      Text(
                        'ساعت تحویل',
                        textAlign: TextAlign.center,
                        style: textTheme.titleSmall,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Center(
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Theme
                                  .of(context)
                                  .colorScheme
                                  .primary,
                              inactiveTrackColor: Theme
                                  .of(context)
                                  .colorScheme
                                  .surface,
                              trackHeight: 4.0,
                              thumbColor: Theme
                                  .of(context)
                                  .colorScheme
                                  .onPrimary,
                              thumbShape: const CustomSliderThumbRect(
                                thumbRadius: 48 * 0.4,
                                thumbHeight: 48,
                                min: 0,
                                max: 24,
                              ),
                              overlayColor: Colors.white.withOpacity(.4),
                              //valueIndicatorColor: Colors.white,
                              activeTickMarkColor: Colors.white,
                              inactiveTickMarkColor: Colors.red.withOpacity(.7),
                            ),
                            child: Slider(
                                value: _valueSliderPickUp,
                                min: 0,
                                max: 24,
                                onChanged: (value) {
                                  widget.onStartTimeChanged.call(value);
                                  setState(() {
                                    _valueSliderPickUp = value;
                                  });
                                }),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'ساعت استرداد',
                        textAlign: TextAlign.center,
                        style: textTheme.titleSmall,
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Center(
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Theme
                                  .of(context)
                                  .colorScheme
                                  .primary,
                              inactiveTrackColor: Theme
                                  .of(context)
                                  .colorScheme
                                  .surface,
                              trackHeight: 4.0,
                              thumbColor: Theme
                                  .of(context)
                                  .colorScheme
                                  .onPrimary,
                              thumbShape: const CustomSliderThumbRect(
                                thumbRadius: 48 * 0.4,
                                thumbHeight: 48,
                                min: 0,
                                max: 24,
                              ),
                              overlayColor: Colors.white.withOpacity(.4),
                              //valueIndicatorColor: Colors.white,
                              activeTickMarkColor: Colors.white,
                              inactiveTickMarkColor: Colors.red.withOpacity(.7),
                            ),
                            child: Slider(
                                value: _valueSliderDropOff,
                                min: 0,
                                max: 24,
                                onChanged: (value) {
                                  widget.onEndTimeChanged.call(value);
                                  setState(() {
                                    _valueSliderDropOff = value;
                                  });
                                }),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    height: 38,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Theme
                            .of(context)
                            .colorScheme
                            .primary,
                        // minimumSize: Size(334, 52),
                        elevation: 0,
                        textStyle: Theme
                            .of(context)
                            .textTheme
                            .titleMedium,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      onPressed: widget.onConfirm,
                      child: const Text('اعمال تغییرات'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PInputDateRangePickerDialog extends StatelessWidget {
  const _PInputDateRangePickerDialog({
    Key? key,
    required this.selectedStartDate,
    required this.selectedEndDate,
    required this.currentDate,
    required this.picker,
    required this.onConfirm,
    required this.onCancel,
    required this.onToggleEntryMode,
    required this.confirmText,
    required this.cancelText,
    required this.helpText,
  }) : super(key: key);

  final Jalali? selectedStartDate;
  final Jalali? selectedEndDate;
  final Jalali? currentDate;
  final Widget picker;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final VoidCallback onToggleEntryMode;
  final String confirmText;
  final String cancelText;
  final String helpText;

  String _formatDateRange(BuildContext context, Jalali? start, Jalali? end, Jalali? now) {
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final String startText = utils.formatRangeStartDate(localizations, start, end);
    final String endText = utils.formatRangeEndDate(localizations, start, end, now);
    if (start == null || end == null) {
      return localizations.unspecifiedDateRange;
    }
    if (Directionality.of(context) == TextDirection.ltr) {
      return '$startText – $endText';
    } else {
      return '$endText – $startText';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final Orientation orientation = MediaQuery
        .of(context)
        .orientation;
    final TextTheme textTheme = theme.textTheme;

    final Color dateColor = colorScheme.brightness == Brightness.light ? colorScheme.onPrimary : colorScheme.onSurface;
    final TextStyle? dateStyle = orientation == Orientation.landscape
        ? textTheme.subtitle1?.apply(color: dateColor)
        : textTheme.headline5?.apply(color: dateColor);
    final String dateText = _formatDateRange(context, selectedStartDate, selectedEndDate, currentDate);
    final String semanticDateText = selectedStartDate != null && selectedEndDate != null
        ? '${selectedStartDate!.formatMediumDate()} – ${selectedEndDate!.formatMediumDate()}'
        : '';

    final Widget header = PDatePickerHeader(
      helpText: helpText,
      titleText: dateText,
      titleSemanticsLabel: semanticDateText,
      titleStyle: dateStyle,
      orientation: orientation,
      isShort: orientation == Orientation.landscape,
      icon: Icons.calendar_today,
      iconTooltip: 'انتخاب تاریخ',
      onIconPressed: onToggleEntryMode,
    );

    final Widget actions = Container(
      alignment: AlignmentDirectional.centerEnd,
      constraints: const BoxConstraints(minHeight: 52.0),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: OverflowBar(
        spacing: 8,
        children: <Widget>[
          TextButton(
            onPressed: onCancel,
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: onConfirm,
            child: Text(confirmText),
          ),
        ],
      ),
    );

    switch (orientation) {
      case Orientation.portrait:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            header,
            Expanded(child: picker),
            actions,
          ],
        );

      case Orientation.landscape:
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            header,
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(child: picker),
                  actions,
                ],
              ),
            ),
          ],
        );
    }
  }
}
