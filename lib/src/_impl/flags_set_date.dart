part of '../../flags_binary.dart';

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
  @override
  void shift(int count, [(int, int, int)? from, (int, int, int)? to]) {
    assert(() {
      if (from == null) return to == null || _isValidDate(to);
      if (_isInvalidDate(from)) return false;
      return to == null || (_isValidDate(to) && from <= to);
    }());
    if (count == 0) return;

    //
    final field = _field,
        last = field.length - 1,
        begin = this.begin,
        indexOf = begin.monthsToYearMonth;
    final int yFrom, mFrom, yTo, mTo, iFrom, iTo, jFrom, jTo;
    if (from == null) {
      yFrom = begin.$1;
      mFrom = begin.$2;
      jFrom = 0;
      iFrom = 0;
    } else {
      yFrom = from.$1;
      mFrom = from.$2;
      final j = indexOf(yFrom, mFrom);
      if (j > last) return;
      jFrom = math.max(0, j);
      iFrom = from.$3 - 1;
    }
    if (to == null) {
      final end = this.end;
      yTo = end.$1;
      mTo = end.$2;
      jTo = last;
      iTo = _monthDaysOf(yTo, mTo) - 1;
    } else {
      yTo = to.$1;
      mTo = to.$2;
      final j = indexOf(yTo, mTo);
      if (j < 0) return;
      jTo = math.min(last, j);
      iTo = to.$3 - 1;
    }

    // throw UnimplementedError();

    //
    const january = 1, december = 12;
    if (count > 0) {
      int j = jTo,
          i = iTo,
          m = mTo,
          y = yTo,
          iSource = i - count,
          jSource = jTo,
          ySource = yTo,
          mSource = mTo,
          source = field[jSource];

      // todo: find first 1

      //
      void findDestinationMonth() {
        j--;
        if (--m < january) {
          y--;
          m = december;
        }
        i = _monthDaysOf(y, m) - 1;
      }

      bool findSourceMonth() {
        if (--jSource < 0) return false;
        if (--mSource < january) {
          ySource--;
          mSource = december;
        }
        source = field[jSource];

        while (source == 0) {
          if (--m < january) {
            y--;
            m = december;
          }
          final days = _monthDaysOf(y, m),
              iLast = days - _monthDaysOf(ySource, mSource) + 1 + i;

          // skip days of current month
          var mask = 1 << i--;
          while (i >= 0) {
            mask |= 1 << i--;
          }
          field[j--] &= ~mask;

          // skip days of previous month
          i = days - 1;
          mask = 1 << i--;
          while (i >= iLast) {
            mask |= 1 << i--;
          }
          field[j] &= ~mask;

          if (--jSource < 0) return false;
          if (--mSource < january) {
            ySource--;
            mSource = december;
          }
          source = field[jSource];
        }
        iSource = _monthDaysOf(ySource, mSource) - 1;
        return true;
      }

      void resetRemain() {
        while (i >= 0) {
          field[j] &= ~(1 << i--);
        }
        while (j > 0) {
          field[--j] = 0;
        }
      }

      bool shiftThenNoSource() {
        print('($ySource, $mSource, ${iSource + 1}) -> ($y, $m, ${i + 1})');
        if (source >> iSource & 1 == 1) {
          field[j] |= 1 << i--;
        } else {
          field[j] &= ~(1 << i--);
        }
        if (--iSource >= 0) return false;
        if (findSourceMonth()) {
          return false;
        }
        resetRemain();
        return true;
      }

      while (iSource < 0) {
        print('shift over month');
        if (findSourceMonth()) {
          if (iSource >= 0) break;
          continue;
        }
        return;
      }

      for (; j > jFrom; findDestinationMonth()) {
        while (i >= 0) {
          if (shiftThenNoSource()) return;
        }
      }
      while (i >= iFrom) {
        if (shiftThenNoSource()) return;
      }
      return;
    }

    throw UnimplementedError();
  }

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
    return i < 0 || i >= field.length ? null : field.iFirstOf(i);
  }

  int? lastInMonth(int year, int month) {
    assert(_isValidMonth(month));
    final field = _field, i = begin.monthsToYearMonth(year, month);
    return i < 0 || i >= field.length ? null : field.iLastOf(i);
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
        firstOf = field.iFirstOf;
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
        firstOf = field.iFirstOf;

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
        final i = field.iFirstOfFrom(j, dAfter - 1);
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
        firstOf = _field.iFirstOf;
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
    final end = this.end, field = _field, lastOf = field.iLastOf;
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
        lastOf = field.iLastOf;
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
        final i = field.iLastOfFrom(j, dBefore - 1);
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
        lastOf = _field.iLastOf;
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
        firstOf = field.iFirstOf;
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
          firstOf = field.iFirstOf;
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
    final firstOf = _field.iFirstOf;
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
      return _isValidDate(from) && _isValidDate(to) && from <= to;
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
    final int bFrom;
    int y, m, j;
    if (isFromLast) {
      y = yEnd;
      m = mEnd;
      bFrom = _monthDaysOf(yEnd, mEnd) - 1;
      j = field.length - 1;
    } else {
      y = from.$1;
      if (y < yBegin) return;
      final mFrom = from.$2;
      if (y == yBegin && mFrom < mBegin) return;
      m = y == yEnd ? math.min(mEnd, mFrom) : mFrom;
      bFrom = from.$3 - 1;
      j = indexOf(y, m);
    }

    // ensure to
    final int yTo, mTo, bTo;
    if (isToFirst) {
      yTo = yBegin;
      mTo = mBegin;
      bTo = 0;
    } else {
      yTo = to.$1;
      if (yTo > yEnd) return;
      final toM = to.$2;
      if (y == yEnd && toM > mEnd) return;
      mTo = y == yBegin ? math.max(mBegin, toM) : toM;
      bTo = to.$3 - 1;
    }

    final datesOfBetween = field.datesBackwardOfBetween;

    // inside a month
    if (y == yTo && m == mTo) {
      yield* datesOfBetween(j, y, m, bFrom, bTo);
      return;
    }

    // last month -> intermediate month -> first month
    const january = DateTime.january, december = DateTime.december;
    final jLast = indexOf(yTo, mTo), datesOf = field.datesBackwardOf;
    assert(j > jLast);
    yield* datesOfBetween(j, y, m, bFrom);
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
    yield* datesOf(j, y, m, bTo);
  }
}

