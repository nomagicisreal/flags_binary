part of '../flags_binary.dart';

///
/// [_MSetFieldMonthsDatesScoped]
/// [_MSetBitsFieldMonthsDates]
///

///
///
///
mixin _MSetFieldMonthsDatesScoped
    implements
        _AFlagsSet<(int, int, int), (int, int, int)>,
        _AFlagsScoped<(int, int)>,
        _AField {
  ///
  /// [_firstMonthIndexedIn], [_lastIndexedMonthIn]
  ///
  (int, int)? _firstMonthIndexedIn(int year) {
    final begin = this.begin, yBegin = begin.$1;
    if (year == yBegin) return (begin.$2, 0);
    if (year < yBegin || year > end.$1) return null;
    const january = DateTime.january;
    return (january, begin.monthsToYearMonth(year, january));
  }

  (int, int)? _lastIndexedMonthIn(int year) {
    final end = this.end, begin = this.begin, yEnd = end.$1;
    if (year == yEnd) return (end.$2, _field.length - 1);
    if (year > yEnd || year < begin.$1) return null;
    final december = DateTime.december;
    return (december, begin.monthsToYearMonth(year, december));
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
    return i < 0 || i >= field.length ? null : field.bLastOf(i);
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
        firstOf = field.bFirstOf;
    for (var y = begin.$1, m = begin.$2, j = 0; j < length; j++) {
      final i = firstOf(j);
      if (i != null) return (y, m, i + 1);
      m++;
      if (m > december) {
        m = january;
        y++;
      }
    }
    return null;
  }

  @override
  (int, int, int)? firstAfter((int, int, int) index) {
    assert(index.isValidDate);
    var y = index.$1, m = index.$2;
    final begin = this.begin,
        yBegin = begin.$1,
        mBegin = begin.$2,
        field = _field,
        length = field.length,
        firstOf = field.bFirstOf;

    int j;
    if (y < yBegin || (y == yBegin && m < mBegin)) {
      y = yBegin;
      m = mBegin;
      j = 0;
      final d = firstOf(j);
      if (d != null) return (y, m, d);
    } else {
      j = y == yBegin ? m - mBegin : begin.monthsToYearMonth(y, m);
      if (j >= length) return null;
      final dAfter = index.$3;
      if (dAfter < _monthDaysOf(y, m)) {
        final i = field.bFirstOfFrom(j, dAfter - 1);
        if (i != null) return (y, m, i + 1);
      }
    }

    const january = DateTime.january, december = DateTime.december;
    while (true) {
      j++;
      if (j >= length) return null;
      m++;
      if (m > december) {
        y++;
        m = january;
      }
      final i = firstOf(j);
      if (i != null) return (y, m, i + 1);
    }
  }

  (int, int, int)? firstInYear(int y) {
    final mj = _firstMonthIndexedIn(y);
    if (mj == null) return null;
    final end = this.end,
        mLast = y == end.$1 ? end.$2 : DateTime.december,
        firstOf = _field.bFirstOf;
    for (var m = mj.$1, j = mj.$2; m <= mLast; m++, j++) {
      final i = firstOf(j);
      if (i != null) return (y, m, i + 1);
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
    const january = DateTime.january, december = DateTime.december;
    final end = this.end, field = _field, lastOf = field.bLastOf;
    for (var y = end.$1, m = end.$2, j = field.length - 1; j >= 0; j--) {
      final i = lastOf(j);
      if (i != null) return (y, m, i + 1);
      m--;
      if (m < january) {
        y--;
        m = december;
      }
    }
    return null;
  }

  @override
  (int, int, int)? lastBefore((int, int, int) index) {
    assert(index.isValidDate);
    final end = this.end,
        yEnd = end.$1,
        mEnd = end.$2,
        field = _field,
        length = field.length,
        lastOf = field.bLastOf;
    var y = index.$1, m = index.$2;

    int j;
    if (y > yEnd || (y == yEnd && m > mEnd)) {
      y = yEnd;
      m = mEnd;
      j = length - 1;
      final d = lastOf(j);
      if (d != null) return (y, m, d);
    } else {
      j = y == yEnd ? length - 1 : begin.monthsToYearMonth(y, m);
      if (j < 0) return null;
      final dBefore = index.$3;
      if (dBefore > 1) {
        final i = field.bLastOfFrom(j, dBefore - 1);
        if (i != null) return (y, m, i + 1);
      }
    }

    const january = DateTime.january, december = DateTime.december;
    while (true) {
      j++;
      if (j >= length) return null;
      m++;
      if (m > december) {
        y++;
        m = january;
      }
      final i = lastOf(j);
      if (i != null) return (y, m, i + 1);
    }
  }

  (int, int, int)? lastInYear(int y) {
    final mj = _lastIndexedMonthIn(y);
    if (mj == null) return null;
    final begin = this.begin,
        mFirst = y == begin.$1 ? begin.$2 : DateTime.january,
        lastOf = _field.bLastOf;
    for (var m = mj.$1, j = mj.$2; m >= mFirst; m--, j++) {
      final i = lastOf(j);
      if (i != null) return (y, m, i + 1);
    }
    return null;
  }

  ///
  /// [availableYears]
  /// [availableMonths]
  /// [availablesForward]
  ///
  Iterable<int> get availableYears sync* {
    const january = DateTime.january, december = DateTime.december;
    final begin = this.begin,
        field = _field,
        length = field.length,
        firstOf = field.bFirstOf;
    var y = begin.$1, m = begin.$2, j = 0;

    while (true) {
      if (firstOf(j) != null) {
        yield y;
        j += 13 - m;
        if (j >= length) return;
        y++;
        m = january;
        continue;
      }
      j++;
      if (j >= length) return;
      m++;
      if (m > december) {
        y++;
        m = january;
      }
    }
  }

  Iterable<(int, int)> availableMonths([int? year]) sync* {
    //
    if (year == null) {
      const january = DateTime.january, december = DateTime.december;
      final begin = this.begin,
          field = _field,
          length = field.length,
          firstOf = field.bFirstOf;
      var y = begin.$1, m = begin.$2, j = 0;
      while (true) {
        if (firstOf(j) != null) yield (y, m);
        j++;
        if (j >= length) return;
        m++;
        if (m > december) {
          y++;
          m = january;
        }
      }
    }

    // year != null
    final mj = _firstMonthIndexedIn(year);
    if (mj == null) return;
    final firstOf = _field.bFirstOf;
    final end = this.end, mLast = year == end.$1 ? end.$2 : DateTime.december;
    for (var m = mj.$1, j = mj.$2; m <= mLast; m++, j++) {
      if (firstOf(j) != null) yield (year, m);
    }
  }

  @override
  Iterable<(int, int, int)> get availablesForward sync* {
    const january = DateTime.january, december = DateTime.december;
    final begin = this.begin,
        field = _field,
        length = field.length,
        datesOf = field.datesForwardOf;
    var y = begin.$1, m = begin.$2, j = 0;
    while (true) {
      yield* datesOf(j, y, m);
      j++;
      if (j >= length) return;
      m++;
      if (m > december) {
        y++;
        m = january;
      }
    }
  }

  @override
  Iterable<(int, int, int)> get availablesBackward sync* {
    const january = DateTime.january, december = DateTime.december;
    final begin = this.begin,
        field = _field,
        length = field.length,
        datesOf = field.datesBackwardOf;
    var y = begin.$1, m = begin.$2, j = length - 1;
    while (true) {
      yield* datesOf(j, y, m);
      j--;
      if (j < 0) return;
      m--;
      if (m < january) {
        y--;
        m = december;
      }
    }
  }

  ///
  /// [availableDatesInYearMonth]
  /// [availableDatesInYear]
  /// [availableDatesInMonth]
  ///
  Iterable<(int, int, int)> availableDatesInYearMonth(int year, int month) =>
      _field.datesForwardOf(begin.monthsToYearMonth(year, month), year, month);

  Iterable<(int, int, int)> availableDatesInYear(int y) sync* {
    final mj = _firstMonthIndexedIn(y);
    if (mj == null) return;
    final end = this.end,
        mLast = y == end.$1 ? end.$2 : DateTime.december,
        datesOf = _field.datesForwardOf;
    for (var m = mj.$1, j = mj.$2; m <= mLast; m++, j++) {
      yield* datesOf(j, y, m);
    }
  }

  Iterable<(int, int, int)> availableDatesInMonth(int month) sync* {
    assert(_isValidMonth(month));
    final yBegin = begin.$1,
        yEnd = end.$1,
        field = _field,
        datesOf = field.datesForwardOf;
    if (yBegin == yEnd) {
      yield* datesOf(month - begin.$2, yBegin, month);
      return;
    }
    var y = yBegin, j = month - begin.$2;
    if (j < 0) {
      y++;
      j += 12;
    }
    for (final length = field.length; j < length; y++, j += 12) {
      yield* datesOf(j, y, month);
    }
  }

  ///
  /// [availablesRecent]
  /// [availablesLatest]
  ///

  ///
  /// 1. [from] == null && [to] == null: take [availablesForward]
  /// 2. date [from] && date [to]: take available dates [from] ~ [to]
  /// 3. date [from] && [to] == null: take available dates [from] ~ [last]
  /// 4. [from] == null && date [to]: take available dates [first] ~ [to]
  ///
  @override
  Iterable<(int, int, int)> availablesRecent([
    (int, int, int)? from,
    (int, int, int)? to,
  ]) sync* {
    assert(() {
      if (from == null || to == null) return true;
      return _isValidDate(from) && _isValidDate(to) && from < to;
    }(), 'invalid scope: ($from, $to)');

    final isFromFirst = from == null, isToLast = to == null;
    if (isFromFirst && isToLast) {
      yield* availablesForward;
      return;
    }

    final end = this.end,
        begin = this.begin,
        yEnd = end.$1,
        yBegin = begin.$1,
        mEnd = end.$2,
        mBegin = begin.$2,
        indexOf = begin.monthsToYearMonth;

    // ensure from
    final int dFrom;
    int y, m, j;
    if (isFromFirst) {
      y = yBegin;
      m = mBegin;
      dFrom = 1;
      j = 0;
    } else {
      y = from.$1;
      if (y > yEnd) return;
      final mFrom = from.$2;
      if (y == yEnd && mFrom > mEnd) return;
      m = y == yBegin ? math.max(mBegin, mFrom) : mFrom;
      dFrom = from.$3;
      j = indexOf(y, m);
    }

    // ensure to
    final int yTo, mTo, dTo;
    if (isToLast) {
      yTo = yEnd;
      mTo = mEnd;
      dTo = _monthDaysOf(yEnd, mEnd);
    } else {
      yTo = to.$1;
      if (yTo < yBegin) return;
      final toM = to.$2;
      if (y == yBegin && toM < mBegin) return;
      mTo = y == yEnd ? math.min(mEnd, toM) : toM;
      dTo = to.$3;
    }

    final field = _field, datesOfBetween = field.datesForwardOfBetween;

    // inside a month
    if (y == yTo && m == mTo) {
      yield* datesOfBetween(j, y, m, dTo, dFrom);
      return;
    }

    // first month -> intermediate month -> last month
    const january = DateTime.january, december = DateTime.december;
    final datesOf = field.datesForwardOf, jLast = indexOf(yTo, mTo);
    assert(j < jLast);
    yield* datesOf(j, y, m, dFrom);
    while (true) {
      j++;
      m++;
      if (m > december) {
        y++;
        m = january;
      }
      if (j == jLast) break;
      yield* datesOf(j, y, m);
    }
    yield* datesOfBetween(j, y, m, dTo);
  }

  ///
  /// 1. [from] == null && [to] == null: take [availablesForward]
  /// 2. date [from] && date [to]: take available dates [from] ~ [to]
  /// 3. date [from] && [to] == null: take available dates [from] ~ [first]
  /// 4. [from] == null && date [to]: take available dates [last] ~ [to]
  ///
  @override
  Iterable<(int, int, int)> availablesLatest([
    (int, int, int)? from,
    (int, int, int)? to,
  ]) sync* {
    assert(() {
      if (from == null || to == null) return true;
      return _isValidDate(from) && _isValidDate(to) && to < from;
    }(), 'invalid scope: ($from, $to)');

    final isFromLast = from == null, isToFirst = to == null;
    if (isFromLast && isToFirst) {
      yield* availablesBackward;
      return;
    }

    final end = this.end,
        begin = this.begin,
        yEnd = end.$1,
        yBegin = begin.$1,
        mEnd = end.$2,
        mBegin = begin.$2,
        field = _field,
        indexOf = begin.monthsToYearMonth;

    // ensure from
    final int dFrom;
    int y, m, j;
    if (isFromLast) {
      y = yEnd;
      m = mEnd;
      dFrom = _monthDaysOf(yEnd, mEnd);
      j = field.length - 1;
    } else {
      y = from.$1;
      if (y < yBegin) return;
      final mFrom = from.$2;
      if (y == yBegin && mFrom < mBegin) return;
      m = y == yEnd ? math.min(mEnd, mFrom) : mFrom;
      dFrom = from.$3;
      j = indexOf(y, m);
    }

    // ensure to
    final int yTo, mTo, dTo;
    if (isToFirst) {
      yTo = yBegin;
      mTo = mBegin;
      dTo = 1;
    } else {
      yTo = to.$1;
      if (yTo > yEnd) return;
      final toM = to.$2;
      if (y == yEnd && toM > mEnd) return;
      mTo = y == yBegin ? math.max(mBegin, toM) : toM;
      dTo = to.$3;
    }

    final datesOf = field.datesBackwardOf;

    // inside a month
    if (y == yTo && m == mTo) {
      yield* datesOf(j, y, m, dFrom, dTo);
      return;
    }

    // last month -> intermediate month -> first month
    const january = DateTime.january, december = DateTime.december;
    final jLast = indexOf(yTo, mTo);
    assert(j > jLast);
    yield* datesOf(j, y, m, dFrom);
    while (true) {
      j--;
      m--;
      if (m < january) {
        y--;
        m = december;
      }
      if (j == jLast) break;
      yield* datesOf(j, y, m);
    }
    yield* datesOf(j, y, m, dTo);
  }
}

mixin _MSetBitsFieldMonthsDates on _MBitsFieldMonthsDates
    implements _AFieldSet<(int, int, int), (int, int, int)> {
  @override
  void includesSub((int, int, int) from, [(int, int, int)? last]) =>
      _sub(_bSet, from, last);

  @override
  void excludesSub((int, int, int) from, [(int, int, int)? last]) =>
      _sub(_bClear, from, last);

  void _sub(
    void Function(int, int, int) consume,
    (int, int, int) begin,
    (int, int, int)? limit,
  );
}
