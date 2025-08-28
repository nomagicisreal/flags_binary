part of '../typed_data.dart';

///
/// [_monthsDays]
///
/// [_predicator_less]
/// [_predicator_additionLess]
/// [_isYearLeapYear]
/// [monthDaysOf]
/// [_isValidYearMonthScope], [isValidMonth]
///
/// [_IntExtension]
/// [_NullableExtension]
/// [_StringBufferExtension]
/// [_Record2Int]
/// [_Record3Int]
///
///
///

///
///
///
const Map<int, int> _monthsDays = {
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
bool Function(int) _predicator_less(int a) => (v) => v < a;

bool Function(int) _predicator_additionLess(int a, int b) => (v) => a + v < b;

bool _isYearLeapYear(int year) =>
    year % 4 == 0
        ? year % 100 == 0
            ? year % 400 == 0
                ? true
                : false
            : true
        : false;

int monthDaysOf(int year, int month) =>
    month == 2
        ? _isYearLeapYear(year)
            ? 29
            : 28
        : _monthsDays[month]!;

int yearDaysOf(int year) => _isYearLeapYear(year) ? 366 : 365;

///
///
///
bool _isValidYearMonthScope((int, int) begin, (int, int) end) =>
    isValidMonth(begin.$2) && isValidMonth(end.$2) && begin < end;

bool isInvalidMonth(int month) =>
    month < DateTime.january || month > DateTime.december;

bool isValidMonth(int month) => month > 0 && month < 13;

bool isValidHour(int hour) => hour > -1 && hour < 24;

bool isInvalidHour(int hour) => hour < 0 || hour > 23;

bool isValidDay(int year, int month, int day) =>
    day > 0 && day < monthDaysOf(year, month) + 1;

bool _isValidDate((int, int, int) date) {
  final month = date.$2;
  if (isInvalidMonth(month)) return false;
  return isValidDay(date.$1, month, date.$3);
}

///
///
///
bool predicateReduce_larger(int a, int b) => a > b;

bool predicateReduce_largerOrEqual(int a, int b) => a >= b;

bool predicateReduce_less(int a, int b) => a < b;

bool predicateReduce_lessOrEqual(int a, int b) => a <= b;

bool predicateReduce_equal(int a, int b) => a == b;

///
///
///
extension _IntExtension on int {
  bool isRangeOpenUpper(num lower, num upper) => this >= lower && this < upper;
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
  }

  void writeRepeat(int n, String value) {
    for (var i = 0; i < n; i++) {
      write(value);
    }
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
    int b,
    bool Function(int, int) reduceInvalid,
    bool Function(int, int) reduce,
    bool Function(int, int) reduceFinal,
  ) {
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
    predicateReduce_larger,
    predicateReduce_less,
    predicateReduce_less,
  );

  bool largerOrEqualThan3((int, int, int) other) => _comparing(
    other.$1,
    other.$2,
    predicateReduce_less,
    predicateReduce_larger,
    predicateReduce_largerOrEqual,
  );

  bool lessOrEqualThan3((int, int, int) other) => _comparing(
    other.$1,
    other.$2,
    predicateReduce_larger,
    predicateReduce_less,
    predicateReduce_lessOrEqual,
  );

  ///
  /// [monthsToYearMonth]
  /// [daysToDate]
  /// [daysToDate]
  ///
  int monthsToYearMonth(int year, int month) {
    assert(
      _isValidYearMonthScope(this, (year, month)),
      'invalid date: $this, ($year, $month)',
    );
    final y = this.$1;
    return month - this.$2 + (year - y) * 12;
  }

  int daysToDate(int year, int month, [int? day]) {
    assert(
      _isValidYearMonthScope(this, (year, month)),
      'invalid date: $this, ($year, $month)',
    );
    assert(
      day == null || isValidDay(year, month, day),
      'invalid day: ($year, $month, $day)',
    );
    final yearCurrent = this.$1;
    var d = 0;
    var m = this.$2;
    if (yearCurrent < year) {
      for (; m < 13; m++) {
        d += monthDaysOf(yearCurrent, m);
      }
      for (var y = yearCurrent + 1; y < year; y++) {
        d += yearDaysOf(y);
      }
      m = 1;
    }
    for (; m < month; m++) {
      d += monthDaysOf(year, m);
    }
    return d + (day ?? monthDaysOf(year, month));
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
    (int, int, int) another,
    bool Function(int, int) reduceInvalid,
    bool Function(int, int) reduce,
    bool Function(int, int) reduceFinal,
  ) {
    final one = this.$1;
    final oneAnother = another.$1;
    if (reduceInvalid(one, oneAnother)) return false;
    if (reduce(one, oneAnother)) return true;
    final two = this.$2;
    final twoAnother = another.$2;
    if (reduceInvalid(two, twoAnother)) return false;
    if (reduce(two, twoAnother)) return true;
    final three = this.$3;
    final threeAnother = another.$3;
    if (reduceInvalid(three, threeAnother)) return false;
    return reduceFinal(three, threeAnother);
  }

  bool operator <((int, int, int) another) => _comparing(
    another,
    predicateReduce_larger,
    predicateReduce_less,
    predicateReduce_less,
  );

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
