import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendarBuilders {
  final Color _borderColor = Colors.green[600]!;

  Color _textColor(DateTime day) {
    const _defaultTextColor = Colors.black87;

    if (day.weekday == DateTime.sunday) {
      return Colors.red;
    }
    if (day.weekday == DateTime.saturday) {
      return Colors.blue[600]!;
    }
    return _defaultTextColor;
  }

  /// 曜日部分を生成する
  Widget daysOfWeekBuilder(BuildContext context, DateTime day) {
    // <TableCalendarの中身からコピペ>
    // アプリの言語設定読み込み
    final locale = Localizations.localeOf(context).languageCode;

    // アプリの言語設定に曜日の文字を対応させる
    final dowText =
        const DaysOfWeekStyle().dowTextFormatter?.call(day, locale) ??
            DateFormat.E(locale).format(day);
    // </ TableCalendarの中身からコピペ>

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.5,
          color: _borderColor,
        ),
      ),
      child: Center(
        child: Text(
          dowText,
          style: TextStyle(
            color: _textColor(day),
          ),
        ),
      ),
    );
  }

  /// 通常の日付部分を生成する
  Widget defaultBuilder(
      BuildContext context, DateTime day, DateTime focusedDay) {
    return _CalendarCellTemplate(
      dayText: day.day.toString(),
      dayTextColor: _textColor(day),
      borderColor: _borderColor,
    );
  }

  /// 有効範囲（firstDay~lastDay）以外の日付部分を生成する
  Widget disabledBuilder(
      BuildContext context, DateTime day, DateTime focusedDay) {
    return _CalendarCellTemplate(
      dayText: day.day.toString(),
      dayTextColor: Colors.grey,
      borderColor: _borderColor,
    );
  }

  /// 選択された日付部分を生成する
  Widget selectedBuilder(
      BuildContext context, DateTime day, DateTime focusedDay) {
    return _CalendarCellTemplate(
      dayText: day.day.toString(),
      dayTextColor: _textColor(day),
      borderColor: Colors.red[800],
      borderWidth: 3.0,
    );
  }

  /// 予定のマーカー部分を生成する
  Widget markerBuilder(
    BuildContext context,
    DateTime day,
    List<dynamic> dailyScheduleList,
  ) {
    final am = dailyScheduleList.first ?? '';
    final pm = dailyScheduleList.last ?? '';

    _scheduleText(String schedule) {
      if (schedule == 'on') {
        return const Text(
          '○',
          style: TextStyle(fontWeight: FontWeight.bold),
        );
      } else if (schedule == 'off') {
        return const Text(
          '×',
          style: TextStyle(fontWeight: FontWeight.bold),
        );
      } else {
        return const Text('-');
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        children: [
          _scheduleText(am),
          _scheduleText(pm),
        ],
      ),
    );
  }
}

class _CalendarCellTemplate extends StatelessWidget {
  _CalendarCellTemplate({
    Key? key,
    String? dayText,
    Duration? duration,
    Alignment? textAlign,
    Color? dayTextColor,
    Color? borderColor,
    double? borderWidth,
  })  : dayText = dayText ?? '',
        duration = duration ?? const Duration(milliseconds: 250),
        textAlign = textAlign ?? Alignment.topCenter,
        dayTextColor = dayTextColor ?? Colors.black87,
        borderColor = borderColor ?? Colors.black87,
        borderWidth = borderWidth ?? 0.5,
        super(key: key);

  final String dayText;
  final Color? dayTextColor;
  final Duration duration;
  final Alignment? textAlign;
  final Color? borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final defaultBorderColor = Theme.of(context).colorScheme.primary;
    return AnimatedContainer(
      duration: duration,
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor ?? defaultBorderColor,
          width: borderWidth,
        ),
      ),
      alignment: textAlign,
      child: Text(
        dayText,
        style: TextStyle(
          color: dayTextColor,
        ),
      ),
    );
  }
}
