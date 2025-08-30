part of '../flags_binary.dart';

///
///
///
/// [_MSetField]
/// [_MSetFieldIndexable]
/// [_MSetFieldMonthsDatesScoped]
/// [_MSetSlot]
/// [_MSetBitsField]
/// [_MSetBitsFieldMonthsDates]
///
///
///

///
///
///
mixin _MSetField
    implements _AFlagsSet<int, int>, _AField, _AFieldIdentical, _AFieldBits {
  @override
  int? get first => _field.pFirst(_sizeEach);

  @override
  int? get last => _field.pLast(_sizeEach);

  @override
  int? firstAfter(int index) =>
      _field.pFirstFrom(index >> _shift, index & _mask, _sizeEach);

  @override
  int? lastBefore(int index) =>
      _field.pLastTo(index >> _shift, index & _mask, _sizeEach);

  @override
  Iterable<int> get availables => _field.pAvailable(_sizeEach);

  @override
  Iterable<int> availablesFrom(int index, [bool inclusive = true]) =>
      _field.pAvailableFrom(index, _sizeEach, inclusive);

  @override
  Iterable<int> availablesTo(int index, [bool inclusive = true]) =>
      _field.pAvailableTo(index, _sizeEach, inclusive);

  @override
  Iterable<int> availablesSub(
    int from,
    int to, [
    bool includeFrom = true,
    bool includeTo = true,
  ]) => _field.pAvailableSub(from, to, _sizeEach, includeFrom, includeTo);
}

