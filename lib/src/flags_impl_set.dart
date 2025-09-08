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
  int? get first => _field.bFirst(_sizeEach);

  @override
  int? get last => _field.bLast(_sizeEach);

  @override
  int? firstAfter(int index) =>
      _field.bFirstAfter(index, _shift, _mask, _sizeEach);

  @override
  int? lastBefore(int index) =>
      _field.bLastBefore(index, _shift, _mask, _sizeEach);

  @override
  Iterable<int> get availables => _field.bitsForward(_sizeEach);

  @override
  Iterable<int> availablesRecent(int from, [int? to]) {
    assert(from > 0);
    assert(to == null || (from <= to && to <= _field.length * _sizeEach));
    final int shift = _shift, mask = _mask, jTo, iTo;
    if (to == null) {
      jTo = _field.length - 1;
      iTo = _sizeEach - 1;
    } else {
      jTo = --to >> shift;
      iTo = to & mask;
    }
    return _field.bitsForwardBetween(
      _sizeEach,
      --from >> shift,
      from & mask,
      jTo,
      iTo,
    );
  }

  @override
  Iterable<int> availablesLatest(int from, [int to = 0]) {
    assert(to >= 0 && to <= from && from <= _field.length * _sizeEach);
    final shift = _shift, mask = _mask, bFrom = from - 1;
    return _field.bitsBackwardBetween(
      _sizeEach,
      bFrom >> shift,
      bFrom & mask,
      to >> shift,
      to & mask,
    );
  }
}

