import 'package:isar/isar.dart';

part 'isar_vector_note_model.g.dart';

@collection
class IsarVectorNoteDocument {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? id;

  String? title;
  DateTime? createdAt;
  DateTime? updatedAt;

  // Spatial Dashboard Position
  double dashboardX = 0.0;
  double dashboardY = 0.0;
  bool isPinned = false;
  String? parentFolderId;
  bool isDeleted = false;
  DateTime? deletedAt;

  // Collaboration
  String? ownerEmail;
  String? lastEditedBy;
  String? driveFileId;
  bool isShared = false;
  List<String> collaborators = [];
  List<String> adminEmails = [];

  List<IsarVectorElement> elements = [];
}

@embedded
class IsarVectorElement {
  String? id;
  
  /// Type descriptor: 'stroke', 'text', 'photo', 'connector', 'group'
  String? type;

  double positionX = 0.0;
  double positionY = 0.0;
  double scale = 1.0;
  double rotation = 0.0;
  String? parentGroupId;

  // ── Group Fields ───────────────────────────────────────────────────────────
  double groupWidth = 0.0;
  double groupHeight = 0.0;

  // ── Stroke Fields ──────────────────────────────────────────────────────────
  List<IsarVectorPoint> strokePoints = [];
  List<double> pressures = [];
  int strokeColorValue = 0xFF000000;
  double strokeWidth = 2.0;

  // ── Text Fields ────────────────────────────────────────────────────────────
  String? text;
  double textSizeWidth = 0.0;
  double textSizeHeight = 0.0;
  int textBgColorValue = 0x00000000; // Transparent default
  int textColorValue = 0xFF000000;
  bool isBold = false;
  bool isItalic = false;
  double fontSize = 16.0;

  // ── Photo Fields ───────────────────────────────────────────────────────────
  String? filePath;
  double photoWidth = 0.0;
  double photoHeight = 0.0;

  // ── Connector Fields ───────────────────────────────────────────────────────
  String? sourceId;
  String? targetId;
  double sourceAnchorX = 0.0;
  double sourceAnchorY = 0.0;
  double targetAnchorX = 0.0;
  double targetAnchorY = 0.0;
  int connectorColorValue = 0xFF000000;
  double connectorStrokeWidth = 2.0;
  bool isDashed = false;
  bool isLocked = false;
}

@embedded
class IsarVectorPoint {
  double x = 0.0;
  double y = 0.0;

  IsarVectorPoint();
  IsarVectorPoint.create(this.x, this.y);
}
