part of '../flags_binary.dart';

///
///
/// mixin:
/// [_MFlagsO8], [_MFlagsO16], [_MFlagsO32], [_MFlagsO64]
///
/// [_MFlagsContainerSpatial1]
/// [_MFlagsContainerSpatial2]
/// [_MFlagsContainerSpatial3]
/// [_MFlagsContainerSpatial4]
/// [_MFlagsContainerScopedDate]
/// [_MFlagsScopedDatePositionDay]
///
/// [_MBitsField]
/// [_MBitsFieldMonthsDates]
/// [_MFieldContainerPositionAble]
/// [_MFieldContainerMonthsDates]
/// [_MSlotContainerPositionAble]
///
/// [_MOperatableField]
/// [_MEquatableSlot]
///
/// concrete class:
/// [_Field8], ...
/// [_Field2D8], ...
/// [_Field3D8], ...
/// [_Field4D8], ...
/// [_FieldAB8], ...
///
///
///

///
///
///
///
mixin _MFlagsO8 implements _AFieldBits, _AFieldIdentical {
  @override
  int get _shift => TypedIntList.shift8;

  @override
  int get _mask => TypedIntList.mask8;

  @override
  int get _sizeEach => TypedIntList.sizeEach8;
}

mixin _MFlagsO16 implements _AFieldBits, _AFieldIdentical {
  @override
  int get _shift => TypedIntList.shift16;

  @override
  int get _mask => TypedIntList.mask16;

  @override
  int get _sizeEach => TypedIntList.sizeEach16;
}

mixin _MFlagsO32 implements _AFieldBits, _AFieldIdentical {
  @override
  int get _shift => TypedIntList.shift32;

  @override
  int get _mask => TypedIntList.mask32;

  @override
  int get _sizeEach => TypedIntList.sizeEach32;
}

mixin _MFlagsO64 implements _AFieldBits, _AFieldIdentical {
  @override
  int get _shift => TypedIntList.shift64;

  @override
  int get _mask => TypedIntList.mask64;

  @override
  int get _sizeEach => TypedIntList.sizeEach64;
}

///
///
///
mixin _MFlagsContainerSpatial1<T>
    implements _AFlagsContainer<int, T>, _AFlagsSpatial1 {
  @override
  bool validateIndex(int index) => index.isRangeOpenUpper(0, spatial1);
}

mixin _MFlagsContainerSpatial2<T>
    implements
        _AFlagsContainer<(int, int), T>,
        _AFlagsSpatial2,
        _AFlagsPositionAble<(int, int)> {
  @override
  bool validateIndex((int, int) index) =>
      index.$1.isRangeOpenUpper(0, spatial1) &&
      index.$2.isRangeOpenUpper(0, spatial2);

  @override
  int _positionOf((int, int) index) {
    assert(validateIndex(index));
    return index.$1 * spatial2 + index.$2;
  }
}

mixin _MFlagsContainerSpatial3<T>
    implements
        _AFlagsContainer<(int, int, int), T>,
        _AFlagsSpatial3,
        _AFlagsPositionAble<(int, int, int)> {
  @override
  bool validateIndex((int, int, int) index) =>
      index.$1.isRangeOpenUpper(0, spatial1) &&
      index.$2.isRangeOpenUpper(0, spatial2) &&
      index.$3.isRangeOpenUpper(0, spatial3);

  @override
  int _positionOf((int, int, int) index) {
    assert(validateIndex(index));
    return (index.$1 * spatial2 + index.$2) * spatial3 + index.$3;
  }
}

mixin _MFlagsContainerSpatial4<T>
    implements
        _AFlagsContainer<(int, int, int, int), T>,
        _AFlagsSpatial4,
        _AFlagsPositionAble<(int, int, int, int)> {
  @override
  bool validateIndex((int, int, int, int) index) =>
      index.$1.isRangeOpenUpper(0, spatial1) &&
      index.$2.isRangeOpenUpper(0, spatial2) &&
      index.$3.isRangeOpenUpper(0, spatial3) &&
      index.$4.isRangeOpenUpper(0, spatial4);

  @override
  int _positionOf((int, int, int, int) index) {
    assert(validateIndex(index));
    return ((index.$1 * spatial2 + index.$2) * spatial3 + index.$3) * spatial4 +
        index.$4;
  }
}

