part of '../../flags_binary.dart';

///
/// [_MFieldOperatable]
/// [_MSlotEquatable]
///

///
///
///
mixin _MFieldOperatable<F extends FieldParent>
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

mixin _MSlotEquatable<T, S extends SlotParent<T>>
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
