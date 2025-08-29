part of '../flags_binary.dart';

///
///
///
/// [_MSetField]
/// [_MSetFieldIndexable]
/// [_MSetFieldMonthsDatesScoped]
/// [_MSetFieldBits]
/// [_MSetFieldBitsMonthsDates]
/// [_MSetSlot]
///
///
///

///
///
///
mixin _MSetField implements _AField, _AFieldIdentical, _AFlagsSet<int> {
  @override
  int? get first => _field.pFirst(_sizeEach);

  @override
  int? get last => _field.pLast(_sizeEach);
}

mixin _MSetFieldIndexable<T>
    implements _AField, _AFieldIdentical, _AFlagsSet<T> {
  @override
  T? get first => _field.pFirst(_sizeEach).nullOrMap(_indexOf);

  @override
  T? get last => _field.pLast(_sizeEach).nullOrMap(_indexOf);

  T _indexOf(int position);
}

mixin _MSetFieldMonthsDatesScoped
    implements _AFlagsSet<(int, int, int)>, _AFlagsScoped<(int, int)>, _AField {
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
  /// [firstInYear]
  /// [firstAfter]
  ///
  @override
  (int, int, int)? get first {
    final begin = this.begin, field = _field, length = field.length;
    for (var y = begin.$1, m = begin.$2, i = 0; i < length; i++) {
      final d = field.bFirstOf(i);
      if (d != null) return (y, m, d);
      m++;
      if (m > 12) {
        m = 1;
        y++;
      }
    }
    return null;
  }

  (int, int, int)? firstInYear(int year) {
    final mi = _firstMonthIndexedOf(year);
    if (mi == null) return null;
    final field = _field,
        end = this.end,
        mLimit = year == end.$1 ? end.$2 + 1 : 13;
    for (var m = mi.$1, i = mi.$2; m < mLimit; m++, i++) {
      final d = field.bFirstOf(i);
      if (d != null) return (year, m, d);
    }
    return null;
  }

  (int, int, int)? firstAfter((int, int, int) date) {
    assert(date.isValidDate);
    final yDate = date.$1,
        mDate = date.$2,
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

    final dDate = date.$3;
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

  ///
  /// [last]
  /// [lastInYear]
  /// [lastBefore]
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

  (int, int, int)? lastInYear(int year) {
    final mi = _lastIndexedMonthOf(year);
    if (mi == null) return null;
    final field = _field, mLimit = year == begin.$1 ? begin.$2 - 1 : 0;
    for (var m = mi.$1, i = mi.$2; m > mLimit; m--, i++) {
      final d = field.bLastOf(i, _monthDaysOf(year, m));
      if (d != null) return (year, m, d);
    }
    return null;
  }

  (int, int, int)? lastBefore((int, int, int) date) {
    assert(date.isValidDate);
    final yDate = date.$1,
        mDate = date.$2,
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

    final dDate = date.$3;
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
    final field = _field, mi = _firstMonthIndexedOf(year);
    if (mi == null) return;
    final mLimit = year == end.$1 ? end.$2 + 1 : 13;
    for (var m = mi.$1, i = mi.$2; m < mLimit; m++, i++) {
      if (field.bFirstOf(i) != null) yield (year, m);
    }
  }

  Iterable<(int, int)> availableMonths([int? year]) =>
      year == null ? _availableMonths : _availableMonthsIn(year);

  ///
  /// [_availableDates]
  /// [_availableDatesInYearMonth]
  /// [_availableDatesInYear]
  /// [_availableDatesInMonth]
  /// [availableDates]
  ///
  Iterable<(int, int, int)> get _availableDates sync* {
    final field = _field, max = field.length - 1;
    var y = begin.$1, m = begin.$2, i = 0;
    while (true) {
      yield* field.bsMappedOf(i, (d) => (y, m, d));
      i++;
      if (i > max) return;
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
    final field = _field, i = begin.monthsToYearMonth(year, month);
    if (i < 0 || i >= field.length) return;
    yield* field.bsMappedOf(i, (d) => (year, month, d));
  }

  Iterable<(int, int, int)> _availableDatesInYear(int year) sync* {
    final mi = _firstMonthIndexedOf(year);
    if (mi == null) return;
    final field = _field, mLimit = year == end.$1 ? end.$2 + 1 : 13;
    for (var m = mi.$1, i = mi.$2; m < mLimit; m++, i++) {
      yield* field.bsMappedOf(i, (d) => (year, m, d));
    }
  }

  Iterable<(int, int, int)> _availableDatesInMonth(int month) sync* {
    assert(_isValidMonth(month));
    final field = _field, yBegin = begin.$1, yEnd = end.$1;
    if (yBegin == yEnd) {
      assert(month >= begin.$2 && month <= end.$2);
      yield* field.bsMappedOf(month - begin.$2, (d) => (yBegin, month, d));
      return;
    }
    var y = yBegin, i = month - begin.$2;
    if (i < 0) {
      y++;
      i += 12;
    }
    for (final length = field.length; i < length; y++, i += 12) {
      yield* field.bsMappedOf(i, (d) => (y, month, d));
    }
  }

  Iterable<(int, int, int)> availableDates([int? year, int? month]) =>
      year == null
      ? month == null
            ? _availableDates
            : _availableDatesInMonth(month)
      : month == null
      ? _availableDatesInYear(year)
      : _availableDatesInYearMonth(year, month);

  ///
  /// [_availableDatesFromMonth]
  /// [availableDatesFrom]
  ///
  Iterable<(int, int, int)> _availableDatesFromMonth(
    int y,
    int m,
    int i,
  ) sync* {
    assert(i > 0);
    final field = _field, length = field.length;
    while (true) {
      yield* field.bsMappedOf(i, (p) => (y, m, p));
      i++;
      if (i >= length) return;
      m++;
      if (m > 12) {
        y++;
        m = 1;
      }
    }
  }

  Iterable<(int, int, int)> availableDatesFrom(
    int y, [
    int m = 0,
    int d = 0,
    bool inclusive = true,
  ]) sync* {
    final end = this.end, yEnd = end.$1;
    if (y > yEnd) return;

    // dates from year
    if (m == 0) {
      assert(d == 0);
      if (!inclusive) y++;
      for (; y <= yEnd; y++) {
        yield* _availableDatesInYear(y);
      }
      return;
    }

    // dates from year month
    assert(_isValidMonth(m));
    final mEnd = end.$2;
    if (y == yEnd && m > mEnd) return;
    if (d == 0) {
      if (!inclusive) {
        m++;
        if (m > 12) {
          y++;
          if (y > yEnd) return;
          m = 1;
        }
        if (y == yEnd && m > mEnd) return;
      }
      var i = begin.monthsToYearMonth(y, m);
      if (i <= 0) {
        yield* _availableDates;
        return;
      }
      yield* _availableDatesFromMonth(y, m, i);
      return;
    }

    // dates from date
    assert(_isValidDay(y, m, d));
    if (y == yEnd && m == mEnd && d > _monthDaysOf(y, m)) return;
    if (!inclusive) {
      d++;
      if (d > _monthDaysOf(y, m)) {
        m++;
        if (m > 12) {
          y++;
          if (y > yEnd) return;
          m = 1;
        }
        if (y == yEnd && m > mEnd) return;
        d = 1;
      }
      if (y == yEnd && m == mEnd && d > _monthDaysOf(y, m)) return;
    }
    var i = begin.monthsToYearMonth(y, m);
    if (i <= 0) {
      yield* _availableDates;
      return;
    }
    final field = _field;
    yield* field.bsMappedOf(i, (p) => (y, m, p), d);
    i++;
    if (i >= field.length) return;
    m++;
    if (m > 12) {
      y++;
      m = 1;
    }
    yield* _availableDatesFromMonth(y, m, i);
  }

  ///
  /// [_availableDatesToMonth]
  /// [availableDatesTo]
  ///
  Iterable<(int, int, int)> _availableDatesToMonth(int y, int m, int i) sync* {
    final field = _field;
    assert(i < field.length);
    while (true) {
      yield* field.bsMappedOf(i, (p) => (y, m, p));
      i--;
      if (i < 0) return;
      m--;
      if (m < 1) {
        y--;
        m = 12;
      }
    }
  }

  Iterable<(int, int, int)> availableDatesTo(
    int y, [
    int m = 0,
    int d = 0,
    bool inclusive = true,
  ]) sync* {
    final begin = this.begin, yBegin = begin.$1;
    if (y < yBegin) return;

    // dates to year
    if (m == 0) {
      assert(d == 0);
      if (!inclusive) y--;
      for (; y > -1; y--) {
        yield* _availableDatesInYear(y);
      }
      return;
    }

    // dates to year month
    assert(_isValidMonth(m));
    final mBegin = begin.$2;
    if (y == yBegin && m < mBegin) return;
    if (d == 0) {
      if (!inclusive) {
        m--;
        if (m < 1) {
          y--;
          if (y < yBegin) return;
          m = 12;
        }
        if (y == yBegin && m < mBegin) return;
      }
      var i = begin.monthsToYearMonth(y, m);
      if (i >= _field.length - 1) {
        yield* _availableDates;
        return;
      }
      yield* _availableDatesToMonth(y, m, i);

      return;
    }

    // dates to date
    assert(_isValidDay(y, m, d));
    if (y == yBegin && m == mBegin && d < _monthDaysOf(y, m)) return;
    if (!inclusive) {
      d--;
      if (d < 1) {
        m--;
        if (m < 1) {
          y--;
          if (y < yBegin) return;
          m = 1;
        }
        if (y == yBegin && m < mBegin) return;
        d = _monthDaysOf(y, m);
      }
      if (y == yBegin && m == mBegin && d < _monthDaysOf(y, m)) return;
    }
    var i = begin.monthsToYearMonth(y, m);
    final field = _field;
    if (i >= field.length - 1) {
      yield* _availableDates;
      return;
    }
    yield* field.bsMappedOfTo(i, d, (p) => (y, m, p));
    i--;
    if (i < 0) return;
    m--;
    if (m < 1) {
      y--;
      m = 12;
    }
    yield* _availableDatesToMonth(y, m, i);
  }

  ///
  /// [availableDatesSub]
  ///
  Iterable<(int, int, int)> availableDatesSub(
    int yFrom,
    int yTo,
    int mFrom,
    int mTo,
    int dFrom,
    int dTo, [
    bool includeFrom = true,
    bool includeTo = true,
  ]) sync* {
    assert(_isValidDay(yFrom, mFrom, dFrom) && _isValidDay(yTo, mTo, dTo));
    assert(yFrom <= yTo);
    final begin = this.begin,
        end = this.end,
        yBegin = begin.$1,
        mBegin = begin.$2,
        yEnd = end.$1,
        mEnd = end.$2;
    if (yFrom > yEnd || yTo < yBegin) return;
    if (yFrom == yTo) {
      if (yBegin == yEnd && (mFrom > mEnd || mTo > mBegin)) return;
      if (mFrom == mTo) {
        if (!includeFrom) dFrom++;
        if (!includeTo) dTo--;
        assert(dFrom > 0 && dTo <= _monthDaysOf(yFrom, mFrom) && dFrom <= dTo);
        yield* _field.bsMappedOfTo(
          begin.monthsToYearMonth(yFrom, mFrom),
          dTo,
          (d) => (yFrom, mFrom, d),
          dFrom,
        );
        return;
      }
    }

    //
    if (!includeFrom) {
      dFrom++;
      if (dFrom > _monthDaysOf(yFrom, mFrom)) {
        mFrom++;
        if (mFrom > 12) {
          yFrom++;
          if (yFrom > yEnd || yFrom > yTo) return;
          mFrom = 1;
        }
        if ((yFrom == yEnd && mFrom > mEnd) || (yFrom == yTo && mFrom > mTo)) {
          return;
        }
        dFrom = 1;
      }
    }
    if (!includeTo) {
      dTo--;
      if (dTo < _monthDaysOf(yTo, mTo)) {
        mTo--;
        if (mTo < 1) {
          yTo--;
          if (yTo < yBegin || yTo < yFrom) return;
          mTo = 12;
        }
        if ((yTo == yBegin && mTo < mBegin) || (yTo == yFrom && mTo < mFrom)) {
          return;
        }
        dTo = _monthDaysOf(yTo, mTo);
      }
    }

    //
    var i = begin.monthsToYearMonth(yFrom, mFrom);
    final limit = begin.monthsToYearMonth(yTo, mTo) + 1, field = _field;
    while (true) {
      yield* field.bsMappedOf(i, (d) => (yFrom, mFrom, d));
      i++;
      if (i > limit) return;
      mFrom++;
      if (mFrom > 12) {
        yFrom++;
        mFrom = 1;
      }
    }
  }
}

///
///
///
mixin _MSetFieldBits<T> on _MBitsField implements _AFieldSet<T> {
  @override
  void includesSub(T begin, [T? limit]) => _ranges(_bitSet, begin, limit);

  @override
  void excludesSub(T begin, [T? limit]) => _ranges(_bitClear, begin, limit);

  void _ranges(void Function(int) consume, T begin, T? limit);
}

mixin _MSetFieldBitsMonthsDates on _MBitsFieldMonthsDates
    implements _AFieldSet<(int, int, int)> {
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

///
///
///
mixin _MSetSlot<I, T>
    implements _ASlot<T>, _ASlotSet<I, T>, _AFlagsPositionAble<I> {
  @override
  T? get first {
    final slot = _slot;
    final length = slot.length;
    for (var i = 0; i < length; i++) {
      final s = slot[i];
      if (s != null) return s;
    }
    return null;
  }

  @override
  T? get last {
    final slot = _slot;
    final length = slot.length;
    for (var i = length - 1; i > -1; i--) {
      final s = slot[i];
      if (s != null) return s;
    }
    return null;
  }

  @override
  Iterable<T> filterOn(FieldParent field) sync* {
    final slot = _slot;
    final length = slot.length;
    final f = field._field;
    final sizeEach = field._sizeEach;
    final count = f.length;
    assert(length == sizeEach * count);
    for (var j = 0; j < count; j++) {
      final start = j * sizeEach;
      for (var i = 0, bits = f[j]; i < sizeEach; i++, bits >>= 1) {
        if (bits & 1 == 1) {
          final value = slot[start + i];
          if (value != null) yield value;
        }
      }
    }
  }

  @override
  void pasteSub(T value, I begin, [I? limit]) {
    final slot = _slot;
    final length = limit == null ? slot.length : _positionOf(limit);
    for (var i = _positionOf(begin); i < length; i++) {
      slot[i] = value;
    }
  }

  @override
  void includesFrom(Iterable<T> iterable, I begin, [bool inclusive = true]) {
    final slot = _slot;
    var i = inclusive ? _positionOf(begin) : _positionOf(begin) + 1;
    assert(i > -1 && i < slot.length);
    for (var it in iterable) {
      slot[i] = it;
      i++;
    }
  }

  @override
  void includesTo(Iterable<T> iterable, I limit, [bool inclusive = true]) {
    final slot = _slot;
    var last = inclusive ? _positionOf(limit) + 1 : _positionOf(limit);
    assert(last < slot.length);
    var i = last - iterable.length;
    assert(i > -1);
    for (var it in iterable) {
      slot[i] = it;
      i++;
    }
  }
}
