import 'package:isar/isar.dart';

part 'isar_note_model.g.dart';

@collection
class IsarNoteDocument {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? id;
  
  String? title;
  DateTime? createdAt;
  DateTime? updatedAt;
  
  // Spatial Dashboard Data
  double dashboardX = 0;
  double dashboardY = 0;
  bool isPinned = false;
  
  List<IsarNotePage> pages = [];
}

@collection
class IsarFolder {
  Id isarId = Isar.autoIncrement;
  
  @Index(unique: true, replace: true)
  String? id;
  
  String? name;
  double dashboardX = 0;
  double dashboardY = 0;
  
  // List of Note IDs inside this folder
  List<String> noteIds = [];
  
  // Nested folders
  List<String> childFolderIds = [];
}

@embedded
class IsarNotePage {
  String? id;
  double width = 792.0;
  double height = 1056.0;
  List<IsarNoteBlock> blocks = [];
}

@embedded
class IsarNoteBlock {
  String? id;
  String? type; // 'text', 'canvas'
  double x = 0;
  double y = 0;
  double width = 0;
  double height = 0;
  double rotation = 0;
  double opacity = 1.0;
  
  // Text Content
  IsarRichTextContent? textContent;
  
  // Canvas Content
  List<IsarStroke> strokes = [];
}

@embedded
class IsarRichTextContent {
  List<IsarTextSegment> segments = [];
}

@embedded
class IsarTextSegment {
  String? text;
  bool isBold = false;
  bool isItalic = false;
  bool isHeading = false;
  double fontSize = 16.0;
  int colorValue = 0xFF000000; 
}

@embedded
class IsarStroke {
  List<IsarPoint> points = [];
  List<double> pressures = [];
  int colorValue = 0xFF000000;
  double width = 2.0;
}

@embedded
class IsarPoint {
  double x = 0;
  double y = 0;
}
