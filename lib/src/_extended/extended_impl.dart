part of '../../flags_binary.dart';

///
/// [_hoursADay]
/// [_minuteADay]
/// [_monthsDaysWithoutFeb]
/// [_predicator_less]
/// [_isYearLeapYear], ...
/// [_monthDaysOf]
/// [_reduce_isLarger], ...
///
/// [_IntExtension]
/// [_NullableExtension]
/// [_StringBufferExtension]
/// [_Record2Int]
/// [_Record3Int]
///
///
///
const int _hoursADay = 24;
const int _minuteADay = 60;
const Map<int, int> _monthsDaysWithoutFeb = {
  1: 31,
  3: 31,
  4: 30,
  5: 31,
  6: 30,
  7: 31,
  8: 31,
  9: 30,
  10: 31,
  11: 30,
  12: 31,
};

///
///
///
bool Function(int) _predicator_less(int a) =>
    (v) => v < a;

bool Function(int) _predicator_additionLess(int a, int b) =>
    (v) => a + v < b;

///
///
///
bool _isYearLeapYear(int year) => year % 4 == 0
    ? year % 100 == 0
          ? year % 400 == 0
                ? true
                : false
          : true
    : false;

bool _isValidYearMonthScope((int, int) begin, (int, int) end) =>
    _isValidMonth(begin.$2) && _isValidMonth(end.$2) && begin < end;

bool _isInvalidMonth(int month) =>
    month < DateTime.january || month > DateTime.december;

bool _isValidMonth(int month) =>
    month >= DateTime.january && month <= DateTime.december;

// bool _isValidHour(int hour) => hour >= 0 && hour < 24;

// bool _isInvalidHour(int hour) => hour < 0 || hour > 23;

bool _isValidDay(int year, int month, int day) =>
    day >= 1 && day <= _monthDaysOf(year, month);

// bool _isInvalidDay(int year, int month, int day) =>
//     day < 1 || day > _monthDaysOf(year, month);

bool _isValidDate((int, int, int) date) {
  final month = date.$2;
  if (_isInvalidMonth(month)) return false;
  return _isValidDay(date.$1, month, date.$3);
}

// bool _isInvalidDate((int, int, int) date) {
//   final month = date.$2;
//   if (_isValidMonth(month)) return false;
//   return _isInvalidDay(date.$1, month, date.$3);
// }

///
///
///
int _monthDaysOf(int year, int month) => month == 2
    ? _isYearLeapYear(year)
          ? 29
          : 28
    : _monthsDaysWithoutFeb[month]!;

int yearDaysOf(int year) => _isYearLeapYear(year) ? 366 : 365;

///
///
///
bool _reduce_isLarger(int a, int b) => a > b;

bool _reduce_isLess(int a, int b) => a < b;

bool _reduce_isLargerOrEqual(int a, int b) => a >= b;

bool _reduce_isLessOrEqual(int a, int b) => a <= b;

///
///
///
extension _IntExtension on int {
  bool isRangeOpenLower(num lower, num upper) => this > lower && this <= upper;
}

///
///
///
extension _NullableExtension<T> on T? {
  S? nullOrMap<S>(S Function(T) mapper) {
    if (this == null) return null;
    return mapper(this as T);
  }
}

extension _NullableIterableExtension<T> on Iterable<T?> {
  Iterable<T> get forwardFilterNotNull sync* {
    for (var item in this) {
      if (item != null) yield item;
    }
  }
}

extension _NullableListExtension<T> on List<T?> {
  Iterable<T> get backwardFilterNotNull sync* {
    for (var i = length - 1; i >= 0; i--) {
      final item = this[i];
      if (item != null) yield item;
    }
  }
}

///
///
///
extension _StringBufferExtension on StringBuffer {
  ///
  /// [writeBit]
  /// [writeBitsOfMonth]
  /// [writeRepeat]
  ///
  void writeBit(int bits) => write(bits & 1 == 1 ? '1' : '0');

