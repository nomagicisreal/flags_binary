part of '../../flags_binary.dart';

///
///
///
/// [TypedIntList]
///
///
///
///

///
/// static constants and methods:
/// [countsAByte], ...
/// [quotientCeil8], ...
///
/// instances methods: todo: identical iterable b, p functions; identical iterable mapB, P functions
/// return void                   : [pConsume], ...
/// return bool                   : [pOn], ...
/// return integer                : [bFirstOf], ...
/// return iterable integer       : [pAvailable], ...
/// return iterable provided type : [mapPAvailable], ...
///
extension TypedIntList on TypedDataList<int> {
  static const int countsAByte = 8;
  static const int limit4 = 5;
  static const int mask4 = 3;
  static const int shift4 = 2;
  static const int limit8 = 9;
  static const int mask8 = 7;
  static const int shift8 = 3;
  static const int sizeEach8 =
      Uint8List.bytesPerElement * TypedIntList.countsAByte;
  static const int limit16 = 17;
  static const int mask16 = 15;
  static const int shift16 = 4;
  static const int sizeEach16 =
      Uint16List.bytesPerElement * TypedIntList.countsAByte;

  // static const int limit32 = 33;
  static const int mask32 = 31;
  static const int shift32 = 5;
  static const int sizeEach32 =
      Uint32List.bytesPerElement * TypedIntList.countsAByte;

  // static const int limit64 = 65;
  static const int mask64 = 63;
  static const int shift64 = 6;
  static const int sizeEach64 =
      Uint64List.bytesPerElement * TypedIntList.countsAByte;

  ///
  ///
  ///
  static int quotientCeil64(int value) => value + mask64 >> shift64;

  static int quotientCeil32(int value) => value + mask32 >> shift32;

  static int quotientCeil16(int value) => value + mask16 >> shift16;

  static int quotientCeil8(int value) => value + mask8 >> shift8;

  ///
  /// [pConsume]
  /// [pSet], [pClear]
  ///
  void pConsume(
    void Function(int p) consume,
    int iLimit, [
    int consumed = 1,
    int? jLimit,
  ]) {
    jLimit ??= length - 1;
    assert(consumed == 0 || consumed == 1);
    assert(iLimit > 0 && jLimit >= 0 && jLimit < length);
    for (var j = 0; j < jLimit; j++) {
      final start = iLimit * j;
      for (var pI = 1, bits = this[j]; bits > 0; pI++, bits >>= 1) {
        if (bits & 1 == consumed) consume(start + pI);
      }
    }
  }

  void pSet(int p, int shift, int mask) {
    assert(p > 0 && mask + 1 == 1 << shift);
    this[p >> shift] |= 1 << (p & mask);
  }

  void pClear(int p, int shift, int mask) {
    assert(p > 0 && mask + 1 == 1 << shift);
    this[p >> shift] &= ~(1 << (p & mask));
  }

  ///
  /// [pOn]
  ///
  bool pOn(int p, int shift, int mask) {
    assert(p > 0 && mask + 1 == 1 << shift);
    return this[p >> shift] >> (p & mask) & 1 == 1;
  }

  ///
  /// [bFirstOf], [bFirstOfFrom], [bFirstOfTo], [bFirstOfBetween], ...
  /// [bFirst], [bFirstFrom], [bFirstTo], [bFirstBetween], ...
  /// [bFirstAfter]
  ///
  /// [bLastOf], [bLastOfTo], [bLastOfFrom], [bLastOfBetween], ...
  /// [bLast], [bLastTo], [bLastFrom], [bLastBetween], ...
  /// [bLastBefore]
  ///

  ///
  ///
  ///
  int? bFirstOf(int j) {
    assert(j >= 0 && j < length);
    for (var bits = this[j], i = 0; bits > 0; bits >>= 1, i++) {
      if (bits & 1 == 1) return i;
    }
    return null;
  }

  // int? bFirstOfN(int j, int n) {
  //   assert(j >= 0 && j < length);
  //   for (var bits = this[j], i = 0; bits > 0; bits >>= 1, i++) {
  //     if (bits & 1 == 1 && --n == 0) return i;
  //   }
  //   return null;
  // }

