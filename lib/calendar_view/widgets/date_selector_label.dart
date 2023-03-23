import 'package:flutter/material.dart';

enum SelectedDate { first, second, none }

class DateSelectorLabel extends StatelessWidget {
  final DateTime? from;
  final DateTime? to;

  final SelectedDate? state;
  const DateSelectorLabel({super.key, this.from, this.to, this.state = SelectedDate.none});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          from?.toString() ?? '',
          style: state == SelectedDate.first
              ? DefaultTextStyle.of(context).style.copyWith(color: Colors.red)
              : null,
        ),
        const Text('—'),
        Text(
          to?.toString() ?? '',
          style: state == SelectedDate.second
              ? DefaultTextStyle.of(context).style.copyWith(color: Colors.red)
              : null,
        ),
      ],
    );
  }
}
