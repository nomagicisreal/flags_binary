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

///
/// All flags index should start from 1, because all the flags implementation required bits.
/// it's impossible for flags implementation to have [int.bitLength] < 1.
/// start from 1 prevents subtraction finding last index, [List.length] - 1.
/// see also [TypedDateListInt.bLastOf], [TypedDateListInt.bitsBackwardOf], ...
/// if started from 0, yielding iterable elements from the functions be like [TypedDateListInt.bitsBackwardOf] required '- 1'
/// for each iterable element.
///
abstract class _AFlagsBitsAble<I> implements _PFlags {
  int _bOf(I index);
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

  Iterable<T> get availablesForward;

  Iterable<T> get availablesBackward;

  ///
  /// to prevent duplicate implementation, there is no [availablesFrom] or [availablesTo]
  ///
  Iterable<T> availablesRecent([I from, I to]);

  Iterable<T> availablesLatest([I from, I to]);
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
  void includesSub(T from, [T? to]);

  void excludesSub(T from, [T? to]);
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

  void includesTo(Iterable<T> iterable, I last, [bool inclusive]);
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