  int? bFirstOfFrom(int j, int i) {
    assert(j >= 0 && j < length && i >= 0);
    for (var bits = this[j] >> i; bits > 0; bits >>= 1, i++) {
      if (bits & 1 == 1) return i;
    }
    return null;
  }

  int? bFirstOfTo(int j, int iTo) {
    assert(j >= 0 && j < length && iTo > 0);
    var b = this[j], i = 0;
    for (final last = math.min(iTo, b.bitLength - 1); i <= last; b >>= 1, i++) {
      if (b & 1 == 1) return i;
    }
    return null;
  }

  int? bFirstOfBetween(int j, int iFrom, int iTo) {
    assert(j >= 0 && j < length && iFrom > 0 && iFrom < iTo);
    var b = this[j] >> iFrom, i = iFrom;
    for (final last = math.min(iTo, b.bitLength - 1); i <= last; b >>= 1, i++) {
      if (b & 1 == 1) return i;
    }
    return null;
  }

  ///
  ///
  ///
  int? bFirst(int iLimit) {
    assert(iLimit > 0);
    final length = this.length;
    for (var j = 0, bits = this[j]; j < length; j++) {
      for (var i = 0; bits > 0; i++, bits >>= 1) {
        if (bits & 1 == 1) return iLimit * j + i;
      }
    }
    return null;
  }

  int? bFirstFrom(int iLimit, int jFrom, int iFrom) {
    assert(jFrom >= 0 && jFrom < this.length && iFrom >= 0 && iFrom < iLimit);

    final length = this.length;
    var bits = this[jFrom] >> iFrom, j = jFrom, i = iFrom;
    while (true) {
      for (; bits > 0; bits >>= 1, i++) {
        if (bits & 1 == 1) return iLimit * j + i;
      }
      j++;
      if (j >= length) return null;
      bits = this[j];
      i = 0;
    }
  }

  int? bFirstTo(int iLimit, int jTo, int iTo) {
    assert(jTo >= 0 && jTo < length && iTo >= 0 && iTo < iLimit);
    var j = 0, bits = this[j];
    for (; j < jTo; j++, bits = this[j]) {
      for (var i = 0; bits > 0; i++, bits >>= 1) {
        if (bits & 1 == 1) return iLimit * j + i;
      }
    }
    final last = math.min(iTo, bits.bitLength - 1);
    for (var i = 0; i <= last; bits >>= 1, i++) {
      if (bits & 1 == 1) return iLimit * jTo + i;
    }
    return null;
  }

  int? bFirstBetween(int iLimit, int jFrom, int iFrom, int jTo, int iTo) {
    assert(jFrom >= 0 && jFrom < length && iFrom >= 0 && iFrom < iLimit);
    assert(jTo >= 0 && jTo < length && iTo > 0 && iTo < iLimit);
    assert(jFrom < jTo || (jFrom == jTo && iFrom < iTo));

    var bits = this[jFrom] >> iFrom, j = jFrom, i = iFrom;
    while (true) {
      for (; bits > 0; bits >>= 1, i++) {
        if (bits & 1 == 1) return iLimit * j + i;
      }
      j++;
      bits = this[j];
      i = 0;
      if (j == jTo) break;
    }
    final last = math.min(iTo, bits.bitLength - 1);
    for (; i <= last; bits >>= 1, i++) {
      if (bits & 1 == 1) return iLimit * jTo + i;
    }
    return null;
  }

  ///
  ///
  ///
  int? bLastOf(int j) {
    assert(j >= 0 && j < length);
    for (var bits = this[j], i = bits.bitLength - 1; i >= 0; i--) {
      if (bits & 1 << i == 1 << i) return i;
    }
    return null;
  }

  int? bLastOfTo(int j, int iTo) {
    assert(j >= 0 && j < length && iTo > 0);
    for (var b = this[j], i = math.min(iTo, b.bitLength - 1); i >= 0; i--) {
      if (b & 1 << i == 1 << i) return i;
    }
    return null;
  }

  int? bLastOfFrom(int j, int iFrom) {
    assert(j >= 0 && j < length && iFrom > 0);
    for (var b = this[j], i = b.bitLength - 1; i >= iFrom; i--) {
      if (b & 1 << i == 1 << i) return i;
    }
    return null;
  }