  void writeBitsOfMonth(int days, int dayLast) {
    var i = 0;
    // 1 ~ 24
    for (var j = 1; j < 4; j++) {
      final last = j * 8;
      while (i < last) {
        writeBit(days);
        days >>= 1;
        i++;
      }
      write(' ');
    }

    // 25 ~ lastDay
    while (i < dayLast) {
      writeBit(days);
      days >>= 1;
      i++;
    }

    while (i < 32) {
      write(' ');
      i++;
    }
  }

  void writeRepeat(
    int n,
    String value, [
    bool newLineEnd = false,
    bool newLineEach = false,
  ]) {
    final writing = newLineEach ? writeln : write;
    for (var i = 0; i < n; i++) {
      writing(value);
    }
    if (newLineEnd) writeln();
  }

  void writeRecord<T>(
    Iterable<T> iterable,
    Iterable<int> padding, [
    bool newLineEnd = false,
  ]) {
    assert(iterable.length == padding.length);
    final it = iterable.iterator;
    final pad = padding.iterator;
    write('(');
    if (it.moveNext() && pad.moveNext()) {
      write('${it.current}'.padLeft(pad.current));
    }
    while (it.moveNext() && pad.moveNext()) {
      write(',');
      write('${it.current}'.padLeft(pad.current));
    }
    newLineEnd ? writeln(')') : write(')');
  }
}

///
///
///
extension _Record2Int on (int, int) {
  ///
  ///
  /// [_comparing],
  /// [>], [<], [largerThan3], [lessThan3]
  /// [>=], [<=], [largerOrEqualThan3], [lessOrEqualThan3]
  ///
  ///
  bool _comparing(
    int a,
    int b, {
    required bool Function(int, int) reduceInvalid,
    required bool Function(int, int) reduce,
    required bool Function(int, int) reduceFinal,
  }) {
    final one = this.$1;
    if (reduceInvalid(one, a)) return false;
    if (reduce(one, a)) return true;
    final two = this.$2;
    if (reduceInvalid(two, b)) return false;
    return reduceFinal(two, b);
  }

  bool operator <((int, int) other) => _comparing(
    other.$1,
    other.$2,
    reduceInvalid: _reduce_isLarger,
    reduce: _reduce_isLess,
    reduceFinal: _reduce_isLess,
  );

  bool largerOrEqualThan3((int, int, int) other) => _comparing(
    other.$1,
    other.$2,
    reduceInvalid: _reduce_isLess,
    reduce: _reduce_isLarger,
    reduceFinal: _reduce_isLargerOrEqual,
  );

  bool lessOrEqualThan3((int, int, int) other) => _comparing(
    other.$1,
    other.$2,
    reduceInvalid: _reduce_isLarger,
    reduce: _reduce_isLess,
    reduceFinal: _reduce_isLessOrEqual,
  );

  ///
  /// [monthsToYearMonth]
  /// [daysToDate]
  /// [daysToDate]
  ///
  int monthsToYearMonth(int year, int month) {
    assert(_isValidMonth(month) && _isValidMonth(this.$2));
    return month - this.$2 + (year - this.$1) * 12;
  }

  int daysToDate(int year, int month, [int? day]) {
    assert(
      _isValidYearMonthScope(this, (year, month)),
      'invalid date: $this, ($year, $month)',
    );
    assert(
      day == null || _isValidDay(year, month, day),
      'invalid day: ($year, $month, $day)',
    );
    final yearCurrent = this.$1;
    var d = 0;
    var m = this.$2;
    if (yearCurrent < year) {
      for (; m < 13; m++) {
        d += _monthDaysOf(yearCurrent, m);
      }
      for (var y = yearCurrent + 1; y < year; y++) {
        d += yearDaysOf(y);
      }
      m = 1;
    }
    for (; m < month; m++) {
      d += _monthDaysOf(year, m);
    }
    return d + (day ?? _monthDaysOf(year, month));
  }
}

///
///
/// instance methods:
/// return bool:      [isValidDate], ...
/// return int:       [daysToDates], ...
///
///
extension _Record3Int on (int, int, int) {
  ///
  /// [isValidDate]
  /// [_comparing],
  /// [>], [<], [>=], [<=]
  ///
  bool get isValidDate => _isValidDate(this);

