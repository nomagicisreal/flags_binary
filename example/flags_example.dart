// ignore: unused_import
import 'package:flags_binary/flags_binary.dart';

void main() {
  final field = Field(99);
  field.includesSub(20, 60);
  // final field = Field2D(10, 22);
  // field.includesOn(5, [1, 2, 7, 9, 18]);
  // final field = Field3D(2, 10, 15);
  // field.includesOn(2, [(1, 1), (9, 3), (4, 10)]);
  print(field.availablesLatest(40, 22));

  // print(field.availablesLatest(25));
  // field[(2, 1)] = true;
  // print(field.firstAfter((2, 0)));
  // print(field.toString());

  // print(field.firstAfter((2, 1, 0)));
  // print(field.toString());

  // final field = FieldDatesInMonths((2025, 7), (2025, 12));
  // field.includesSub((2025, 8, 10), (2025, 9, 20));
  // print(field.availablesFrom((2025, 9, 18), false));
  // print(field.availablesTo((2025, 8, 12), false));
  // print(field.availablesSub((2025, 8, 20), (2025, 8, 24), false, false));

  // final slot = Slot4D<String>(5, 3, 4, 2);
  // slot.includesFrom(['he', 'she', 'it'], (0, 1, 1, 1), false);
  // final slot = Slot3D<String>(5, 3, 4);
  // slot.includesFrom(['he', 'she', 'it'], (1, 1, 1), false);
  // final slot = Slot2D<String>(5, 3);
  // slot.includesFrom(['he', 'she', 'it'], (1, 1), false);
  // final slot = Slot<String>(29);
  // slot.includesFrom(['he', 'she', 'it'], 5, false);
  // print(slot.toString());
}