  int? bLastOfBetween(int j, int iFrom, int iTo) {
    assert(j >= 0 && j < length && iFrom > 0 && iFrom < iTo);
    for (var b = this[j], i = math.min(iTo, b.bitLength - 1); i >= iFrom; i--) {
      if (b & 1 << i == 1 << i) return i;
    }
    return null;
  }

  ///
  ///
  ///
  int? bLast(int iLimit) {
    assert(iLimit > 0);
    for (var j = length - 1, bits = this[j]; j >= 0; j--) {
      for (var i = math.min(iLimit - 1, bits.bitLength - 1); i >= 0; i--) {
        if (bits & 1 << i == 1 << i) return iLimit * j + i;
      }
    }
    return null;
  }

  int? bLastTo(int iLimit, int jTo, int iTo) {
    assert(jTo >= 0 && jTo < length && iTo >= 0 && iTo < iLimit);

    var bits = this[jTo], j = jTo, i = math.min(iTo, bits.bitLength - 1);
    while (true) {
      for (; i >= 0; i--, bits >>= 1) {
        if (bits & 1 << i == 1 << i) return iLimit * j + i;
      }
      j--;
      if (j < 0) return null;
      bits = this[j];
      i = bits.bitLength - 1;
    }
  }

  int? bLastFrom(int iLimit, int jFrom, int iFrom) {
    assert(jFrom >= 0 && jFrom < length && iFrom >= 0 && iFrom < iLimit);
    var j = length - 1, bits = this[j];
    for (; j < jFrom; j++, bits = this[j]) {
      for (var i = bits.bitLength; i >= 0; i--) {
        if (bits & 1 << i == 1 << i) return iLimit * j + i;
      }
    }
    for (var i = bits.bitLength - 1; i >= iFrom; i--) {
      if (bits & 1 << i == 1 << i) return iLimit * jFrom + i;
    }
    return null;
  }

  int? bLastBetween(int iLimit, int jTo, int iTo, int jFrom, int iFrom) {
    assert(jTo >= 0 && jTo < length && iTo >= 0 && iTo < iLimit);
    assert(jFrom >= 0 && jFrom < length && iFrom >= 0 && iFrom < iLimit);
    assert(jTo > jFrom || (jTo == jFrom && iTo > iFrom));

    var bits = this[jTo], j = jTo, i = iTo;
    while (true) {
      for (; i >= 0; i--) {
        if (bits & 1 << i == 1 << i) return iLimit * j + i;
      }
      j--;
      bits = this[j];
      if (j == jFrom) break;
      i = bits.bitLength;
    }
    for (i = bits.bitLength - 1; i >= iFrom; i--) {
      if (bits & 1 << i == 1 << i) return iLimit * jFrom + i;
    }
    return null;
  }

  ///
  /// [bFirstAfter]
  /// [bLastBefore]
  ///
  int? bFirstAfter(int index, int shift, int mask, int iLimit) {
    assert(index >= 0 && index < length * iLimit && mask + 1 == 1 << shift);
    index++;
    return bFirstFrom(iLimit, index >> shift, index & mask);
  }

  int? bLastBefore(int index, int shift, int mask, int iLimit) {
    assert(index > 1 && index <= length * iLimit && mask + 1 == 1 << shift);
    index--;
    return bLastTo(iLimit, index >> shift, index & mask);
  }

  ///
  /// [bitsOf], [bitsOfFrom], [bitsOfTo], [bitsOfBetween]
  /// [bitsMapOf], [bitsMapOfFrom], [bitsMapOfTo], [bitsMapOfBetween] todo
  ///
  /// [psOf], [psOfFrom], [psOfTo], [psOfBetween]
  /// [psMapOf], [psMapOfFrom], [psMapOfTo], [psMapOfBetween]
  /// [datesForwardOf], [datesForwardOfFrom], [datesForwardOfTo], [datesForwardOfBetween]
  /// [datesBackwardOf], [datesBackwardOfFrom], [datesBackwardOfTo], [datesBackwardOfBetween]
  ///

