import 'package:flutter/material.dart';
import 'package:ui_exp/calendar_view/month_model.dart';
import 'package:ui_exp/calendar_view/widgets/month_view.dart';

class DateRangeModel {
  final DateTime? from;
  final DateTime? to;

  DateRangeModel({this.from, this.to});

  DateRangeModel copyWith({DateTime? from, DateTime? to}) => DateRangeModel(
        from: from ?? this.from,
        to: to ?? this.to,
      );

  DateRangeModel fixRange() {
    if (from == null || to == null) {
      return this;
    }
    if (from!.isAfter(to!)) {
      return DateRangeModel(from: to, to: from);
    }
    return this;
  }

  bool rangeIsCorrect() {
    if (from == null || to == null) {
      return false;
    }
    return from!.isBefore(to!);
  }

  bool dayInRangeOrEqual(DateTime? date) {
    if (date == null) {
      return false;
    }
    if (from == null || to == null) {
      return false;
    }
    return date.isAtSameMomentAs(from!) ||
        date.isAtSameMomentAs(to!) ||
        (date.isAfter(from!) && date.isBefore(to!));
  }

  bool isFirstDay(DateTime? date) {
    if (date == null) {
      return false;
    }
    return date.isAtSameMomentAs(from!);
  }

  bool isLastDay(DateTime? date) {
    if (date == null) {
      return false;
    }
    return date.isAtSameMomentAs(to!);
  }

  @override
  String toString() {
    return 'DateRangeModel{from: ${from?.day}, to: ${to?.day}}';
  }
}

class DateRangeSelectorView extends StatelessWidget {
  final MonthModel value;
  final DateRangeModel dateRange;
  final void Function(DateTime?)? onDayTap;

  const DateRangeSelectorView({
    super.key,
    required this.value,
    required this.dateRange,
    this.onDayTap,
  });

  List<Widget> generateTable() {
    return value.weeks
        .map(
          (week) => WeekRow(
            children: week
                .map((day) => GestureDetector(
              behavior: HitTestBehavior.opaque,
                      onTap: () => onDayTap?.call(day.date),
                      child: dateRange.dayInRangeOrEqual(day.date)
                          ? SelectedDayWidget(date: day.date)
                          : DayCell(date: day.date),
                    ))
                .toList(),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: generateTable(),
    );
  }
}

class SelectedDayWidget extends StatelessWidget {
  final DateTime? date;

  const SelectedDayWidget({super.key, this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: DayCellContainer(
        child: Text(
          date?.day.toString() ?? '',
          style: DefaultTextStyle.of(context).style.copyWith(color: Colors.white, fontSize: 11),
        ),
      ),
    );
  }
}
