part of '../../flags_binary.dart';

///
///
///
/// to know the inheritance detail, see the comment above [_PFlags]
///
/// [Field]
/// [Field2D]
/// [Field3D]
/// [Field4D]
///
///
///

///
///
///
abstract class Field extends FieldParent
    with
        _MFlagsContainerSpatial1<bool>,
        _MBitsField,
        _MSetField,
        _MSetBitsField<int>,
        _MOperatableField<Field> {
  @override
  final int spatial1;

  const Field._(this.spatial1, super._field);

  @override
  bool operator [](int index) {
    assert(validateIndex(index));
    return _bitOn(index);
  }

  @override
  void operator []=(int index, bool value) {
    assert(validateIndex(index));
    return value ? _bitSet(index) : _bitClear(index);
  }

  @override
  void _sub(void Function(int) consume, int from, int? limit) {
    assert(validateIndex(from) && (limit == null || validateIndex(limit)));
    final l = limit ?? spatial1;
    for (; from < l; from++) {
      consume(from);
    }
  }

  factory Field(int width, [bool native = false]) {
    assert(width > 1);
    if (width < TypedIntList.limit8) return _Field8(width);
    if (width < TypedIntList.limit16) return _Field16(width);
    if (width > TypedIntList.sizeEach32 && native) {
      return _Field64(width, TypedIntList.quotientCeil64(width));
    }
    return _Field32(width, TypedIntList.quotientCeil32(width));
  }
}

///
///
///
abstract class Field2D extends FieldParent
    with
        _MFlagsContainerSpatial2<bool>,
        _MBitsField,
        _MFieldContainerPositionAble<(int, int)>,
        _MSetFieldIndexable<(int, int)>,
        _MSetBitsField<(int, int)>,
        _MOperatableField<Field2D>
    implements _AFlagsOn<Field> {
  @override
  final int spatial1;
  @override
  final int spatial2;

  const Field2D._(this.spatial1, this.spatial2, super.field);

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

  @override
  (int, int) _indexOf(int position) {
    final spatial2 = this.spatial2;
    assert(position.isRangeOpenUpper(0, spatial1 * spatial2));
    return (position ~/ spatial2, position % spatial2);
  }

  @override
  Field collapseOn(int index) {
    assert(index.isRangeOpenUpper(0, spatial1));
    final spatial2 = this.spatial2,
        start = index * spatial2,
        field = Field(spatial2);
    for (var i = 0; i < spatial2; i++) {
      if (_bitOn(start + i)) field._bitSet(i);
    }
    return field;
  }

  factory Field2D(int width, int height, {bool native = false}) {
    assert(width > 1 && height > 1);
    final size = width * height;
    if (size < TypedIntList.limit8) return _Field2D8(width, height);
    if (size < TypedIntList.limit16) return _Field2D16(width, height);
    if (size > TypedIntList.sizeEach32 && native) {
      return _Field2D64(width, height, TypedIntList.quotientCeil64(size));
    }
    return _Field2D32(width, height, TypedIntList.quotientCeil32(size));
  }
}

///
///
///
abstract class Field3D extends FieldParent
    with
        _MFlagsContainerSpatial3<bool>,
        _MBitsField,
        _MFieldContainerPositionAble<(int, int, int)>,
        _MSetBitsField<(int, int, int)>,
        _MSetFieldIndexable<(int, int, int)>,
        _MOperatableField<Field3D>
    implements _AFlagsOn<Field2D> {
  @override
  final int spatial1;
  @override
  final int spatial2;
  @override
  final int spatial3;

  const Field3D._(this.spatial1, this.spatial2, this.spatial3, super.field);

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

  @override
  (int, int, int) _indexOf(int position) {
    final spatial2 = this.spatial2, spatial3 = this.spatial3;
    assert(position.isRangeOpenUpper(0, spatial1 * spatial2 * spatial3));
    final p2 = position ~/ spatial3;
    return (p2 ~/ spatial2, p2 % spatial2, position % spatial3);
  }

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
        if (_bitOn(start + p)) field._bitSet(p);
      }
    }
    return field;
  }

  factory Field3D(int width, int height, int depth, [bool native = false]) {
    assert(width > 1 && height > 1 && depth > 1);
    final size = width * height * depth;
    if (size < TypedIntList.limit8) return _Field3D8(width, height, depth);
    if (size < TypedIntList.limit16) return _Field3D16(width, height, depth);
    if (size > TypedIntList.sizeEach32 && native) {
      return _Field3D64(
        width,
        height,
        depth,
        TypedIntList.quotientCeil64(size),
      );
    }
    return _Field3D32(width, height, depth, TypedIntList.quotientCeil32(size));
  }
}

///
///
///
abstract class Field4D extends FieldParent
    with
        _MFlagsContainerSpatial4<bool>,
        _MBitsField,
        _MFieldContainerPositionAble<(int, int, int, int)>,
        _MSetBitsField<(int, int, int, int)>,
        _MSetFieldIndexable<(int, int, int, int)>,
        _MOperatableField<Field4D>
    implements _AFlagsOn<Field3D> {
  @override
  final int spatial1;
  @override
  final int spatial2;
  @override
  final int spatial3;
  @override
  final int spatial4;

  const Field4D._(
    this.spatial1,
    this.spatial2,
    this.spatial3,
    this.spatial4,
    super.field,
  );

  @override
  void _sub(
    void Function(int) consume,
    (int, int, int, int) from,
    (int, int, int, int)? limit,
  ) {
    assert(validateIndex(from) && (limit == null || validateIndex(limit)));
    final s2 = this.spatial2,
        s3 = this.spatial3,
        s4 = this.spatial4,
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

  @override
  (int, int, int, int) _indexOf(int position) {
    final spatial1 = this.spatial1;
    final spatial2 = this.spatial2;
    final spatial3 = this.spatial3;
    assert(
      position.isRangeOpenUpper(0, spatial1 * spatial2 * spatial3 * spatial4),
    );
    final p2 = position ~/ spatial1;
    final p3 = p2 ~/ spatial2;
    return (p3 ~/ spatial3, p3 % spatial3, p2 % spatial2, position % spatial1);
  }

  @override
  Field3D collapseOn(int index) {
    assert(index.isRangeOpenUpper(0, spatial4));
    final spatial3 = this.spatial3;
    final spatial2 = this.spatial2;
    final spatial1 = this.spatial1;
    final start = (index - 1) * spatial1 * spatial2 * spatial3;
    final result = Field3D(spatial1, spatial2, spatial3);
    for (var k = 0; k < spatial3; k++) {
      final b1 = k * spatial2;
      for (var j = 0; j < spatial2; j++) {
        final b2 = j * spatial1;
        for (var i = 0; i < spatial1; i++) {
          final p = b1 + b2 + i;
          if (_bitOn(start + p)) result._bitSet(p);
        }
      }
    }
    return result;
  }

  factory Field4D(int s1, int s2, int s3, int s4, [bool native = false]) {
    assert(s1 > 1 && s2 > 1 && s3 > 1 && s4 > 1);
    final size = s1 * s2 * s3 * s4;
    if (size < TypedIntList.limit8) return _Field4D8(s1, s2, s3, s4);
    if (size < TypedIntList.limit16) return _Field4D16(s1, s2, s3, s4);
    if (size > TypedIntList.sizeEach32 && native) {
      return _Field4D64(s1, s2, s3, s4, TypedIntList.quotientCeil64(size));
    }
    return _Field4D32(s1, s2, s3, s4, TypedIntList.quotientCeil32(size));
  }
}
