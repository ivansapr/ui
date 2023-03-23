import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ui_exp/calendar_view/month_model.dart';
import 'package:ui_exp/calendar_view/widgets/date_range_selector_view.dart';

class DateRangeDragSelectorView extends StatefulWidget {
  final MonthModel value;
  final void Function(DateRangeModel) onSelect;
  final Widget child;

  const DateRangeDragSelectorView({
    super.key,
    required this.value,
    required this.onSelect,
    required this.child,
  });

  @override
  State<DateRangeDragSelectorView> createState() => _DateRangeDragSelectorViewState();
}

class _DateRangeDragSelectorViewState extends State<DateRangeDragSelectorView> {
  final key = GlobalKey();
  DateRangeModel dateRange = DateRangeModel();
  DateTime? currentDay;

  DateTime? getDayFromPoint(Offset point) {
    final renderBox = key.currentContext!.findRenderObject() as RenderBox;
    final local = renderBox.globalToLocal(point);
    final size = renderBox.size;
    final rows = widget.value.weeks.length;
    final columns = 7;
    final cellWidth = size.width / columns;
    final cellHeight = size.height / rows;
    final column = (local.dx / cellWidth).floor();
    final row = (local.dy / cellHeight).floor();
    try {
      final day = widget.value.weeks[row][column];
      return day.date;
    } catch (e) {
      return null;
    }
  }

  void onSelect(DateRangeModel dateRange) {
    widget.onSelect(dateRange.fixRange());
  }

  void onPanStart(DragStartDetails details) {
    dateRange = DateRangeModel();
    final day = getDayFromPoint(details.globalPosition);
    if (day == null) {
      return;
    }
    currentDay = day;
    if (dateRange.from == null) {
      dateRange = dateRange.copyWith(from: day, to: day);
      onSelect(dateRange);
    }
  }

  void onPanUpdate(DragUpdateDetails details) {
    final day = getDayFromPoint(details.globalPosition);
    if (day == null) {
      return;
    }
    if (day == currentDay) {
      return;
    }

    currentDay = day;

    dateRange = dateRange.copyWith(to: day);
    onSelect(dateRange);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: key,
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      onPanCancel: () {
        dateRange = DateRangeModel();
      },
      child: widget.child,
    );
  }
}