mixin _MSetFieldIndexable<T> on _MFieldContainerPositionAble<T>
    implements _AField, _AFieldIdentical, _AFlagsSet<T, T> {
  T _indexOf(int position);

  @override
  T? get first => _field.pFirst(_sizeEach).nullOrMap(_indexOf);

  @override
  T? get last => _field.pLast(_sizeEach).nullOrMap(_indexOf);

  @override
  T? firstAfter(T index) => _field
      .pFirstAfter(_positionOf(index), _shift, _mask, _sizeEach)
      .nullOrMap(_indexOf);

  @override
  T? lastBefore(T index) => _field
      .pLastBefore(_positionOf(index), _shift, _mask, _sizeEach)
      .nullOrMap(_indexOf);

  @override
  Iterable<T> get availables => _field.mapPAvailable(_sizeEach, _indexOf);

  @override
  Iterable<T> availablesFrom(T index, [bool inclusive = true]) => _field
      .mapPAvailableFrom(_positionOf(index), _sizeEach, _indexOf, inclusive);

  @override
  Iterable<T> availablesTo(T index, [bool inclusive = true]) => _field
      .mapPAvailableTo(_positionOf(index), _sizeEach, _indexOf, inclusive);

  @override
  Iterable<T> availablesSub(
    T from,
    T to, [
    bool includeFrom = true,
    bool includeTo = true,
  ]) => _field.mapPAvailableSub(
    _positionOf(from),
    _positionOf(to),
    _sizeEach,
    _indexOf,
    includeFrom,
    includeTo,
  );
}

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
    final mi = _lastIndexedMonthOf(year);
    if (mi == null) return null;
    final field = _field, mLimit = year == begin.$1 ? begin.$2 - 1 : 0;
    for (var m = mi.$1, i = mi.$2; m > mLimit; m--, i++) {
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
  /// [availables]
  /// [_availableDatesInYearMonth]
  /// [_availableDatesInYear]
  /// [_availableDatesInMonth]
  /// [availablesOn]
  ///
  @override
  Iterable<(int, int, int)> get availables sync* {
    final field = _field, max = field.length - 1;
    var y = begin.$1, m = begin.$2, i = 0;
    while (true) {
      yield* field.bitsMappedOf(i, (d) => (y, m, d));
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
    yield* field.bitsMappedOf(i, (d) => (year, month, d));
  }

  Iterable<(int, int, int)> _availableDatesInYear(int year) sync* {
    final mi = _firstMonthIndexedOf(year);
    if (mi == null) return;
    final field = _field, mLimit = year == end.$1 ? end.$2 + 1 : 13;
    for (var m = mi.$1, i = mi.$2; m < mLimit; m++, i++) {
      yield* field.bitsMappedOf(i, (d) => (year, m, d));
    }
  }

  Iterable<(int, int, int)> _availableDatesInMonth(int month) sync* {
    assert(_isValidMonth(month));
    final field = _field, yBegin = begin.$1, yEnd = end.$1;
    if (yBegin == yEnd) {
      assert(month >= begin.$2 && month <= end.$2);
      yield* field.bitsMappedOf(month - begin.$2, (d) => (yBegin, month, d));
      return;
    }
    var y = yBegin, i = month - begin.$2;
    if (i < 0) {
      y++;
      i += 12;
    }
    for (final length = field.length; i < length; y++, i += 12) {
      yield* field.bitsMappedOf(i, (d) => (y, month, d));
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
  /// [availablesFrom]
  /// [availablesTo]
  /// [availablesSub]
  ///
  @override
  Iterable<(int, int, int)> availablesFrom(
    (int, int, int) index, [
    bool inclusive = true,
  ]) sync* {
    final end = this.end, yEnd = end.$1;
    var y = index.$1;
    if (y > yEnd) return;

    const int january = 1;
    var m = index.$2, d = index.$3, i = 0;
    assert(m >= 0 && d >= 0);
    final hasDay = d != 0;

    // dates to year
    if (m == 0) {
      assert(!hasDay);
      if (!inclusive) y++;
      m = january;
    } else {
      const int december = 12;
      assert(_isValidMonth(m));

      // dates to date
      if (hasDay) {
        assert(_isValidDay(y, m, d));
        if (!inclusive) {
          d++;
          if (d > _monthDaysOf(y, m)) {
            i++;
            m++;
            if (m > december) {
              y++;
              m = january;
            }
            d = 1;
          }
        }

        // dates to year month
      } else {
        if (!inclusive) {
          i++;
          m++;
          if (m > december) {
            y++;
            m = january;
          }
        }
      }
    }

    //
    i += begin.monthsToYearMonth(y, m);
    final field = _field, length = field.length;
    if (i >= length) return;
    if (i < 0) {
      yield* availables;
      return;
    }

    (int, int, int) mapper(int position) => (y, m, position);
    const int december = 12;
    final mapping = field.bitsMappedOfLimit, max = length - 1;
    yield* mapping(i, _monthDaysOf(y, m) + 1, mapper, hasDay ? d : 1);
    while (true) {
      i++;
      if (i > max) return;
      m++;
      if (m > december) {
        y++;
        m = january;
      }
      yield* mapping(i, _monthDaysOf(y, m) + 1, mapper);
    }
  }

  @override
  Iterable<(int, int, int)> availablesTo(
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
    var i = 0;

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
            i--;
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
          i--;
          m--;
          if (m < january) {
            y--;
            m = december;
          }
        }
      }
    }

    //
    i += begin.monthsToYearMonth(y, m);
    if (i < 0) return;
    final field = _field;
    if (i >= field.length) {
      yield* availables;
      return;
    }

    (int, int, int) mapper(int position) => (y, m, position);
    const int january = 1;
    final mapping = field.bitsMappedOfLimit;
    yield* hasDay
        ? mapping(i, d + 1, mapper)
        : mapping(i, _monthDaysOf(y, m) + 1, mapper);
    while (true) {
      i--;
      if (i < 0) return;
      m--;
      if (m < january) {
        y--;
        m = december;
      }
      yield* mapping(i, _monthDaysOf(y, m) + 1, mapper);
    }
  }

  @override
  Iterable<(int, int, int)> availablesSub(
    (int, int, int) from,
    (int, int, int) to, [
    bool includeFrom = true,
    bool includeTo = true,
  ]) sync* {
    final begin = this.begin, end = this.end, yBegin = begin.$1, yEnd = end.$1;
    var y = from.$1, yTo = to.$1;
    assert(_isValidDate(from) && _isValidDate(to) && y <= yTo);
    if (y > yEnd || yTo < yBegin) return;

    final ySame = y == yTo, mBegin = end.$1, mEnd = end.$2;
    var m = from.$2, mTo = to.$2;
    if (ySame && yBegin == yEnd && (m > mEnd || mTo > mBegin)) return;

    //
    (int, int, int) mapper(int position) => (y, m, position);
    final indexing = begin.monthsToYearMonth,
        mapping = _field.bitsMappedOfLimit;
    var d = from.$3, dLimit = to.$3;
    if (ySame) {
      assert(m <= mTo);
      if (m == mTo) {
        if (!includeFrom) d++;
        if (includeTo) dLimit++;
        assert(d > 0 && dLimit <= _monthDaysOf(y, m) && d <= dLimit);
        yield* mapping(indexing(y, m), dLimit, mapper, d);
        return;
      }
    }

    //
    const int january = 1, december = 12;
    if (!includeFrom) {
      d++;
      if (d > _monthDaysOf(y, m)) {
        m++;
        if (m > december) {
          y++;
          assert(y <= yTo);
          if (y > yEnd) return;
          m = january;
        }
        assert(y != yTo || m <= mTo, 'exclusive from $from after to: $to');
        if (y == yEnd && m > mEnd) return;
        d = 1;
      }
    }
    if (includeTo) {
      dLimit++;
    } else if (dLimit == 1) {
      mTo--;
      if (mTo < january) {
        yTo--;
        assert(yTo >= y);
        if (yTo < yBegin) return;
        mTo = december;
      }
      assert(yTo != y || mTo >= m, 'exclusive to: $to after from: $from');
      if (yTo == yBegin && mTo < mBegin) return;
      dLimit = _monthDaysOf(yTo, mTo) + 1;
    }

    // first month -> intermediate month -> last month
    final last = indexing(yTo, mTo);
    var i = indexing(y, m);
    yield* mapping(i, _monthDaysOf(y, m) + 1, mapper, d);
    while (true) {
      i++;
      m++;
      if (m > december) {
        y++;
        m = january;
      }
      if (i == last) break;
      yield* mapping(i, _monthDaysOf(y, m) + 1, mapper);
    }
    yield* mapping(i, dLimit, mapper);
  }
}

