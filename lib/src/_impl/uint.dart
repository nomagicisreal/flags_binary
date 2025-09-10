part of '../../flags_binary.dart';

///
///
///
/// [TypedDateListInt]
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
/// return bool                   : [bOn], ...
/// return integer                : [bFirstOf], ...
/// return iterable integer       : [bitsForward], ...
/// return iterable provided type : [mapPAvailable], ...
///
extension TypedDateListInt on TypedDataList<int> {
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
  /// [bSet], [bClear]
  ///
  void pConsume1(void Function(int p) consume, int bSize, [int? jLimit]) {
    jLimit ??= length - 1;
    assert(bSize > 0 && jLimit > 0 && jLimit < length);
    for (var j = 0, p = 1; j < jLimit; j++, p = bSize * j + 1) {
      for (var bits = this[j]; bits > 0; bits >>= 1, p++) {
        if (bits & 1 == 1) consume(p);
      }
    }
  }

  void pConsume0(void Function(int p) consume, int bSize, [int? jLimit]) {
    jLimit ??= length - 1;
    assert(bSize > 0 && jLimit > 0 && jLimit < length);
    for (var j = 0, p = 1; j < jLimit; j++, p = bSize * j + 1) {
      for (var bits = this[j]; bits > 0; bits >>= 1, p++) {
        if (bits & 1 == 0) consume(p);
      }
    }
  }

  void bSet(int b, int shift, int mask) {
    assert(b >= 0 && mask + 1 == 1 << shift);
    this[b >> shift] |= 1 << (b & mask);
  }

  void bClear(int b, int shift, int mask) {
    assert(b >= 0 && mask + 1 == 1 << shift);
    this[b >> shift] &= ~(1 << (b & mask));
  }

  ///
  /// [bOn]
  ///
  bool bOn(int b, int shift, int mask) {
    assert(b >= 0 && mask + 1 == 1 << shift);
    return this[b >> shift] >> (b & mask) & 1 == 1;
  }

  ///
  /// [bFirstOf], [bFirstOfFrom], [bFirstOfTo], [bFirstOfBetween], ..., bFirstNOf, ...?
  /// [bFirst], [bFirstFrom], [bFirstTo], [bFirstBetween], ...
  /// [bFirstAfter]
  ///
  /// [bLastOf], [bLastOfFrom], [bLastOfTo], [bLastOfBetween], ...
  /// [bLast], [bLastFrom], [bLastTo], [bLastBetween], ...
  /// [bLastBefore]
  ///
  ///

  ///
  ///
  ///
  int? bFirstOf(int j) {
    assert(j >= 0 && j < length);
    for (var bits = this[j], b = 1; bits > 0; bits >>= 1, b++) {
      if (bits & 1 == 1) return b;
    }
    return null;
  }

  int? bFirstOfFrom(int j, int i) {
    assert(j >= 0 && j < length && i >= 0);
    for (var bits = this[j] >> i, b = i + 1; bits > 0; bits >>= 1, b++) {
      if (bits & 1 == 1) return b;
    }
    return null;
  }

  int? bFirstOfTo(int j, int iTo) {
    assert(j >= 0 && j < length && iTo > 0);
    var bits = this[j], b = 1;
    for (final bLimit = b + iTo; b < bLimit; bits >>= 1, b++) {
      if (bits & 1 == 1) return b;
    }
    return null;
  }

  int? bFirstOfBetween(int j, int i, int iTo) {
    assert(j >= 0 && j < length && i > 0 && i < iTo);
    var bits = this[j] >> i, b = i + 1;
    for (final bLimit = b + iTo; b < bLimit; bits >>= 1, b++) {
      if (bits & 1 == 1) return b;
    }
    return null;
  }

  ///
  ///
  ///
  int? bFirst(int bSize) {
    assert(bSize > 0);
    final length = this.length;
    for (var j = 0, bits = this[j]; j < length; j++) {
      for (var b = 1; bits > 0; bits >>= 1, b++) {
        if (bits & 1 == 1) return bSize * j + b;
      }
    }
    return null;
  }

