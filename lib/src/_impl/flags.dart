part of '../../flags_binary.dart';

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
/// [_MSlotField]
/// [_MFieldSlot]
///
/// concrete class:
/// [_Field8], ...
/// [_Field2D8], ...
/// [_Field3D8], ...
/// [_Field4D8], ...
/// [_FieldAB8], ... (in dev)
///
///
///

///
///
///
///
mixin _MFlagsO8 implements _AFieldBits, _AFieldIdentical {
  @override
  int get _shift => TypedDataListInt.shift8;

  @override
  int get _mask => TypedDataListInt.mask8;

  @override
  int get _sizeEach => TypedDataListInt.sizeEach8;
}

mixin _MFlagsO16 implements _AFieldBits, _AFieldIdentical {
  @override
  int get _shift => TypedDataListInt.shift16;

  @override
  int get _mask => TypedDataListInt.mask16;

  @override
  int get _sizeEach => TypedDataListInt.sizeEach16;
}

mixin _MFlagsO32 implements _AFieldBits, _AFieldIdentical {
  @override
  int get _shift => TypedDataListInt.shift32;

  @override
  int get _mask => TypedDataListInt.mask32;

  @override
  int get _sizeEach => TypedDataListInt.sizeEach32;
}

mixin _MFlagsO64 implements _AFieldBits, _AFieldIdentical {
  @override
  int get _shift => TypedDataListInt.shift64;

  @override
  int get _mask => TypedDataListInt.mask64;

  @override
  int get _sizeEach => TypedDataListInt.sizeEach64;
}

///
///
///
mixin _MFlagsContainerSpatial1<T>
    implements _AFlagsContainer<int, T>, _AFlagsSpatial1, _AFlagsBitsAble<int> {
  @override
  bool validateIndex(int index) => index.isRange(1, spatial1);

  @override
  int _bOf(int index) {
    assert(validateIndex(index));
    return index - 1;
  }
}

mixin _MFlagsContainerSpatial2<T>
    implements
        _AFlagsContainer<(int, int), T>,
        _AFlagsSpatial2,
        _AFlagsBitsAble<(int, int)> {
  @override
  bool validateIndex((int, int) index) =>
      index.$1.isRange(1, spatial1) && index.$2.isRange(1, spatial2);

  @override
  int _bOf((int, int) index) {
    assert(validateIndex(index));
    return (index.$1 - 1) * spatial2 + index.$2 - 1;
  }
}

mixin _MFlagsContainerSpatial3<T>
    implements
        _AFlagsContainer<(int, int, int), T>,
        _AFlagsSpatial3,
        _AFlagsBitsAble<(int, int, int)> {
  @override
  bool validateIndex((int, int, int) index) =>
      index.$1.isRange(1, spatial1) &&
      index.$2.isRange(1, spatial2) &&
      index.$3.isRange(1, spatial3);

  @override
  int _bOf((int, int, int) index) {
    assert(validateIndex(index));
    return ((index.$1 - 1) * spatial2 + index.$2 - 1) * spatial3 + index.$3 - 1;
  }
}

