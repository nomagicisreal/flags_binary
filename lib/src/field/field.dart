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
        _MSetBitsFieldSpatial1,
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
        _MSetBitsFieldSpatial2,
        _MOperatableField<Field2D>,
        _MOnFlagsIndexSub<Field, (int, int), int>,
        _MOnFieldSpatial2 {
  @override
  final int spatial1;
  @override
  final int spatial2;

  const Field2D._(this.spatial1, this.spatial2, super.field);

  @override
  (int, int) _indexOf(int position) {
    final s2 = spatial2;
    assert(position.isRangeOpenUpper(0, spatial1 * s2));
    return (position ~/ s2, position % s2);
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
        _MSetBitsFieldSpatial3,
        _MOperatableField<Field3D>,
        _MOnFlagsIndexSub<Field2D, (int, int, int), (int, int)>,
        _MOnFieldSpatial3 {
  @override
  final int spatial1;
  @override
  final int spatial2;
  @override
  final int spatial3;

  const Field3D._(this.spatial1, this.spatial2, this.spatial3, super.field);

  @override
  (int, int, int) _indexOf(int position) {
    final s2 = spatial2, s3 = spatial3;
    assert(position.isRangeOpenUpper(0, spatial1 * s2 * s3));
    final p2 = position ~/ s3;
    return (p2 ~/ s2, p2 % s2, position % s3);
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
        _MSetBitsFieldSpatial4,
        _MOperatableField<Field4D>,
        _MOnFlagsIndexSub<Field3D, (int, int, int, int), (int, int, int)>,
        _MOnFieldSpatial4 {
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
  (int, int, int, int) _indexOf(int position) {
    final s1 = spatial1, s2 = spatial2, s3 = spatial3;
    assert(position.isRangeOpenUpper(0, s1 * s2 * s3 * spatial4));
    final p2 = position ~/ s1, p3 = p2 ~/ s2;
    return (p3 ~/ s3, p3 % s3, p2 % s2, position % s1);
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
