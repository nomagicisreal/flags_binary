part of '../flags_binary.dart';

///
/// [_MSetFieldMonthsDatesScoped]
/// [_MSetBitsFieldMonthsDates]
///
mixin _MSetFieldMonthsDatesScoped
    implements
        _AFlagsSet<(int, int, int), (int, int, int)>,
        _AFlagsScoped<(int, int)>,
        _AField {
  ///
  /// [_firstMonthIndexedOf], [_lastIndexedMonthOf]
  ///
  (int, int)? _firstMonthIndexedOf(int year) {
    final begin = this.begin, yBegin = begin.$1;
    if (year < yBegin || year > end.$1) return null;
    if (year == yBegin) return (begin.$2, 0);
    return (1, begin.monthsToYearMonth(year, 1));
  }

  (int, int)? _lastIndexedMonthOf(int year) {
    final end = this.end, begin = this.begin, yEnd = end.$1;
    if (year < begin.$1 || year > yEnd) return null;
    if (year == yEnd) return (end.$2, _field.length - 1);
    return (12, begin.monthsToYearMonth(year, 12));
  }

  ///
  /// [firstInMonth]
  /// [lastInMonth]
  ///
  int? firstInMonth(int year, int month) {
    assert(_isValidMonth(month));
    final field = _field, i = begin.monthsToYearMonth(year, month);
    return i < 0 || i >= field.length ? null : field.bFirstOf(i);
  }

  int? lastInMonth(int year, int month) {
    assert(_isValidMonth(month));
    final field = _field, i = begin.monthsToYearMonth(year, month);
    return i < 0 || i >= field.length
        ? null
        : field.bLastOf(i, _monthDaysOf(year, month));
  }

  ///
  /// [first]
  /// [firstAfter]
  /// [firstInYear]
  ///
  @override
  (int, int, int)? get first {
    const december = DateTime.december, january = DateTime.january;
    final begin = this.begin,
        field = _field,
        length = field.length,
        firstOf = field.pFirstOf;
    for (var y = begin.$1, m = begin.$2, j = 0; j < length; j++) {
      final d = firstOf(j);
      if (d != null) return (y, m, d);
      m++;
      if (m > december) {
        m = january;
        y++;
      }
    }
    return null;
  }

  // todo: implements p
  @override
  (int, int, int)? firstAfter((int, int, int) index) {
    assert(index.isValidDate);
    final yDate = index.$1,
        mDate = index.$2,
        begin = this.begin,
        field = _field,
        length = field.length;
    var i = begin.monthsToYearMonth(yDate, mDate);
    if (i < 0 || i >= length) return null;

    var y = begin.$1, m = begin.$2;
    bool nextMonth() {
      i++;
      if (i >= length) return false;
      m++;
      if (m > 12) {
        y++;
        m = 1;
      }
      return true;
    }

    final dDate = index.$3;
    int? d;
    if (dDate == _monthDaysOf(yDate, mDate)) {
      if (!nextMonth()) return null;
      d = field.bFirstOf(i);
    } else {
      d = field.bFirstOf(i, dDate + 1);
    }
    if (d != null) return (y, m, d);
    if (!nextMonth()) return null;
    do {
      d = field.bFirstOf(i);
      if (d != null) return (y, m, d);
    } while (nextMonth());
    return null;
  }

  (int, int, int)? firstInYear(int year) {
    final mj = _firstMonthIndexedOf(year);
    if (mj == null) return null;
    final field = _field,
        end = this.end,
        mLimit = year == end.$1 ? end.$2 + 1 : 13;
    for (var m = mj.$1, i = mj.$2; m < mLimit; m++, i++) {
      final d = field.bFirstOf(i);
      if (d != null) return (year, m, d);
    }
    return null;
  }

  ///
  /// [last]
  /// [lastBefore]
  /// [lastInYear]
  ///
  @override
  (int, int, int)? get last {
    final end = this.end, field = _field, daysOf = _monthDaysOf;
    for (var y = end.$1, m = end.$2, i = field.length - 1; i > -1; i--) {
      final d = field.bLastOf(i, daysOf(y, m));
      if (d != null) return (y, m, d);
      m--;
      if (m < 1) {
        y--;
        m = 12;
      }
    }
    return null;
  }

  @override
  (int, int, int)? lastBefore((int, int, int) index) {
    assert(index.isValidDate);
    final yDate = index.$1,
        mDate = index.$2,
        begin = this.begin,
        field = _field,
        length = field.length;
    var i = begin.monthsToYearMonth(yDate, mDate);
    if (i < 0 || i >= length) return null;

    final end = this.end;
    var y = end.$1, m = end.$2;
    bool nextMonth() {
      i--;
      if (i < 0) return false;
      m--;
      if (m < 0) {
        y--;
        m = 12;
      }
      return true;
    }

    final dDate = index.$3;
    int? d;
    if (dDate == 1) {
      if (!nextMonth()) return null;
      d = field.bLastOf(i, _monthDaysOf(yDate, mDate));
    } else {
      d = field.bLastOf(i, dDate - 1);
    }
    if (d != null) return (y, m, d);
    if (!nextMonth()) return null;
    do {
      d = field.bLastOf(i, _monthDaysOf(y, m));
      if (d != null) return (y, m, d);
    } while (nextMonth());
    return null;
  }

  (int, int, int)? lastInYear(int year) {
    final mj = _lastIndexedMonthOf(year);
    if (mj == null) return null;
    final field = _field, mLimit = year == begin.$1 ? begin.$2 - 1 : 0;
    for (var m = mj.$1, i = mj.$2; m > mLimit; m--, i++) {
      final d = field.bLastOf(i, _monthDaysOf(year, m));
      if (d != null) return (year, m, d);
    }
    return null;
  }

  ///
  /// [availableYears]
  ///
  Iterable<int> get availableYears sync* {
    final begin = this.begin, field = _field, max = field.length - 1;
    var y = begin.$1, m = begin.$2, i = 0;

    while (true) {
      if (field.bFirstOf(i) != null) {
        yield y;
        i += 13 - m;
        if (i > max) return;
        y++;
        m = 1;
        continue;
      }
      i++;
      if (i > max) return;
      m++;
      if (m > 12) {
        y++;
        m = 1;
      }
    }
  }

  ///
  /// [_availableMonths]
  /// [_availableMonthsIn]
  /// [availableMonths]
  ///
  Iterable<(int, int)> get _availableMonths sync* {
    final begin = this.begin, field = _field, max = field.length - 1;
    var y = begin.$1, m = begin.$2, i = 0;
    while (true) {
      if (field.bFirstOf(i) != null) yield (y, m);
      i++;
      if (i > max) return;
      m++;
      if (m > 12) {
        y++;
        m = 1;
      }
    }
  }

  Iterable<(int, int)> _availableMonthsIn(int year) sync* {
    final field = _field, mj = _firstMonthIndexedOf(year);
    if (mj == null) return;
    final mLimit = year == end.$1 ? end.$2 + 1 : 13;
    for (var m = mj.$1, i = mj.$2; m < mLimit; m++, i++) {
      if (field.bFirstOf(i) != null) yield (year, m);
    }
  }

  Iterable<(int, int)> availableMonths([int? year]) =>
      year == null ? _availableMonths : _availableMonthsIn(year);

  ///
  /// [availables]
  /// [_availableDatesInYearMonth]
  /// [_availableDatesInYear]
  /// [_availableDatesInMonth]
  /// [availablesOn]
  ///
  @override
  Iterable<(int, int, int)> get availables sync* {
    final field = _field, max = field.length - 1, mapping = field.mapBits;
    var y = begin.$1, m = begin.$2, j = 0;
    (int, int, int) indexToDate(int i) => (y, m, i + 1);
    while (true) {
      yield* mapping(indexToDate, j);
      j++;
      if (j > max) return;
      m++;
      if (m > 12) {
        y++;
        m = 1;
      }
    }
  }

  Iterable<(int, int, int)> _availableDatesInYearMonth(
    int year,
    int month,
  ) sync* {
    assert(_isValidMonth(month));
    final field = _field, j = begin.monthsToYearMonth(year, month);
    if (j < 0 || j >= field.length) return;
    yield* field.mapPs((d) => (year, month, d), j);
  }

  Iterable<(int, int, int)> _availableDatesInYear(int year) sync* {
    final mj = _firstMonthIndexedOf(year);
    if (mj == null) return;
    final field = _field, mLimit = year == end.$1 ? end.$2 + 1 : 13;
    for (var m = mj.$1, j = mj.$2; m < mLimit; m++, j++) {
      yield* field.mapPs((d) => (year, m, d), j);
    }
  }

  Iterable<(int, int, int)> _availableDatesInMonth(int month) sync* {
    assert(_isValidMonth(month));
    final field = _field, yBegin = begin.$1, yEnd = end.$1;
    if (yBegin == yEnd) {
      assert(month >= begin.$2 && month <= end.$2);
      yield* field.mapPs((d) => (yBegin, month, d), month - begin.$2);
      return;
    }
    var y = yBegin, j = month - begin.$2;
    if (j < 0) {
      y++;
      j += 12;
    }
    for (final length = field.length; j < length; y++, j += 12) {
      yield* field.mapPs((d) => (y, month, d), j);
    }
  }

  Iterable<(int, int, int)> availablesOn([int? year, int? month]) =>
      year == null
      ? month == null
            ? availables
            : _availableDatesInMonth(month)
      : month == null
      ? _availableDatesInYear(year)
      : _availableDatesInYearMonth(year, month);

  ///
  /// [availablesLatest]
  /// [availablesRecent]
  ///
  @override
  Iterable<(int, int, int)> availablesLatest(
    (int, int, int) index, [
    bool inclusive = true,
  ]) sync* {
    final begin = this.begin, yBegin = begin.$1;
    var y = index.$1;
    if (y < yBegin) return;

    const int december = 12;
    var m = index.$2, d = index.$3;
    assert(m >= 0 && d >= 0);
    final hasDay = d != 0;
    var j = 0;

    // dates to year
    if (m == 0) {
      assert(!hasDay);
      if (!inclusive) y--;
      m = december;
    } else {
      const int january = 1;
      assert(_isValidMonth(m));

      // dates to date
      if (hasDay) {
        assert(_isValidDay(y, m, d));
        if (!inclusive) {
          d--;
          if (d < 1) {
            j--;
            m--;
            if (m < january) {
              y--;
              m = december;
            }
            d = _monthDaysOf(y, m);
          }
        }

        // dates to year month
      } else {
        if (!inclusive) {
          j--;
          m--;
          if (m < january) {
            y--;
            m = december;
          }
        }
      }
    }

    //
    j += begin.monthsToYearMonth(y, m);
    if (j < 0) return;
    final field = _field;
    if (j >= field.length) {
      yield* availables;
      return;
    }

    (int, int, int) indexToDate(int i) => (y, m, i + 1);
    const int january = 1;
    final bitsFixed = field.mapBitsFixed;
    yield* hasDay
        ? bitsFixed(indexToDate, d, j)
        : bitsFixed(indexToDate, _monthDaysOf(y, m), j);
    while (true) {
      j--;
      if (j < 0) return;
      m--;
      if (m < january) {
        y--;
        m = december;
      }
      yield* bitsFixed(indexToDate, _monthDaysOf(y, m), j);
    }
  }

  ///
  ///
  /// 1. [from] == null && [to] == null: assertion failed, use [availables] instead.
  /// 2. date [from] && date [to]: take available dates [from] ~ [to]
  /// 3. date [from] && [to] == null: take available dates [from] ~ [last]
  /// 4. [from] == null && date [to]: take available dates [first] ~ [to]
  /// Notice that not only valid date can be treated as valid [from], [to],
  /// there are 2 more possible args, though invalid date, can be treated as valid [from], [to]:
  ///   1. valid month && day == 0
  ///   2. month == 0 && day == 0
  /// when [from] is case 1, day will be the first day of month, 1.
  /// when [from] is case 2, day will be the first day of [DateTime.january], 1, month is [DateTime.january], 1.
  /// when [to] is case 1, day will be the last day of provided-valid month, 1 ~ 12.
  /// when [to] is case 2, day will be the last day of [DateTime.december], 31, month is [DateTime.december], 12.
  ///
  ///
  @override
  Iterable<(int, int, int)> availablesRecent([
    (int, int, int)? from,
    (int, int, int)? to,
  ]) sync* {
    assert(() {
      if (from == null && to == null) return false;
      if (from != null) {
        final mFrom = from.$2, dFrom = from.$3;
        if (mFrom < 0 || dFrom < 0) return false;
        final mf0 = mFrom == 0;
        if (!mf0 && _isInvalidMonth(mFrom)) return false;
        final yFrom = from.$1, df0 = dFrom == 0;
        if (!df0 && (_isInvalidDay(yFrom, mFrom, dFrom) || mf0)) return false;
      }
      if (to != null) {
        final mTo = to.$2, dTo = to.$3;
        if (mTo < 0 || dTo < 0) return false;
        final mt0 = mTo == 0;
        if (!mt0 && _isInvalidMonth(mTo)) return false;
        final yTo = to.$1, dT0 = dTo == 0;
        if (!dT0 && (_isInvalidDay(yTo, mTo, dTo) || mt0)) return false;
      }
      return true;
    }(), 'invalid scope: ($from, $to)');

    const int january = DateTime.january, december = DateTime.december;
    final end = this.end,
        begin = this.begin,
        yEnd = end.$1,
        yBegin = begin.$1,
        mEnd = end.$2,
        mBegin = begin.$2;

    // ensure from
    int y, m;
    final int iFrom;
    if (from == null) {
      y = yBegin;
      m = mBegin;
      iFrom = 0;
    } else {
      y = from.$1;
      if (y > yEnd) return;
      final mFrom = from.$2;
      if (mFrom == 0) {
        m = y == yBegin ? mBegin : january;
      } else {
        if (y == yEnd && mFrom > mEnd) return;
        m = y == yBegin ? math.max(mBegin, mFrom) : mFrom;
      }
      final dFrom = from.$3;
      iFrom = (dFrom == 0 ? _monthDaysOf(y, m) : dFrom) - 1;
    }

    // ensure to
    final int toY, toM, toD;
    if (to == null) {
      toY = yEnd;
      toM = mEnd;
      toD = _monthDaysOf(yEnd, mEnd) - 1;
    } else {
      toY = to.$1;
      if (toY < yBegin) return;
      final mTo = to.$2;
      if (mTo == 0) {
        toM = y == yEnd ? mEnd : december;
      } else {
        if (y == yBegin && mTo < mBegin) return;
        toM = y == yEnd ? math.min(mEnd, mTo) : mTo;
      }
      final dTo = to.$3;
      toD = (dTo == 0 ? _monthDaysOf(y, m) : dTo) - 1;
    }

    (int, int, int) indexToDate(int i) => (y, m, i + 1);
    final bitsOf = _field.mapBitsFixed, indexOf = begin.monthsToYearMonth;

    // inside a month
    if (y == toY && m == toM) {
      yield* bitsOf(indexToDate, toD, indexOf(y, m), iFrom);
      return;
    }

    // first month -> intermediate month -> last month
    final iLast = indexOf(toY, toM);
    var j = indexOf(y, m);
    yield* bitsOf(indexToDate, _monthDaysOf(y, m), j, iFrom);
    while (true) {
      j++;
      m++;
      if (m > december) {
        y++;
        m = january;
      }
      if (j == iLast) break;
      yield* bitsOf(indexToDate, _monthDaysOf(y, m), j);
    }
    yield* bitsOf(indexToDate, toD, j);
  }
}

mixin _MSetBitsFieldMonthsDates on _MBitsFieldMonthsDates
    implements _AFieldSet<(int, int, int), (int, int, int)> {
  @override
  void includesSub((int, int, int) begin, [(int, int, int)? limit]) =>
      _sub(_bitSet, begin, limit);

  @override
  void excludesSub((int, int, int) begin, [(int, int, int)? limit]) =>
      _sub(_bitClear, begin, limit);

  void _sub(
    void Function(int, int, int) consume,
    (int, int, int) begin,
    (int, int, int)? limit,
  );
}