mixin _MFlagsContainerScopedDate<T>
    implements _AFlagsContainer<(int, int, int), T>, _AFlagsScoped<(int, int)> {
  @override
  bool validateIndex((int, int, int) index) =>
      index.isValidDate &&
      begin.lessOrEqualThan3(index) &&
      end.largerOrEqualThan3(index);
}

mixin _MFlagsScopedDatePositionDay
    implements _AFlagsScoped<(int, int)>, _AFlagsPositionAble<(int, int, int)> {
  @override
  int _positionOf((int, int, int) index) =>
      begin.daysToDate(index.$1, index.$2, index.$3);
}

///
///
///
///
mixin _MBitsField implements _AField, _AFieldBits {
  bool _pOn(int position) => _field.pOn(position, _shift, _mask);

  void _pSet(int position) => _field.pSet(position, _shift, _mask);

  void _pClear(int position) => _field.pClear(position, _shift, _mask);
}

mixin _MBitsFieldMonthsDates
    implements _AField, _AFieldIdentical, _AFlagsScoped<(int, int)> {
  bool _pOn(int year, int month, int day) =>
      _field[begin.monthsToYearMonth(year, month)] >> day - 1 & 1 == 1;

  void _pSet(int year, int month, int day) =>
      _field[begin.monthsToYearMonth(year, month)] |= 1 << day - 1;

  void _pClear(int year, int month, int day) =>
      _field[begin.monthsToYearMonth(year, month)] &= ~(1 << day - 1);

  @override
  int get _sizeEach => TypedIntList.sizeEach32;
}

///
///
///
mixin _MFieldContainerPositionAble<I> on _MBitsField
    implements _AFlagsContainer<I, bool>, _AFlagsPositionAble<I> {
  @override
  bool operator [](I index) {
    assert(validateIndex(index));
    return _pOn(_positionOf(index));
  }

  @override
  void operator []=(I index, bool value) {
    assert(validateIndex(index));
    value ? _pSet(_positionOf(index)) : _pClear(_positionOf(index));
  }
}

mixin _MFieldContainerMonthsDates on _MFlagsContainerScopedDate<bool>
    implements _MBitsFieldMonthsDates {
  @override
  bool operator []((int, int, int) index) {
    assert(validateIndex(index));
    return _pOn(index.$1, index.$2, index.$3);
  }

  @override
  void operator []=((int, int, int) index, bool value) {
    assert(validateIndex(index));
    value
        ? _pSet(index.$1, index.$2, index.$3)
        : _pClear(index.$1, index.$2, index.$3);
  }
}

mixin _MSlotContainerPositionAble<I, T>
    implements _AFlagsContainer<I, T?>, _AFlagsPositionAble<I>, _ASlot<T> {
  @override
  T? operator [](I index) {
    assert(validateIndex(index));
    return _slot[_positionOf(index)];
  }

  @override
  void operator []=(I index, T? value) {
    assert(validateIndex(index));
    _slot[_positionOf(index)] = value;
  }
}

