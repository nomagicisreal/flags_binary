part of '../../flags_binary.dart';

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
  Iterable<int> get availablesForward => _field.bitsForward(_sizeEach);

  @override
  Iterable<int> get availablesBackward => _field.bitsBackward(_sizeEach);

  @override
  Iterable<int> availablesRecent([int from = 1, int? to]) {
    assert(() {
      if (from == 1 || to == null) return true;
      return from <= to && to <= _field.length * _sizeEach;
    }(), 'invalid scope: ($from, $to)');

    final shift = _shift, mask = _mask, field = _field, sizeEach = _sizeEach;
    final int jTo, iTo;
    if (to == null) {
      jTo = field.length - 1;
      iTo = sizeEach - 1;
    } else {
      jTo = --to >> shift;
      iTo = to & mask;
    }
    return field.bitsForwardBetween(
      sizeEach,
      --from >> shift,
      from & mask,
      jTo,
      iTo,
    );
  }

  @override
  Iterable<int> availablesLatest([int? from, int to = 1]) {
    assert(() {
      if (from == null || to == 0) return true;
      return to <= from && from <= _field.length * _sizeEach;
    }(), 'invalid scope: ($from, $to)');

    final shift = _shift,
        mask = _mask,
        field = _field,
        sizeEach = _sizeEach,
        bFrom = (from ?? field.length * sizeEach) - 1;
    return field.bitsBackwardBetween(
      sizeEach,
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
      .bFirstAfter(_bOf(index), _shift, _mask, _sizeEach)
      .nullOrMap(_indexOf);

  @override
  T? lastBefore(T index) => _field
      .bLastBefore(_bOf(index), _shift, _mask, _sizeEach)
      .nullOrMap(_indexOf);

  @override
  Iterable<T> get availablesForward =>
      _field.bitsForwardMap(_indexOf, _sizeEach);

  @override
  Iterable<T> get availablesBackward =>
      _field.bitsBackwardMap(_indexOf, _sizeEach);

  @override
  Iterable<T> availablesRecent([T? from, T? to]) {
    assert(() {
      if (from == null || to == null) return true;
      final bFrom = _bOf(from);
      if (bFrom < 0) return false;
      final pTo = _bOf(to);
      return bFrom <= pTo && pTo <= _field.length * _sizeEach;
    }());

    final shift = _shift,
        mask = _mask,
        field = _field,
        sizeEach = _sizeEach,
        bFrom = from == null ? 0 : _bOf(from);
    final int jT, iT;
    if (to == null) {
      jT = field.length - 1;
      iT = sizeEach - 1;
    } else {
      final pTo = _bOf(to);
      jT = pTo >> shift;
      iT = pTo & mask;
    }
    return field.bitsForwardMapBetween(
      _indexOf,
      sizeEach,
      bFrom >> shift,
      bFrom & mask,
      jT,
      iT,
    );
  }

  @override
  Iterable<T> availablesLatest([T? from, T? to]) {
    assert(() {
      if (from == null || to == null) return true;
      final pFrom = _bOf(from);
      if (pFrom < 0) return false;
      final pTo = _bOf(to);
      return pTo >= 0 && pTo <= pFrom && pFrom <= _field.length * _sizeEach;
    }());
    final shift = _shift,
        mask = _mask,
        field = _field,
        length = field.length,
        sizeEach = _sizeEach,
        bFrom = from == null ? length * sizeEach - 1 : _bOf(from);
    final int jTo, iTo;
    if (to == null) {
      jTo = length - 1;
      iTo = sizeEach - 1;
    } else {
      final pTo = _bOf(to);
      jTo = pTo >> shift;
      iTo = pTo & mask;
    }
    return field.bitsBackwardMapBetween(
      _indexOf,
      sizeEach,
      bFrom >> shift,
      bFrom & mask,
      jTo,
      iTo,
    );
  }
}

///
///
///
mixin _MSetSlot<I, T>
    implements _ASlot<T>, _ASlotSet<I, T>, _AFlagsBitsAble<I> {
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
    final slot = _slot, length = slot.length, b = _bOf(index);
    if (b >= length - 1) return null;
    for (var i = math.max(0, b + 1); i < length; i++) {
      final s = slot[i];
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
    final slot = _slot, last = slot.length - 1, b = _bOf(index);
    if (b <= 1) return null;
    for (var i = math.min(last, b - 1); i >= 0; i--) {
      final s = slot[i];
      if (s != null) return s;
    }
    return null;
  }

  @override
  Iterable<T> get availablesForward => _slot.forwardFilterNotNull;

  @override
  Iterable<T> get availablesBackward => _slot.backwardFilterNotNull;

  @override
  Iterable<T> availablesRecent([I? from, I? to]) sync* {
    assert(from == null || to == null || _bOf(from) <= _bOf(to));

    final slot = _slot, last = slot.length - 1;
    final int iTo;
    if (to == null) {
      iTo = last;
    } else {
      final bLast = _bOf(to);
      if (bLast < 0) return;
      iTo = math.min(bLast, last);
    }
    int i;
    if (from == null) {
      i = 0;
    } else {
      final bFrom = _bOf(from);
      if (bFrom > last) return;
      i = math.max(0, bFrom);
    }

    for (; i <= iTo; i++) {
      final s = slot[i];
      if (s != null) yield s;
    }
  }

  @override
  Iterable<T> availablesLatest([I? from, I? to]) sync* {
    assert(from == null || to == null || _bOf(from) >= _bOf(to));

    final slot = _slot, last = slot.length - 1;
    final int iTo;
    if (to == null) {
      iTo = 0;
    } else {
      final bTo = _bOf(to);
      if (bTo > last) return;
      iTo = math.max(0, bTo);
    }

    var i = from == null ? last : _bOf(from);
    if (from == null) {
      i = 0;
    } else {
      final bFrom = _bOf(from);
      if (bFrom < 0) return;
      i = math.min(last, bFrom);
    }

    for (; i >= iTo; i--) {
      final s = slot[i];
      if (s != null) yield s;
    }
  }

  ///
  ///
  ///
  @override
  Iterable<T> filterOn(FieldParent field) sync* {
    final slot = _slot,
        length = slot.length,
        filter = field._field,
        sizeEach = field._sizeEach,
        count = filter.length;
    assert(length == sizeEach * count);
    for (var j = 0; j < count; j++) {
      final start = j * sizeEach;
      for (var i = 0, bits = filter[j]; i < sizeEach; i++, bits >>= 1) {
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
    final length = limit == null ? slot.length : _bOf(limit);
    for (var i = _bOf(begin); i < length; i++) {
      slot[i] = value;
    }
  }

  @override
  void includesFrom(Iterable<T> iterable, I begin, [bool inclusive = true]) {
    final slot = _slot;
    var i = inclusive ? _bOf(begin): _bOf(begin) + 1;
    assert(i >= 0 && i < slot.length);
    for (var it in iterable) {
      slot[i] = it;
      i++;
    }
  }

  @override
  void includesTo(Iterable<T> iterable, I last, [bool inclusive = true]) {
    final slot = _slot, bLast = inclusive ? _bOf(last) : _bOf(last) - 1;
    assert(bLast < slot.length);
    var i = bLast - iterable.length + 1;
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
  void includesSub(T from, [T? to]) => _sub(_bSet, from, to);

  @override
  void excludesSub(T from, [T? to]) => _sub(_bClear, from, to);

  void _sub(void Function(int) consume, T from, T? to);
}

///
///
///
mixin _MSetBitsFieldSpatial1
    implements _MFlagsContainerSpatial1<bool>, _MSetBitsField<int> {
  @override
  void _sub(void Function(int) consume, int from, int? to) {
    assert(validateIndex(from));
    assert(to == null || validateIndex(to) && from <= to);

    final bLimit = to ?? spatial1;
    for (var b = from - 1; b < bLimit; b++) {
      consume(b);
    }
  }
}

mixin _MSetBitsFieldSpatial2
    implements _MFlagsContainerSpatial2<bool>, _MSetBitsField<(int, int)> {
  @override
  void _sub(void Function(int) consume, (int, int) from, (int, int)? to) {
    assert(validateIndex(from));
    assert(to == null || validateIndex(to) && from <= to);

    final spatial2 = this.spatial2,
        fJ = from.$1,
        fI = from.$2,
        lJ = to?.$1 ?? spatial1,
        lI = to?.$2 ?? spatial2;
    var bI = fI - 1, index = (fJ - 1) * spatial2 + bI;

    if (fJ < lJ) {
      index = consume.iteratingI(bI, spatial2, index);
      index = consume.iteratingJ(fJ, lJ - 1, spatial2, index);
      bI = 0;
    }

    for (; bI < lI; bI++, index++) {
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
    (int, int, int)? to,
  ) {
    assert(validateIndex(from));
    assert(to == null || validateIndex(to) && from <= to);

    final spatial2 = this.spatial2,
        spatial3 = this.spatial3,
        fK = from.$1,
        fJ = from.$2,
        fI = from.$3,
        lK = to?.$1 ?? spatial1,
        lJ = to?.$2 ?? spatial2,
        lI = to?.$3 ?? spatial3;
    var bJ = fJ - 1,
        bI = fI - 1,
        index = ((fK - 1) * spatial2 + bJ) * spatial3 + bI;

    if (fK < lK) {
      index = consume.iteratingI(bI, spatial3, index);
      index = consume.iteratingJ(bJ, spatial2, spatial3, index);
      index = consume.iteratingK(fK, lK - 1, spatial2, spatial3, index);
      bJ = 0;
      bI = 0;
    }

    if (fJ < lJ) {
      index = consume.iteratingI(bI, spatial3, index);
      index = consume.iteratingJ(fJ, lJ - 1, spatial3, index);
      bI = 0;
    }

    for (; bI < lI; bI++, index++) {
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
    (int, int, int, int)? to,
  ) {
    assert(validateIndex(from));
    assert(to == null || validateIndex(to) && from <= to);

    final s2 = spatial2,
        s3 = spatial3,
        s4 = spatial4,
        fL = from.$1,
        fK = from.$2,
        fJ = from.$3,
        fI = from.$4,
        lL = to?.$1 ?? spatial1,
        lK = to?.$2 ?? spatial2,
        lJ = to?.$3 ?? spatial3,
        lI = to?.$4 ?? spatial4;
    var bK = fK - 1,
        bJ = fJ - 1,
        bI = fI - 1,
        index = (((fL - 1) * s2 + bK) * s3 + bJ) * s4 + bI;

    if (fL < lL) {
      index = consume.iteratingI(bI, s4, index);
      index = consume.iteratingJ(bJ, s3, s4, index);
      index = consume.iteratingK(bK, s2, s3, s4, index);
      index = consume.iteratingL(fL, lL - 1, s2, s3, s4, index);
      bK = 0;
      bJ = 0;
      bI = 0;
    }

    if (fK < lK) {
      index = consume.iteratingI(bI, s4, index);
      index = consume.iteratingJ(bJ, s3, s4, index);
      index = consume.iteratingK(fK, lK - 1, s3, s4, index);
      bJ = 0;
      bI = 0;
    }

    if (fJ < lJ) {
      index = consume.iteratingI(bI, s4, index);
      index = consume.iteratingJ(fJ, lJ - 1, s4, index);
      bI = 0;
    }

    for (; bI < lI; bI++, index++) {
      consume(index);
    }
  }
}