mixin _MSetBitsFieldMonthsDates on _MFlagsContainerScopedDate<bool>
    implements _AFieldSet<(int, int, int), (int, int, int)> {
  static void _bSet(TypedDataList<int> field, int j, int i) =>
      field[j] |= 1 << i;

  static void _bClear(TypedDataList<int> field, int j, int i) =>
      field[j] &= ~(1 << i);

  @override
  void includesSub((int, int, int) from, [(int, int, int)? to]) =>
      _sub(_bSet, from, to);

  @override
  void excludesSub((int, int, int) from, [(int, int, int)? to]) =>
      _sub(_bClear, from, to);

  void _sub(
    void Function(TypedDataList<int>, int, int) consume,
    (int, int, int) from,
    (int, int, int)? to,
  ) {
    assert(validateIndex(from));
    assert(to == null || (validateIndex(to) && from <= to));

    final yFrom = from.$1, yTo = to?.$1 ?? end.$1;
    assert(yFrom <= yTo);

    final mFrom = from.$2,
        dFrom = from.$3,
        mTo = to?.$2 ?? end.$2,
        dTo = to?.$3 ?? _monthDaysOf(yTo, mTo),
        field = _field,
        jFrom = begin.monthsToYearMonth(yFrom, mFrom);

    // ==
    if (yFrom == yTo) {
      assert(mFrom <= mTo);

      // ==
      if (mFrom == mTo) {
        assert(dFrom <= dTo);
        for (var i = dFrom - 1; i < dTo; i++) {
          consume(field, jFrom, i);
        }
        return;
      }

      // <
      final daysOf = _monthDaysOf, dLast = daysOf(yFrom, mFrom);
      for (var i = dFrom - 1; i < dLast; i++) {
        consume(field, jFrom, i);
      }
      var j = jFrom + 1;
      for (var m = mFrom + 1; m < mTo; m++, j++) {
        final dLast = daysOf(yFrom, m);
        for (var i = 0; i < dLast; i++) {
          consume(field, j, i);
        }
      }
      for (var i = 0; i < dTo; i++) {
        consume(field, j, i);
      }
      return;
    }

    // <
    const january = DateTime.january, december = DateTime.december;
    final daysOf = _monthDaysOf, dLastFrom = daysOf(yFrom, mFrom);
    for (var i = dFrom - 1; i < dLastFrom; i++) {
      consume(field, jFrom, i);
    }
    var j = jFrom + 1;
    for (var m = mFrom + 1; m <= december; m++, j++) {
      final dLast = daysOf(yFrom, m);
      for (var i = 0; i < dLast; i++) {
        consume(field, j, i);
      }
    }
    for (var k = yFrom + 1; k < yTo; k++) {
      for (var m = january; m <= december; m++, j++) {
        final dLast = daysOf(k, m);
        for (var i = 0; i < dLast; i++) {
          consume(field, j, i);
        }
      }
    }
    for (var m = january; m < mTo; m++, j++) {
      final dLast = daysOf(yTo, m);
      for (var i = 0; i < dLast; i++) {
        consume(field, j, i);
      }
    }
    final dLastTo = daysOf(yTo, mTo);
    for (var i = 0; i < dLastTo; i++) {
      consume(field, j, i);
    }
  }
}
