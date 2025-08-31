part of '../flags_binary.dart';

///
///
///
/// prefix 'A' stands for abstraction, with contract
/// [_AFlagsContainer]
/// [_AFlagsScoped]
/// [_AFlagsSpatial1], [_AFlagsSpatial2], [_AFlagsSpatial3], [_AFlagsSpatial4]
/// [_AFlagsOn]
/// [_AFlagsOperatable]
/// [_AField]
/// [_AFieldBits]
/// [_AFlagsSet]
/// [_AFieldIdentical]
///
/// [FieldParent]
/// [SlotParent]
///
///
///

abstract class _AFlagsContainer<I, S> implements _PFlags {
  bool validateIndex(I index);

  S operator [](I index);

  void operator []=(I index, S value);
}

abstract class _AFlagsScoped<T> implements _PFlags {
  T get begin;

  T get end;
}

abstract class _AFlagsSpatial1 implements _PFlags {
  int get spatial1;
}

abstract class _AFlagsSpatial2 implements _AFlagsSpatial1 {
  int get spatial2;
}

abstract class _AFlagsSpatial3 implements _AFlagsSpatial2 {
  int get spatial3;
}

abstract class _AFlagsSpatial4 implements _AFlagsSpatial3 {
  int get spatial4;
}

abstract class _AFlagsPositionAble<I> implements _PFlags {
  int _positionOf(I index);
}

abstract class _AFlagsOn<F, I> implements _PFlags {
  F collapseOn(int index);

  void includesOn(int index, Iterable<I> inclusion);
  void excludesOn(int index, Iterable<I> exclusion);
}

abstract class _AFlagsEquatable<F> implements _PFlags {
  bool isSizeEqual(F other);
}

abstract class _AFlagsOperatable<F> implements _AFlagsEquatable<F> {
  F get newZero;

  F operator &(F other);

  F operator |(F other);

  F operator ^(F other);

  void setAnd(F other);

  void setOr(F other);

  void setXOr(F other);
}

abstract class _AFlagsSet<I, T> implements _PFlags {
  T? get first;

  T? get last;

  T? firstAfter(I index);

  T? lastBefore(I index);

  Iterable<T> get availables;

  Iterable<T> availablesFrom(I index, [bool inclusive]);

  Iterable<T> availablesTo(I index, [bool inclusive]);

  Iterable<T> availablesSub(I from, I to, [bool includeFrom, bool includeTo]);
}

///
///
///
abstract class _AField implements _PFlags {
  TypedDataList<int> get _field;
}

abstract class _AFieldIdentical implements _PFlags {
  int get _sizeEach;

  int get size;
}

abstract class _AFieldBits implements _PFlags {
  // int get _shift => math.log(_sizeEach) ~/ math.ln2 - 1;
  int get _shift;

  int get _mask;
}

abstract class _AFieldSet<I, T> implements _AFlagsSet<I, T> {
  void includesSub(T begin, [T? limit]);

  void excludesSub(T begin, [T? limit]);
}

//
sealed class FieldParent extends _PFlags implements _AField, _AFieldIdentical {
  @override
  final TypedDataList<int> _field;

  const FieldParent(this._field);

  @override
  int get size => _sizeEach * _field.length;

  @override
  void clear() {
    final length = _field.length;
    for (var i = 0; i < length; i++) {
      _field[i] = 0;
    }
  }
}

///
///
///
abstract class _ASlot<T> implements _PFlags {
  List<T?> get _slot;
}

abstract class _ASlotSet<I, T> implements _AFlagsSet<I, T> {
  Iterable<T> filterOn(FieldParent field);

  void pasteSub(T value, I begin, [I? limit]);

  void includesFrom(Iterable<T> iterable, I begin, [bool inclusive]);

  void includesTo(Iterable<T> iterable, I limit, [bool inclusive]);
}

//
sealed class SlotParent<T> extends _PFlags implements _ASlot<T> {
  @override
  final List<T?> _slot;

  SlotParent(int size) : _slot = List.filled(size, null);

  @override
  void clear() {
    final slot = _slot;
    final length = slot.length;
    for (var i = 0; i < length; i++) {
      slot[i] = null;
    }
  }
}