  ///
  ///
  ///
  Iterable<int> bitsOf(int j) sync* {
    assert(j >= 0 && j < length);
    for (var bits = this[j], i = 0; bits > 0; bits >>= 1, i++) {
      if (bits & 1 == 1) yield i;
    }
  }

  Iterable<int> bitsOfFrom(int j, int iFrom) sync* {
    assert(j >= 0 && j < length && iFrom > 0);
    for (var bits = this[j] >> iFrom, i = iFrom; bits > 0; bits >>= 1, i++) {
      if (bits & 1 == 1) yield i;
    }
  }

  Iterable<int> bitsOfTo(int j, int iTo) sync* {
    assert(j >= 0 && j < length && iTo > 0);
    var b = this[j], i = 0;
    for (final last = math.min(iTo, b.bitLength - 1); i <= last; b >>= 1, i++) {
      if (b & 1 == 1) yield i;
    }
  }

  Iterable<int> bitsOfBetween(int j, int iFrom, iTo) sync* {
    assert(j >= 0 && j < length && iFrom > 0 && iFrom < iTo);
    var b = this[j] >> iFrom, i = iFrom;
    for (final last = math.min(iTo, b.bitLength - 1); i <= last; b >>= 1, i++) {
      if (b & 1 == 1) yield i;
    }
  }

  ///
  ///
  ///
  Iterable<int> psOf(int j) sync* {
    assert(j >= 0 && j < length);
    for (var bits = this[j], i = 1; bits > 0; bits >>= 1, i++) {
      if (bits & 1 == 1) yield i;
    }
  }

  Iterable<int> psOfFrom(int j, int pFrom) sync* {
    assert(j >= 0 && j < length && pFrom > 0);
    for (
      var bits = this[j] >> pFrom, p = pFrom + 1;
      bits > 0;
      bits >>= 1, p++
    ) {
      if (bits & 1 == 1) yield p;
    }
  }

  Iterable<int> psOfTo(int j, int pTo) sync* {
    assert(j >= 0 && j < length && pTo > 0);
    var b = this[j], p = 1;
    for (final last = math.min(pTo, b.bitLength); p <= last; b >>= 1, p++) {
      if (b & 1 == 1) yield p;
    }
  }

  Iterable<int> psOfBetween(int j, int pFrom, int pTo) sync* {
    assert(j >= 0 && j < length && pFrom > 0 && pFrom < pTo);
    var b = this[j] >> pFrom, i = pFrom;
    for (final last = math.min(pTo, b.bitLength); i <= last; b >>= 1, i++) {
      if (b & 1 == 1) yield i;
    }
  }

  ///
  ///
  ///
  Iterable<(int, int, int)> datesForwardOf(
    int j,
    int y,
    int m, [
    int d = 1,
  ]) sync* {
    assert(this is Uint32List && this[j] >> _monthDaysOf(y, m) == 0);
    assert(j >= 0 && j < length && _isValidMonth(m) && _isValidDay(y, m, d));
    for (var bits = this[j] >> d - 1; bits > 0; bits >>= 1, d++) {
      if (bits & 1 == 1) yield (y, m, d);
    }
  }

  Iterable<(int, int, int)> datesForwardOfTo(
    int j,
    int y,
    int m,
    int dLast, [
    int d = 1,
  ]) sync* {
    assert(this is Uint32List && this[j] >> _monthDaysOf(y, m) == 0);
    assert(j >= 0 && j < length && _isValidMonth(m) && _isValidDay(y, m, d));
    for (var bits = this[j] >> d - 1; d <= dLast; bits >>= 1, d++) {
      if (bits & 1 == 1) yield (y, m, d);
    }
  }

  ///
  /// todo
  /// [pAvailable], [mapPAvailable]
  /// [pAvailableForward], [mapPAvailableFrom]
  /// [pAvailableBackward], [mapPAvailableTo]
  /// [pAvailableForwardTo], [mapPAvailableRecent]
  /// [pAvailableBackwardTo], [mapPAvailableLatest]
  ///
  ///
  ///
  Iterable<int> pAvailable(int sizeEach) sync* {
    assert(sizeEach > 0);
    final length = this.length;
    for (var j = 0, p = 1; j < length; p = sizeEach * j + 1) {
      for (var bits = this[j]; bits > 0; bits >>= 1, p++) {
        if (bits & 1 == 1) yield p;
      }
      j++;
      assert(p <= sizeEach * j);
    }
  }

