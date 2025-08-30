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
mixin _MSetField
    implements _AFlagsSet<int>, _AField, _AFieldIdentical, _AFieldBits {
  @override
  int? get first => _field.pFirst(_sizeEach);

  @override
  int? get last => _field.pLast(_sizeEach);

  @override
  int? firstAfter(int flag) =>
      _field.pFirstFrom(flag >> _shift, flag & _mask, _sizeEach);

  @override
  int? lastBefore(int flag) =>
      _field.pLastTo(flag >> _shift, flag & _mask, _sizeEach);

  // @override
  // Iterable<int> get availables => _field.pAvailable(_sizeEach);

  // @override
  // Iterable<int> availablesFrom(int flag, [bool include = true]) {
  //   throw UnimplementedError();
  // }
}

mixin _MSetFieldIndexable<T> on _MFieldContainerPositionAble<T>
    implements _AField, _AFieldIdentical, _AFlagsSet<T> {
  T _indexOf(int position);

  @override
  T? get first => _field.pFirst(_sizeEach).nullOrMap(_indexOf);

  @override
  T? get last => _field.pLast(_sizeEach).nullOrMap(_indexOf);

  @override
  T? firstAfter(T flag) {
    final field = _field,
        sizeEach = _sizeEach,
        p = math.max(_positionOf(flag) + 1, 0);
    if (p >= field.length * sizeEach) return null;
    return field
        .pFirstFrom(p >> _shift, p & _mask, sizeEach)
        .nullOrMap(_indexOf);
  }

  @override
  T? lastBefore(T flag) {
    final field = _field,
        sizeEach = _sizeEach,
        p = math.min(_positionOf(flag) - 1, field.length * sizeEach - 1);
    if (p < 0) return null;
    return field.pLastTo(p >> _shift, p & _mask, sizeEach).nullOrMap(_indexOf);
  }
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
  // @override
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
  // @override
  Iterable<(int, int, int)> availablesFrom(
    (int, int, int) date, [
    bool inclusive = true,
  ]) sync* {
    final end = this.end, yEnd = end.$1;
    var y = date.$1;
    if (y > yEnd) return;

    const int january = 1;
    var m = date.$2, d = date.$3, i = 0;
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
    final mapping = field.bitsMappedOfTo, max = length - 1;
    yield* mapping(i, _monthDaysOf(y, m), mapper, hasDay ? d : 1);
    while (true) {
      i++;
      if (i > max) return;
      m++;
      if (m > december) {
        y++;
        m = january;
      }
      yield* mapping(i, _monthDaysOf(y, m), mapper);
    }
  }

  // @override
  Iterable<(int, int, int)> availablesTo(
    (int, int, int) date, [
    bool inclusive = true,
  ]) sync* {
    final begin = this.begin, yBegin = begin.$1;
    var y = date.$1;
    if (y < yBegin) return;

    const int december = 12;
    var m = date.$2, d = date.$3;
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
    final mapping = field.bitsMappedOfTo;
    yield* hasDay
        ? mapping(i, d, mapper)
        : mapping(i, _monthDaysOf(y, m), mapper);
    while (true) {
      i--;
      if (i < 0) return;
      m--;
      if (m < january) {
        y--;
        m = december;
      }
      yield* mapping(i, _monthDaysOf(y, m), mapper);
    }
  }

  // @override
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
    final indexing = begin.monthsToYearMonth, mapping = _field.bitsMappedOfTo;
    var d = from.$3, dTo = to.$3;
    if (ySame) {
      assert(m <= mTo);
      if (m == mTo) {
        if (!includeFrom) d++;
        if (!includeTo) dTo--;
        assert(d > 0 && dTo <= _monthDaysOf(y, m) && d <= dTo);
        yield* mapping(indexing(y, m), dTo, mapper, d);
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
    if (!includeTo) {
      dTo--;
      if (dTo < 1) {
        mTo--;
        if (mTo < january) {
          yTo--;
          assert(yTo >= y);
          if (yTo < yBegin) return;
          mTo = december;
        }
        assert(yTo != y || mTo >= m, 'exclusive to: $to after from: $from');
        if (yTo == yBegin && mTo < mBegin) return;
        dTo = _monthDaysOf(yTo, mTo);
      }
    }

    // first month -> intermediate month -> last month
    final last = indexing(yTo, mTo);
    var i = indexing(y, m);
    yield* mapping(i, _monthDaysOf(y, m), mapper, d);
    while (true) {
      i++;
      m++;
      if (m > december) {
        y++;
        m = january;
      }
      if (i == last) break;
      yield* mapping(i, _monthDaysOf(y, m), mapper);
    }
    yield* mapping(i, dTo, mapper);
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
    final slot = _slot, length = slot.length;
    for (var i = 0; i < length; i++) {
      final s = slot[i];
      if (s != null) return s;
    }
    return null;
  }

  @override
  T? firstAfter(T flag) {
    final slot = _slot, max = slot.length - 1;
    for (var i = 0; i < max; i++) {
      final s = slot[i];
      if (s == flag) return slot[i + 1];
    }
    return null;
  }

  @override
  T? get last {
    final slot = _slot, length = slot.length;
    for (var i = length - 1; i > -1; i--) {
      final s = slot[i];
      if (s != null) return s;
    }
    return null;
  }

  @override
  T? lastBefore(T flag) {
    final slot = _slot, length = slot.length;
    for (var i = length - 1; i > 0; i--) {
      final s = slot[i];
      if (s != null) return slot[i - 1];
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
