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
/// return integer                : [bForwardOf], ...
/// return iterable integer       : [pAvailable], ...
/// return iterable provided type : [mapPAvailable], ...
///
extension TypedIntList on TypedDataList<int> {
  // static const int limit32 = 33;
  // static const int limit64 = 65;
  static const int countsAByte = 8;
  static const int limit4 = 5;
  static const int mask4 = 3;
  static const int shift4 = 2;
  static const int limit8 = 9;
  static const int mask8 = 7;
  static const int shift8 = 3;
  static const int sizeEach8 = Uint8List.bytesPerElement * countsAByte;
  static const int limit16 = 17;
  static const int mask16 = 15;
  static const int shift16 = 4;
  static const int sizeEach16 = Uint16List.bytesPerElement * countsAByte;
  static const int mask32 = 31;
  static const int shift32 = 5;
  static const int sizeEach32 = Uint32List.bytesPerElement * countsAByte;
  static const int mask64 = 63;
  static const int shift64 = 6;
  static const int sizeEach64 = Uint64List.bytesPerElement * countsAByte;

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
  /// [bFirst], [bLast]
  ///
  /// [bForwardOf], [bForwardOfFrom], [bForwardOfTo], [bForwardOfBetween], ...
  /// [bForward], [bForwardFrom], [bForwardTo], [bForwardBetween], ...
  /// [bForwardAfter]
  ///
  /// [bBackwardOf], [bBackwardOfFrom], [bBackwardOfTo], [bBackwardOfBetween], ...
  /// [bBackward], [bBackwardFrom], [bBackwardTo], [bBackwardBetween], ...
  /// [bBackwardBefore]
  ///

  ///
  ///
  ///
  int? bFirst(int iLimit) {
    final length = this.length;
    for (var j = 0, bits = this[j]; j < length; j++) {
      for (var i = 0; bits > 0; bits >>= 1, i++) {
        if (bits & 1 == 1) return iLimit * j + i;
      }
    }
    return null;
  }

  int? bLast(int iLimit) {
    for (var j = length - 1, bits = this[j]; j >= 0; j--) {
      for (var i = bits.bitLength - 1; i >= 0; i >>= 1) {
        final mask = 1 << i;
        if (bits & mask == mask) return iLimit * j + i;
      }
    }
    return null;
  }

  ///
  ///
  ///
  int? bForwardOf(int j) {
    assert(j >= 0 && j < length);
    for (var bits = this[j], i = 0; bits > 0; bits >>= 1, i++) {
      if (bits & 1 == 1) return i;
    }
    return null;
  }

  // int? bForwardOfN(int j, int n) {
  //   assert(j >= 0 && j < length);
  //   for (var bits = this[j], i = 0; bits > 0; bits >>= 1, i++) {
  //     if (bits & 1 == 1 && --n == 0) return i;
  //   }
  //   return null;
  // }

  int? bForwardOfFrom(int j, int i) {
    assert(j >= 0 && j < length && i >= 0);
    for (var bits = this[j] >> i; bits > 0; bits >>= 1, i++) {
      if (bits & 1 == 1) return i;
    }
    return null;
  }

  int? bForwardOfTo(int j, int iTo) {
    assert(j >= 0 && j < length && iTo > 0);
    var bits = this[j], i = 0;
    for (
      final iLast = math.min(iTo, bits.bitLength - 1);
      i <= iLast;
      bits >>= 1, i++
    ) {
      if (bits & 1 == 1) return i;
    }
    return null;
  }

  int? bForwardOfBetween(int j, int iFrom, int iTo) {
    assert(j >= 0 && j < length && iFrom > 0 && iFrom < iTo);
    var bits = this[j], i = iFrom;
    for (
      final iLast = math.min(iTo, bits.bitLength - 1);
      i <= iLast;
      bits >>= 1, i++
    ) {
      if (bits & 1 == 1) return i;
    }
    return null;
  }