  bool _comparing(
    (int, int, int) other, {
    required bool Function(int, int) reduceInvalid,
    required bool Function(int, int) reduce,
    required bool Function(int, int) reduceFinal,
  }) {
    final one = this.$1;
    final oneAnother = other.$1;
    if (reduceInvalid(one, oneAnother)) return false;
    if (reduce(one, oneAnother)) return true;
    final two = this.$2;
    final twoAnother = other.$2;
    if (reduceInvalid(two, twoAnother)) return false;
    if (reduce(two, twoAnother)) return true;
    final three = this.$3;
    final threeAnother = other.$3;
    if (reduceInvalid(three, threeAnother)) return false;
    return reduceFinal(three, threeAnother);
  }

  bool operator <((int, int, int) other) => _comparing(
    other,
    reduceInvalid: _reduce_isLarger,
    reduce: _reduce_isLess,
    reduceFinal: _reduce_isLess,
  );

  // bool operator <=((int, int, int) other) => _comparing(
  //   other,
  //   reduceInvalid: _reduce_isLarger,
  //   reduce: _reduce_isLess,
  //   reduceFinal: _reduce_isLessOrEqual,
  // );

  // ///
  // /// [daysToDates]
  // ///
  // int daysToDates((int, int, int) another) {
  //   assert(
  //     _isValidDate(this) && _isValidDate(another),
  //     'invalid date: $this, $another',
  //   );
  //   final year = another.$1;
  //   final month = another.$2;
  //   final day = another.$3;
  //
  //   final yearCurrent = this.$1;
  //   assert(yearCurrent <= year);
  //   final monthCurrent = this.$2;
  //   final dayCurrent = this.$3;
  //
  //   // ==
  //   if (yearCurrent == year) {
  //     assert(monthCurrent <= month);
  //     if (monthCurrent == month) {
  //       assert(dayCurrent <= day);
  //       return day - dayCurrent;
  //     }
  //     var days = 0;
  //     for (var m = monthCurrent; m < month; m++) {
  //       days += monthDaysOf(yearCurrent, m);
  //     }
  //     return days + day - dayCurrent;
  //   }
  //
  //   // <
  //   var days = 0;
  //   for (var m = monthCurrent; m < 13; m++) {
  //     days += monthDaysOf(yearCurrent, m);
  //   }
  //   for (var y = yearCurrent + 1; y < year; y++) {
  //     days += 365;
  //     if (_isYearLeapYear(y)) days++;
  //   }
  //   for (var m = DateTime.january; m < month; m++) {
  //     days += monthDaysOf(year, m);
  //   }
  //   return days + day - dayCurrent;
  // }
}

// extension _IterableExtension<I> on Iterable<I> {
//   Iterable<T> mapWhere<T>(
//     bool Function(I item) predicate,
//     T Function(I mapper) mapping,
//   ) sync* {
//     for (var item in this) {
//       if (predicate(item)) yield mapping(item);
//     }
//   }
// }

extension _ConsumeIntAllExtension on void Function(int) {
  int iteratingI(int from, int limit, int arg) {
    for (var i = from; i < limit; i++, arg++) {
      this(arg);
    }
    return arg;
  }

  int iteratingJ(int from, int limit, int limitI, int arg) {
    for (var j = from; j < limit; j++) {
      for (var i = 0; i < limitI; i++, arg++) {
        this(arg);
      }
    }
    return arg;
  }

  int iteratingK(int from, int limit, int lJ, int lI, int arg) {
    for (var k = from; k < limit; k++) {
      for (var j = 0; j < lJ; j++) {
        for (var i = 0; i < lI; i++, arg++) {
          this(arg);
        }
      }
    }
    return arg;
  }

  int iteratingL(int from, int limit, int lK, int lJ, int lI, int arg) {
    for (var l = from; l < limit; l++) {
      for (var k = 0; k < lK; k++) {
        for (var j = 0; j < lJ; j++) {
          for (var i = 0; i < lI; i++, arg++) {
            this(arg);
          }
        }
      }
    }
    return arg;
  }
}