  Iterable<int> pAvailableForward(int sizeEach, int j, int i) sync* {
    final length = this.length;
    assert(sizeEach > 0 && j < length && i.isRangeOpenUpper(0, sizeEach));
    if (j < 0) j = 0;

    var bits = this[j] >> i, p = sizeEach * j + i + 1;
    while (true) {
      for (; bits > 0; bits >>= 1, p++) {
        if (bits & 1 == 1) yield p;
      }
      j++;
      assert(p <= sizeEach * j);
      if (j == length) return;
      bits = this[j];
      p = sizeEach * j + 1;
    }
  }

  Iterable<int> pAvailableBackward(int sizeEach, int j, int i) sync* {
    final length = this.length;
    assert(sizeEach > 0 && j >= 0 && i.isRangeOpenUpper(0, sizeEach));
    if (j >= length) j = length - 1;

    final iLast = sizeEach - 1;
    var bits = this[j], p = sizeEach * j + 1;
    while (true) {
      for (; i >= 0; i--) {
        if (bits & 1 << i == 1 << i) yield p + i;
      }
      j--;
      if (j < 0) return;
      bits = this[j];
      p -= sizeEach;
      i = iLast;
    }
  }

  Iterable<int> pAvailableForwardTo(
    int sizeEach,
    int j,
    int i,
    int? jTo,
    int? iTo,
  ) sync* {
    assert(() {
      if (sizeEach < 1) return false;
      if (j < 0 || j >= length) return false;
      if (jTo != null && (jTo < 0 || jTo < j)) return false;
      if (i < 0 || i >= sizeEach) return false;
      if (iTo != null && (iTo < 0 || (jTo == j && iTo < i))) return false;
      return true;
    }());
    if (jTo == null && iTo == null) {
      yield* pAvailableForward(sizeEach, j, i);
      return;
    }

    final jLast = jTo ?? length - 1, iLast = iTo ?? sizeEach - 1;
    var bits = this[j] >> i, p = sizeEach * j + 1;
    while (true) {
      for (; bits > 0; p++, bits >>= 1) {
        if (bits & 1 == 1) yield p;
      }
      j++;
      assert(p <= sizeEach * j);
      bits = this[j];
      p = sizeEach * j + 1;
      if (j == jLast) break;
    }
    for (i = 0; i <= iLast; i++, bits >>= 1) {
      if (bits & 1 == 1) yield p + i;
    }
  }

  Iterable<int> pAvailableBackwardTo(
    int sizeEach,
    int j,
    int i, [
    int jTo = 0,
    int iTo = 0,
  ]) sync* {
    assert(() {
      if (sizeEach < 1) return false;
      if (j < 0 || j >= length) return false;
      if (jTo < 0 || jTo > j) return false;
      if (i < 0 || i >= sizeEach) return false;
      if (iTo < 0 || (jTo == j && iTo > i)) return false;
      return true;
    }());
    if (jTo == 0 && iTo == 0) {
      yield* pAvailableBackward(sizeEach, j, i);
      return;
    }

    final iLast = sizeEach - 1;
    var bits = this[j], p = sizeEach * j + 1;
    while (true) {
      for (; i >= 0; i--) {
        if (bits & 1 << i == 1 << i) yield p + i;
      }
      j--;
      bits = this[j];
      p -= sizeEach;
      i = iLast;
      if (j == jTo) break;
    }
    for (; i >= iTo; i--) {
      if (bits & 1 << i == 1 << i) yield p + i;
    }
  }