///
///
///
mixin _MOperatableField<F extends FieldParent>
    implements _AField, _AFieldIdentical, _AFlagsOperatable<F> {
  @override
  bool isSizeEqual(F other) {
    if (_sizeEach != other._sizeEach) return false;
    return _field.length == other._field.length;
  }

  @override
  bool operator ==(Object other) {
    if (other is! F) return false;
    if (_sizeEach != other._sizeEach) return false;
    final fA = _field;
    final fB = other._field;
    final length = fA.length;
    if (length != fB.length) return false;
    for (var i = 0; i < length; i++) {
      if (fA[i] != fB[i]) return false;
    }
    return true;
  }

  @override
  F operator &(F other) {
    assert(isSizeEqual(other));
    final fA = _field;
    final length = fA.length;
    final result = newZero;
    final fB = other._field;
    final fR = result._field;
    for (var i = 0; i < length; i++) {
      fR[i] = fA[i] & fB[i];
    }
    return result;
  }

  @override
  F operator |(F other) {
    assert(isSizeEqual(other));
    final fA = _field;
    final length = fA.length;
    final result = newZero;
    final fB = other._field;
    final fR = result._field;
    for (var i = 0; i < length; i++) {
      fR[i] = fA[i] | fB[i];
    }
    return result;
  }

  @override
  F operator ^(F other) {
    assert(isSizeEqual(other));
    final fA = _field;
    final length = fA.length;
    final result = newZero;
    final fB = other._field;
    final fR = result._field;
    for (var i = 0; i < length; i++) {
      fR[i] = fA[i] ^ fB[i];
    }
    return result;
  }

  @override
  void setAnd(F other) {
    assert(isSizeEqual(other));
    final fA = _field;
    final fB = other._field;
    final length = fA.length;
    for (var i = 0; i < length; i++) {
      fA[i] &= fB[i];
    }
  }

  @override
  void setOr(F other) {
    assert(isSizeEqual(other));
    final fA = _field;
    final fB = other._field;
    final length = fA.length;
    for (var i = 0; i < length; i++) {
      fA[i] |= fB[i];
    }
  }

  @override
  void setXOr(F other) {
    assert(isSizeEqual(other));
    final fA = _field;
    final fB = other._field;
    final length = fA.length;
    for (var i = 0; i < length; i++) {
      fA[i] ^= fB[i];
    }
  }
}

mixin _MEquatableSlot<T, S extends SlotParent<T>>
    implements _ASlot<T>, _AFlagsEquatable<S> {
  @override
  bool isSizeEqual(S other) => _slot.length == other._slot.length;

  @override
  bool operator ==(Object other) {
    if (other is! S) return false;
    final sA = _slot;
    final sB = other._slot;
    final length = sA.length;
    if (length != sB.length) return false;
    for (var i = 0; i < length; i++) {
      if (sA[i] != sB[i]) return false;
    }
    return true;
  }
}

///
///
///
mixin _MOnFlagsIndexSub<F, I, J> on _MFieldContainerPositionAble<I>
    implements _AFlagsSpatial1, _AFlagsOn<F, J> {
  bool _validateIndexSub(J indexSub);

  I _indexMerge(int index, J indexSub);

  @override
  void includesOn(int index, Iterable<J> inclusion) {
    assert(index.isRangeOpenUpper(0, spatial1));
    for (var indexSub in inclusion) {
      assert(_validateIndexSub(indexSub));
      _pSet(_positionOf(_indexMerge(index, indexSub)));
    }
  }

  @override
  void excludesOn(int index, Iterable<J> exclusion) {
    assert(index.isRangeOpenUpper(0, spatial1));
    for (var indexSub in exclusion) {
      assert(_validateIndexSub(indexSub));
      _pClear(_positionOf(_indexMerge(index, indexSub)));
    }
  }
}

mixin _MOnFieldSpatial2 on _MOnFlagsIndexSub<Field, (int, int), int>
    implements _AFlagsSpatial2 {
  @override
  bool _validateIndexSub(int indexSub) =>
      indexSub.isRangeOpenUpper(0, spatial2);

  @override
  (int, int) _indexMerge(int index, int indexSub) => (index, indexSub);

  @override
  Field collapseOn(int index) {
    assert(index.isRangeOpenUpper(0, spatial1));
    final spatial2 = this.spatial2,
        start = index * spatial2,
        field = Field(spatial2);
    for (var i = 0; i < spatial2; i++) {
      if (_pOn(start + i)) field._pSet(i);
    }
    return field;
  }
}

