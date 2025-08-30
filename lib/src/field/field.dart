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
    for (var i = from; i < l; i++) {
      consume(i);
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
    implements _AFlagsCollapse<Field> {
  @override
  final int spatial1;
  @override
  final int spatial2;

  const Field2D._(this.spatial1, this.spatial2, super.field);

  @override
  void _sub(void Function(int) consume, (int, int) from, (int, int)? limit) {
    assert(validateIndex(from) && (limit == null || validateIndex(limit)));
    var j = from.$1;
    var i = from.$2;
    final spatial1 = this.spatial1;
    final iLimit = limit?.$2 ?? spatial1;
    final jEnd = limit?.$1 ?? spatial2;
    assert(j <= jEnd);

    var index = j * spatial1 + i;

    // j == jEnd
    if (j == jEnd) {
      assert(i < iLimit);
      for (; i < iLimit; i++, index++) {
        consume(index);
      }
      return;
    }

    // j < jEnd
    for (; i < spatial1; i++, index++) {
      consume(index);
    }
    for (j++; j < jEnd; j++) {
      for (i = 0; i < spatial1; i++, index++) {
        consume(index);
      }
    }

    // j == jEnd
    for (i = 0; i < iLimit; i++, index++) {
      consume(index);
    }
  }

  @override
  (int, int) _indexOf(int position) {
    final spatial1 = this.spatial1;
    assert(position.isRangeOpenUpper(0, spatial1 * spatial2));
    return (position ~/ spatial1, position % spatial1);
  }

  @override
  Field collapseOn(int index) {
    assert(index.isRangeOpenUpper(0, spatial2));
    final spatial1 = this.spatial1;
    final start = (index - 1) * spatial1;
    final result = Field(spatial1);
    for (var i = 0; i < spatial1; i++) {
      if (_bitOn(start + i)) result._bitSet(i);
    }
    return result;
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
    implements _AFlagsCollapse<Field2D> {
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
    var k = from.$1;
    var j = from.$2;
    var i = from.$3;
    final spatial1 = this.spatial1;
    final spatial2 = this.spatial2;
    final kEnd = limit?.$1 ?? spatial3;
    final jEnd = limit?.$2 ?? spatial2;
    final iLimit = limit?.$3 ?? spatial1;
    assert(k <= kEnd);

    var index = (k * spatial2 + j) * spatial1 + i;

    // k == kEnd
    if (k == kEnd) {
      assert(j <= jEnd); // belows is copied from [Field2D]

      // j == jEnd
      if (j == jEnd) {
        assert(i < iLimit);
        for (; i < iLimit; i++, index++) {
          consume(index);
        }
        return;
      }

      // j < jEnd
      for (; i < spatial1; i++, index++) {
        consume(index);
      }
      for (j++; j < jEnd; j++) {
        for (i = 0; i < spatial1; i++, index++) {
          consume(index);
        }
      }

      // j == jEnd
      for (i = 0; i < iLimit; i++, index++) {
        consume(index);
      }
      return;
    }

    // k < kEnd
    for (; i < spatial1; i++, index++) {
      consume(index);
    }
    for (j++; j < spatial2; j++) {
      for (i = 0; i < spatial1; i++, index++) {
        consume(index);
      }
    }
    for (k++; k < kEnd; k++) {
      for (j = 0; j < spatial2; j++) {
        for (i = 0; i < spatial1; i++, index++) {
          consume(index);
        }
      }
    }

    // k == kEnd
    for (j = 0; j < jEnd; j++) {
      for (i = 0; i < spatial1; i++, index++) {
        consume(index);
      }
    }
    for (i = 0; i < iLimit; i++, index++) {
      consume(index);
    }
  }

  @override
  (int, int, int) _indexOf(int position) {
    final spatial1 = this.spatial1;
    final spatial2 = this.spatial2;
    assert(position.isRangeOpenUpper(0, spatial1 * spatial2 * spatial3));
    final p2 = position ~/ spatial1;
    return (p2 ~/ spatial2, p2 % spatial2, position % spatial1);
  }

  @override
  Field2D collapseOn(int index) {
    assert(index.isRangeOpenUpper(0, spatial3));
    final spatial2 = this.spatial2;
    final spatial1 = this.spatial1;
    final start = (index - 1) * spatial2 * spatial1;
    final result = Field2D(spatial1, spatial2);
    for (var j = 0; j < spatial2; j++) {
      final begin = j * spatial1;
      for (var i = 0; i < spatial1; i++) {
        final p = begin + i;
        if (_bitOn(start + p)) result._bitSet(p);
      }
    }
    return result;
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
    implements _AFlagsCollapse<Field3D> {
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
    var l = from.$1;
    var k = from.$2;
    var j = from.$3;
    var i = from.$4;
    final spatial1 = this.spatial1;
    final spatial2 = this.spatial2;
    final spatial3 = this.spatial3;
    final lEnd = limit?.$1 ?? spatial4;
    final kEnd = limit?.$2 ?? spatial3;
    final jEnd = limit?.$3 ?? spatial2;
    final iLimit = limit?.$4 ?? spatial1;
    assert(l <= lEnd);

    var index = ((l * spatial3 + k) * spatial2 + j) + i;

    // l == lEnd
    if (l == lEnd) {
      assert(k <= kEnd); // belows is copied from [_rangeS3From]

      // k == kEnd
      if (k == kEnd) {
        assert(j <= jEnd); // belows is copied from [_rangeS2From]

        // j == jEnd
        if (j == jEnd) {
          assert(i < iLimit);
          for (; i < iLimit; i++, index++) {
            consume(index);
          }
          return;
        }

        // j < jEnd
        for (; i < spatial1; i++, index++) {
          consume(index);
        }
        for (j++; j < jEnd; j++) {
          for (i = 0; i < spatial1; i++, index++) {
            consume(index);
          }
        }

        // j == jEnd
        for (i = 0; i < iLimit; i++, index++) {
          consume(index);
        }
        return;
      }

      // k < kEnd
      for (; i < spatial1; i++, index++) {
        consume(index);
      }
      for (j++; j < spatial2; j++) {
        for (i = 0; i < spatial1; i++, index++) {
          consume(index);
        }
      }
      for (k++; k < kEnd; k++) {
        for (j = 0; j < spatial2; j++) {
          for (i = 0; i < spatial1; i++, index++) {
            consume(index);
          }
        }
      }

      // k == kEnd
      for (j = 0; j < jEnd; j++) {
        for (i = 0; i < spatial1; i++, index++) {
          consume(index);
        }
      }
      for (i = 0; i < iLimit; i++, index++) {
        consume(index);
      }
      return;
    }

    // l < lEnd
    for (; i < spatial1; i++, index++) {
      consume(index);
    }
    for (j++; j < spatial2; j++) {
      for (i = 0; i < spatial1; i++, index++) {
        consume(index);
      }
    }
    for (k++; k < spatial3; k++) {
      for (j = 0; j < spatial2; j++) {
        for (i = 0; i < spatial1; i++, index++) {
          consume(index);
        }
      }
    }
    for (l++; l < lEnd; l++) {
      for (k = 0; k < spatial3; k++) {
        for (j = 0; j < spatial2; j++) {
          for (i = 0; i < spatial1; i++, index++) {
            consume(index);
          }
        }
      }
    }

    // l == lEnd
    for (k = 0; k < kEnd; k++) {
      for (j = 0; j < spatial2; j++) {
        for (i = 0; i < spatial1; i++, index++) {
          consume(index);
        }
      }
    }
    for (j = 0; j < jEnd; j++) {
      for (i = 0; i < spatial1; i++, index++) {
        consume(index);
      }
    }
    for (i = 0; i < iLimit; i++, index++) {
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