///
///
///
mixin _MSetSlot<I, T>
    implements _ASlot<T>, _ASlotSet<I, T>, _AFlagsPositionAble<I> {
  @override
  T? get first {
    final slot = _slot, length = slot.length;
    for (var i = 0; i < length; i++) {
      final s = slot[i];
      if (s != null) return s;
    }
    return null;
  }

  @override
  T? firstAfter(I index) {
    final slot = _slot, length = slot.length;
    var p = _positionOf(index);
    if (p > length - 2) return null;
    for (p = p < 0 ? 0 : p + 1; p < length; p++) {
      final s = slot[p];
      if (s != null) return s;
    }
    return null;
  }

  @override
  T? get last {
    final slot = _slot;
    for (var i = slot.length - 1; i > -1; i--) {
      final s = slot[i];
      if (s != null) return s;
    }
    return null;
  }

  @override
  T? lastBefore(I index) {
    final slot = _slot, last = slot.length - 1;
    var p = _positionOf(index);
    if (p < 2) return null;
    if (p > last) return slot[last];
    for (p = p > last ? last : p - 1; p > -1; p--) {
      final s = slot[p];
      if (s != null) return s;
    }
    return null;
  }

  @override
  Iterable<T> get availables => _slot.filterNotNull;

  @override
  Iterable<T> availablesFrom(I index, [bool inclusive = true]) sync* {
    final slot = _slot, length = slot.length;
    var p = inclusive ? _positionOf(index) : _positionOf(index) + 1;
    if (p > length - 1) return;
    if (p < 0) p = 0;
    for (; p < length; p++) {
      final s = slot[p];
      if (s != null) yield s;
    }
  }

  @override
  Iterable<T> availablesTo(I index, [bool inclusive = true]) sync* {
    final slot = _slot, last = slot.length - 1;
    var p = inclusive ? _positionOf(index) : _positionOf(index) - 1;
    if (p < 0) return;
    if (p > last) p = last;
    for (; p > -1; p--) {
      final s = slot[p];
      if (s != null) yield s;
    }
  }

  @override
  Iterable<T> availablesSub(
    I from,
    I to, [
    bool includeFrom = true,
    bool includeTo = true,
  ]) sync* {
    final slot = _slot, length = slot.length, last = length - 1;
    var p = includeFrom ? _positionOf(from) : _positionOf(from) + 1;
    if (p > last) return;
    final pLimit = includeTo ? _positionOf(to) + 1 : _positionOf(to);
    if (pLimit < 1) return;
    if (p < 0) p = 0;
    final limit = pLimit > length ? length : pLimit;
    for (; p < limit; p++) {
      final s = slot[p];
      if (s != null) yield s;
    }
  }

  ///
  ///
  ///
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

///
///
///
mixin _MSetBitsField<T> on _MBitsField implements _AFieldSet<T, T> {
  @override
  void includesSub(T begin, [T? limit]) => _sub(_bitSet, begin, limit);

  @override
  void excludesSub(T begin, [T? limit]) => _sub(_bitClear, begin, limit);

  void _sub(void Function(int) consume, T from, T? limit);
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