mixin _MOnFieldSpatial3
    on _MOnFlagsIndexSub<Field2D, (int, int, int), (int, int)>
    implements _AFlagsSpatial3 {
  @override
  bool _validateIndexSub((int, int) indexSub) =>
      indexSub.$1.isRangeOpenUpper(0, spatial2) &&
      indexSub.$2.isRangeOpenUpper(0, spatial3);

  @override
  (int, int, int) _indexMerge(int index, (int, int) indexSub) =>
      (index, indexSub.$1, indexSub.$2);

  @override
  Field2D collapseOn(int index) {
    assert(index.isRangeOpenUpper(0, spatial1));
    final spatial2 = this.spatial2,
        spatial3 = this.spatial3,
        field = Field2D(spatial2, spatial3),
        start = index * spatial2 * spatial3;
    for (var j = 0; j < spatial2; j++) {
      final begin = j * spatial3;
      for (var i = 0; i < spatial3; i++) {
        final p = begin + i;
        if (_pOn(start + p)) field._pSet(p);
      }
    }
    return field;
  }
}

mixin _MOnFieldSpatial4
    on _MOnFlagsIndexSub<Field3D, (int, int, int, int), (int, int, int)>
    implements _AFlagsSpatial4 {
  @override
  bool _validateIndexSub((int, int, int) indexSub) =>
      indexSub.$1.isRangeOpenUpper(0, spatial2) &&
      indexSub.$2.isRangeOpenUpper(0, spatial3) &&
      indexSub.$3.isRangeOpenUpper(0, spatial4);

  @override
  (int, int, int, int) _indexMerge(int index, (int, int, int) indexSub) =>
      (index, indexSub.$1, indexSub.$2, indexSub.$3);

  @override
  Field3D collapseOn(int index) {
    assert(index.isRangeOpenUpper(0, spatial1));
    final spatial2 = this.spatial2,
        spatial3 = this.spatial3,
        spatial4 = this.spatial4,
        start = index * spatial2 * spatial3 * spatial4,
        result = Field3D(spatial2, spatial3, spatial4);
    for (var k = 0; k < spatial2; k++) {
      final b1 = k * spatial3;
      for (var j = 0; j < spatial3; j++) {
        final b2 = j * spatial4;
        for (var i = 0; i < spatial4; i++) {
          final p = b1 + b2 + i;
          if (_pOn(start + p)) result._pSet(p);
        }
      }
    }
    return result;
  }
}

///
///
///
///
///
///
class _Field8 extends Field with _MFlagsO8 {
  _Field8(int width) : super._(width, Uint8List(1));

  @override
  Field get newZero => _Field8(spatial1);
}

class _Field16 extends Field with _MFlagsO16 {
  _Field16(int width) : super._(width, Uint16List(1));

  @override
  Field get newZero => _Field16(spatial1);
}

class _Field32 extends Field with _MFlagsO32 {
  _Field32(int width, int s) : super._(width, Uint32List(s));

  @override
  Field get newZero => _Field32(spatial1, _field.length);
}

class _Field64 extends Field with _MFlagsO64 {
  _Field64(int width, int s) : super._(width, Uint64List(s));

  @override
  Field get newZero => _Field64(spatial1, _field.length);
}

//
class _Field2D8 extends Field2D with _MFlagsO8 {
  _Field2D8(int w, int h) : super._(w, h, Uint8List(1));

  @override
  Field2D get newZero => _Field2D8(spatial1, spatial2);
}

class _Field2D16 extends Field2D with _MFlagsO16 {
  _Field2D16(int w, int h) : super._(w, h, Uint16List(1));

  @override
  Field2D get newZero => _Field2D8(spatial1, spatial2);
}

class _Field2D32 extends Field2D with _MFlagsO32 {
  _Field2D32(int w, int h, int s) : super._(w, h, Uint32List(s));

  @override
  Field2D get newZero => _Field2D32(spatial1, spatial2, _field.length);
}

class _Field2D64 extends Field2D with _MFlagsO64 {
  _Field2D64(int w, int h, int s) : super._(w, h, Uint64List(s));

  @override
  Field2D get newZero => _Field2D64(spatial1, spatial2, _field.length);
}

//
class _Field3D8 extends Field3D with _MFlagsO8 {
  _Field3D8(int w, int h, int d) : super._(w, h, d, Uint8List(1));

