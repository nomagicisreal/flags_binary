part of '../flags_binary.dart';

///
///
///
/// to know the inheritance detail, see the comment above [_PFlags]
///
/// [Slot]
/// [Slot2D]
/// [Slot3D]
/// [Slot4D]
///
/// [SlotDatesInMonths]
///
///
///

///
///
///
class Slot<T> extends SlotParent<T>
    with
        _MFlagsContainerSpatial1<T?>,
        _MSetSlot<int, T>,
        _MEquatableSlot<T, Slot<T>> {
  Slot(super.size);

  @override
  int get spatial1 => _slot.length;

  @override
  T? operator [](int index) {
    assert(validateIndex(index));
    return _slot[index - 1];
  }

  @override
  void operator []=(int index, T? value) {
    assert(validateIndex(index));
    _slot[index - 1] = value;
  }

  @override
  int _bOf(int index) => index - 1;
}

class Slot2D<T> extends SlotParent<T>
    with
        _MFlagsContainerSpatial2<T?>,
        _MSlotContainerPositionAble<(int, int), T>,
        _MSetSlot<(int, int), T>,
        _MEquatableSlot<T, Slot2D<T>> {
  @override
  final int spatial1;
  @override
  final int spatial2;

  Slot2D(this.spatial1, this.spatial2) : super(spatial1 * spatial2);

  Slot2D.from(Field2D field) : this(field.spatial1, field.spatial2);
}

class Slot3D<T> extends SlotParent<T>
    with
        _MFlagsContainerSpatial3<T?>,
        _MSlotContainerPositionAble<(int, int, int), T>,
        _MSetSlot<(int, int, int), T>,
        _MEquatableSlot<T, Slot3D<T>> {
  @override
  final int spatial1;
  @override
  final int spatial2;
  @override
  final int spatial3;

  Slot3D(this.spatial1, this.spatial2, this.spatial3)
    : super(spatial1 * spatial2 * spatial3);

  Slot3D.from(Field3D field)
    : this(field.spatial1, field.spatial2, field.spatial3);
}

class Slot4D<T> extends SlotParent<T>
    with
        _MFlagsContainerSpatial4<T?>,
        _MSlotContainerPositionAble<(int, int, int, int), T>,
        _MSetSlot<(int, int, int, int), T>,
        _MEquatableSlot<T, Slot4D<T>> {
  @override
  final int spatial1;
  @override
  final int spatial2;
  @override
  final int spatial3;
  @override
  final int spatial4;

  Slot4D(this.spatial1, this.spatial2, this.spatial3, this.spatial4)
    : super(spatial1 * spatial2 * spatial3 * spatial4);

  Slot4D.from(Field4D field)
    : this(field.spatial1, field.spatial2, field.spatial3, field.spatial4);
}


///
///
///
class SlotDatesInMonths<T> extends SlotParent<T>
    with
        _MFlagsContainerScopedDate<T?>,
        _MFlagsScopedDatePositionDay,
        _MSlotContainerPositionAble<(int, int, int), T>,
        _MSetSlot<(int, int, int), T>,
        _MEquatableSlot<T, SlotDatesInMonths<T>> {
  @override
  final (int, int) begin;
  @override
  final (int, int) end;

  SlotDatesInMonths(this.begin, this.end)
      : assert(_isValidYearMonthScope(begin, end), 'invalid date $begin ~ $end'),
        super(begin.daysToDate(end.$1, end.$2));
}
