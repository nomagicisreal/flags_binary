
import 'package:flags_binary/flags_binary.dart';

void main() {
  // final field = Field2D(10, 6);
  // print(field.toString());

  final slot = Slot4D<String>(5, 3, 4, 2);
  // final slot = Slot3D<String>(5, 3, 4);
  // final slot = Slot2D<String>(5, 3);
  // final slot = Slot<String>(29);
  print(slot.toString());
}
