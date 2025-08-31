import 'package:flags_binary/flags_binary.dart';

void main() {
  final field = Field2D(10, 6);
  field.includesSub((0, 1), (1, 2));
  print(field.availablesFrom((0, 5), false));
  print(field.availablesTo((0, 5)));

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
