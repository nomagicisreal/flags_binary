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
        _MSlotContainerPositionAble<int, T>,
        _MSetSlot<int, T>,
        _MSlotEquatable<T, Slot<T>>,
        _MSlotField<T, Field> {
  Slot(super.size);

  @override
  int get spatial1 => _slot.length;

  @override
  Field _newField(bool native) => Field(spatial1, native);
}

class Slot2D<T> extends SlotParent<T>
    with
        _MFlagsContainerSpatial2<T?>,
        _MSlotContainerPositionAble<(int, int), T>,
        _MSetSlot<(int, int), T>,
        _MSlotEquatable<T, Slot2D<T>>,
        _MSlotField<T, Field2D> {
  @override
  final int spatial1;
  @override
  final int spatial2;

  Slot2D(this.spatial1, this.spatial2) : super(spatial1 * spatial2);

  Slot2D.from(Field2D field) : this(field.spatial1, field.spatial2);

  @override
  Field2D _newField(bool native) => Field2D(spatial1, spatial2, native);
}

class Slot3D<T> extends SlotParent<T>
    with
        _MFlagsContainerSpatial3<T?>,
        _MSlotContainerPositionAble<(int, int, int), T>,
        _MSetSlot<(int, int, int), T>,
        _MSlotEquatable<T, Slot3D<T>>,
        _MSlotField<T, Field3D> {
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

  @override
  Field3D _newField(bool native) =>
      Field3D(spatial1, spatial2, spatial3, native);
}

class Slot4D<T> extends SlotParent<T>
    with
        _MFlagsContainerSpatial4<T?>,
        _MSlotContainerPositionAble<(int, int, int, int), T>,
        _MSetSlot<(int, int, int, int), T>,
        _MSlotEquatable<T, Slot4D<T>>,
        _MSlotField<T, Field4D> {
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

  @override
  Field4D _newField(bool native) =>
      Field4D(spatial1, spatial2, spatial3, spatial4, native);
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
        _MSlotEquatable<T, SlotDatesInMonths<T>>
    implements _ASlotField<FieldDatesInMonths> {
  @override
  final (int, int) begin;
  @override
  final (int, int) end;

  SlotDatesInMonths(this.begin, this.end)
    : assert(_isValidYearMonthScope(begin, end), 'invalid date $begin ~ $end'),
      super(begin.daysToDate(end.$1, end.$2));

  @override
  FieldDatesInMonths toField() {
    const december = 12, january = 1;
    final slot = _slot,
        begin = this.begin,
        end = this.end,
        result = FieldDatesInMonths(begin, end),
        field = result._field,
        lengthField = field.length;
    var y = begin.$1, m = begin.$2, j = 0;
    while (true) {
      final days = _monthDaysOf(y, m);
      var bits = 0;
      for (var d = 1; d <= days; d++) {
        if (slot[j + d] != null) bits |= 1 << d - 1;
      }
      field[j] = bits;
      j++;
      if (j >= lengthField) return result;

      m++;
      if (m > december) {
        y++;
        m = january;
      }
    }
  }
}