  int? bFirstFrom(int bSize, int j, int i) {
    assert(j >= 0 && j < this.length && i >= 0 && i < bSize);
    final length = this.length;
    var bits = this[j] >> i, b = i + 1;
    while (true) {
      for (; bits > 0; bits >>= 1, b++) {
        if (bits & 1 == 1) return bSize * j + b;
      }
      if (++j >= length) return null;
      bits = this[j];
      b = 1;
    }
  }

  int? bFirstTo(int bSize, int jTo, int iTo) {
    assert(jTo >= 0 && jTo < length && iTo >= 0 && iTo < bSize);
    var bits = this[0];
    for (var j = 0; j < jTo; j++, bits = this[j]) {
      for (var b = 1; bits > 0; bits >>= 1, b++) {
        if (bits & 1 == 1) return bSize * j + b;
      }
    }
    var b = 1;
    for (final bLimit = iTo + 1; b < bLimit; bits >>= 1, b++) {
      if (bits & 1 == 1) return bSize * jTo + b;
    }
    return null;
  }

  int? bFirstBetween(int bSize, int j, int i, int jTo, int iTo) {
    assert(j >= 0 && j <= jTo && jTo < length);
    assert(i >= 0 && i < bSize && iTo > 0 && iTo < bSize);

    var bits = this[j] >> i;
    for (var j = 0; j < jTo; j++, bits = this[j]) {
      for (var b = 1; bits > 0; bits >>= 1, b++) {
        if (bits & 1 == 1) return bSize * j + b;
      }
    }
    var b = 1;
    for (final bLimit = iTo + 1; b < bLimit; bits >>= 1, b++) {
      if (bits & 1 == 1) return bSize * jTo + b;
    }
    return null;
  }

