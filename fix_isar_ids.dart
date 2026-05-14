import 'dart:io';

void main() {
  final file = File('lib/features/notes/data/models/isar_note_model.g.dart');
  var content = file.readAsStringSync();
  
  int counter = 1;
  final regex = RegExp(r'id: (-?\d{15,})');
  content = content.replaceAllMapped(regex, (match) {
    return "id: ${counter++}";
  });
  
  file.writeAsStringSync(content);
  print('Successfully patched Isar generated file with safe IDs.');
}
