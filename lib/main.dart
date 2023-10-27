import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ui_exp/align_buttons_row/align_buttons.dart';
import 'package:ui_exp/animate_switch/animate_switch_icons.dart';
import 'package:ui_exp/calendar_view/selection_calendar.dart';
import 'package:ui_exp/chart.dart';
import 'package:ui_exp/drop_down.dart';
import 'package:ui_exp/gradient_screen/gradient_screen.dart';
import 'package:ui_exp/hero_local_transition/hero_local_page.dart';
import 'package:ui_exp/jumping_letters.dart';
import 'package:ui_exp/planetary_date/planetary_date.dart';
import 'package:ui_exp/rolling_numbers_widget.dart';
import 'package:ui_exp/shader/shader_page.dart';
import 'package:ui_exp/show_widget.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 6, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        bottomNavigationBar: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          tabs: const [
            Tab(icon: Icon(Icons.animation)),
            Tab(icon: Icon(Icons.imagesearch_roller)),
            Tab(icon: Icon(Icons.auto_graph_outlined)),
            Tab(icon: Icon(Icons.animation)),
            Tab(icon: Icon(Icons.gradient)),
            Tab(icon: Icon(Icons.widgets)),
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            AnimatedSwitchIconsPage(),
            ShaderPage(),
            TestPage(),
            HeroLocalPage(),
            GradientScreen(),
            WidgetsPage(),
          ],
        ),
      ),
    );
  }
}

class WidgetsPage extends StatefulWidget {
  const WidgetsPage({super.key});

  @override
  State<WidgetsPage> createState() => _WidgetsPageState();
}

class _WidgetsPageState extends State<WidgetsPage> {
  int numbers = 12345;

  @override
  void initState() {
    super.initState();

    numbers = 12345;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromRGBO(27, 31, 36, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StatefulBuilder(
                builder: (context, setState) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RollingNumbers(numbers: numbers),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton(
                            onPressed: () {
                              final r = Random();
                              setState(() {
                                numbers = r.nextInt(9999);
                              });
                            },
                            child: const Text('Random')),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              numbers += 1;
                            });
                          },
                          child: const Text('+1'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // SizedBox(height: 10),
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  JumpingLetters(value: 'Ivan'),
                ],
              ),

              const ShowWidget(
                title: 'Animated Drop Down',
                child: CustomDropDown(),
              ),
              const ShowWidget(
                title: 'Calendar with selectable range',
                child: SelectionCalendar(),
              ),
              const PlanetaryDate(),
              const AlignButtons(),
            ],
          ),
        ),
      ),
    );
  }
}

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  final width = 200.0;
  final padding = 20.0;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(18.0),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(18.0),
              child: MonthSpendingChart(),
            ),
          ),
        ),
      ),
    );
  }
}

class SnapScrollPhysics extends ScrollPhysics {
  const SnapScrollPhysics({super.parent, required this.snapSize});

  final double snapSize;

  @override
  ScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return SnapScrollPhysics(parent: buildParent(ancestor), snapSize: snapSize);
  } // @override
  // SnapScrollSize applyTo(ScrollPhysics? ancestor) {
  //   return SnapScrollSize(parent: buildParent(ancestor), snapSize: snapSize);
  // }

  double _getPage(ScrollMetrics position) {
    return position.pixels / snapSize;
  }

  double _getPixels(ScrollMetrics position, double page) {
    return page * snapSize;
  }

  double _getTargetPixels(ScrollMetrics position, Tolerance tolerance, double velocity) {
    double page = _getPage(position);
    if (velocity < -tolerance.velocity) {
      page -= 0.5;
    } else if (velocity > tolerance.velocity) {
      page += 0.5;
    }
    return _getPixels(position, page.roundToDouble());
  }

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at a page boundary.
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }
    final Tolerance tolerance = this.tolerance;
    final double target = _getTargetPixels(position, tolerance, velocity);
    if (target != position.pixels) {
      return ScrollSpringSimulation(spring, position.pixels, target, velocity,
          tolerance: tolerance);
    }
    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}