  ///
  ///
  ///
  // Iterable<T> mapPAvailable<T>(int sizeEach, T Function(int) mapper) sync* {
  //   assert(sizeEach > 0);
  //   final length = this.length;
  //   for (var j = 0, index = 0; j < length; index = sizeEach * j) {
  //     for (var bits = this[j]; bits > 0; index++, bits >>= 1) {
  //       if (bits & 1 == 1) yield mapper(index);
  //     }
  //     j++;
  //     assert(index < sizeEach * j);
  //   }
  // }
  //
  // Iterable<T> mapPAvailableFrom<T>(
  //   int j,
  //   int i,
  //   int sizeEach,
  //   bool includeFrom,
  //   T Function(int) mapper,
  // ) sync* {
  //   if (!includeFrom) {
  //     i++;
  //     if (i == sizeEach) {
  //       j++;
  //       i = 0;
  //     }
  //   }
  //   final length = this.length;
  //   assert(sizeEach > 0);
  //   assert(j.isRangeOpenUpper(0, length) && i.isRangeOpenUpper(0, sizeEach));
  //
  //   var bits = this[j] >> i, p = sizeEach * j;
  //   while (true) {
  //     for (; bits > 0; p++, bits >>= 1) {
  //       if (bits & 1 == 1) yield mapper(p);
  //     }
  //     j++;
  //     assert(p < sizeEach * j);
  //     bits = this[j];
  //     p = sizeEach * j;
  //     if (j == length) break;
  //   }
  // }
  //
  // Iterable<int> mapPAvailableTo(
  //   int j,
  //   int i,
  //   int sizeEach,
  //   bool inclusive,
  // ) sync* {
  //   if (!inclusive) {
  //     i--;
  //     if (i < 0) {
  //       j--;
  //       i = sizeEach - 1;
  //     }
  //   }
  //   assert(j >= 0 && i.isRangeOpenUpper(0, sizeEach) && sizeEach > 0);
  //   final length = this.length;
  //   if (j >= length) j = length - 1;
  //   var bits = this[j] >> i, p = sizeEach * j;
  //   while (true) {
  //     for (; i >= 0; i--) {
  //       if (bits & 1 << i == 1 << i) yield p + i;
  //     }
  //     j--;
  //     if (j < 0) return;
  //     bits = this[j];
  //     p -= sizeEach;
  //     i = sizeEach - 1;
  //   }
  // }
  //
  // Iterable<T> mapPAvailableRecent<T>(
  //   int j,
  //   int i,
  //   int sizeEach,
  //   T Function(int) mapper, [
  //   int? jTo,
  //   int? iTo,
  // ]) sync* {
  //   assert(() {
  //     if (sizeEach < 1) return false;
  //     if (j != 0) {
  //       if (j < 0 || j >= length) return false;
  //       if (jTo != null && jTo < j) return false;
  //     }
  //     if (i != 0) {
  //       if (i < 0 || i >= sizeEach) return false;
  //       if (iTo != null && iTo < i) return false;
  //     }
  //     // if both null, call pAvailableFrom instead of pAvailableRecent
  //     return jTo != null || iTo != null;
  //   }());
  //
  //   final jLast = jTo ?? length - 1, iLast = iTo ?? sizeEach - 1;
  //   var bits = this[j] >> i, p = sizeEach * j;
  //   while (true) {
  //     for (; bits > 0; p++, bits >>= 1) {
  //       if (bits & 1 == 1) yield mapper(p);
  //     }
  //     j++;
  //     assert(p < sizeEach * j);
  //     bits = this[j];
  //     p = sizeEach * j;
  //     if (j == jLast) break;
  //   }
  //   for (i = 0; i <= iLast; i++, bits >>= 1) {
  //     if (bits & 1 == 1) yield mapper(p + i);
  //   }
  // }
  //
  // Iterable<T> mapPAvailableLatest<T>(
  //   int j,
  //   int i,
  //   int sizeEach,
  //   bool inclusive,
  //   T Function(int) mapper,
  // ) sync* {
  //   if (!inclusive) {
  //     i--;
  //     if (i < 0) {
  //       j--;
  //       i = sizeEach - 1;
  //     }
  //   }
  //   assert(j >= 0 && i.isRangeOpenUpper(0, sizeEach) && sizeEach > 0);
  //   final length = this.length;
  //   if (j >= length) j = length - 1;
  //   var bits = this[j] >> i, p = sizeEach * j;
  //   while (true) {
  //     for (; i >= 0; i--) {
  //       if (bits & 1 << i == 1 << i) yield mapper(p + i);
  //     }
  //     j--;
  //     if (j < 0) return;
  //     bits = this[j];
  //     p -= sizeEach;
  //     i = sizeEach - 1;
  //   }
  // }
}
