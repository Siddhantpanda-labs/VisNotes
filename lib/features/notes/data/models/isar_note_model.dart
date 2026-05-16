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
  
  String? parentFolderId;
  bool isDeleted = false;
  bool excludeFromBackup = false;
  bool isLocked = false;
  DateTime? deletedAt;

  // Collaboration
  String? ownerEmail;
  String? lastEditedBy;
  String? driveFileId;
  bool isShared = false;
  List<String> collaborators = []; // all collaborator emails (excluding owner)
  List<String> adminEmails   = []; // subset of collaborators who are co-admins
  
  List<String> tags = [];
  
  List<IsarNotePage> pages = [];
}

@collection
class IsarTag {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? id;
  String? name;
  int colorValue = 0xFF2196F3; // Default Blue
}

@collection
class IsarFolder {
  Id isarId = Isar.autoIncrement;
  
  @Index(unique: true, replace: true)
  String? id;
  
  String? name;
  double dashboardX = 0;
  double dashboardY = 0;
  
  String? parentFolderId;
  bool isDeleted = false;

  // Collaboration
  String? ownerEmail;
  String? driveFileId;
  bool isShared = false;
  List<String> collaborators = []; // all collaborator emails (excluding owner)
  List<String> adminEmails   = []; // subset of collaborators who are co-admins
  DateTime? deletedAt;
  
  bool isPinned = false;
  int? colorValue; // Custom folder color
  int? iconCodePoint; // Custom icon
  
  List<String> tags = [];
  
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

@collection
class IsarUserSettings {
  Id isarId = Isar.autoIncrement;

  String? name;
  String? email;
  String? avatarUrl;
  bool isCloudSyncEnabled = false;
  bool isLoggedIn = false;
  DateTime? lastSyncTime;

  // Google OAuth2 Tokens
  String? googleAccessToken;
  String? googleRefreshToken;
  DateTime? googleTokenExpiry;

  // Google Drive folder IDs
  String? visNotesFolderId;     // "VisNotes/" root folder
  String? sharedRootFolderId;   // "VisNotes/Shared/" subfolder
}
