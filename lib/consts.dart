class ConstsDuration {
  Duration operator [](int i) => Duration(milliseconds: i);
}

class Consts {
  static final duration = ConstsDuration();
}
