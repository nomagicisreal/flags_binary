part of '../flags_binary.dart';

///
///
/// [_PFlags]
///   **[_AFieldContainer] for all [_PFlags] concrete children
///   **[_AFieldIdentical]
///   **[_AFieldBits]
///   **[_AFlagsOn]
///   **[_AFlagsSet]
///   **[_AFlagsOperatable]
///   |
///   --[FieldParent], [SlotParent]
///   |   --[Field], [Field2D], [Field3D], [Field4D]
///   |   --[FieldDatesInMonths]
///   |   --[FieldAB]
///   |
///   --[_PFieldMapSplay]
///   |   --[FieldMapDate]
///   |   --[FieldMapHourDate]
///   |
///   --[SlotParent]
///   |   --[Slot]
///   |
///
///
///
///
/// there are only two functions here: [clear], [toString]
///
sealed class _PFlags {
  const _PFlags();

  ///
  /// clear all flags
  ///
  void clear();

  @override
  String toString() {
    String result = '';

    assert(() {
      final buffer = StringBuffer('$runtimeType field:\n'), flags = this;

      ///
      /// slot
      ///
      if (flags is SlotParent) {
        final slot = flags._slot,
            length = slot.length,
            padItem = slot.map((s) => '$s'.length).reduce(math.max) + 1;
        late final int padOverallSpace;

        String itemOf(int i) => '${slot[i]}'.padLeft(padItem);
        final _ = switch (flags) {
          Slot() || Slot2D() || Slot3D() || Slot4D() => () {
            if (flags is Slot) {
              final pad = '$length'.length + 1;
              padOverallSpace = 6 + pad;
              buffer.writeRepeat(padOverallSpace, '-', true);
              buffer.writeln('space: $length');
              buffer.writeRepeat(padOverallSpace, '-', true);
              for (var i = 0; i < length; i++) {
                if (i & 3 == 0) {
                  buffer.write('|');
                  final end = math.min(i + 4, length);
                  if (end == i) {
                    buffer.write('${i + 1}'.padLeft(pad + 3));
                  } else {
                    buffer.write('$i'.padLeft(pad + 1));
                    buffer.write('~$end');
                  }
                }
                buffer.writeln();
                buffer.write('| ');
                buffer.write('${i + 1}'.padRight(pad));
                buffer.write(':');
                buffer.write(itemOf(i));
                if (i + 1 & 3 == 0) {
                  if (i == length - 1) break;
                  buffer.writeln();
                }
              }
              buffer.writeln();
              return;
            }

            void writeTitle(Iterable<int> record, Iterable<int> padding) {
              buffer.writeRepeat(padOverallSpace, '-', true);
              buffer.write('space: ');
              buffer.writeRecord(record, padding, true);
              buffer.writeRepeat(padOverallSpace, '-', true);
            }

            if (flags is Slot2D) {
              final s1 = flags.spatial1,
                  s2 = flags.spatial2,
                  padJ = '$s1'.length + 1,
                  padI = '$s2'.length + 1,
                  padding = [padJ, padI];
              padOverallSpace = padJ + padI + 10;
              writeTitle([s1, s2], padding);
              int start = -1;
              for (var j = 1; j <= s1; j++) {
                for (var i = 1; i <= s2; i++) {
                  buffer.writeRecord([j, i], padding);
                  buffer.write(' :');
                  buffer.writeln(itemOf(start + i));
                }
                start += s2;
              }
              return;
            }

            if (flags is Slot3D) {
              final s1 = flags.spatial1,
                  s2 = flags.spatial2,
                  s3 = flags.spatial3,
                  padK = '$s1'.length + 1,
                  padJ = '$s2'.length + 1,
                  padI = '$s3'.length + 1,
                  padding = [padK, padJ, padI];
              padOverallSpace = padK + padJ + padI + 11;
              writeTitle([s1, s2, s3], padding);
              int start = -1;
              for (var k = 1; k <= s1; k++) {
                for (var j = 1; j <= s2; j++) {
                  for (var i = 1; i <= s3; i++) {
                    buffer.writeRecord([k, j, i], padding);
                    buffer.write(' :');
                    buffer.writeln(itemOf(start + i));
                  }
                  start += s3;
                }
              }
              return;
            }

            if (flags is Slot4D) {
              final s1 = flags.spatial1,
                  s2 = flags.spatial2,
                  s3 = flags.spatial3,
                  s4 = flags.spatial4,
                  padL = '$s1'.length + 1,
                  padK = '$s2'.length + 1,
                  padJ = '$s3'.length + 1,
                  padI = '$s4'.length + 1,
                  padding = [padL, padK, padJ, padI];
              padOverallSpace = padL + padK + padJ + padI + 12;
              writeTitle([s1, s2, s3, s4], padding);
              int start = -1;
              for (var l = 1; l <= s1; l++) {
                for (var k = 1; k <= s2; k++) {
                  for (var j = 1; j <= s3; j++) {
                    for (var i = 1; i <= s4; i++) {
                      buffer.writeRecord([l, k, j, i], padding);
                      buffer.write(' :');
                      buffer.writeln(itemOf(start + i));
                    }
                    start += s4;
                  }
                }
              }
              return;
            }

            throw UnimplementedError();
          }(),
          SlotDatesInMonths() => throw UnimplementedError(),
        };
        buffer.writeRepeat(padOverallSpace, '-');
        buffer.writeln();

        ///
        /// field
        ///
      } else if (flags is FieldParent) {
        final field = flags._field,
            sizeEach = flags._sizeEach,
            instance = this,
            borderLength = switch (instance) {
              SlotParent() => 0,
              Field() =>
                3 +
                    '${instance.spatial1}'.length * 2 +
                    4 +
                    (instance._sizeEach + 3 >> 2) * 5 +
                    2,
              Field2D() =>
                2 +
                    '${instance.spatial1}'.length +
                    2 +
                    instance.spatial2 +
                    (instance.spatial2 + 3 >> 2) +
                    2,
              Field3D() =>
                2 +
                    '${instance.spatial2}'.length +
                    2 +
                    instance.spatial3 +
                    (instance.spatial3 + 3 >> 2) +
                    2,

              Field4D() =>
                2 +
                    '${instance.spatial3}'.length +
                    2 +
                    instance.spatial4 +
                    (instance.spatial4 + 3 >> 2) +
                    2,
              FieldDatesInMonths() => 1 + 12 + 32 + 4 + 1,
              // FieldAB() =>
              //   3 +
              //       6 +
              //       2 +
              //       switch (instance.bDivision) {
              //             1 => 6,
              //             2 || 3 => 4,
              //             _ => 3,
              //           } *
              //           (instance.bDivision + 1) +
              //       2,
              _ => throw UnimplementedError(),
            };
        buffer.writeRepeat(borderLength, '-');
        buffer.writeln();

        final _ = switch (flags) {
          Field() || Field2D() || Field3D() || Field4D() => () {
            if (flags is Field) {
              final spatial1 = flags.spatial1,
                  limit = field.length,
                  pad = '${sizeEach * field.length}'.length + 1,
                  jLast = field.length - 1,
                  last = spatial1 & flags._mask;

              for (var j = 0; j < limit; j++) {
                final start = j * sizeEach;
                late final int padAfterBits;
                late final String end;
                late final bool Function(int) predicate;
                if (j != jLast || last == 0) {
                  end = '${start + sizeEach}';
                  predicate = _predicator_less(sizeEach);
                  padAfterBits = 1;
                } else {
                  end = '$spatial1';
                  predicate = _predicator_additionLess(start, spatial1);
                  padAfterBits =
                      1 + (sizeEach >> 2) * 5 - last - (last + 3 >> 2);
                }

                buffer.write('|');
                buffer.write('${start + 1}'.padLeft(pad));
                buffer.write(' ~');
                buffer.write(end.padLeft(pad));
                buffer.write(' :');
                var i = 0;
                for (var bits = field[j]; bits > 0; bits >>= 1) {
                  if (i & 3 == 0) buffer.write(' ');
                  buffer.writeBit(bits);
                  i++;
                }
                while (predicate(i)) {
                  if (i & 3 == 0) buffer.write(' ');
                  buffer.write('0');
                  i++;
                }
                buffer.writeRepeat(padAfterBits, ' ');
                buffer.writeln('|');
              }
              return;
            }

            void fieldFlags2(
              int nrow,
              int ncol,
              int mask, [
              int l = 0,
              int pass = 0,
            ]) {
              final pad = '$nrow'.length + 1,
                  remain4 = ncol & 3,
                  limit = remain4 == 0 ? (ncol >> 2) - 1 : ncol >> 2,
                  padAfterBits = 1 + remain4 + 1;

              buffer.write('|'.padRight(pad + 3));
              var chunk = 0;
              for (; chunk < limit; chunk++) {
                buffer.write(' ${chunk * 4 + 1}'.padRight(5));
              }
              buffer.write(' ${chunk * 4 + 1}'.padRight(padAfterBits));
              buffer.writeln('|');

              buffer.write('|'.padRight(pad + 3));
              for (chunk = 0; chunk < limit; chunk++) {
                buffer.write(' v'.padRight(5));
              }
              buffer.write(' v'.padRight(padAfterBits));
              buffer.writeln('|');

              var bits = field[l] >> pass;
              for (var j = 0; j < nrow; j++) {
                buffer.write('|');
                buffer.write('${j + 1}'.padLeft(pad));
                buffer.write(' :');
                final start = pass + j * ncol;
                var i = 1;
                while (i <= ncol) {
                  if (i & 3 == 1) buffer.write(' ');
                  buffer.writeBit(bits);
                  bits >>= 1;
                  if (start + ++i & mask == 1) bits = field[++l];
                }
                buffer.writeln(' |');
              }
            }

            if (flags is Field2D) {
              fieldFlags2(flags.spatial1, flags.spatial2, flags._mask);
              return;
            }

            ///
            ///
            ///
            void fieldFlags3(
              int spatial1,
              int spatial2,
              int spatial3,
              int mask,
            ) {
              final space = spatial2 * spatial3;
              for (var k = 0; k < spatial1; k++) {
                final start = k * space;
                fieldFlags2(
                  spatial2,
                  spatial3,
                  mask,
                  start ~/ sizeEach,
                  start % sizeEach,
                );
                if (k < spatial1 - 1) {
                  buffer.write('\\');
                  buffer.write('${k + 1}/'.padLeft(borderLength - 1, '-'));
                  buffer.writeln();

                  buffer.write('/${k + 2}'.padRight(borderLength - 1, '-'));
                  buffer.write('\\');
                  buffer.writeln();
                }
              }
            }

            if (flags is Field3D) {
              fieldFlags3(
                flags.spatial1,
                flags.spatial2,
                flags.spatial3,
                flags._mask,
              );
              return;
            }

            if (flags is Field4D) {
              buffer.writeRepeat(borderLength, '==');
              buffer.writeRepeat(borderLength, '==');
            }
            throw UnimplementedError();
          }(),
          FieldDatesInMonths() => () {
            buffer.write('|');
            buffer.writeRepeat(12, ' ');
            for (var d = 1; d < 32; d+=8) {
              buffer.write('Day $d'.padRight(9));
            }
            buffer.writeln('|');

            buffer.write('|');
            buffer.writeRepeat(12, ' ');
            for (var c = 0; c < 4; c++) {
              buffer.write(' v'.padRight(9));
            }
            buffer.writeln('|');

            final december = DateTime.december,
                begin = flags.begin,
                limit = field.length;
            var year = begin.$1, month = begin.$2;
            for (var j = 0; j < limit; j++) {
              buffer.write('| (');
              buffer.write('$year'.padLeft(4));
              buffer.write(',');
              buffer.write('$month'.padLeft(2));
              buffer.write(') : ');
              buffer.writeBitsOfMonth(field[j], _monthDaysOf(year, month));
              buffer.writeln('|');
              month++;
              if (month > december) {
                month = 1;
                year++;
              }
            }
          }(),
          // FieldAB() => () {
          //   final shift = flags._shift,
          //       mask = flags._mask,
          //       division = flags.bDivision,
          //       hoursPerLine = switch (division) {
          //         1 => 6,
          //         2 || 3 => 4,
          //         _ => 3,
          //       },
          //       size = hoursPerLine * division,
          //       limit = (flags.aLimit - 1) ~/ hoursPerLine;
          //   var i = 0;
          //   for (var j = 0; j < limit; j++) {
          //     final h = j * hoursPerLine;
          //     buffer.write('|');
          //     buffer.write('$h'.padLeft(3));
          //     buffer.write(' ~');
          //     buffer.write('${h + hoursPerLine - 1}'.padLeft(3));
          //     buffer.write(' :');
          //     for (var m = 0; m < size; m++) {
          //       if (m % division == 0) buffer.write(' ');
          //       buffer.writeBit(field[i >> shift] >> (i & mask));
          //       i++;
          //     }
          //     buffer.writeln(' |');
          //   }
          // }(),
          // FieldWeekSchedule() => throw UnimplementedError(),
        };
        buffer.writeRepeat(borderLength, '-');
        buffer.writeln();
      } else {
        throw UnimplementedError();
      }

      result = buffer.toString();
      return true;
    }());
    return result;
  }
}