  int? bFirstAfter(int index, int shift, int mask, int bSize) {
    assert(index >= 0 && index < length * bSize && mask + 1 == 1 << shift);
    if (++index >= length * bSize - 1) return null;
    return bFirstFrom(bSize, index >> shift, index & mask);
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
  int? bLast(int bSize) {
    assert(bSize > 0);
    for (var j = length - 1, bits = this[j]; j >= 0; j--) {
      for (var m = 1 << bits.bitLength - 1; m > 0; m >>= 1) {
        if (bits & m == m) return bSize * j + m.bitLength;
      }
    }
    return null;
  }

  int? bLastFrom(int bSize, int j, int i) {
    assert(j >= 0 && j < length && i >= 0 && i < bSize);
    var bits = this[j], m = 1 << math.min(i, bits.bitLength - 1);
    while (true) {
      for (; m > 0; m >>= 1) {
        if (bits & m == m) return bSize * j + m.bitLength;
      }
      if (--j < 0) return null;
      bits = this[j];
      m = 1 << bits.bitLength - 1;
    }
  }

  int? bLastTo(int bSize, int jTo, int iTo) {
    assert(jTo >= 0 && jTo < length && iTo >= 0 && iTo < bSize);
    var j = length - 1, bits = this[j], m = 1 << bits.bitLength - 1;
    for (; j > jTo; j--, bits = this[j], m = 1 << bits.bitLength - 1) {
      for (; m > 0; m >>= 1) {
        if (bits & m == m) return bSize * j + m.bitLength;
      }
    }
    assert(bits.bitLength <= bSize);
    for (final smallest = 1 << iTo; m >= smallest; m >>= 1) {
      if (bits & m == m) return bSize * jTo + m.bitLength;
    }
    return null;
  }

  int? bLastBetween(int bSize, int j, int i, int jTo, int iTo) {
    assert(jTo >= 0 && jTo <= j && j < length);
    assert(iTo >= 0 && iTo < bSize && i >= 0 && i < bSize);

    var bits = this[j], m = 1 << math.min(i, bits.bitLength - 1);
    for (; j > jTo; j--, bits = this[j], m = 1 << bits.bitLength - 1) {
      for (; m > 0; m >>= 1) {
        if (bits & m == m) return bSize * j + m.bitLength;
      }
    }
    for (final smallest = 1 << iTo; m >= smallest; m >>= 1) {
      if (bits & m == m) return bSize * jTo + m.bitLength;
    }
    return null;
  }

  int? bLastBefore(int index, int shift, int mask, int bSize) {
    assert(index >= 0 && index < length * bSize && mask + 1 == 1 << shift);
    if (--index < 1) return null;
    return bLastFrom(bSize, index >> shift, index & mask);
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
  /// [datesForwardOf], [datesForwardOfBetween], [datesBackwardOfBetween]
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
  Iterable<int> bitsForwardOf(int j) sync* {
    assert(j >= 0 && j < length);
    for (var bits = this[j], b = 1; bits > 0; bits >>= 1, b++) {
      if (bits & 1 == 1) yield b;
    }
  }

  Iterable<int> bitsForwardOfFrom(int j, int i) sync* {
    assert(j >= 0 && j < length && i >= 0);
    for (var bits = this[j] >> i, b = i + 1; bits > 0; bits >>= 1, b++) {
      if (bits & 1 == 1) yield b;
    }
  }

  Iterable<int> bitsForwardOfTo(int j, int iTo) sync* {
    assert(j >= 0 && j < length && iTo > 0);
    var bits = this[j], b = 1;
    for (final bLimit = b + iTo; b < bLimit; bits >>= 1, b++) {
      if (bits & 1 == 1) yield b;
    }
  }

  Iterable<int> bitsForwardOfBetween(int j, int i, int iTo) sync* {
    assert(j >= 0 && j < length && i > 0 && i < iTo);
    var bits = this[j] >> i, b = i + 1;
    for (final bLimit = b + iTo; b < bLimit; bits >>= 1, b++) {
      if (bits & 1 == 1) yield b;
    }
  }

  //
  Iterable<T> bitsForwardMapOf<T>(T Function(int) mapper, int j) sync* {
    assert(j >= 0 && j < length);
    for (var bits = this[j], b = 1; bits > 0; bits >>= 1, b++) {
      if (bits & 1 == 1) yield mapper(b);
    }
  }

  Iterable<T> bitsForwardMapOfFrom<T>(
    T Function(int) mapper,
    int j,
    int i,
  ) sync* {
    assert(j >= 0 && j < length && i >= 0);
    for (var bits = this[j] >> i, b = i + 1; bits > 0; bits >>= 1, b++) {
      if (bits & 1 == 1) yield mapper(b);
    }
  }

  Iterable<T> bitsForwardMapOfTo<T>(
    T Function(int) mapper,
    int j,
    int iTo,
  ) sync* {
    assert(j >= 0 && j < length && iTo > 0);
    var bits = this[j], b = 1;
    for (final bLimit = b + iTo; b < bLimit; bits >>= 1, b++) {
      if (bits & 1 == 1) yield mapper(b);
    }
  }

  Iterable<T> bitsForwardMapOfBetween<T>(
    T Function(int) mapper,
    int j,
    int i,
    int iTo,
  ) sync* {
    assert(j >= 0 && j < length && i > 0 && i < iTo);
    var bits = this[j] >> i, b = i + 1;
    for (final bLimit = b + iTo; b < bLimit; bits >>= 1, b++) {
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
    assert(_isValidDay(y, m, dFrom) && j >= 0 && j < length);

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
    int dTo, [
    int dFrom = 1,
  ]) sync* {
    assert(() {
      if (this is Uint32List && this[j] >> _monthDaysOf(y, m) > 0) return false;
      if (_isInvalidDay(y, m, dFrom) || _isInvalidDay(y, m, dTo)) return false;
      return dFrom <= dTo && j >= 0 && j < length;
    }());

    var bits = this[j] >> dFrom - 1, d = dFrom;
    for (
      final last = math.min(dTo, bits.bitLength);
      d <= last;
      bits >>= 1, d++
    ) {
      if (bits & 1 == 1) yield (y, m, d);
    }
  }

  Iterable<(int, int, int)> datesBackwardOf(
    int j,
    int y,
    int m, [
    int bTo = 0,
  ]) sync* {
    assert(this is Uint32List && this[j] >> _monthDaysOf(y, m) == 0);
    assert(_isValidDay(y, m, bTo + 1) && j >= 0 && j < length);

    for (var bits = this[j], b = bits.bitLength - 1; b >= bTo; b--) {
      final mask = 1 << b;
      if (bits & mask == mask) yield (y, m, b + 1);
    }
  }

  Iterable<(int, int, int)> datesBackwardOfBetween(
    int j,
    int y,
    int m,
    int bFrom, [
    int bTo = 0,
  ]) sync* {
    assert(() {
      if (this is Uint32List && this[j] >> _monthDaysOf(y, m) > 0) return false;
      if (_isInvalidDay(y, m, bFrom + 1)) return false;
      if (_isInvalidDay(y, m, bTo + 1)) return false;
      return bFrom >= bTo && j >= 0 && j < length;
    }());

    for (
      var bits = this[j], b = math.min(bFrom, bits.bitLength - 1);
      b >= bTo;
      b--
    ) {
      final mask = 1 << b;
      if (bits & mask == mask) yield (y, m, b + 1);
    }
  }

  ///
  ///
  ///
  Iterable<int> bitsForward(int bSize) sync* {
    assert(bSize > 0);
    final length = this.length;
    for (var j = 0, p = 1, bits = this[j]; j < length; j++, p = bSize * j + 1) {
      for (; bits > 0; bits >>= 1, p++) {
        if (bits & 1 == 1) yield p;
      }
    }
  }

  Iterable<int> bitsForwardFrom(int bSize, int j, int i) sync* {
    assert(j >= 0 && j < this.length && i >= 0 && i < bSize);
    final length = this.length;
    var bits = this[j] >> i, p = bSize * j + i + 1;
    while (true) {
      for (; bits > 0; bits >>= 1, p++) {
        if (bits & 1 == 1) yield p;
      }
      if (++j >= length) return;
      bits = this[j];
      p = bSize * j + 1;
    }
  }

  Iterable<int> bitsForwardTo(int bSize, int jTo, int iTo) sync* {
    assert(jTo >= 0 && jTo < length && iTo >= 0 && iTo < bSize);
    var j = 0, bits = this[0], p = 1;
    for (; j < jTo; j++, bits = this[j], p = bSize * j + 1) {
      for (; bits > 0; bits >>= 1, p++) {
        if (bits & 1 == 1) yield p;
      }
    }
    for (final last = p + iTo; p <= last; bits >>= 1, p++) {
      if (bits & 1 == 1) yield p;
    }
  }

  Iterable<int> bitsForwardBetween(
    int bSize,
    int j,
    int i,
    int jTo,
    int iTo,
  ) sync* {
    assert(j >= 0 && j <= jTo && jTo < length);
    assert(i >= 0 && i < bSize && iTo > 0 && iTo < bSize);

    var bits = this[j] >> i, p = bSize * j + i + 1;
    for (; j < jTo; j++, bits = this[j], p = bSize * j + 1) {
      for (; bits > 0; bits >>= 1, p++) {
        if (bits & 1 == 1) yield p;
      }
    }
    for (final last = p + iTo; p <= last; bits >>= 1, p++) {
      if (bits & 1 == 1) yield p;
    }
  }

  Iterable<int> bitsForwardAfter(
    int index,
    int shift,
    int mask,
    int bSize,
  ) sync* {
    assert(index >= 0 && index < length * bSize && mask + 1 == 1 << shift);
    if (++index >= length * bSize - 1) return;
    yield* bitsForwardFrom(bSize, index >> shift, index & mask);
  }

  //
  Iterable<T> bitsForwardMap<T>(T Function(int) mapper, int bSize) sync* {
    assert(bSize > 0);
    final length = this.length;
    for (var j = 0, p = 1, bits = this[j]; j < length; j++, p = bSize * j + 1) {
      for (; bits > 0; bits >>= 1, p++) {
        if (bits & 1 == 1) yield mapper(p);
      }
    }
  }

  Iterable<T> bitsForwardMapFrom<T>(
    T Function(int) mapper,
    int bSize,
    int j,
    int i,
  ) sync* {
    assert(j >= 0 && j < this.length && i >= 0 && i < bSize);
    final length = this.length;
    var bits = this[j] >> i, p = bSize * j + i + 1;
    while (true) {
      for (; bits > 0; bits >>= 1, p++) {
        if (bits & 1 == 1) yield mapper(p);
      }
      if (++j >= length) return;
      bits = this[j];
      p = bSize * j + 1;
    }
  }

  Iterable<T> bitsForwardMapTo<T>(
    T Function(int) mapper,
    int bSize,
    int jTo,
    int iTo,
  ) sync* {
    assert(jTo >= 0 && jTo < length && iTo >= 0 && iTo < bSize);
    var j = 0, bits = this[0], p = 1;
    for (; j < jTo; j++, bits = this[j], p = bSize * j + 1) {
      for (; bits > 0; bits >>= 1, p++) {
        if (bits & 1 == 1) yield mapper(p);
      }
    }
    for (final last = p + iTo; p <= last; bits >>= 1, p++) {
      if (bits & 1 == 1) yield mapper(p);
    }
  }

  Iterable<T> bitsForwardMapBetween<T>(
    T Function(int) mapper,
    int bSize,
    int j,
    int i,
    int jTo,
    int iTo,
  ) sync* {
    assert(j >= 0 && j <= jTo && jTo < length);
    assert(i >= 0 && i < bSize && iTo > 0 && iTo < bSize);

    var bits = this[j] >> i, p = bSize * j + i + 1;
    for (; j < jTo; j++, bits = this[j], p = bSize * j + 1) {
      for (; bits > 0; bits >>= 1, p++) {
        if (bits & 1 == 1) yield mapper(p);
      }
    }
    for (final last = p + iTo; p <= last; bits >>= 1, p++) {
      if (bits & 1 == 1) yield mapper(p);
    }
  }

  Iterable<T> bitsForwardMapAfter<T>(
    T Function(int) mapper,
    int index,
    int shift,
    int mask,
    int bSize,
  ) sync* {
    assert(index >= 0 && index < length * bSize && mask + 1 == 1 << shift);
    if (++index >= length * bSize - 1) return;
    yield* bitsForwardMapFrom(mapper, bSize, index >> shift, index & mask);
  }

  ///
  ///
  ///
  Iterable<int> bitsBackward(int bSize) sync* {
    assert(bSize > 0);
    for (
      var j = length - 1, bits = this[j], m = 1 << bits.bitLength - 1;
      j >= 0;
      j--
    ) {
      for (final from = bSize * j; m > 0; m >>= 1) {
        if (bits & m == m) yield from + m.bitLength;
      }
    }
  }

  Iterable<int> bitsBackwardFrom(int bSize, int j, int i) sync* {
    assert(j >= 0 && j < length && i >= 0 && i < bSize);

    var bits = this[j], m = 1 << math.min(i, bits.bitLength - 1);
    while (true) {
      for (final from = bSize * j; m > 0; m >>= 1) {
        if (bits & m == m) yield from + m.bitLength;
      }
      if (--j < 0) return;
      bits = this[j];
      m = 1 << bits.bitLength - 1;
    }
  }

  Iterable<int> bitsBackwardTo(int bSize, int jTo, int iTo) sync* {
    assert(jTo >= 0 && jTo < length && iTo >= 0 && iTo < bSize);

    var j = length - 1, bits = this[j], m = 1 << bits.bitLength - 1;
    for (; j > jTo; j--, bits = this[j], m = 1 << bits.bitLength - 1) {
      for (final from = bSize * j; m > 0; m >>= 1) {
        if (bits & m == m) yield from + m.bitLength;
      }
    }
    assert(bits.bitLength <= bSize);
    for (final smallest = 1 << iTo, from = bSize * j; m >= smallest; m >>= 1) {
      if (bits & m == m) yield from + m.bitLength;
    }
  }

  Iterable<int> bitsBackwardBetween(
    int bSize,
    int j,
    int i,
    int jTo,
    int iTo,
  ) sync* {
    assert(jTo >= 0 && jTo <= j && j < length);
    assert(iTo >= 0 && iTo < bSize && i >= 0 && i < bSize);

    var bits = this[j], m = 1 << math.min(i, bits.bitLength - 1);
    for (; j > jTo; j--, bits = this[j], m = 1 << bits.bitLength - 1) {
      for (final from = bSize * j; m > 0; m >>= 1) {
        if (bits & m == m) yield from + m.bitLength;
      }
    }
    for (final smallest = 1 << iTo, from = bSize * j; m >= smallest; m >>= 1) {
      if (bits & m == m) yield from + m.bitLength;
    }
  }

  Iterable<int> bitsBackwardBefore(
    int index,
    int shift,
    int mask,
    int bSize,
  ) sync* {
    assert(index >= 0 && index < length * bSize && mask + 1 == 1 << shift);
    if (--index < 1) return;
    yield* bitsBackwardFrom(bSize, index >> shift, index & mask);
  }

  //
  Iterable<T> bitsBackwardMap<T>(T Function(int) mapper, int bSize) sync* {
    assert(bSize > 0);
    for (
      var j = length - 1, bits = this[j], m = 1 << bits.bitLength - 1;
      j >= 0;
      j--
    ) {
      for (final from = bSize * j; m > 0; m >>= 1) {
        if (bits & m == m) yield mapper(from + m.bitLength);
      }
    }
  }

  Iterable<T> bitsBackwardMapFrom<T>(
    T Function(int) mapper,
    int bSize,
    int j,
    int i,
  ) sync* {
    assert(j >= 0 && j < length && i >= 0 && i < bSize);

    var bits = this[j], m = 1 << math.min(i, bits.bitLength - 1);
    while (true) {
      for (final from = bSize * j; m > 0; m >>= 1) {
        if (bits & m == m) yield mapper(from + m.bitLength);
      }
      if (--j < 0) return;
      bits = this[j];
      m = 1 << bits.bitLength - 1;
    }
  }

  Iterable<T> bitsBackwardMapTo<T>(
    T Function(int) mapper,
    int bSize,
    int jTo,
    int iTo,
  ) sync* {
    assert(jTo >= 0 && jTo < length && iTo >= 0 && iTo < bSize);

    var j = length - 1, bits = this[j], m = 1 << bits.bitLength - 1;
    for (; j > jTo; j--, bits = this[j], m = 1 << bits.bitLength - 1) {
      for (final from = bSize * j; m > 0; m >>= 1) {
        if (bits & m == m) yield mapper(from + m.bitLength);
      }
    }
    assert(bits.bitLength <= bSize);
    for (final smallest = 1 << iTo, from = bSize * j; m >= smallest; m >>= 1) {
      if (bits & m == m) yield mapper(from + m.bitLength);
    }
  }

  Iterable<T> bitsBackwardMapBetween<T>(
    T Function(int) mapper,
    int bSize,
    int j,
    int i,
    int jTo,
    int iTo,
  ) sync* {
    assert(jTo >= 0 && jTo <= j && j < length);
    assert(iTo >= 0 && iTo < bSize && i >= 0 && i < bSize);

    var bits = this[j], m = 1 << math.min(i, bits.bitLength - 1);
    for (; j > jTo; j--, bits = this[j], m = 1 << bits.bitLength - 1) {
      for (final from = bSize * j; m > 0; m >>= 1) {
        if (bits & m == m) yield mapper(from + m.bitLength);
      }
    }
    for (final smallest = 1 << iTo, from = bSize * j; m >= smallest; m >>= 1) {
      if (bits & m == m) yield mapper(from + m.bitLength);
    }
  }

  Iterable<T> bitsBackwardMapBefore<T>(
    T Function(int) mapper,
    int index,
    int shift,
    int mask,
    int bSize,
  ) sync* {
    assert(index >= 0 && index < length * bSize && mask + 1 == 1 << shift);
    if (--index < 1) return;
    yield* bitsBackwardMapFrom(mapper, bSize, index >> shift, index & mask);
  }
}
