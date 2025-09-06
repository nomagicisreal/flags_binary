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
  /// [availables]
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
  Iterable<(int, int, int)> get availables sync* {
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
  /// 1. [from] == null && [to] == null: take [availables]
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

    if (from == null && to == null) {
      yield* availables;
      return;
    }

    const january = DateTime.january, december = DateTime.december;
    final end = this.end,
        begin = this.begin,
        yEnd = end.$1,
        yBegin = begin.$1,
        mEnd = end.$2,
        mBegin = begin.$2;

    // ensure from
    final int dFrom;
    int y, m;
    if (from == null) {
      y = yBegin;
      m = mBegin;
      dFrom = 1;
    } else {
      y = from.$1;
      if (y > yEnd) return;
      final mFrom = from.$2;
      if (y == yEnd && mFrom > mEnd) return;
      m = y == yBegin ? math.max(mBegin, mFrom) : mFrom;
      dFrom = from.$3;
    }

    // ensure to
    final int toY, toM, dTo;
    if (to == null) {
      toY = yEnd;
      toM = mEnd;
      dTo = _monthDaysOf(yEnd, mEnd);
    } else {
      toY = to.$1;
      if (toY < yBegin) return;
      final mTo = to.$2;
      if (y == yBegin && mTo < mBegin) return;
      toM = y == yEnd ? math.min(mEnd, mTo) : mTo;
      dTo = to.$3;
    }

    final field = _field,
        datesOfFixed = field.datesForwardOfBetween,
        indexOf = begin.monthsToYearMonth;

    // inside a month
    if (y == toY && m == toM) {
      yield* datesOfFixed(indexOf(y, m), y, m, dTo, dFrom);
      return;
    }

    // first month -> intermediate month -> last month
    final datesOf = field.datesForwardOf, iLast = indexOf(toY, toM);
    var j = indexOf(y, m);
    yield* datesOf(j, y, m, dFrom);
    while (true) {
      j++;
      m++;
      if (m > december) {
        y++;
        m = january;
      }
      if (j == iLast) break;
      yield* datesOf(j, y, m);
    }
    yield* datesOfFixed(j, y, m, dTo);
  }

  ///
  /// 1. [from] == null && [to] == null: take [availables]
  /// 2. date [from] && date [to]: take available dates [from] ~ [to]
  /// 3. date [from] && [to] == null: take available dates [from] ~ [last]
  /// 4. [from] == null && date [to]: take available dates [first] ~ [to]
  ///
  @override
  Iterable<(int, int, int)> availablesLatest(
    (int, int, int) from, [
    (int, int, int)? to,
  ]) sync* {
    throw UnimplementedError();
  }
}

mixin _MSetBitsFieldMonthsDates on _MBitsFieldMonthsDates
    implements _AFieldSet<(int, int, int), (int, int, int)> {
  @override
  void includesSub((int, int, int) begin, [(int, int, int)? limit]) =>
      _sub(_pSet, begin, limit);

  @override
  void excludesSub((int, int, int) begin, [(int, int, int)? limit]) =>
      _sub(_pClear, begin, limit);

  void _sub(
    void Function(int, int, int) consume,
    (int, int, int) begin,
    (int, int, int)? limit,
  );
}
