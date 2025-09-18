part of '../flags_binary.dart';

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
/// [FieldDatesInMonths]
/// [FieldWeekSchedule] (in dev)
/// [FieldAB] (in dev)
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
        _MFieldOperatable<Field>,
        _MFieldSlot<int, Slot> {
  @override
  final int spatial1;

  const Field._(this.spatial1, super._field);

  @override
  int _indexOf(int position) => position;

  @override
  Slot get _newSlot => Slot(size);

  @override
  bool operator [](int index) {
    assert(validateIndex(index));
    return _bOn(index);
  }

  @override
  void operator []=(int index, bool value) {
    assert(validateIndex(index));
    return value ? _bSet(index) : _bClear(index);
  }

  factory Field(int width, [bool native = false]) {
    assert(width > 1);
    if (width < TypedDateListInt.limit8) return _Field8(width);
    if (width < TypedDateListInt.limit16) return _Field16(width);
    if (width > TypedDateListInt.sizeEach32 && native) {
      return _Field64(width, TypedDateListInt.quotientCeil64(width));
    }
    return _Field32(width, TypedDateListInt.quotientCeil32(width));
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
        _MFieldOperatable<Field2D>,
        _MOnFlagsIndexSub<Field, (int, int), int>,
        _MOnFieldSpatial2,
        _MFieldSlot<(int, int), Slot2D> {
  @override
  final int spatial1;
  @override
  final int spatial2;

  const Field2D._(this.spatial1, this.spatial2, super.field);

  @override
  Slot2D get _newSlot => Slot2D(spatial1, spatial2);

  @override
  (int, int) _indexOf(int position) {
    final s2 = spatial2;
    assert(position.isRange(1, spatial1 * s2));
    return (position ~/ s2, position % s2);
  }

  factory Field2D(int width, int height, [bool native = false]) {
    assert(width > 1 && height > 1);
    final size = width * height;
    if (size < TypedDateListInt.limit8) return _Field2D8(width, height);
    if (size < TypedDateListInt.limit16) return _Field2D16(width, height);
    if (size > TypedDateListInt.sizeEach32 && native) {
      return _Field2D64(width, height, TypedDateListInt.quotientCeil64(size));
    }
    return _Field2D32(width, height, TypedDateListInt.quotientCeil32(size));
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
        _MFieldOperatable<Field3D>,
        _MOnFlagsIndexSub<Field2D, (int, int, int), (int, int)>,
        _MOnFieldSpatial3,
        _MFieldSlot<(int, int, int), Slot3D> {
  @override
  final int spatial1;
  @override
  final int spatial2;
  @override
  final int spatial3;

  const Field3D._(this.spatial1, this.spatial2, this.spatial3, super.field);

  @override
  Slot3D get _newSlot => Slot3D(spatial1, spatial2, spatial3);

  @override
  (int, int, int) _indexOf(int position) {
    final s2 = spatial2, s3 = spatial3;
    assert(position.isRange(1, spatial1 * s2 * s3));
    final p2 = position ~/ s3;
    return (p2 ~/ s2, p2 % s2, position % s3);
  }

  factory Field3D(int width, int height, int depth, [bool native = false]) {
    assert(width > 1 && height > 1 && depth > 1);
    final size = width * height * depth;
    if (size < TypedDateListInt.limit8) return _Field3D8(width, height, depth);
    if (size < TypedDateListInt.limit16) {
      return _Field3D16(width, height, depth);
    }
    if (size > TypedDateListInt.sizeEach32 && native) {
      return _Field3D64(
        width,
        height,
        depth,
        TypedDateListInt.quotientCeil64(size),
      );
    }
    return _Field3D32(
      width,
      height,
      depth,
      TypedDateListInt.quotientCeil32(size),
    );
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
        _MFieldOperatable<Field4D>,
        _MOnFlagsIndexSub<Field3D, (int, int, int, int), (int, int, int)>,
        _MOnFieldSpatial4,
        _MFieldSlot<(int, int, int, int), Slot4D> {
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
  Slot4D get _newSlot => Slot4D(spatial1, spatial2, spatial3, spatial4);

  @override
  (int, int, int, int) _indexOf(int position) {
    final s1 = spatial1, s2 = spatial2, s3 = spatial3;
    assert(position.isRange(1, s1 * s2 * s3 * spatial4));
    final p2 = position ~/ s1, p3 = p2 ~/ s2;
    return (p3 ~/ s3, p3 % s3, p2 % s2, position % s1);
  }

  factory Field4D(int s1, int s2, int s3, int s4, [bool native = false]) {
    assert(s1 > 1 && s2 > 1 && s3 > 1 && s4 > 1);
    final size = s1 * s2 * s3 * s4;
    if (size < TypedDateListInt.limit8) return _Field4D8(s1, s2, s3, s4);
    if (size < TypedDateListInt.limit16) return _Field4D16(s1, s2, s3, s4);
    if (size > TypedDateListInt.sizeEach32 && native) {
      return _Field4D64(s1, s2, s3, s4, TypedDateListInt.quotientCeil64(size));
    }
    return _Field4D32(s1, s2, s3, s4, TypedDateListInt.quotientCeil32(size));
  }
}

///
///
///
class FieldDatesInMonths extends FieldParent
    with
        _MFlagsContainerScopedDate<bool>,
        _MBitsFieldMonthsDates,
        _MFieldContainerMonthsDates,
        _MSetFieldMonthsDatesScoped,
        _MSetBitsFieldMonthsDates,
        _MFieldOperatable<FieldDatesInMonths> {
  @override
  final (int, int) begin;
  @override
  final (int, int) end;

  FieldDatesInMonths(this.begin, this.end)
    : assert(_isValidYearMonthScope(begin, end), 'invalid date $begin ~ $end'),
      super(Uint32List(begin.monthsToYearMonth(end.$1, end.$2) + 1));

  @override
  FieldDatesInMonths get newZero => FieldDatesInMonths(begin, end);
}

// ///
// ///
// ///
// abstract class FieldWeekSchedule extends FieldParent {
//   const FieldWeekSchedule(super.field);
// }
//
// ///
// ///
// ///
// abstract class FieldAB extends FieldParent
//     with
//         _MBitsField,
//         _MFieldContainerPositionAble<(int, int)>,
//         _MSetFieldIndexable<(int, int)>,
//         _MSetBitsField<(int, int)>,
//         _MOperatableField<FieldAB> {
//   final int aLimit;
//   final bool Function(int) bValidate;
//   final int bDivision;
//   final int bSize;
//   final int bSizeDivision;
//
//   const FieldAB._(
//       this.bValidate,
//       this.bDivision,
//       super._field, {
//         this.aLimit = _hoursADay,
//         this.bSize = _minuteADay,
//       }) : assert(
//   bSize % bDivision == 0,
//   'invalid division: $bDivision for $bSize',
//   ),
//         bSizeDivision = bSize ~/ bDivision;
//
//   factory FieldAB.dayPerHour() = _FieldAB8.dayPerHour;
//
//   factory FieldAB.dayPer10Minute() = _FieldAB16.dayPer10Minute;
//
//   factory FieldAB.dayPer12Minute() = _FieldAB8.dayPer12Minute;
//
//   factory FieldAB.dayPer15Minute() = _FieldAB16.dayPer15Minute;
//
//   factory FieldAB.dayPer20Minute() = _FieldAB8.dayPer20Minute;
//
//   factory FieldAB.dayPer30Minute() = _FieldAB16.dayPer30Minute;
//
//   @override
//   bool validateIndex((int, int) index) {
//     final a = index.$1;
//     return !a.isNegative && a < aLimit && bValidate(index.$2);
//   }
//
//   @override
//   int _bOf((int, int) index) {
//     assert(validateIndex(index));
//     return index.$1 * bDivision + index.$2 ~/ bSizeDivision;
//   }
//
//   @override
//   (int, int) _indexOf(int position) {
//     final division = bDivision;
//     return (position ~/ division, position % division);
//   }
//
//   @override
//   void _sub(void Function(int) consume, (int, int) from, (int, int)? last) {
//     assert(validateIndex(from));
//     assert(last == null || (validateIndex(last) && from < last));
//
//     final division = bDivision;
//     final sizeDivision = bSizeDivision;
//     final aBegin = from.$1 * division;
//     final aEnd = (last?.$1 ?? aLimit - 1) * division;
//     var d = from.$2 ~/ sizeDivision;
//     for (; d < sizeDivision; d++) {
//       consume(aBegin + d);
//     }
//     for (var a = aBegin; a < aEnd; a += division) {
//       for (d = 0; d < sizeDivision; d++) {
//         consume(a + d);
//       }
//     }
//     final dEnd = (last?.$2 ?? size) ~/ sizeDivision;
//     for (d = 0; d <= dEnd; d++) {
//       consume(aEnd + d);
//     }
//   }
// }
