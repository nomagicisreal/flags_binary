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
  /// [bFirstOf], [pFirstOf]
  /// [bLastOf], [pLastOf]
  ///
  int? bFirstOf(int j, [int i = 0]) {
    assert(j > -1 && j < length && i > -1);
    for (var bits = this[j] >> i; bits > 0; bits >>= 1, i++) {
      if (bits & 1 == 1) return i;
    }
    return null;
  }

  int? bLastOf(int j, int iLast) {
    assert(j > -1 && j < length && iLast > -1);
    for (var bits = this[j]; iLast > -1; iLast--) {
      if (bits & 1 << iLast == 1 << iLast) return iLast;
    }
    return null;
  }

  int? pFirstOf(int pJ, [int pI = 1]) {
    assert(pJ > 0 && pJ <= length && pI > 0);
    for (var bits = this[pJ - 1] >> pI - 1; bits > 0; bits >>= 1, pI++) {
      if (bits & 1 == 1) return pI;
    }
    return null;
  }

  int? pLastOf(int pJ, int pILast) {
    assert(pJ > 0 && pJ <= length && pILast > 0);
    for (var bits = this[pJ - 1], i = pILast - 1; i > -1; i--) {
      if (bits & 1 << i == 1 << i) return i + 1;
    }
    return null;
  }

  ///
  /// [bits], [ps]
  /// [bitsFixed], [psFixed]
  ///
  Iterable<int> bits([int j = 0, int i = 0]) sync* {
    assert(j > -1 && j < length && i > -1);
    for (var bits = this[j] >> i; bits > 0; bits >>= 1, i++) {
      if (bits & 1 == 1) yield i;
    }
  }

  Iterable<int> bitsFixed(int iLimit, [int j = 0, int i = 0]) sync* {
    assert(j > -1 && j < length && i > -1 && i < iLimit);
    for (var bits = this[j] >> i; i < iLimit; bits >>= 1, i++) {
      if (bits & 1 == 1) yield i;
    }
  }

  //
  Iterable<int> ps([int j = 0, int p = 1]) sync* {
    assert(j > -1 && j < length && p > 0);
    for (var bits = this[j] >> p - 1; bits > 0; bits >>= 1, p++) {
      if (bits & 1 == 1) yield p;
    }
  }

  Iterable<int> psFixed(int pLimit, [int j = 0, int p = 1]) sync* {
    assert(j > -1 && j < length && p > -1 && p < pLimit);
    for (var bits = this[j] >> p - 1; p < pLimit; bits >>= 1, p++) {
      if (bits & 1 == 1) yield p;
    }
  }

  ///
  /// [mapBits], [mapPs]
  /// [mapBitsFixed], [mapPs]
  /// [mapBitsAll]; [mapPsAll]
  ///
  Iterable<T> mapBits<T>(
    T Function(int) mapping, [
    int j = 0,
    int i = 0,
  ]) sync* {
    assert(j > -1 && j < length && i > -1);
    for (var bits = this[j] >> i; bits > 0; bits >>= 1, i++) {
      if (bits & 1 == 1) yield mapping(i);
    }
  }

  Iterable<T> mapBitsFixed<T>(
    T Function(int) mapping,
    int iLimit, [
    int j = 0,
    int i = 0,
  ]) sync* {
    assert(j > -1 && j < length && i > -1 && i < iLimit);
    for (var bits = this[j] >> i; i < iLimit; bits >>= 1, i++) {
      if (bits & 1 == 1) yield mapping(i);
    }
  }

  Iterable<T> mapBitsAll<T>(
    T Function(int, int) mapping, [
    int j = 0,
    int? jLimit,
    int i = 0,
  ]) sync* {
    final limit = jLimit ?? length;
    assert(j > -1 && j < limit && i > -1);
    for (; j < limit; j++) {
      for (var bits = this[j] >> i; bits > 0; bits >>= 1, i++) {
        if (bits & 1 == 1) yield mapping(j, i);
      }
    }
  }

  //
  Iterable<T> mapPs<T>(
    T Function(int) mapping, [
    int pJ = 0,
    int pI = 1,
  ]) sync* {
    assert(pJ > 0 && pJ <= length && pI > 0);
    for (var bits = this[pJ - 1] >> pI - 1; bits > 0; bits >>= 1, pI++) {
      if (bits & 1 == 1) yield mapping(pI);
    }
  }

  Iterable<T> mapPsFixed<T>(
    T Function(int) mapping,
    int pLimit, [
    int pJ = 1,
    int pI = 1,
  ]) sync* {
    assert(pJ > 0 && pJ <= length && pI > 0 && pI < pLimit);
    for (var bits = this[pJ - 1] >> pI - 1; pI < pLimit; bits >>= 1, pI++) {
      if (bits & 1 == 1) yield mapping(pI);
    }
  }

  Iterable<T> mapPsAll<T>(
    T Function(int, int) mapping, [
    int pJ = 1,
    int? pJLimit,
    int pI = 1,
  ]) sync* {
    final last = pJLimit ?? length;
    assert(pJ > 0 && pJ <= last && pI > 0);
    for (; pJ <= last; pJ++) {
      for (var bits = this[pJ - 1] >> pI - 1; bits > 0; bits >>= 1, pI++) {
        if (bits & 1 == 1) yield mapping(pJ, pI);
      }
    }
  }

  ///
  /// [pSet], [pClear]
  /// [pConsume]
  ///
  void pSet(int p, int shift, int mask) {
    assert(p > -1 && mask + 1 == 1 << shift);
    this[p >> shift] |= 1 << (p & mask);
  }

  void pClear(int p, int shift, int mask) {
    assert(p > -1 && mask + 1 == 1 << shift);
    this[p >> shift] &= ~(1 << (p & mask));
  }

  void pConsume(
    void Function(int p) consume,
    int sizeEach, [
    int bit = 1,
    int? jLimit,
  ]) {
    jLimit ??= length;
    assert(
      sizeEach > 0 && jLimit > 0 && jLimit <= length && bit == 0 || bit == 1,
    );
    for (var j = 0; j < jLimit; j++) {
      for (var i = 1, bits = this[j]; bits > 0; i++, bits >>= 1) {
        if (bits & 1 == bit) consume(sizeEach * j + i);
      }
    }
  }

  ///
  /// [pOn]
  ///
  bool pOn(int p, int shift, int mask) {
    assert(p > -1 && mask + 1 == 1 << shift);
    return (this[p >> shift] >> (p & mask)) & 1 == 1;
  }

  ///
  /// [pFirst]
  /// [pLast]
  /// [pN]
  ///
  int? pFirst(int sizeEach) {
    assert(sizeEach > 0);
    final length = this.length;
    for (var j = 0; j < length; j++) {
      var i = 0;
      for (var bits = this[j]; bits > 0; i++, bits >>= 1) {
        if (bits & 1 == 1) return sizeEach * j + i;
      }
      assert(i < sizeEach);
    }
    return null;
  }

  int? pLast(int sizeEach) {
    assert(sizeEach > 0);
    for (var j = length - 1; j > -1; j--) {
      for (var i = sizeEach - 1, bits = this[j]; i > -1; i--) {
        if (bits & 1 << i == 1 << i) return sizeEach * j + i;
      }
    }
    return null;
  }

  int? pN(int n, int sizeEach) {
    assert(sizeEach > 0);
    final length = this.length;
    for (var j = 0; j < length; j++) {
      var i = 0;
      for (var bits = this[j]; bits > 0; i++, bits >>= 1) {
        if (bits & 1 == 1) {
          n--;
          if (n == 0) return sizeEach * j * i;
        }
      }
      assert(i < sizeEach);
    }
    return null;
  }

  ///
  /// [pFirstFrom]
  /// [pNFrom]
  /// [pLastTo]
  ///
  int? pFirstFrom(int j, int from, int sizeEach) {
    assert(sizeEach > 0 && from.isRangeOpenUpper(0, sizeEach));
    final length = this.length;
    if (j >= length) return null;

    for (var bits = this[j] >> from; bits > 0; from++, bits >>= 1) {
      if (bits & 1 == 1) return sizeEach * j + from;
    }
    for (j++; j < length; j++) {
      from = 0;
      for (var bits = this[j]; bits > 0; from++, bits >>= 1) {
        if (bits & 1 == 1) return sizeEach * j + from;
      }
      assert(from < sizeEach);
    }
    return null;
  }

  int? pLastTo(int j, int to, int sizeEach) {
    assert(sizeEach > 0 && to.isRangeOpenUpper(0, sizeEach));
    if (j >= length) return null;

    for (var bits = this[j]; to > -1; to--) {
      if (bits & 1 << to == 1 << to) return sizeEach * j + to;
    }

    for (j--; j > -1; j--) {
      to = sizeEach - 1;
      for (var bits = this[j]; to > -1; to--) {
        if (bits & 1 << to == 1 << to) return sizeEach * j + to;
      }
    }
    return null;
  }

  int? pNFrom(int j, int from, int sizeEach, int n) {
    assert(sizeEach > 0 && from.isRangeOpenUpper(0, sizeEach));
    final length = this.length;
    if (j >= length) return null;

    for (var bits = this[j] >> from; bits > 0; from++, bits >>= 1) {
      if (bits & 1 == 1) {
        n--;
        if (n == 0) return sizeEach * j + from;
      }
      assert(from < sizeEach);
    }
    for (j++; j < length; j++) {
      from = 1;
      for (var bits = this[j]; bits > 0; from++, bits >>= 1) {
        if (bits & 1 == 1) {
          n--;
          if (n == 0) return sizeEach * j + from;
        }
      }
      assert(from < sizeEach);
    }
    return null;
  }

  ///
  /// [pFirstAfter]
  /// [pLastBefore]
  ///
  int? pFirstAfter(int p, int shift, int mask, int sizeEach) {
    assert(p > -1 && mask + 1 == 1 << shift);
    if (p >= length * sizeEach) return null;
    p++;
    return pFirstFrom(p >> shift, p & mask, sizeEach);
  }

  int? pLastBefore(int p, int shift, int mask, int sizeEach) {
    assert(p > -1 && mask + 1 == 1 << shift);
    if (p == 0) return null;
    p--;
    return pLastTo(p >> shift, p & mask, sizeEach);
  }

  ///
  ///
  /// [pAvailable], [mapPAvailable]
  /// [pAvailableFrom], [mapPAvailableFrom]
  /// [pAvailableLatest], [mapPAvailableLatest]
  /// [pAvailableRecent], [mapPAvailableRecent]
  ///
  ///
  ///
  Iterable<int> pAvailable(int sizeEach) sync* {
    assert(sizeEach > 0);
    final length = this.length;
    for (var j = 0, index = 0; j < length; index = sizeEach * j) {
      for (var bits = this[j]; bits > 0; index++, bits >>= 1) {
        if (bits & 1 == 1) yield index;
      }
      j++;
      assert(index < sizeEach * j);
    }
  }

  Iterable<int> pAvailableFrom(
    int j,
    int i,
    int sizeEach,
    bool includeFrom,
  ) sync* {
    if (!includeFrom) {
      i++;
      if (i == sizeEach) {
        j++;
        i = 0;
      }
    }
    final length = this.length;
    assert(sizeEach > 0);
    assert(j.isRangeOpenUpper(0, length) && i.isRangeOpenUpper(0, sizeEach));

    var bits = this[j] >> i, p = sizeEach * j;
    while (true) {
      for (; bits > 0; p++, bits >>= 1) {
        if (bits & 1 == 1) yield p;
      }
      j++;
      assert(p < sizeEach * j);
      bits = this[j];
      p = sizeEach * j;
      if (j == length) break;
    }
  }

  Iterable<int> pAvailableLatest(
    int j,
    int i,
    int sizeEach,
    bool inclusive,
  ) sync* {
    if (!inclusive) {
      i--;
      if (i < 0) {
        j--;
        i = sizeEach - 1;
      }
    }
    assert(j > -1 && i.isRangeOpenUpper(0, sizeEach) && sizeEach > 0);
    final length = this.length;
    if (j >= length) j = length - 1;
    var bits = this[j] >> i, p = sizeEach * j;
    while (true) {
      for (; i > -1; i--) {
        if (bits & 1 << i == 1 << i) yield p + i;
      }
      j--;
      if (j < 0) return;
      bits = this[j];
      p -= sizeEach;
      i = sizeEach - 1;
    }
  }

  Iterable<int> pAvailableRecent(
    int sizeEach, [
    int j = 0,
    int i = 0,
    int? jTo,
    int? iTo,
  ]) sync* {
    assert(() {
      if (sizeEach < 1) return false;
      if (j != 0) {
        if (j < 0 || j >= length) return false;
        if (jTo != null && jTo < j) return false;
      }
      if (i != 0) {
        if (i < 0 || i >= sizeEach) return false;
        if (iTo != null && iTo < i) return false;
      }
      // if both null, call pAvailableFrom instead of pAvailableRecent
      return jTo != null || iTo != null;
    }());

    final jLast = jTo ?? length - 1, iLast = iTo ?? sizeEach - 1;
    var bits = this[j] >> i, p = sizeEach * j;
    while (true) {
      for (; bits > 0; p++, bits >>= 1) {
        if (bits & 1 == 1) yield p;
      }
      j++;
      assert(p < sizeEach * j);
      bits = this[j];
      p = sizeEach * j;
      if (j == jLast) break;
    }
    for (i = 0; i <= iLast; i++, bits >>= 1) {
      if (bits & 1 == 1) yield p + i;
    }
  }

  ///
  ///
  ///
  Iterable<T> mapPAvailable<T>(int sizeEach, T Function(int) mapper) sync* {
    assert(sizeEach > 0);
    final length = this.length;
    for (var j = 0, index = 0; j < length; index = sizeEach * j) {
      for (var bits = this[j]; bits > 0; index++, bits >>= 1) {
        if (bits & 1 == 1) yield mapper(index);
      }
      j++;
      assert(index < sizeEach * j);
    }
  }

  Iterable<T> mapPAvailableFrom<T>(
    int j,
    int i,
    int sizeEach,
    bool includeFrom,
    T Function(int) mapper,
  ) sync* {
    if (!includeFrom) {
      i++;
      if (i == sizeEach) {
        j++;
        i = 0;
      }
    }
    final length = this.length;
    assert(sizeEach > 0);
    assert(j.isRangeOpenUpper(0, length) && i.isRangeOpenUpper(0, sizeEach));

    var bits = this[j] >> i, p = sizeEach * j;
    while (true) {
      for (; bits > 0; p++, bits >>= 1) {
        if (bits & 1 == 1) yield mapper(p);
      }
      j++;
      assert(p < sizeEach * j);
      bits = this[j];
      p = sizeEach * j;
      if (j == length) break;
    }
  }

  Iterable<T> mapPAvailableLatest<T>(
    int j,
    int i,
    int sizeEach,
    bool inclusive,
    T Function(int) mapper,
  ) sync* {
    if (!inclusive) {
      i--;
      if (i < 0) {
        j--;
        i = sizeEach - 1;
      }
    }
    assert(j > -1 && i.isRangeOpenUpper(0, sizeEach) && sizeEach > 0);
    final length = this.length;
    if (j >= length) j = length - 1;
    var bits = this[j] >> i, p = sizeEach * j;
    while (true) {
      for (; i > -1; i--) {
        if (bits & 1 << i == 1 << i) yield mapper(p + i);
      }
      j--;
      if (j < 0) return;
      bits = this[j];
      p -= sizeEach;
      i = sizeEach - 1;
    }
  }

  Iterable<T> mapPAvailableRecent<T>(
    int j,
    int i,
    int sizeEach,
    T Function(int) mapper, [
    int? jTo,
    int? iTo,
  ]) sync* {
    assert(() {
      if (sizeEach < 1) return false;
      if (j != 0) {
        if (j < 0 || j >= length) return false;
        if (jTo != null && jTo < j) return false;
      }
      if (i != 0) {
        if (i < 0 || i >= sizeEach) return false;
        if (iTo != null && iTo < i) return false;
      }
      // if both null, call pAvailableFrom instead of pAvailableRecent
      return jTo != null || iTo != null;
    }());

    final jLast = jTo ?? length - 1, iLast = iTo ?? sizeEach - 1;
    var bits = this[j] >> i, p = sizeEach * j;
    while (true) {
      for (; bits > 0; p++, bits >>= 1) {
        if (bits & 1 == 1) yield mapper(p);
      }
      j++;
      assert(p < sizeEach * j);
      bits = this[j];
      p = sizeEach * j;
      if (j == jLast) break;
    }
    for (i = 0; i <= iLast; i++, bits >>= 1) {
      if (bits & 1 == 1) yield mapper(p + i);
    }
  }
}
