import 'package:isar/isar.dart';

part 'app_settings_model.g.dart';

@collection
class IsarAppSettings {
  Id id = 0; // Singleton pattern: we only ever have one settings object

  String? masterPinHash;
  
  // Relock logic
  // 0: On App Close (Default)
  // 1: On Note Close
  int relockLogic = 0;

  bool get isPinSet => masterPinHash != null && masterPinHash!.isNotEmpty;
}
