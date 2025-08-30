
import 'package:flags_binary/flags_binary.dart';

void main() {
  final field = Field2D(10, 6);
  field[(2, 2)] = true;
  print(field.toString());

  // final field = FieldDatesInMonths((2025, 7), (2025, 12));
  // field[(2025, 8, 30)] = true;
  // field.includesSub((2025, 8, 10), (2025, 9, 20));
  // print(field.toString());

  // final slot = Slot4D<String>(5, 3, 4, 2);
  // final slot = Slot3D<String>(5, 3, 4);
  // final slot = Slot2D<String>(5, 3);
  // final slot = Slot<String>(29);
  // print(slot.toString());
}