mixin _MSetFieldIndexable<T> on _MFieldContainerPositionAble<T>
    implements _AField, _AFieldIdentical, _AFlagsSet<T, T> {
  T _indexOf(int position);

  @override
  T? get first => _field.bFirst(_sizeEach).nullOrMap(_indexOf);

  @override
  T? get last => _field.bLast(_sizeEach).nullOrMap(_indexOf);

  @override
  T? firstAfter(T index) => _field
      .bFirstAfter(_positionOf(index), _shift, _mask, _sizeEach)
      .nullOrMap(_indexOf);

  @override
  T? lastBefore(T index) => _field
      .bLastBefore(_positionOf(index), _shift, _mask, _sizeEach)
      .nullOrMap(_indexOf);

  // Iterable<T> get availables => _field.mapPAvailable(_sizeEach, _indexOf);
  @override
  Iterable<T> get availables => throw UnimplementedError();

  @override
  Iterable<T> availablesLatest(T from, [T? to]) {
    throw UnimplementedError();
    // final p = _positionOf(index);
    // return _field.mapPAvailableLatest(
    //   p >> _shift,
    //   p & _mask,
    //   _sizeEach,
    //   inclusive,
    //   _indexOf,
    // );
  }

  @override
  Iterable<T> availablesRecent([T? from, T? to]) {
    throw UnimplementedError();
    // final int shift = _shift, mask = _mask, jF, iF;
    // if (from == null) {
    //   jF = 0;
    //   iF = 0;
    // } else {
    //   final pFrom = _positionOf(from);
    //   jF = pFrom >> shift;
    //   iF = pFrom & mask;
    // }
    // final int? jT, iT;
    // if (to == null) {
    //   jT = null;
    //   iT = null;
    // } else {
    //   final pTo = _positionOf(to);
    //   jT = pTo >> shift;
    //   iT = pTo & mask;
    // }
    // return _field.mapPAvailableRecent(_sizeEach, jF, iF, _indexOf, jT, iT);
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
    for (var i = slot.length - 1; i >= 0; i--) {
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
    for (p = p > last ? last : p - 1; p >= 0; p--) {
      final s = slot[p];
      if (s != null) return s;
    }
    return null;
  }

  @override
  Iterable<T> get availables => _slot.filterNotNull;

  @override
  Iterable<T> availablesLatest(I from, [I? to]) sync* {
    throw UnimplementedError();
    // final slot = _slot, last = slot.length - 1;
    // var p = inclusive ? _positionOf(index) : _positionOf(index) - 1;
    // if (p < 0) return;
    // if (p > last) p = last;
    // for (; p >= 0; p--) {
    //   final s = slot[p];
    //   if (s != null) yield s;
    // }
  }

  @override
  Iterable<T> availablesRecent([I? from, I? to]) sync* {
    final slot = _slot, length = slot.length, last = length - 1;
    var p = from == null ? 0 : _positionOf(from);
    final int pLast;
    if (to == null) {
      pLast = last;
    } else {
      final pTo = _positionOf(to);
      assert(p <= pTo, 'invalid index($from, $to) -> position($p, $pTo)');
      if (pTo < 0) return;
      pLast = math.min(pTo, last);
    }
    if (p > last) return;
    if (p < 0) p = 0;
    for (; p < pLast; p++) {
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
    assert(i >= 0 && i < slot.length);
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
    assert(i >= 0);
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
  void includesSub(T start, [T? limit]) => _sub(_bSet, start, limit);

  @override
  void excludesSub(T start, [T? limit]) => _sub(_bClear, start, limit);

  void _sub(void Function(int) consume, T start, T? limit);
}

///
///
///
mixin _MSetBitsFieldSpatial1
    implements _MFlagsContainerSpatial1<bool>, _MSetBitsField<int> {
  @override
  void _sub(void Function(int) consume, int start, int? limit) {
    assert(validateIndex(start) && (limit == null || (validateIndex(limit))));
    final bLimit = limit ?? spatial1;
    for (var b = start; b < bLimit; b++) {
      consume(b);
    }
  }
}

mixin _MSetBitsFieldSpatial2
    implements _MFlagsContainerSpatial2<bool>, _MSetBitsField<(int, int)> {
  @override
  void _sub(void Function(int) consume, (int, int) start, (int, int)? limit) {
    assert(validateIndex(start) && (limit == null || validateIndex(limit)));
    final spatial2 = this.spatial2,
        end = limit ?? (spatial1, spatial2),
        jFrom = start.$1,
        jEnd = end.$1,
        iEnd = end.$2;
    var i = start.$2, index = (jFrom - 1) * spatial2 + i;

    if (jFrom < jEnd) {
      index = consume.iteratingI(i, spatial2, index);
      index = consume.iteratingJ(jFrom + 1, jEnd - 1, spatial2, index);
      i = 1;
    }

    for (; i <= iEnd; i++, index++) {
      consume(index);
    }
  }
}

mixin _MSetBitsFieldSpatial3
    implements _MFlagsContainerSpatial3<bool>, _MSetBitsField<(int, int, int)> {
  @override
  void _sub(
    void Function(int) consume,
    (int, int, int) start,
    (int, int, int)? limit,
  ) {
    assert(validateIndex(start) && (limit == null || validateIndex(limit)));
    final spatial2 = this.spatial2,
        spatial3 = this.spatial3,
        end = limit ?? (spatial1, spatial2, spatial3),
        kFrom = start.$1,
        kEnd = end.$1,
        jEnd = end.$2,
        iEnd = end.$3;
    var j = start.$2,
        i = start.$3,
        index = ((kFrom - 1) * spatial2 + j - 1) * spatial3 + i;

    if (kFrom < kEnd) {
      index = consume.iteratingI(i, spatial3, index);
      index = consume.iteratingJ(j + 1, spatial2, spatial3, index);
      index = consume.iteratingK(
        kFrom + 1,
        kEnd - 1,
        spatial2,
        spatial3,
        index,
      );
      j = 1;
      i = 1;
    }

    if (j < jEnd) {
      index = consume.iteratingI(i, spatial3, index);
      index = consume.iteratingJ(j + 1, jEnd - 1, spatial3, index);
      i = 1;
    }

    for (; i <= iEnd; i++, index++) {
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
    (int, int, int, int) start,
    (int, int, int, int)? limit,
  ) {
    assert(validateIndex(start) && (limit == null || validateIndex(limit)));
    final s2 = spatial2,
        s3 = spatial3,
        s4 = spatial4,
        end = limit ?? (spatial1, s2, s3, s4),
        lFrom = start.$1,
        lEnd = end.$1,
        kEnd = end.$2,
        jEnd = end.$3,
        iEnd = end.$4;
    var k = start.$2,
        j = start.$3,
        i = start.$4,
        index = (((lFrom - 1) * s2 + k - 1) * s3 + j - 1) * s4 + i;

    if (lFrom < lEnd) {
      index = consume.iteratingI(i, s4, index);
      index = consume.iteratingJ(j + 1, s3, s4, index);
      index = consume.iteratingK(k + 1, s2, s3, s4, index);
      index = consume.iteratingL(lFrom + 1, lEnd - 1, s2, s3, s4, index);
      k = 0;
      j = 0;
      i = 0;
    }

    if (k < kEnd) {
      index = consume.iteratingI(i, s4, index);
      index = consume.iteratingJ(j + 1, s3, s4, index);
      index = consume.iteratingK(k + 1, kEnd - 1, s3, s4, index);
      j = 0;
      i = 0;
    }

    if (j < jEnd) {
      index = consume.iteratingI(i, s4, index);
      index = consume.iteratingJ(j + 1, jEnd - 1, s4, index);
      i = 0;
    }

    for (; i <= iEnd; i++, index++) {
      consume(index);
    }
  }
}
