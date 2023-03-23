import 'package:ui_exp/calendar_view/datetime_extension.dart';

class MonthModel {
  final DateTime value;

  late final int previuosMonthDays;
  late final List<List<DayModel>> weeks;
  late final int weeksLength;
  static const int columnsLength = 7;

  int countPreviuosMonthDays() {
    final d = DateTime(value.year, value.month, 1);
    return d.weekday - 1;
  }

  MonthModel(this.value) {
    previuosMonthDays = countPreviuosMonthDays();
    weeksLength = (previuosMonthDays + value.daysInMonth) ~/ 6;
    weeks = generate();
  }

  List<List<DayModel>> generate() {
    final dayCellsData = List.filled(previuosMonthDays, DayModel.empty(), growable: true);
    dayCellsData
      ..addAll(
        List.generate(
          value.daysInMonth,
          (index) => DayModel(DateTime(value.year, value.month, index + 1)),
        ),
      )
      ..addAll(
        List.filled(
          weeksLength * DateTime.daysPerWeek - dayCellsData.length,
          DayModel.empty(),
        ),
      );

    final rows = <List<DayModel>>[];
    for (var i = 0; i < weeksLength; i++) {
      final rowIndex = i * DateTime.daysPerWeek;
      rows.add(dayCellsData.sublist(rowIndex, rowIndex + DateTime.daysPerWeek));
    }

    return rows;
  }
}

class DayModel {
  final DateTime? date;

  DayModel(this.date);
  DayModel.empty() : date = null;
}
