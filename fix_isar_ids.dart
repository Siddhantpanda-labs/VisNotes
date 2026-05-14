import 'dart:io';

void main() {
  final file = File('lib/features/notes/data/models/isar_note_model.g.dart');
  var content = file.readAsStringSync();
  
  // Replace large IDs with bit-shifting expressions
  // This avoids the single-literal JS check while preserving the 64-bit value.
  final regex = RegExp(r"id: (-?)(0x[0-9A-F]+)");
  content = content.replaceAllMapped(regex, (match) {
    final sign = match.group(1) ?? '';
    final fullHex = match.group(2)!;
    
    // Remove 0x
    final hex = fullHex.substring(2);
    if (hex.length <= 8) return match.group(0)!; // Already small
    
    final mid = hex.length - 8;
    final high = hex.substring(0, mid);
    final low = hex.substring(mid);
    
    return "id: $sign((0x$high << 32) | 0x$low)";
  });
  
  file.writeAsStringSync(content);
  print('Successfully patched Isar generated file with bit-shifting expressions.');
}