  @override
  Field3D get newZero => _Field3D8(spatial1, spatial2, spatial3);
}

class _Field3D16 extends Field3D with _MFlagsO16 {
  _Field3D16(int w, int h, int d) : super._(w, h, d, Uint16List(1));

  @override
  Field3D get newZero => _Field3D16(spatial1, spatial2, spatial3);
}

class _Field3D32 extends Field3D with _MFlagsO32 {
  _Field3D32(int w, int h, int d, int s) : super._(w, h, d, Uint32List(s));

  @override
  Field3D get newZero =>
      _Field3D32(spatial1, spatial2, spatial3, _field.length);
}

class _Field3D64 extends Field3D with _MFlagsO64 {
  _Field3D64(int w, int h, int d, int s) : super._(w, h, d, Uint64List(s));

  @override
  Field3D get newZero =>
      _Field3D64(spatial1, spatial2, spatial3, _field.length);
}

//
class _Field4D8 extends Field4D with _MFlagsO8 {
  _Field4D8(int a, int b, int c, int d) : super._(a, b, c, d, Uint8List(1));

  @override
  Field4D get newZero => _Field4D8(spatial1, spatial2, spatial3, spatial4);
}

class _Field4D16 extends Field4D with _MFlagsO16 {
  _Field4D16(int a, int b, int c, int d) : super._(a, b, c, d, Uint16List(1));

  @override
  Field4D get newZero => _Field4D16(spatial1, spatial2, spatial3, spatial4);
}

class _Field4D32 extends Field4D with _MFlagsO32 {
  _Field4D32(int a, int b, int c, int d, int s)
    : super._(a, b, c, d, Uint32List(s));

  @override
  Field4D get newZero =>
      _Field4D32(spatial1, spatial2, spatial3, spatial4, _field.length);
}

class _Field4D64 extends Field4D with _MFlagsO64 {
  _Field4D64(int a, int b, int c, int d, int s)
    : super._(a, b, c, d, Uint64List(s));

  @override
  Field4D get newZero =>
      _Field4D64(spatial1, spatial2, spatial3, spatial4, _field.length);
}

//
class _FieldAB8 extends FieldAB with _MFlagsO8 {
  _FieldAB8.dayPer12Minute() : super._(_validate_per12m, 5, Uint8List(9));

  _FieldAB8.dayPer20Minute() : super._(_validate_per20m, 3, Uint8List(9));

  _FieldAB8.dayPerHour() : super._(_validate_perH, 1, Uint8List(3));

  _FieldAB8._(super.bValidate, super.bDivision, super._field) : super._();

  @override
  FieldAB get newZero =>
      _FieldAB8._(bValidate, bDivision, Uint8List(_field.length));

  static bool _validate_perH(int minute) => minute == 0;

  static bool _validate_per20m(int minute) =>
      minute == 0 || minute == 20 || minute == 40;

  static bool _validate_per12m(int minute) =>
      minute == 0 ||
      minute == 12 ||
      minute == 24 ||
      minute == 36 ||
      minute == 48;
}

class _FieldAB16 extends FieldAB with _MFlagsO16 {
  _FieldAB16.dayPer10Minute() : super._(_validate_per10m, 6, Uint16List(9));

  _FieldAB16.dayPer15Minute() : super._(_validate_per15m, 4, Uint16List(9));

  _FieldAB16.dayPer30Minute() : super._(_validate_per30m, 2, Uint16List(3));

  _FieldAB16._(super.bValidate, super.bDivision, super._field) : super._();

  @override
  FieldAB get newZero =>
      _FieldAB16._(bValidate, bDivision, Uint16List(_field.length));

  static bool _validate_per30m(int minute) => minute == 0 || minute == 30;

  static bool _validate_per15m(int minute) =>
      minute == 0 || minute == 15 || minute == 30 || minute == 45;

  static bool _validate_per10m(int minute) =>
      minute == 0 ||
      minute == 10 ||
      minute == 20 ||
      minute == 30 ||
      minute == 40 ||
      minute == 50;
}
