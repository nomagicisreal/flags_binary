// ignore: unused_import
import 'package:flags_binary/flags_binary.dart';

void main() {
  // final field = Field(99);
  // field.includesSub(20, 23);
  // print(field.availablesLatest(22));
  // print(field.toSlot<String>((value) => 's:$value'));

  // final field = Field2D(10, 22);
  // field.includesOn(5, [1, 2, 7, 9, 18]);
  // field.includesSub((2, 5), (3, 2));
  // print(field.toString());

  // final field = Field3D(2, 10, 15);
  // field.includesSub((1, 3, 12), (1, 5, 14));
  // print(field.collapseOn(1));
  // field.includesOn(2, [(1, 1), (9, 3), (4, 10)]);
  // print(field.collapseOn(2));

  // final field = Field4D(2, 4, 9, 11);
  // field.includesSub((2, 4, 8, 4));
  // print(field.firstAfter((1, 2, 1, 1)));
  // print(field.collapseOn(2).collapseOn(4));


  final field = FieldDatesInMonths((2025, 7), (2025, 12));
  // field.includesSub((2025, 8, 10), (2025, 9, 20));
  // print(field.availablesRecent((2025, 9, 18)));
  // print(field.availablesLatest((2025, 8, 12)));
  // field
  //   ..[(2025, 8, 9)] = true
  //   ..[(2025, 11, 29)] = true
  //   ..[(2025, 12, 1)] = true;
  field[(2025, 8, 9)] = true;
  field[(2025, 12, 1)] = true;
  // field[(2025, 12, 30)] = true;
  print(field.toString());
  print(field..shift(5));

  // final slot = Slot<String>(29);
  // slot.includesFrom(['he', 'she', 'it'], 5, false);
  // print(slot.toString());

  // final slot = Slot2D<String>(5, 3);
  // slot.includesTo(['he', 'she', 'it'], (2, 3));
  // print(slot.toString());

  // final slot = Slot3D<String>(5, 3, 4);
  // slot.includesFrom(['he', 'she', 'it'], (2, 1, 2), true);
  // print(slot.toString());

  // final slot = Slot4D<String>(5, 3, 4, 2);
  // slot.includesFrom(['he', 'she', 'it'], (5, 2, 2, 1), false);
  // print(slot.toString());
}
