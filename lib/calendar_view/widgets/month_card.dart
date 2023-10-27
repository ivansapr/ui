import 'package:flutter/material.dart';

class MonthCard extends StatelessWidget {
  final String label;
  final Widget child;
  const MonthCard({super.key, required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MonthNameWidget(label: label),
            const SizedBox(height: 5),
            Flexible(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthNameWidget extends StatelessWidget {
  final String label;
  const _MonthNameWidget({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: DefaultTextStyle.of(context).style.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
