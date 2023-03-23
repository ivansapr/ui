import 'package:flutter/material.dart';
import 'package:ui_exp/calendar_view/month_model.dart';
import 'package:ui_exp/calendar_view/widgets/calendar_point_listener.dart';

import 'date_range_selector_view.dart';
import 'month_card.dart';
import 'month_view.dart';
import 'package:intl/intl.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late final DateTime value;
  late final MonthModel monthModel;

  @override
  void initState() {
    super.initState();
    value = DateTime.now();
    monthModel = MonthModel(value);
  }

  DateRangeModel dateRange = DateRangeModel();

  void onDayTap(DateTime? date) {
    if (date == null) {
      return;
    }
    if (dateRange.from == null) {
      setState(() {
        dateRange = dateRange.copyWith(from: date);
      });
      return;
    }

    if (dateRange.to == null) {
      setState(() {
        dateRange = dateRange.copyWith(to: date);
      });
      return;
    }

    if (dateRange.from?.isAfter(date) ?? false) {
      setState(() {
        dateRange = dateRange.copyWith(from: date);
      });
      return;
    }
    if (dateRange.to?.isBefore(date) ?? false) {
      setState(() {
        dateRange = dateRange.copyWith(to: date);
      });
      return;
    }
    if (dateRange.from?.isBefore(date) ?? false) {
      setState(() {
        dateRange = dateRange.copyWith(to: date);
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MonthCard(
          label: DateFormat('MMMM').format(value),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MonthViewHeaderRow(),
              DateRangeDragSelectorView(
                value: monthModel,
                onSelect: (range) {
                  setState(() {
                    dateRange = range;
                  });
                },
                child: Stack(
                  children: [
                    MonthView(value: monthModel),
                    DateRangeSelectorView(
                      value: monthModel,
                      dateRange: dateRange,
                      onDayTap: onDayTap,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        DateRangeWidget(dateRange: dateRange),
      ],
    );
  }
}

class MonthViewHeaderRow extends StatelessWidget {
  const MonthViewHeaderRow({super.key});

  static const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return WeekRow(
      children: labels
          .map(
            (e) => DayCellContainer(
              child: Text(
                e,
                textAlign: TextAlign.center,
                style: DefaultTextStyle.of(context).style.copyWith(
                      fontSize: 10,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class DateRangeWidget extends StatelessWidget {
  final DateRangeModel dateRange;

  const DateRangeWidget({super.key, required this.dateRange});

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd');
    if (dateRange.from == null && dateRange.to == null) {
      return const SizedBox.shrink();
    }
    return Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: dateRange.from == null ? '?' : formatter.format(dateRange.from!),
            ),
            const TextSpan(text: ' - '),
            TextSpan(
              text: dateRange.to == null ? '?' : formatter.format(dateRange.to!),
            ),
          ],
        ),
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ));
  }
}
