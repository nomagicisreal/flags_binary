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
/// return void                   : [pConsume], ...
/// return bool                   : [pOn], ...
/// return integer                : [pFirst], ...
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
  /// [comparing8First], ...
  ///
  static int comparing8First(Uint8List a, Uint8List b) => a[0].compareTo(b[0]);

  static int comparing16First(Uint16List a, Uint16List b) =>
      a[0].compareTo(b[0]);

  static int comparing32First(Uint16List a, Uint16List b) =>
      a[0].compareTo(b[0]);

  static int comparing64First(Uint64List a, Uint64List b) =>
      a[0].compareTo(b[0]);

  ///
  /// [getPFirst1]
  /// [getPLast1]
  ///
  static int? getPFirst1<T extends TypedDataList<int>>(T list, int sizeEach) =>
      list.pFirst(sizeEach);

  static int? getPLast1<T extends TypedDataList<int>>(T list, int sizeEach) =>
      list.pLast(sizeEach);

  ///
  /// [bFirstOf]
  /// [bLastOf]
  ///
  int? bFirstOf(int j, [int from = 1]) {
    for (var bits = this[j] >> from - 1, p = from; bits > 0; bits >>= 1, p++) {
      if (bits & 1 == 1) return p;
    }
    return null;
  }

  int? bLastOf(int j, int from) {
    for (var bits = this[j], i = from - 1; i > -1; i--) {
      if ((bits & 1 << i) >> i == 1) return i + 1;
    }
    return null;
  }

  ///
  /// [bitsOf]
  /// [bitsMappedOf]
  /// [bitsMappedOfLimit]
  /// [bitsMappedFrom]
  /// [bitsMappedTo]
  ///
  Iterable<int> bitsOf(int i, [int from = 1]) sync* {
    for (var bits = this[i] >> from - 1, p = from; bits > 0; bits >>= 1, p++) {
      if (bits & 1 == 1) yield p;
    }
  }

  Iterable<T> bitsMappedOf<T>(
    int i,
    T Function(int) mapping, [
    int from = 1,
  ]) sync* {
    for (var bits = this[i] >> from - 1, p = from; bits > 0; bits >>= 1, p++) {
      if (bits & 1 == 1) yield mapping(p);
    }
  }

  Iterable<T> bitsMappedOfLimit<T>(
    int i,
    int limit,
    T Function(int) mapping, [
    int from = 1,
  ]) sync* {
    for (
      var bits = this[i] >> from - 1, p = from;
      p < limit;
      bits >>= 1, p++
    ) {
      if (bits & 1 == 1) yield mapping(p);
    }
  }

  Iterable<T> bitsMappedFrom<T>(
    int index,
    T Function(int, int) mapping, [
    int from = 1,
  ]) sync* {
    final length = this.length;
    for (; index < length; index++) {
      for (
        var bits = this[index] >> from - 1, p = from;
        bits > 0;
        bits >>= 1, p++
      ) {
        if (bits & 1 == 1) yield mapping(index, p);
      }
    }
  }

  Iterable<T> bitsMappedTo<T>(
    int index,
    T Function(int, int) mapping, [
    int from = 1,
  ]) sync* {
    for (var i = 0; i <= index; i++) {
      for (
        var bits = this[i] >> from - 1, p = from;
        bits > 0;
        bits >>= 1, p++
      ) {
        if (bits & 1 == 1) yield mapping(i, p);
      }
    }
  }

  ///
  /// [pSet], [pClear]
  /// [pConsume]
  ///
  void pSet(int p, int shift, int mask) => this[p >> shift] |= 1 << (p & mask);

  void pClear(int p, int shift, int mask) =>
      this[p >> shift] &= ~(1 << (p & mask));

  void pConsume(
    void Function(int p) consume,
    int size,
    int max, [
    int bit = 1,
  ]) {
    for (var j = 0; j < max; j++) {
      for (var i = 1, bits = this[j]; bits > 0; i++, bits >>= 1) {
        if (bits & 1 == bit) consume(size * j + i);
      }
    }
  }

  ///
  /// [pOn]
  ///
  bool pOn(int p, int shift, int mask, [int bit = 1]) =>
      (this[p >> shift] >> (p & mask)) & 1 == bit;

  ///
  /// [pFirst]
  /// [pLast]
  /// [pN]
  ///
  int? pFirst(int sizeEach, [int bit = 1]) {
    final length = this.length;
    for (var j = 0; j < length; j++) {
      for (var i = 0, bits = this[j]; bits > 0; i++, bits >>= 1) {
        if (bits & 1 == bit) return sizeEach * j + i;
      }
    }
    return null;
  }

  int? pLast(int sizeEach, [int bit = 1]) {
    for (var j = length - 1; j > -1; j--) {
      for (var bits = this[j], i = sizeEach - 1; i > -1; i--) {
        if ((bits & 1 << i) >> i == bit) return sizeEach * j + i + 1;
      }
    }
    return null;
  }

  int? pN(int n, int sizeEach, [int bit = 1]) {
    final length = this.length;
    for (var j = 0; j < length; j++) {
      for (var i = 0, bits = this[j]; bits > 0; i++, bits >>= 1) {
        if (bits & 1 == bit) {
          n--;
          if (n == 0) return sizeEach * j * i;
        }
      }
    }
    return null;
  }

  ///
  /// [pFirstFrom]
  /// [pNFrom]
  /// [pLastTo]
  ///
  int? pFirstFrom(int j, int i, int sizeEach, [int bit = 1]) {
    var bits = this[j];
    while (bits > 0) {
      if (bits & 1 == bit) return sizeEach * j + i;
      i++;
      bits >>= 1;
    }
    j++;

    final length = this.length;
    while (j < length) {
      i = 0;
      bits = this[j];
      while (bits > 0) {
        if (bits & 1 == bit) return sizeEach * j + i;
        i++;
        bits >>= 1;
      }
      j++;
    }
    return null;
  }

  int? pLastTo(int j, int p, int sizeEach, [int bit = 1]) {
    var bits = this[j], i = p - 1;
    while (i > -1) {
      if ((bits & 1 << i) >> i == bit) return sizeEach * j + i + 1;
      i--;
    }
    j--;

    while (j > -1) {
      i = sizeEach - 1;
      bits = this[j];
      while (i > -1) {
        if ((bits & 1 << i) >> i == bit) return sizeEach * j + i + 1;
        i--;
      }
      j--;
    }

    return null;
  }

  int? pNFrom(int j, int p, int sizeEach, int n, [int bit = 1]) {
    var bits = this[j];
    while (bits > 0) {
      if (bits & 1 == bit) {
        n--;
        if (n == 0) return sizeEach * j + p;
      }
      p++;
      bits >>= 1;
    }
    j++;

    final length = this.length;
    while (j < length) {
      p = 1;
      bits = this[j];
      while (bits > 0) {
        if (bits & 1 == bit) {
          n--;
          if (n == 0) return sizeEach * j + p;
        }
        p++;
        bits >>= 1;
      }
      j++;
    }
    return null;
  }

  ///
  /// [pFirstAfter]
  /// [pLastBefore]
  ///
  int? pFirstAfter(int p, int shift, int mask, int sizeEach) {
    if (p > length * sizeEach - 1) return null;
    p = p < 1 ? 1 : p + 1;
    return pFirstFrom(p >> shift, p & mask, sizeEach);
  }

  int? pLastBefore(int p, int shift, int mask, int sizeEach) {
    if (p < 2) return null;
    final size = length * sizeEach;
    p = p > size ? size : p - 1;
    return pLastTo(p >> shift, p & mask, sizeEach);
  }

  ///
  ///
  /// [pAvailable], [mapPAvailable]
  /// [pAvailableFrom], [mapPAvailableFrom]
  /// [pAvailableTo], [mapPAvailableTo]
  /// [pAvailableSub], [mapPAvailableSub]
  /// notice that [sizeEach] must be 2^n, so [sizeEach] - 1 will be [_Field8.mask8], [TypedIntList.mask16], ...
  ///
  ///
  Iterable<int> pAvailable<T>(int sizeEach) sync* {
    final length = this.length;
    for (var j = 0; j < length; j++) {
      final prefix = sizeEach * j;
      var bits = this[j];
      for (var i = 0; bits > 0; i++, bits >>= 1) {
        if (bits & 1 == 1) yield prefix + i;
      }
    }
  }

  Iterable<int> pAvailableFrom(int from, int sizeEach, bool inclusive) sync* {
    from += inclusive ? 0 : 1;
    var j = from ~/ sizeEach;
    final prefix = sizeEach * j;
    for (
      var i = from & sizeEach - 1, bits = this[j] >> i - 1;
      bits > 0;
      i++, bits >>= 1
    ) {
      if (bits & 1 == 1) yield prefix + i;
    }
    j++;

    final length = this.length;
    for (; j < length; j++) {
      final prefix = sizeEach * j;
      for (var i = 0, bits = this[j]; bits > 0; i++, bits >>= 1) {
        if (bits & 1 == 1) yield prefix + i;
      }
    }
  }

  Iterable<int> pAvailableTo(int to, int sizeEach, bool inclusive) sync* {
    to -= inclusive ? 0 : 1;
    if (to < 1) return;

    final limit = to ~/ sizeEach;
    for (var j = 0; j < limit; j++) {
      final prefix = sizeEach * j;
      for (var i = 0, bits = this[j]; bits > 0; bits >>= 1, i++) {
        if (bits & 1 == 1) yield prefix + i;
      }
    }

    final max = to & sizeEach - 1;
    final prefix = sizeEach * limit;
    for (var i = 0, bits = this[limit]; i <= max; bits >>= 1, i++) {
      if (bits & 1 == 1) yield prefix + i;
    }
  }

  // inclusive
  Iterable<int> pAvailableSub(
    int? from,
    int? to,
    int sizeEach,
    bool includeFrom,
    bool includeTo,
  ) sync* {
    if (from == null) {
      if (to == null) {
        yield* pAvailable(sizeEach);
        return;
      }
      yield* pAvailableTo(to, sizeEach, includeFrom);
      return;
    }
    if (to == null) {
      yield* pAvailableFrom(from, sizeEach, includeTo);
      return;
    }

    from += includeFrom ? 0 : 1;
    to -= includeTo ? 0 : 1;
    if (from > to) return;

    final limit = to ~/ sizeEach;
    final max = to & sizeEach - 1;
    var j = from ~/ sizeEach;
    var i = from & sizeEach - 1;
    var start = sizeEach * j;

    // on from && on to
    if (j == limit) {
      for (var bits = this[j]; i <= max; bits >>= 1, i++) {
        if (bits & 1 == 1) yield start + i;
      }
      return;
    }

    // on from
    for (var bits = this[j] >> i - 1; bits > 0; i++, bits >>= 1) {
      if (bits & 1 == 1) yield start + i;
    }
    j++;

    // after from, before to
    for (; j < limit; j++) {
      start = sizeEach * j;
      i = 0;
      for (var bits = this[j]; bits > 0; bits >>= 1, i++) {
        if (bits & 1 == 1) yield start + i;
      }
    }

    // on to
    start = sizeEach * limit;
    i = 0;
    for (var bits = this[limit]; i <= max; bits >>= 1, i++) {
      if (bits & 1 == 1) yield start + i;
    }
  }

  ///
  ///
  ///
  Iterable<T> mapPAvailable<T>(int sizeEach, T Function(int) mapping) sync* {
    final length = this.length;
    for (var j = 0; j < length; j++) {
      final prefix = sizeEach * j;
      var bits = this[j];
      for (var i = 0; bits > 0; i++, bits >>= 1) {
        if (bits & 1 == 1) yield mapping(prefix + i);
      }
    }
  }

  Iterable<T> mapPAvailableFrom<T>(
    int from,
    int sizeEach,
    T Function(int) mapping,
    bool inclusive,
  ) sync* {
    from += inclusive ? 0 : 1;
    var j = from ~/ sizeEach;
    final prefix = sizeEach * j;
    for (
      var i = from & sizeEach - 1, bits = this[j] >> i - 1;
      bits > 0;
      i++, bits >>= 1
    ) {
      if (bits & 1 == 1) yield mapping(prefix + i);
    }
    j++;

    final length = this.length;
    for (; j < length; j++) {
      final prefix = sizeEach * j;
      for (var i = 0, bits = this[j]; bits > 0; i++, bits >>= 1) {
        if (bits & 1 == 1) yield mapping(prefix + i);
      }
    }
  }

  Iterable<T> mapPAvailableTo<T>(
    int to,
    int sizeEach,
    T Function(int) mapping,
    bool inclusive,
  ) sync* {
    to -= inclusive ? 0 : 1;
    if (to < 1) return;

    final limit = to ~/ sizeEach;
    for (var j = 0; j < limit; j++) {
      final prefix = sizeEach * j;
      for (var i = 0, bits = this[j]; bits > 0; bits >>= 1, i++) {
        if (bits & 1 == 1) yield mapping(prefix + i);
      }
    }

    final max = to & sizeEach - 1;
    final prefix = sizeEach * limit;
    for (var i = 0, bits = this[limit]; i <= max; bits >>= 1, i++) {
      if (bits & 1 == 1) yield mapping(prefix + i);
    }
  }

  // inclusive
  Iterable<T> mapPAvailableSub<T>(
    int? from,
    int? to,
    int sizeEach,
    T Function(int) mapping,
    bool includeFrom,
    bool includeTo,
  ) sync* {
    if (from == null) {
      if (to == null) {
        yield* mapPAvailable(sizeEach, mapping);
        return;
      }
      yield* mapPAvailableTo(to, sizeEach, mapping, includeFrom);
      return;
    }
    if (to == null) {
      yield* mapPAvailableFrom(from, sizeEach, mapping, includeTo);
      return;
    }

    from += includeFrom ? 0 : 1;
    to -= includeTo ? 0 : 1;
    if (from > to) return;

    final limit = to ~/ sizeEach;
    final max = to & sizeEach - 1;
    var j = from ~/ sizeEach;
    var i = from & sizeEach - 1;
    var prefix = sizeEach * j;

    // on from && on to
    if (j == limit) {
      for (var bits = this[j]; i <= max; bits >>= 1, i++) {
        if (bits & 1 == 1) yield mapping(prefix + i);
      }
      return;
    }

    // on from
    for (var bits = this[j] >> i - 1; bits > 0; i++, bits >>= 1) {
      if (bits & 1 == 1) yield mapping(prefix + i);
    }
    j++;

    // after from, before to
    for (; j < limit; j++) {
      prefix = sizeEach * j;
      i = 0;
      for (var bits = this[j]; bits > 0; bits >>= 1, i++) {
        if (bits & 1 == 1) yield mapping(prefix + i);
      }
    }

    // on to
    prefix = sizeEach * limit;
    i = 0;
    for (var bits = this[limit]; i <= max; bits >>= 1, i++) {
      if (bits & 1 == 1) yield mapping(prefix + i);
    }
  }
}
