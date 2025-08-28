part of '../flags_binary.dart';

///
///
/// [_PFlags]
///   **[_AFieldContainer] for all [_PFlags] concrete children
///   **[_AFieldIdentical]
///   **[_AFieldBits]
///   **[_AFlagsCollapse]
///   **[_AFlagsSet]
///   **[_AFlagsOperatable]
///   |
///   --[FieldParent], [SlotParent]
///   |   --[Field]
///   |   --[Field2D]
///   |   --[Field3D]
///   |   --[Field4D]
///   |   --[_PFieldScoped]
///   |   |   --[FieldDatesInMonths]
///   |   |
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
      final buffer = StringBuffer('$runtimeType field:\n'),
          instance = this,
          borderLength = switch (instance) {
            Field() =>
              3 +
                  '${instance.spatial1}'.length * 2 +
                  4 +
                  (instance._sizeEach + 3 >> 2) * 5 +
                  2,
            _AFlagsSpatial2() => // Field2D() || Field3D() || Field4D()
              2 +
                  '${instance.spatial2}'.length +
                  2 +
                  instance.spatial1 +
                  (instance.spatial1 + 3 >> 2) +
                  2,
            FieldAB() =>
              3 +
                  6 +
                  2 +
                  switch (instance.bDivision) {
                        1 => 6,
                        2 || 3 => 4,
                        _ => 3,
                      } *
                      (instance.bDivision + 1) +
                  2,
            FieldDatesInMonths() => 15 + 32 + 4 + 2,
            _ => 10,
          };
      buffer.writeRepeat(borderLength, '-');
      buffer.writeln();

      ///
      /// slot
      ///
      if (instance is SlotParent) {
        final slot = instance._slot,
            length = slot.length,
            pad = '$length'.length + 1,
            padItem = slot.map((s) => '$s'.length).reduce(math.max);

        final _ = switch (instance) {
          Slot() || Slot2D() || Slot3D() || Slot4D() => () {
            if (instance is Slot) {
              for (var i = 0; i < length; i++) {
                if (i & 3 == 0) {
                  buffer.write('|');
                  buffer.write('$i'.padLeft(pad));
                  buffer.write('~');
                  buffer.write('${math.min(i + 3, length - 1)}');
                }
                buffer.writeln();
                buffer.write('|');
                buffer.writeRepeat(pad - 1, '.');
                buffer.write('${slot[i]}'.padLeft(padItem));
                if (i + 1 & 3 == 0) {
                  if (i == length - 1) break;
                  buffer.writeln();
                  buffer.writeln('|');
                }
              }
              return;
            }

            // void slotFlags2D(int spatial1, int spatial2) {
            // }

            if (instance is Slot2D) {}

            throw UnimplementedError();
          }(),
          SlotDatesInMonths() => throw UnimplementedError(),
        };

        ///
        /// field
        ///
      } else if (instance is FieldParent) {
        final field = instance._field, sizeEach = instance._sizeEach;
        final _ = switch (instance) {
          Field() || Field2D() || Field3D() || Field4D() => () {
            if (instance is Field) {
              final spatial1 = instance.spatial1,
                  limit = field.length,
                  pad = '${sizeEach * field.length}'.length + 1,
                  jLast = field.length - 1,
                  last = spatial1 & instance._mask;

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
                  end = '${spatial1 - 1}';
                  predicate = _predicator_additionLess(start, spatial1);
                  padAfterBits =
                      1 + (sizeEach >> 2) * 5 - last - (last + 3 >> 2);
                }

                buffer.write('|');
                buffer.write('$start'.padLeft(pad));
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
              int spatial1,
              int spatial2,
              int mask, [
              int l = 0,
              int pass = 0,
            ]) {
              final pad = '$spatial2'.length + 1,
                  limit = spatial1 >> 2,
                  padAfterBits = 5 - (spatial1 & 3) + 1;

              buffer.write('|'.padRight(pad + 3));
              var chunk = 0;
              for (; chunk < limit; chunk++) {
                buffer.write(' ${chunk * 4}'.padRight(5));
              }
              buffer.write(' ${chunk * 4}'.padRight(padAfterBits));
              buffer.writeln('|');

              buffer.write('|'.padRight(pad + 3));
              for (chunk = 0; chunk < limit; chunk++) {
                buffer.write(' v'.padRight(5));
              }
              buffer.write(' v'.padRight(padAfterBits));
              buffer.writeln('|');

              var bits = field[l] >> pass;
              l++;
              final nextField =
                  field.length == 1
                      ? null
                      : (j, i) {
                        if (i == spatial1) return;
                        if (j * spatial1 + pass + i & mask == 0) {
                          bits = field[l];
                          pass = 0;
                          l++;
                        }
                      };
              for (var j = 0; j < spatial2; j++) {
                buffer.write('|');
                buffer.write('$j'.padLeft(pad));
                buffer.write(' :');
                var i = 0;
                while (i < spatial1) {
                  if (i % 4 == 0) buffer.write(' ');
                  buffer.writeBit(bits);
                  bits >>= 1;
                  i++;
                  nextField?.call(j, i);
                }
                buffer.writeln(' |');
              }
            }

            if (instance is Field2D) {
              fieldFlags2(instance.spatial1, instance.spatial2, instance._mask);
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
              final space = spatial1 * spatial2;
              for (var k = 0; k < spatial3; k++) {
                final start = k * space;
                fieldFlags2(
                  spatial1,
                  spatial2,
                  mask,
                  start ~/ sizeEach,
                  start % sizeEach,
                );
                if (k < spatial3 - 1) {
                  buffer.write('\\');
                  buffer.write('${k + 1}/'.padLeft(borderLength - 1, '-'));
                  buffer.writeln();

                  buffer.write('/${k + 2}'.padRight(borderLength - 1, '-'));
                  buffer.write('\\');
                  buffer.writeln();
                }
              }
            }

            if (instance is Field3D) {
              fieldFlags3(
                instance.spatial1,
                instance.spatial2,
                instance.spatial3,
                instance._mask,
              );
              return;
            }

            if (instance is Field4D) {
              buffer.writeRepeat(borderLength, '==');
              buffer.writeRepeat(borderLength, '==');
            }
            throw UnimplementedError();
          }(),
          FieldAB() => () {
            final shift = instance._shift,
                mask = instance._mask,
                division = instance.bDivision,
                hoursPerLine = switch (division) {
                  1 => 6,
                  2 || 3 => 4,
                  _ => 3,
                },
                size = hoursPerLine * division,
                limit = (instance.aLimit - 1) ~/ hoursPerLine;
            var i = 0;
            for (var j = 0; j < limit; j++) {
              final h = j * hoursPerLine;
              buffer.write('|');
              buffer.write('$h'.padLeft(3));
              buffer.write(' ~');
              buffer.write('${h + hoursPerLine - 1}'.padLeft(3));
              buffer.write(' :');
              for (var m = 0; m < size; m++) {
                if (m % division == 0) buffer.write(' ');
                buffer.writeBit(field[i >> shift] >> (i & mask));
                i++;
              }
              buffer.writeln(' |');
            }
          }(),
          FieldDatesInMonths() => () {
            final december = DateTime.december,
                begin = instance.begin,
                limit = field.length;
            var year = begin.$1, month = begin.$2;

            for (var j = 0; j < limit; j++) {
              buffer.write('|');
              buffer.write('($year'.padLeft(6));
              buffer.write(',');
              buffer.write('$month)'.padLeft(4));
              buffer.write(' :');
              buffer.write(' ');
              buffer.writeBitsOfMonth(field[j], _monthDaysOf(year, month));
              buffer.writeln(' |');
              month++;
              if (month > december) {
                month = 1;
                year++;
              }
            }
          }(),
        };
      } else {
        throw UnimplementedError();
      }

      buffer.writeRepeat(borderLength, '-');
      buffer.writeln();
      result = buffer.toString();
      return true;
    }());
    return result;
  }
}
