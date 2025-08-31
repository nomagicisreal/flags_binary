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
/// [_MSetBitsFieldSpatial1]
/// [_MSetBitsFieldSpatial2]
/// [_MSetBitsFieldSpatial3]
/// [_MSetBitsFieldSpatial4]
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

///
///
///
mixin _MSetBitsFieldSpatial1
    implements _MFlagsContainerSpatial1<bool>, _MSetBitsField<int> {
  @override
  void _sub(void Function(int) consume, int from, int? limit) {
    assert(validateIndex(from) && (limit == null || validateIndex(limit)));
    final l = limit ?? spatial1;
    for (; from < l; from++) {
      consume(from);
    }
  }
}

mixin _MSetBitsFieldSpatial2
    implements _MFlagsContainerSpatial2<bool>, _MSetBitsField<(int, int)> {
  @override
  void _sub(void Function(int) consume, (int, int) from, (int, int)? limit) {
    assert(validateIndex(from) && (limit == null || validateIndex(limit)));
    final spatial2 = this.spatial2,
        end = limit ?? (spatial1 - 1, spatial2 - 1),
        jEnd = end.$1,
        iEnd = end.$2;
    var jFrom = from.$1, iFrom = from.$2, index = jFrom * spatial2 + iFrom;

    if (jFrom < jEnd) {
      index = consume.iteratingI(iFrom, spatial2, index);
      index = consume.iteratingJ(jFrom + 1, jEnd, spatial2, index);
      iFrom = 0;
    }

    for (; iFrom <= iEnd; iFrom++, index++) {
      consume(index);
    }
  }
}

mixin _MSetBitsFieldSpatial3
    implements _MFlagsContainerSpatial3<bool>, _MSetBitsField<(int, int, int)> {
  @override
  void _sub(
    void Function(int) consume,
    (int, int, int) from,
    (int, int, int)? limit,
  ) {
    assert(validateIndex(from) && (limit == null || validateIndex(limit)));
    final spatial2 = this.spatial2,
        spatial3 = this.spatial3,
        end = limit ?? (spatial1 - 1, spatial2 - 1, spatial3 - 1),
        kEnd = end.$1,
        jEnd = end.$2,
        iEnd = end.$3;
    var kFrom = from.$1,
        jFrom = from.$2,
        iFrom = from.$3,
        index = (kFrom * spatial2 + jFrom) * spatial3 + iFrom;

    if (kFrom < kEnd) {
      index = consume.iteratingI(iFrom, spatial3, index);
      index = consume.iteratingJ(jFrom + 1, spatial2, spatial3, index);
      index = consume.iteratingK(kFrom + 1, kEnd, spatial2, spatial3, index);
      jFrom = 0;
      iFrom = 0;
    }

    if (jFrom < jEnd) {
      index = consume.iteratingI(iFrom, spatial3, index);
      index = consume.iteratingJ(jFrom + 1, spatial2, spatial3, index);
      iFrom = 0;
    }

    for (; iFrom <= iEnd; iFrom++, index++) {
      consume(index);
    }
  }
}

mixin _MSetBitsFieldSpatial4
    implements
        _MFlagsContainerSpatial4<bool>,
        _MSetBitsField<(int, int, int, int)> {
  @override
  void _sub(
    void Function(int) consume,
    (int, int, int, int) from,
    (int, int, int, int)? limit,
  ) {
    assert(validateIndex(from) && (limit == null || validateIndex(limit)));
    final s2 = spatial2,
        s3 = spatial3,
        s4 = spatial4,
        end = limit ?? (spatial1 - 1, s2 - 1, s3 - 1, s4 - 1),
        lEnd = end.$1,
        kEnd = end.$2,
        jEnd = end.$3,
        iEnd = end.$4;
    var lFrom = from.$1,
        kFrom = from.$2,
        jFrom = from.$3,
        iFrom = from.$4,
        index = ((lFrom * s2 + kFrom) * s3 + jFrom) * s4 + iFrom;

    if (lFrom < lEnd) {
      index = consume.iteratingI(iFrom, s4, index);
      index = consume.iteratingJ(jFrom + 1, s3, s4, index);
      index = consume.iteratingK(kFrom + 1, s2, s3, s4, index);
      index = consume.iteratingL(lFrom + 1, lEnd, s2, s3, s4, index);
      kFrom = 0;
      jFrom = 0;
      iFrom = 0;
    }

    if (kFrom < kEnd) {
      index = consume.iteratingI(iFrom, s4, index);
      index = consume.iteratingJ(jFrom + 1, s3, s4, index);
      index = consume.iteratingK(kFrom + 1, kEnd, s3, s4, index);
      jFrom = 0;
      iFrom = 0;
    }

    if (jFrom < jEnd) {
      index = consume.iteratingI(iFrom, s4, index);
      index = consume.iteratingJ(jFrom + 1, jEnd, s4, index);
      iFrom = 0;
    }

    for (; iFrom <= iEnd; iFrom++, index++) {
      consume(index);
    }
  }
}
