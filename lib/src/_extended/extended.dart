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
/// instances methods:
/// return void                   : [pConsume1], ...
/// return bool                   : [pOn], ...
/// return integer                : [bFirstOf], ...
/// return iterable integer       : [bitsForward], ...
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
  /// [pConsume1], [pConsume0]
  /// [pSet], [pClear]
  ///
  void pConsume1(void Function(int p) consume, int iLimit, [int? jLimit]) {
    jLimit ??= length - 1;
    assert(iLimit > 0 && jLimit > 0 && jLimit < length);
    for (var j = 0, p = 1; j < jLimit; j++, p = iLimit * j + 1) {
      for (var bits = this[j]; bits > 0; bits >>= 1, p++) {
        if (bits & 1 == 1) consume(p);
      }
    }
  }

  void pConsume0(void Function(int p) consume, int iLimit, [int? jLimit]) {
    jLimit ??= length - 1;
    assert(iLimit > 0 && jLimit > 0 && jLimit < length);
    for (var j = 0, p = 1; j < jLimit; j++, p = iLimit * j + 1) {
      for (var bits = this[j]; bits > 0; bits >>= 1, p++) {
        if (bits & 1 == 0) consume(p);
      }
    }
  }

  void pSet(int p, int shift, int mask) {
    assert(p > 0 && mask + 1 == 1 << shift);
    this[--p >> shift] |= 1 << (p & mask);
  }

  void pClear(int p, int shift, int mask) {
    assert(p > 0 && mask + 1 == 1 << shift);
    this[--p >> shift] &= ~(1 << (p & mask));
  }

  ///
  /// [pOn]
  ///
  bool pOn(int p, int shift, int mask) {
    assert(p > 0 && mask + 1 == 1 << shift);
    final b = p - 1;
    return this[b >> shift] >> (b & mask) & 1 == 1;
  }

  ///
  /// [bFirstOf], [bFirstOfFrom], [bFirstOfTo], [bFirstOfBetween], ...
  /// [bFirst], [bFirstFrom], [bFirstTo], [bFirstBetween], ...
  /// [bFirstAfter]
  ///
  /// [bLastOf], [bLastOfFrom], [bLastOfTo], [bLastOfBetween], ...
  /// [bLast], [bLastFrom], [bLastTo], [bLastBetween], ...
  /// [bLastBefore]
  ///
  /// the purpose of "[b] == 1" in first-functions is to be consistent with last-functions,
  /// while it's also possible to start from 0 instead of 1.
  ///

  ///
  ///
  ///
  int? bFirstOf(int j, [int b = 1]) {
    assert(j >= 0 && j < length);
    for (var bits = this[j]; bits > 0; bits >>= 1, b++) {
      if (bits & 1 == 1) return b;
    }
    return null;
  }

  // int? bFirstNOf(int j, int n, [int b = 1]) {
  //   assert(j >= 0 && j < length);
  //   for (var bits = this[j]; bits > 0; bits >>= 1, b++) {
  //     if (bits & 1 == 1 && --n == 0) return b;
  //   }
  //   return null;
  // }

  int? bFirstOfFrom(int j, int i, [int b = 1]) {
    assert(j >= 0 && j < length && i >= 0);
    for (var bits = this[j] >> i; bits > 0; bits >>= 1, b++) {
      if (bits & 1 == 1) return b;
    }
    return null;
  }

  int? bFirstOfTo(int j, int iTo, [int b = 1]) {
    assert(j >= 0 && j < length && iTo > 0);
    final smallest = 1 << iTo;
    for (var bits = this[j]; bits >= smallest; bits >>= 1, b++) {
      if (bits & 1 == 1) return b;
    }
    return null;
  }

  int? bFirstOfBetween(int j, int i, int iTo, [int b = 1]) {
    assert(j >= 0 && j < length && i > 0 && i < iTo);
    final smallest = 1 << iTo;
    b += i;
    for (var bits = this[j] >> i; bits >= smallest; bits >>= 1, b++) {
      if (bits & 1 == 1) return b;
    }
    return null;
  }

  ///
  ///
  ///
  int? bFirst(int iLimit, [int b = 1]) {
    assert(iLimit > 0);
    final length = this.length;
    for (var j = 0, bits = this[j]; j < length; j++) {
      for (var i = b; bits > 0; bits >>= 1, i++) {
        if (bits & 1 == 1) return iLimit * j + i;
      }
    }
    return null;
  }

  int? bFirstFrom(int iLimit, int j, int i, [int b = 1]) {
    assert(j >= 0 && j < this.length && i >= 0 && i < iLimit);
    final length = this.length;
    var bits = this[j] >> i;
    while (true) {
      for (i = b; bits > 0; bits >>= 1, i++) {
        if (bits & 1 == 1) return i;
      }
      if (++j >= length) return null;
      bits = this[j];
    }
  }

  int? bFirstTo(int iLimit, int jTo, int iTo, [int b = 1]) {
    assert(jTo >= 0 && jTo < length && iTo >= 0 && iTo < iLimit);
    var bits = this[0];
    for (var j = 0; j < jTo; j++, bits = this[j]) {
      for (var i = b; bits > 0; bits >>= 1, i++) {
        if (bits & 1 == 1) return iLimit * j + i;
      }
    }
    final smallest = 1 << iTo;
    for (var i = b; bits >= smallest; bits >>= 1, i++) {
      if (bits & 1 == 1) return iLimit * jTo + i;
    }
    return null;
  }

  int? bFirstBetween(int iLimit, int j, int i, int jTo, int iTo, [int b = 1]) {
    assert(j >= 0 && j <= jTo && jTo < length);
    assert(i >= 0 && i < iLimit && iTo > 0 && iTo < iLimit);

    var bits = this[j] >> i;
    for (var j = 0; j < jTo; j++, bits = this[j]) {
      for (var i = b; bits > 0; bits >>= 1, i++) {
        if (bits & 1 == 1) return iLimit * j + i;
      }
    }
    final smallest = 1 << iTo;
    for (var i = b; bits >= smallest; bits >>= 1, i++) {
      if (bits & 1 == 1) return iLimit * jTo + i;
    }
    return null;
  }

  int? bFirstAfter(int index, int shift, int mask, int iLimit, [int b = 1]) {
    assert(index >= 0 && index < length * iLimit && mask + 1 == 1 << shift);
    if (++index >= length * iLimit - 1) return null;
    return bFirstFrom(iLimit, index >> shift, index & mask, b);
  }

  ///
  ///
  ///
  int? bLastOf(int j) {
    assert(j >= 0 && j < length);
    for (var bits = this[j], m = 1 << bits.bitLength - 1; m > 0; m >>= 1) {
      if (bits & m == m) return m.bitLength;
    }
    return null;
  }

  int? bLastOfFrom(int j, int i) {
    assert(j >= 0 && j < length && i > 0);
    for (
      var bits = this[j], m = 1 << math.min(i, bits.bitLength - 1);
      m > 0;
      m >>= 1
    ) {
      if (bits & m == m) return m.bitLength;
    }
    return null;
  }

  int? bLastOfTo(int j, int iTo) {
    assert(j >= 0 && j < length && iTo > 0);
    final smallest = 1 << iTo;
    for (
      var bits = this[j], m = 1 << bits.bitLength - 1;
      m >= smallest;
      m >>= 1
    ) {
      if (bits & m == m) return m.bitLength;
    }
    return null;
  }

  int? bLastOfBetween(int j, int i, int iTo) {
    assert(j >= 0 && j < length && iTo > 0 && iTo < i);
    final smallest = 1 << iTo;
    for (
      var bits = this[j], m = 1 << math.min(i, bits.bitLength - 1);
      m >= smallest;
      m >>= 1
    ) {
      if (bits & m == m) return m.bitLength;
    }
    return null;
  }

  ///
  ///
  ///
  int? bLast(int iLimit) {
    assert(iLimit > 0);
    for (var j = length - 1, bits = this[j]; j >= 0; j--) {
      for (var m = 1 << bits.bitLength - 1; m > 0; m >>= 1) {
        if (bits & m == m) return iLimit * j + m.bitLength;
      }
    }
    return null;
  }

  int? bLastFrom(int iLimit, int j, int i) {
    assert(j >= 0 && j < length && i >= 0 && i < iLimit);
    var bits = this[j], m = 1 << math.min(i, bits.bitLength - 1);
    while (true) {
      for (; m > 0; m >>= 1) {
        if (bits & m == m) return iLimit * j + m.bitLength;
      }
      if (--j < 0) return null;
      bits = this[j];
      m = 1 << bits.bitLength - 1;
    }
  }

  int? bLastTo(int iLimit, int jTo, int iTo) {
    assert(jTo >= 0 && jTo < length && iTo >= 0 && iTo < iLimit);
    var j = length - 1, bits = this[j], m = 1 << bits.bitLength - 1;
    for (; j > jTo; j--, bits = this[j], m = 1 << bits.bitLength - 1) {
      for (; m > 0; m >>= 1) {
        if (bits & m == m) return iLimit * j + m.bitLength;
      }
    }
    assert(bits.bitLength <= iLimit);
    for (final smallest = 1 << iTo; m >= smallest; m >>= 1) {
      if (bits & m == m) return iLimit * jTo + m.bitLength;
    }
    return null;
  }

  int? bLastBetween(int iLimit, int j, int i, int jTo, int iTo) {
    assert(jTo >= 0 && jTo <= j && j < length);
    assert(iTo >= 0 && iTo < iLimit && i >= 0 && i < iLimit);

    var bits = this[j], m = 1 << math.min(i, bits.bitLength - 1);
    for (; j > jTo; j--, bits = this[j], m = 1 << bits.bitLength - 1) {
      for (; m > 0; m >>= 1) {
        if (bits & m == m) return iLimit * j + m.bitLength;
      }
    }
    for (final smallest = 1 << iTo; m >= smallest; m >>= 1) {
      if (bits & m == m) return iLimit * jTo + m.bitLength;
    }
    return null;
  }

  int? bLastBefore(int index, int shift, int mask, int iLimit) {
    assert(index >= 0 && index < length * iLimit && mask + 1 == 1 << shift);
    if (--index < 1) return null;
    return bLastFrom(iLimit, index >> shift, index & mask);
  }

  ///
  /// (algorithm is same as [bFirstOf], ...)
  /// [bitsForwardOf], [bitsForwardOfFrom], [bitsForwardOfTo], [bitsForwardOfBetween]
  /// [bitsForwardMapOf], [bitsForwardMapOfFrom], [bitsForwardMapOfTo], [bitsForwardMapOfBetween]
  ///
  /// (algorithm is same as [bLastOf], ...)
  /// [bitsBackwardOf], [bitsBackwardOfFrom], [bitsBackwardOfTo], [bitsBackwardOfBetween]
  /// [bitsBackwardMapOf], [bitsBackwardMapOfFrom], [bitsBackwardMapOfTo], [bitsBackwardMapOfBetween]
  ///
  /// (algorithm is same as [bitsForwardOfFrom], [bitsForwardOfBetween], [bitsBackwardOf])
  /// [datesForwardOf], [datesForwardOfBetween], [datesBackwardOf]
  ///
  /// (algorithm is same as [bFirst], ...)
  /// [bitsForward], [bitsForwardFrom], [bitsForwardTo], [bitsForwardBetween], [bitsForwardAfter]
  ///
  /// (algorithm is same as [bLast], ...)
  /// [bitsBackward], [bitsBackwardFrom], [bitsBackwardTo], [bitsBackwardBetween], [bitsBackwardBefore]
  ///
  ///

  ///
  ///
  ///
  Iterable<int> bitsForwardOf(int j, [int b = 1]) sync* {
    assert(j >= 0 && j < length);
    for (var bits = this[j]; bits > 0; bits >>= 1, b++) {
      if (bits & 1 == 1) yield b;
    }
  }

  Iterable<int> bitsForwardOfFrom(int j, int i, [int b = 1]) sync* {
    assert(j >= 0 && j < length && i >= 0);
    b += i;
    for (var bits = this[j] >> i; bits > 0; bits >>= 1, b++) {
      if (bits & 1 == 1) yield b;
    }
  }

  Iterable<int> bitsForwardOfTo(int j, int iTo, [int b = 1]) sync* {
    assert(j >= 0 && j < length && iTo > 0);
    final smallest = 1 << iTo;
    for (var bits = this[j]; bits >= smallest; bits >>= 1, b++) {
      if (bits & 1 == 1) yield b;
    }
  }

  Iterable<int> bitsForwardOfBetween(int j, int i, int iTo, [int b = 1]) sync* {
    assert(j >= 0 && j < length && i > 0 && i < iTo);
    final smallest = 1 << iTo;
    b += i;
    for (var bits = this[j] >> i; bits >= smallest; bits >>= 1, b++) {
      if (bits & 1 == 1) yield b;
    }
  }

  //
  Iterable<T> bitsForwardMapOf<T>(
    T Function(int) mapper,
    int j, [
    int b = 1,
  ]) sync* {
    assert(j >= 0 && j < length);
    for (var bits = this[j]; bits > 0; bits >>= 1, b++) {
      if (bits & 1 == 1) yield mapper(b);
    }
  }

  Iterable<T> bitsForwardMapOfFrom<T>(
    T Function(int) mapper,
    int j,
    int i, [
    int b = 1,
  ]) sync* {
    assert(j >= 0 && j < length && i >= 0);
    b += i;
    for (var bits = this[j] >> i; bits > 0; bits >>= 1, b++) {
      if (bits & 1 == 1) yield mapper(b);
    }
  }

  Iterable<T> bitsForwardMapOfTo<T>(
    T Function(int) mapper,
    int j,
    int iTo, [
    int b = 1,
  ]) sync* {
    assert(j >= 0 && j < length && iTo > 0);
    final smallest = 1 << iTo;
    for (var bits = this[j]; bits >= smallest; bits >>= 1, b++) {
      if (bits & 1 == 1) yield mapper(b);
    }
  }

  Iterable<T> bitsForwardMapOfBetween<T>(
    T Function(int) mapper,
    int j,
    int i,
    int iTo, [
    int b = 1,
  ]) sync* {
    assert(j >= 0 && j < length && i > 0 && i < iTo);
    final smallest = 1 << iTo;
    b += i;
    for (var bits = this[j] >> i; bits >= smallest; bits >>= 1, b++) {
      if (bits & 1 == 1) yield mapper(b);
    }
  }

  ///
  ///
  ///
  Iterable<int> bitsBackwardOf(int j) sync* {
    assert(j >= 0 && j < length);
    for (var bits = this[j], m = 1 << bits.bitLength - 1; m > 0; m >>= 1) {
      if (bits & m == m) yield m.bitLength;
    }
  }

  Iterable<int> bitsBackwardOfFrom(int j, int i) sync* {
    assert(j >= 0 && j < length && i > 0);
    for (
      var bits = this[j], m = 1 << math.min(i, bits.bitLength - 1);
      m > 0;
      m >>= 1
    ) {
      if (bits & m == m) yield m.bitLength;
    }
  }

  Iterable<int> bitsBackwardOfTo(int j, int iTo) sync* {
    assert(j >= 0 && j < length && iTo > 0);
    final smallest = 1 << iTo;
    for (
      var bits = this[j], m = 1 << bits.bitLength - 1;
      m >= smallest;
      m >>= 1
    ) {
      if (bits & m == m) yield m.bitLength;
    }
  }

  Iterable<int> bitsBackwardOfBetween(int j, int i, int iTo) sync* {
    assert(j >= 0 && j < length && iTo > 0 && iTo < i);
    final smallest = 1 << iTo;
    for (
      var bits = this[j], m = 1 << math.min(i, bits.bitLength - 1);
      m >= smallest;
      m >>= 1
    ) {
      if (bits & m == m) yield m.bitLength;
    }
  }

  //
  Iterable<T> bitsBackwardMapOf<T>(T Function(int) mapper, int j) sync* {
    assert(j >= 0 && j < length);
    for (var bits = this[j], m = 1 << bits.bitLength - 1; m > 0; m >>= 1) {
      if (bits & m == m) yield mapper(m.bitLength);
    }
  }

  Iterable<T> bitsBackwardMapOfFrom<T>(
    T Function(int) mapper,
    int j,
    int i,
  ) sync* {
    assert(j >= 0 && j < length && i > 0);
    for (
      var bits = this[j], m = 1 << math.min(i, bits.bitLength - 1);
      m > 0;
      m >>= 1
    ) {
      if (bits & m == m) yield mapper(m.bitLength);
    }
  }

  Iterable<T> bitsBackwardMapOfTo<T>(
    T Function(int) mapper,
    int j,
    int iTo,
  ) sync* {
    assert(j >= 0 && j < length && iTo > 0);
    final smallest = 1 << iTo;
    for (
      var bits = this[j], m = 1 << bits.bitLength - 1;
      m >= smallest;
      m >>= 1
    ) {
      if (bits & m == m) yield mapper(m.bitLength);
    }
  }

  Iterable<T> bitsBackwardMapOfBetween<T>(
    T Function(int) mapper,
    int j,
    int i,
    int iTo,
  ) sync* {
    assert(j >= 0 && j < length && iTo > 0 && iTo < i);
    final smallest = 1 << iTo;
    for (
      var bits = this[j], m = 1 << math.min(i, bits.bitLength - 1);
      m >= smallest;
      m >>= 1
    ) {
      if (bits & m == m) yield mapper(m.bitLength);
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
    for (
      var bits = this[j] >> dFrom - 1, d = dFrom;
      bits > 0;
      bits >>= 1, d++
    ) {
      if (bits & 1 == 1) yield (y, m, d);
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
    var bits = this[j] >> dFrom - 1, d = dFrom;
    for (
      final last = math.min(dLast, bits.bitLength);
      d <= last;
      bits >>= 1, d++
    ) {
      if (bits & 1 == 1) yield (y, m, d);
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
  ///
  ///
  Iterable<int> bitsForward(int iLimit, [int p = 1]) sync* {
    assert(iLimit > 0);
    final length = this.length, start = p;
    for (var j = 0, bits = this[j]; j < length; j++, p = start + iLimit * j) {
      for (; bits > 0; bits >>= 1, p++) {
        if (bits & 1 == 1) yield p;
      }
    }
  }

  Iterable<int> bitsForwardFrom(int iLimit, int j, int i, [int p = 1]) sync* {
    assert(j >= 0 && j < this.length && i >= 0 && i < iLimit);
    final length = this.length, start = p;
    var bits = this[j] >> i;
    while (true) {
      for (; bits > 0; bits >>= 1, p++) {
        if (bits & 1 == 1) yield p;
      }
      if (++j >= length) return;
      bits = this[j];
      p = start + iLimit * j;
    }
  }

  Iterable<int> bitsForwardTo(int iLimit, int jTo, int iTo, [int p = 1]) sync* {
    assert(jTo >= 0 && jTo < length && iTo >= 0 && iTo < iLimit);
    final start = p, smallest = 1 << iTo;
    var j = 0, bits = this[0];
    for (; j < jTo; j++, bits = this[j], p = start + iLimit * j) {
      for (; bits > 0; bits >>= 1, p++) {
        if (bits & 1 == 1) yield p;
      }
    }
    for (; bits >= smallest; bits >>= 1, p++) {
      if (bits & 1 == 1) yield p;
    }
  }

  Iterable<int> bitsForwardBetween(
    int iLimit,
    int j,
    int i,
    int jTo,
    int iTo, [
    int p = 1,
  ]) sync* {
    assert(j >= 0 && j <= jTo && jTo < length);
    assert(i >= 0 && i < iLimit && iTo > 0 && iTo < iLimit);

    final start = p;
    var bits = this[j] >> i;
    for (var j = 0; j < jTo; j++, bits = this[j], p = start + iLimit * j) {
      for (; bits > 0; bits >>= 1, i++) {
        if (bits & 1 == 1) yield p;
      }
    }
    final smallest = 1 << iTo;
    for (; bits >= smallest; bits >>= 1, p++) {
      if (bits & 1 == 1) yield p;
    }
  }

  Iterable<int> bitsForwardAfter(
    int index,
    int shift,
    int mask,
    int iLimit, [
    int p = 1,
  ]) sync* {
    assert(index >= 0 && index < length * iLimit && mask + 1 == 1 << shift);
    if (++index >= length * iLimit - 1) return;
    yield* bitsForwardFrom(iLimit, index >> shift, index & mask, p);
  }

  ///
  ///
  ///
  Iterable<int> bitsBackward(int iLimit) sync* {
    assert(iLimit > 0);
    for (
      var j = length - 1, bits = this[j], m = 1 << bits.bitLength - 1;
      j >= 0;
      j--
    ) {
      for (final pStart = iLimit * j; m > 0; m >>= 1) {
        if (bits & m == m) yield pStart + m.bitLength;
      }
    }
  }

  Iterable<int> bitsBackwardFrom(int iLimit, int j, int i) sync* {
    assert(j >= 0 && j < length && i >= 0 && i < iLimit);

    var bits = this[j], m = 1 << math.min(i, bits.bitLength - 1);
    while (true) {
      for (final pStart = iLimit * j; m > 0; m >>= 1) {
        if (bits & m == m) yield pStart + m.bitLength;
      }
      if (--j < 0) return;
      bits = this[j];
      m = 1 << bits.bitLength - 1;
    }
  }

  Iterable<int> bitsBackwardTo(int iLimit, int jTo, int iTo) sync* {
    assert(jTo >= 0 && jTo < length && iTo >= 0 && iTo < iLimit);

    var j = length - 1, bits = this[j], m = 1 << bits.bitLength - 1;
    for (; j > jTo; j--, bits = this[j], m = 1 << bits.bitLength - 1) {
      for (final pStart = iLimit * j; m > 0; m >>= 1) {
        if (bits & m == m) yield pStart + m.bitLength;
      }
    }
    assert(bits.bitLength <= iLimit);
    for (
      final smallest = 1 << iTo, pStart = iLimit * j;
      m >= smallest;
      m >>= 1
    ) {
      if (bits & m == m) yield pStart + m.bitLength;
    }
  }

  Iterable<int> bitsBackwardBetween(
    int iLimit,
    int j,
    int i,
    int jTo,
    int iTo,
  ) sync* {
    assert(jTo >= 0 && jTo <= j && j < length);
    assert(iTo >= 0 && iTo < iLimit && i >= 0 && i < iLimit);

    var bits = this[j], m = 1 << math.min(i, bits.bitLength - 1);
    for (; j > jTo; j--, bits = this[j], m = 1 << bits.bitLength - 1) {
      for (final pStart = iLimit * j; m > 0; m >>= 1) {
        if (bits & m == m) yield pStart + m.bitLength;
      }
    }
    for (
      final smallest = 1 << iTo, pStart = iLimit * j;
      m >= smallest;
      m >>= 1
    ) {
      if (bits & m == m) yield pStart + m.bitLength;
    }
  }

  Iterable<int> bitsBackwardBefore(
    int index,
    int shift,
    int mask,
    int iLimit,
  ) sync* {
    assert(index >= 0 && index < length * iLimit && mask + 1 == 1 << shift);
    if (--index < 1) return;
    yield* bitsBackwardFrom(iLimit, index >> shift, index & mask);
  }
}