mixin _MFlagsContainerSpatial4<T>
    implements
        _AFlagsContainer<(int, int, int, int), T>,
        _AFlagsSpatial4,
        _AFlagsBitsAble<(int, int, int, int)> {
  @override
  bool validateIndex((int, int, int, int) index) =>
      index.$1.isRange(1, spatial1) &&
      index.$2.isRange(1, spatial2) &&
      index.$3.isRange(1, spatial3) &&
      index.$4.isRange(1, spatial4);

  @override
  int _bOf((int, int, int, int) index) {
    assert(validateIndex(index));
    return (((index.$1 - 1) * spatial2 + index.$2 - 1) * spatial3 +
                index.$3 -
                1) *
            spatial4 +
        index.$4 -
        1;
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
    implements _AFlagsScoped<(int, int)>, _AFlagsBitsAble<(int, int, int)> {
  @override
  int _bOf((int, int, int) index) =>
      begin.daysToDate(index.$1, index.$2, index.$3);
}

///
///
///
///
mixin _MBitsField implements _AField, _AFieldBits {
  bool _bOn(int b) => _field.iOn(b, _shift, _mask);

  void _bSet(int b) => _field.iSet(b, _shift, _mask);

  void _bClear(int b) => _field.iClear(b, _shift, _mask);
}

///
///
///
mixin _MFieldContainerPositionAble<I> on _MBitsField
    implements _AFlagsContainer<I, bool>, _AFlagsBitsAble<I> {
  @override
  bool operator [](I index) {
    assert(validateIndex(index));
    return _bOn(_bOf(index));
  }

  @override
  void operator []=(I index, bool value) {
    assert(validateIndex(index));
    value ? _bSet(_bOf(index)) : _bClear(_bOf(index));
  }
}

mixin _MFieldContainerMonthsDates on _MFlagsContainerScopedDate<bool>
    implements _AFieldIdentical {
  @override
  int get _sizeEach => TypedDataListInt.sizeEach32;

  @override
  bool operator []((int, int, int) index) {
    assert(validateIndex(index));
    return _field[begin.monthsToYearMonth(index.$1, index.$2)] >> index.$3 - 1 &
            1 ==
        1;
  }

  @override
  void operator []=((int, int, int) index, bool value) {
    assert(validateIndex(index));
    value
        ? _field[begin.monthsToYearMonth(index.$1, index.$2)] |=
              1 << index.$3 - 1
        : _field[begin.monthsToYearMonth(index.$1, index.$2)] &=
              ~(1 << index.$3 - 1);
  }
}

mixin _MSlotContainerPositionAble<I, T>
    implements _AFlagsContainer<I, T?>, _AFlagsBitsAble<I>, _ASlot<T> {
  @override
  T? operator [](I index) {
    assert(validateIndex(index));
    return _slot[_bOf(index)];
  }

  @override
  void operator []=(I index, T? value) {
    assert(validateIndex(index));
    _slot[_bOf(index)] = value;
  }
}

//
mixin _MSlotField<T, F extends FieldParent>
    implements _ASlot<T>, _ASlotField<F> {
  F _newField(bool native);

  @override
  F toField([bool native = false]) {
    final slot = _slot,
        result = _newField(native),
        sizeEach = result._sizeEach,
        field = result._field,
        lengthField = field.length;
    for (var j = 0; j < lengthField; j++) {
      final start = sizeEach * j;
      var bits = 0;
      for (var i = 0; i < sizeEach; i++) {
        if (slot[start + i] != null) bits |= 1 << i;
      }
      field[j] = bits;
    }
    return result;
  }
}

mixin _MFieldSlot<I, S extends SlotParent>
    implements
        _AField,
        _AFieldSlot<I, S>,
        _AFieldIdentical,
        _AFlagsIndexable<I> {
  S get _newSlot;

  @override
  S toSlot<T>(T Function(I) mapper) {
    final result = _newSlot,
        slot = result._slot,
        field = _field,
        sizeEach = _sizeEach,
        length = field.length;
    for (var j = 0; j < length; j++) {
      final start = sizeEach * j;
      for (var bits = field[j], b = 0; b < sizeEach; bits >>= 1, b++) {
        if (bits & 1 == 1) {
          final i = start + b;
          slot[i] = mapper(_indexOf(i));
        }
      }
    }
    return result;
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
    assert(index.isRange(1, spatial1));
    for (var indexSub in inclusion) {
      assert(_validateIndexSub(indexSub));
      _bSet(_bOf(_indexMerge(index, indexSub)));
    }
  }

  @override
  void excludesOn(int index, Iterable<J> exclusion) {
    assert(index.isRange(1, spatial1));
    for (var indexSub in exclusion) {
      assert(_validateIndexSub(indexSub));
      _bClear(_bOf(_indexMerge(index, indexSub)));
    }
  }
}

mixin _MOnFieldSpatial2 on _MOnFlagsIndexSub<Field, (int, int), int>
    implements _AFlagsSpatial2 {
  @override
  bool _validateIndexSub(int indexSub) => indexSub.isRange(1, spatial2);

  @override
  (int, int) _indexMerge(int index, int indexSub) => (index, indexSub);

  @override
  Field collapseOn(int index) {
    assert(index.isRange(1, spatial1));
    final spatial2 = this.spatial2,
        start = (index - 1) * spatial2,
        source = _field,
        sourceShift = _shift,
        sourceMask = _mask,
        result = Field(spatial2),
        field = result._field,
        shift = result._shift,
        mask = result._mask;
    for (var b = 0; b < spatial2; b++) {
      final bSource = start + b;
      if (source[bSource >> sourceShift] >> (bSource & sourceMask) & 1 == 1) {
        field[b >> shift] |= 1 << (b & mask);
      }
    }
    return result;
  }
}

mixin _MOnFieldSpatial3
    on _MOnFlagsIndexSub<Field2D, (int, int, int), (int, int)>
    implements _AFlagsSpatial3 {
  @override
  bool _validateIndexSub((int, int) indexSub) =>
      indexSub.$1.isRange(1, spatial2) && indexSub.$2.isRange(1, spatial3);

  @override
  (int, int, int) _indexMerge(int index, (int, int) indexSub) =>
      (index, indexSub.$1, indexSub.$2);

  @override
  Field2D collapseOn(int index) {
    assert(index.isRange(1, spatial1));
    final spatial2 = this.spatial2,
        spatial3 = this.spatial3,
        start = (index - 1) * spatial2 * spatial3,
        source = _field,
        sourceShift = _shift,
        sourceMask = _mask,
        result = Field2D(spatial2, spatial3),
        field = result._field,
        shift = result._shift,
        mask = result._mask;
    for (var j = 0, b = 0; j < spatial2; j++) {
      for (var i = 0; i < spatial3; i++, b++) {
        final bSource = start + b;
        if (source[bSource >> sourceShift] >> (bSource & sourceMask) & 1 == 1) {
          field[b >> shift] |= 1 << (b & mask);
        }
      }
    }
    return result;
  }
}

mixin _MOnFieldSpatial4
    on _MOnFlagsIndexSub<Field3D, (int, int, int, int), (int, int, int)>
    implements _AFlagsSpatial4 {
  @override
  bool _validateIndexSub((int, int, int) indexSub) =>
      indexSub.$1.isRange(1, spatial2) &&
      indexSub.$2.isRange(1, spatial3) &&
      indexSub.$3.isRange(1, spatial4);

  @override
  (int, int, int, int) _indexMerge(int index, (int, int, int) indexSub) =>
      (index, indexSub.$1, indexSub.$2, indexSub.$3);

  @override
  Field3D collapseOn(int index) {
    assert(index.isRange(1, spatial1));
    final spatial2 = this.spatial2,
        spatial3 = this.spatial3,
        spatial4 = this.spatial4,
        start = (index - 1) * spatial2 * spatial3 * spatial4,
        source = _field,
        sShift = _shift,
        sMask = _mask,
        result = Field3D(spatial2, spatial3, spatial4),
        field = result._field,
        shift = result._shift,
        mask = result._mask;
    for (var k = 0, b = 0; k < spatial2; k++) {
      for (var j = 0; j < spatial3; j++) {
        for (var i = 0; i < spatial4; i++, b++) {
          final bSource = start + b;
          if (source[bSource >> sShift] >> (bSource & sMask) & 1 == 1) {
            field[b >> shift] |= 1 << (b & mask);
          }
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

// //
// class _FieldAB8 extends FieldAB with _MFlagsO8 {
//   _FieldAB8.dayPer12Minute() : super._(_validate_per12m, 5, Uint8List(9));
//
//   _FieldAB8.dayPer20Minute() : super._(_validate_per20m, 3, Uint8List(9));
//
//   _FieldAB8.dayPerHour() : super._(_validate_perH, 1, Uint8List(3));
//
//   _FieldAB8._(super.bValidate, super.bDivision, super._field) : super._();
//
//   @override
//   FieldAB get newZero =>
//       _FieldAB8._(bValidate, bDivision, Uint8List(_field.length));
//
//   static bool _validate_perH(int minute) => minute == 0;
//
//   static bool _validate_per20m(int minute) =>
//       minute == 0 || minute == 20 || minute == 40;
//
//   static bool _validate_per12m(int minute) =>
//       minute == 0 ||
//       minute == 12 ||
//       minute == 24 ||
//       minute == 36 ||
//       minute == 48;
// }
//
// class _FieldAB16 extends FieldAB with _MFlagsO16 {
//   _FieldAB16.dayPer10Minute() : super._(_validate_per10m, 6, Uint16List(9));
//
//   _FieldAB16.dayPer15Minute() : super._(_validate_per15m, 4, Uint16List(9));
//
//   _FieldAB16.dayPer30Minute() : super._(_validate_per30m, 2, Uint16List(3));
//
//   _FieldAB16._(super.bValidate, super.bDivision, super._field) : super._();
//
//   @override
//   FieldAB get newZero =>
//       _FieldAB16._(bValidate, bDivision, Uint16List(_field.length));
//
//   static bool _validate_per30m(int minute) => minute == 0 || minute == 30;
//
//   static bool _validate_per15m(int minute) =>
//       minute == 0 || minute == 15 || minute == 30 || minute == 45;
//
//   static bool _validate_per10m(int minute) =>
//       minute == 0 ||
//       minute == 10 ||
//       minute == 20 ||
//       minute == 30 ||
//       minute == 40 ||
//       minute == 50;
// }
