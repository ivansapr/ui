import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../month_model.dart';

class MonthView extends StatefulWidget {
  final MonthModel value;
  const MonthView({super.key, required this.value});

  @override
  State<MonthView> createState() => _MonthViewState();
}

class _MonthViewState extends State<MonthView> {
  MonthModel get value => widget.value;

  List<Widget> generateTable() {
    return value.weeks
        .map(
          (week) => WeekRow(
            children: week.map((day) => DayCell(date: day.date)).toList(),
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

class DayCellContainer extends StatelessWidget {
  final Widget? child;
  const DayCellContainer({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 22),
      child: SizedBox(
        height: 20,
        child: Center(
          child: child,
        ),
      ),
    );
  }
}

class DayCell extends StatelessWidget {
  final DateTime? date;

  const DayCell({
    super.key,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    if (date == null) {
      return const DayCellContainer();
    }
    return DayCellContainer(
      child: Text(
        date!.day.toString(),
        textAlign: TextAlign.center,
        style: DefaultTextStyle.of(context).style.copyWith(
              fontSize: 10,
            ),
      ),
    );
  }
}


class WeekRow extends StatelessWidget {
  final List<Widget> children;
  const WeekRow({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}
