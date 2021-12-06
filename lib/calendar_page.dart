import 'package:custom_table_calendar/calendar_model.dart';
import 'package:custom_table_calendar/custom_calendar_builders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CalendarModel>(
      create: (_) => CalendarModel()..init(),
      child: Consumer<CalendarModel>(builder: (context, model, snapshot) {
        final CustomCalendarBuilders customCalendarBuilders =
            CustomCalendarBuilders();

        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: TableCalendar<dynamic>(
                focusedDay: model.focusedDay,
                firstDay: model.firstDayOfMonth,
                lastDay: model.lastDayOfMonth,
                locale: Localizations.localeOf(context).languageCode,
                weekendDays: const [DateTime.sunday],
                rowHeight: 70,
                daysOfWeekHeight: 32,
                availableGestures: AvailableGestures.none,
                headerStyle: const HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                  leftChevronVisible: false,
                  rightChevronVisible: false,
                ),
                calendarStyle: const CalendarStyle(
                  isTodayHighlighted: false,
                  weekendTextStyle: TextStyle(color: Colors.red),
                  holidayTextStyle: TextStyle(color: Colors.red),
                ),
                calendarBuilders: CalendarBuilders(
                  dowBuilder: customCalendarBuilders.daysOfWeekBuilder,
                  selectedBuilder: customCalendarBuilders.selectedBuilder,
                  disabledBuilder: customCalendarBuilders.outsideBuilder,
                  outsideBuilder: customCalendarBuilders.outsideBuilder,
                  defaultBuilder: customCalendarBuilders.defaultBuilder,
                  markerBuilder: customCalendarBuilders.markerBuilder,
                ),
                eventLoader: model.fetchScheduleForDay,
                selectedDayPredicate: (day) {
                  return isSameDay(model.selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  model.selectDay(selectedDay, focusedDay);
                },
              ),
            ),
          ),
        );
      }),
    );
  }
}
