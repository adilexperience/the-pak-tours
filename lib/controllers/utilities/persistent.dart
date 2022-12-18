import 'package:get_storage/get_storage.dart';

class Persistent {
  static GetStorage storage = GetStorage();

  // storage constants
  static const String isNotFirstVisit = "is_not_first_visit";

  static bool? get isNotFirstTime => storage.read(isNotFirstVisit);

  static void recordUserFirstVisit() {
    // making the check enabled so user can only see the on-boarding for first time
    // and for rest of the times, we'll handle the flow
    storage.write(isNotFirstVisit, true);
  }
}