  ///
  ///
  ///
  int? bForward(int iLimit) {
    assert(iLimit > 0);
    final length = this.length;
    for (var j = 0, bits = this[j]; j < length; j++) {
      for (var i = 0; bits > 0; i++, bits >>= 1) {
        if (bits & 1 == 1) return iLimit * j + i;
      }
    }
    return null;
  }

  int? bForwardFrom(int iLimit, int jFrom, int iFrom) {
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

  int? bForwardTo(int iLimit, int jTo, int iTo) {
    assert(jTo >= 0 && jTo < length && iTo >= 0 && iTo < iLimit);
    var j = 0, bits = this[j], i = 0;
    for (; j < jTo; j++, bits = this[j]) {
      for (; bits > 0; i++, bits >>= 1) {
        if (bits & 1 == 1) return iLimit * j + i;
      }
      i = 0;
    }
    for (
      final last = math.min(iTo, bits.bitLength - 1);
      i <= last;
      bits >>= 1, i++
    ) {
      if (bits & 1 == 1) return iLimit * jTo + i;
    }
    return null;
  }

  int? bForwardBetween(int iLimit, int jFrom, int iFrom, int jTo, int iTo) {
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
    for (
      final last = math.min(iTo, bits.bitLength - 1);
      i <= last;
      bits >>= 1, i++
    ) {
      if (bits & 1 == 1) return iLimit * jTo + i;
    }
    return null;
  }

  ///
  ///
  ///
  int? bBackwardOf(int j) {
    assert(j >= 0 && j < length);
    for (var bits = this[j], i = bits.bitLength - 1; i >= 0; i--) {
      final mask = 1 << i;
      if (bits & mask == mask) return i;
    }
    return null;
  }

  int? bBackwardOfFrom(int j, int iFrom) {
    assert(j >= 0 && j < length && iFrom > 0);
    for (
      var bits = this[j], i = math.min(iFrom, bits.bitLength - 1);
      i >= 0;
      i--
    ) {
      final mask = 1 << i;
      if (bits & mask == mask) return i;
    }
    return null;
  }

  int? bBackwardOfTo(int j, int iTo) {
    assert(j >= 0 && j < length && iTo > 0);
    for (var bits = this[j], i = bits.bitLength - 1; i >= iTo; i--) {
      final mask = 1 << i;
      if (bits & mask == mask) return i;
    }
    return null;
  }

  int? bBackwardOfBetween(int j, int iFrom, int iTo) {
    assert(j >= 0 && j < length && iTo > 0 && iTo < iFrom);
    for (
      var bits = this[j], i = math.min(iFrom, bits.bitLength - 1);
      i >= iTo;
      i--
    ) {
      final mask = 1 << i;
      if (bits & mask == mask) return i;
    }
    return null;
  }

  ///
  ///
  ///
  int? bBackward(int iLimit) {
    assert(iLimit > 0);
    for (var j = length - 1, bits = this[j]; j >= 0; j--) {
      for (var i = math.min(iLimit - 1, bits.bitLength - 1); i >= 0; i--) {
        final mask = 1 << i;
        if (bits & mask == mask) return iLimit * j + i;
      }
    }
    return null;
  }

  int? bBackwardFrom(int iLimit, int jFrom, int iFrom) {
    assert(jFrom >= 0 && jFrom < length && iFrom >= 0 && iFrom < iLimit);

    var bits = this[jFrom], j = jFrom, i = math.min(iFrom, bits.bitLength - 1);
    while (true) {
      for (; i >= 0; i--) {
        final mask = 1 << i;
        if (bits & mask == mask) return iLimit * j + i;
      }
      j--;
      if (j < 0) return null;
      bits = this[j];
      i = bits.bitLength - 1;
    }
  }

  int? bBackwardTo(int iLimit, int jTo, int iTo) {
    assert(jTo >= 0 && jTo < length && iTo >= 0 && iTo < iLimit);
    var j = length - 1, bits = this[j];
    for (; j < jTo; j++, bits = this[j]) {
      for (var i = bits.bitLength; i >= 0; i--) {
        final mask = 1 << i;
        if (bits & mask == mask) return iLimit * j + i;
      }
    }
    for (var i = bits.bitLength - 1; i >= iTo; i--) {
      final mask = 1 << i;
      if (bits & mask == mask) return iLimit * jTo + i;
    }
    return null;
  }

  int? bBackwardBetween(int iLimit, int jTo, int iTo, int jFrom, int iFrom) {
    assert(jTo >= 0 && jTo < length && iTo >= 0 && iTo < iLimit);
    assert(jFrom >= 0 && jFrom < length && iFrom >= 0 && iFrom < iLimit);
    assert(jTo > jFrom || (jTo == jFrom && iTo > iFrom));

    var bits = this[jTo], j = jTo, i = iTo;
    while (true) {
      for (; i >= 0; i--) {
        final mask = 1 << i;
        if (bits & mask == mask) return iLimit * j + i;
      }
      j--;
      bits = this[j];
      if (j == jFrom) break;
      i = bits.bitLength;
    }
    for (i = bits.bitLength - 1; i >= iFrom; i--) {
      final mask = 1 << i;
      if (bits & mask == mask) return iLimit * jFrom + i;
    }
    return null;
  }

  ///
  /// [bForwardAfter]
  /// [bBackwardBefore]
  ///
  int? bForwardAfter(int index, int shift, int mask, int iLimit) {
    assert(index >= 0 && index < length * iLimit && mask + 1 == 1 << shift);
    index++;
    return bForwardFrom(iLimit, index >> shift, index & mask);
  }

  int? bBackwardBefore(int index, int shift, int mask, int iLimit) {
    assert(index > 1 && index <= length * iLimit && mask + 1 == 1 << shift);
    index--;
    return bBackwardFrom(iLimit, index >> shift, index & mask);
  }

  ///
  /// (algorithm is same as [bForwardOf], ...)
  /// [bitsForwardOf], [bitsForwardOfFrom], [bitsForwardOfTo], [bitsForwardOfBetween]
  /// [bitsForwardMapOf], [bitsForwardMapOfFrom], [bitsForwardMapOfTo], [bitsForwardMapOfBetween]
  ///
  /// (algorithm is same as [bBackwardOf], ...)
  /// [bitsBackwardOf], [bitsBackwardOfFrom], [bitsBackwardOfTo], [bitsBackwardOfBetween]
  /// [bitsBackwardMapOf], [bitsBackwardMapOfFrom], [bitsBackwardMapOfTo], [bitsBackwardMapOfBetween]
  ///
  /// (algorithm is same as [bitsForwardOfFrom], [bitsForwardOfBetween], [bBackwardOf])
  /// [datesForwardOf], [datesForwardOfBetween], [datesBackwardOf]
  ///
  ///

  ///
  ///
  ///
  Iterable<int> bitsForwardOf(int j, [int bStart = 0]) sync* {
    assert(j >= 0 && j < length);
    for (var bits = this[j], b = bStart; bits > 0; bits >>= 1, b++) {
      if (bits & 1 == 1) yield b;
    }
  }

  Iterable<int> bitsForwardOfFrom(int j, int iFrom, [int? bStart]) sync* {
    assert(j >= 0 && j < length && iFrom > 0);
    for (
      var bits = this[j] >> iFrom, b = bStart ?? iFrom;
      bits > 0;
      bits >>= 1, b++
    ) {
      if (bits & 1 == 1) yield b;
    }
  }

  Iterable<int> bitsForwardOfTo(int j, int bTo, [int bStart = 0]) sync* {
    assert(j >= 0 && j < length);
    var bits = this[j], b = bStart;
    for (
      final bBackward = math.min(bTo, bStart + bits.bitLength - 1);
      b <= bBackward;
      bits >>= 1, b++
    ) {
      if (bits & 1 == 1) yield b;
    }
  }

  Iterable<int> bitsForwardOfBetween(
    int j,
    int iFrom,
    int bTo, [
    int? bStart,
  ]) sync* {
    assert(j >= 0 && j < length && iFrom > 0 && iFrom < bTo);
    var bits = this[j] >> iFrom, b = bStart ?? iFrom;
    for (
      final iLast = math.min(bTo, bits.bitLength - 1);
      b <= iLast;
      bits >>= 1, b++
    ) {
      if (bits & 1 == 1) yield b;
    }
  }

  //
  Iterable<T> bitsForwardMapOf<T>(
    T Function(int) mapper,
    int j, [
    int bStart = 0,
  ]) sync* {
    assert(j >= 0 && j < length);
    for (var bits = this[j], b = bStart; bits > 0; bits >>= 1, b++) {
      if (bits & 1 == 1) yield mapper(b);
    }
  }

  Iterable<T> bitsForwardMapOfFrom<T>(
    T Function(int) mapper,
    int j,
    int iFrom, [
    int? bStart,
  ]) sync* {
    assert(j >= 0 && j < length && iFrom > 0);
    for (
      var bits = this[j] >> iFrom, b = bStart ?? iFrom;
      bits > 0;
      bits >>= 1, b++
    ) {
      if (bits & 1 == 1) yield mapper(b);
    }
  }

  Iterable<T> bitsForwardMapOfTo<T>(
    T Function(int) mapper,
    int j,
    int bTo, [
    int bStart = 0,
  ]) sync* {
    assert(j >= 0 && j < length);
    var bits = this[j], b = bStart;
    for (
      final bBackward = math.min(bTo, bStart + bits.bitLength - 1);
      b <= bBackward;
      bits >>= 1, b++
    ) {
      if (bits & 1 == 1) yield mapper(b);
    }
  }

  Iterable<T> bitsForwardMapOfBetween<T>(
    T Function(int) mapper,
    int j,
    int iFrom,
    int bTo, [
    int? bStart,
  ]) sync* {
    assert(j >= 0 && j < length && iFrom > 0 && iFrom < bTo);
    var bits = this[j] >> iFrom, b = bStart ?? iFrom;
    for (
      final iLast = math.min(bTo, bits.bitLength - 1);
      b <= iLast;
      bits >>= 1, b++
    ) {
      if (bits & 1 == 1) yield mapper(b);
    }
  }

  ///
  ///
  ///
  Iterable<int> bitsBackwardOf(int j) sync* {
    assert(j >= 0 && j < length);
    for (var bits = this[j], i = bits.bitLength - 1; i >= 0; i--) {
      final mask = 1 << i;
      if (bits & mask == mask) yield i;
    }
  }

  Iterable<int> bitsBackwardOfFrom(int j, int iFrom) sync* {
    assert(j >= 0 && j < length && iFrom > 0);
    for (
      var bits = this[j], i = math.min(iFrom, bits.bitLength - 1);
      i >= 0;
      i--
    ) {
      final mask = 1 << i;
      if (bits & mask == mask) yield i;
    }
  }

  Iterable<int> bitsBackwardOfTo(int j, int iTo) sync* {
    assert(j >= 0 && j < length && iTo > 0);
    for (var bits = this[j], i = bits.bitLength - 1; i >= iTo; i--) {
      final mask = 1 << i;
      if (bits & mask == mask) yield i;
    }
  }

  Iterable<int> bitsBackwardOfBetween(int j, int iFrom, int iTo) sync* {
    assert(j >= 0 && j < length && iTo > 0 && iTo < iFrom);
    for (
      var bits = this[j], i = math.min(iFrom, bits.bitLength - 1);
      i >= iTo;
      i--
    ) {
      final mask = 1 << i;
      if (bits & mask == mask) yield i;
    }
  }

  //
  Iterable<T> bitsBackwardMapOf<T>(T Function(int) mapper, int j) sync* {
    assert(j >= 0 && j < length);
    for (var bits = this[j], i = bits.bitLength - 1; i >= 0; i--) {
      final mask = 1 << i;
      if (bits & mask == mask) yield mapper(i);
    }
  }

  Iterable<T> bitsBackwardMapOfFrom<T>(
    T Function(int) mapper,
    int j,
    int iFrom,
  ) sync* {
    assert(j >= 0 && j < length && iFrom > 0);
    for (
      var bits = this[j], i = math.min(iFrom, bits.bitLength - 1);
      i >= 0;
      i--
    ) {
      final mask = 1 << i;
      if (bits & mask == mask) yield mapper(i);
    }
  }

  Iterable<T> bitsBackwardMapOfTo<T>(
    T Function(int) mapper,
    int j,
    int iTo,
  ) sync* {
    assert(j >= 0 && j < length && iTo > 0);
    for (var bits = this[j], i = bits.bitLength - 1; i >= iTo; i--) {
      final mask = 1 << i;
      if (bits & mask == mask) yield mapper(i);
    }
  }

  Iterable<T> bitsBackwardMapOfBetween<T>(
    T Function(int) mapper,
    int j,
    int iFrom,
    int iTo,
  ) sync* {
    assert(j >= 0 && j < length && iTo > 0 && iTo < iFrom);
    for (
      var bits = this[j], i = math.min(iFrom, bits.bitLength - 1);
      i >= iTo;
      i--
    ) {
      final mask = 1 << i;
      if (bits & mask == mask) yield mapper(i);
    }
  }

  ///
  ///
  ///
  Iterable<(int, int, int)> datesForwardOf(
    int j,
    int y,
    int m, [
    int dFrom = 1,
  ]) sync* {
    assert(this is Uint32List && this[j] >> _monthDaysOf(y, m) == 0);
    assert(_isValidMonth(m) && _isValidDay(y, m, dFrom));
    assert(j >= 0 && j < length);
    for (var bits = this[j] >> dFrom - 1; bits > 0; bits >>= 1, dFrom++) {
      if (bits & 1 == 1) yield (y, m, dFrom);
    }
  }

  Iterable<(int, int, int)> datesForwardOfBetween(
    int j,
    int y,
    int m,
    int dLast, [
    int dFrom = 1,
  ]) sync* {
    assert(this is Uint32List && this[j] >> _monthDaysOf(y, m) == 0);
    assert(_isValidMonth(m) && _isValidDay(y, m, dFrom));
    assert(j >= 0 && j < length);
    var bits = this[j] >> dFrom - 1;
    for (
      final last = math.min(dLast, bits.bitLength);
      dFrom <= last;
      bits >>= 1, dFrom++
    ) {
      if (bits & 1 == 1) yield (y, m, dFrom);
    }
  }

  Iterable<int> datesBackwardOf(
    int j,
    int y,
    int m, [
    int? dFrom,
    int dTo = 1,
  ]) sync* {
    assert(this is Uint32List && this[j] >> _monthDaysOf(y, m) == 0);
    assert(_isValidMonth(m) && _isValidDay(y, m, dTo));
    assert(j >= 0 && j < length);
    for (
      var bits = this[j],
          d = math.min(dFrom ?? _monthDaysOf(y, m), bits.bitLength - 1);
      d >= dTo;
      d--
    ) {
      final mask = 1 << d;
      if (bits & mask == mask) yield d;
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
        final mask = 1 << i;
        if (bits & mask == mask) yield p + i;
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
        final mask = 1 << i;
        if (bits & mask == mask) yield p + i;
      }
      j--;
      bits = this[j];
      p -= sizeEach;
      i = iLast;
      if (j == jTo) break;
    }
    for (; i >= iTo; i--) {
      final mask = 1 << i;
      if (bits & mask == mask) yield p + i;
    }
  }
}
