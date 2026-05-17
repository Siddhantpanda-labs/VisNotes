import 'dart:ui';
import '../../../data/models/isar_vector_note_model.dart';
import '../../../domain/entities/vector_canvas/vector_element.dart';
import '../../../domain/entities/vector_canvas/vector_note_document.dart';

class VectorNoteMapper {
  /// Translates an [IsarVectorNoteDocument] to a domain [VectorNoteDocument]
  static VectorNoteDocument toDomain(IsarVectorNoteDocument isarDoc) {
    return VectorNoteDocument(
      id: isarDoc.id ?? '',
      title: isarDoc.title ?? '',
      elements: isarDoc.elements.map(_elementToDomain).whereType<VectorElement>().toList(),
      createdAt: isarDoc.createdAt ?? DateTime.now(),
      updatedAt: isarDoc.updatedAt ?? DateTime.now(),
      dashboardX: isarDoc.dashboardX,
      dashboardY: isarDoc.dashboardY,
      isPinned: isarDoc.isPinned,
      parentFolderId: isarDoc.parentFolderId,
      isDeleted: isarDoc.isDeleted,
      deletedAt: isarDoc.deletedAt,
      ownerEmail: isarDoc.ownerEmail,
      lastEditedBy: isarDoc.lastEditedBy,
      driveFileId: isarDoc.driveFileId,
      isShared: isarDoc.isShared,
      collaborators: List.from(isarDoc.collaborators),
      adminEmails: List.from(isarDoc.adminEmails),
    );
  }

  /// Translates a domain [VectorNoteDocument] to an [IsarVectorNoteDocument]
  static IsarVectorNoteDocument toIsar(VectorNoteDocument domainDoc) {
    return IsarVectorNoteDocument()
      ..id = domainDoc.id
      ..title = domainDoc.title
      ..elements = domainDoc.elements.map(_elementToIsar).toList()
      ..createdAt = domainDoc.createdAt
      ..updatedAt = domainDoc.updatedAt
      ..dashboardX = domainDoc.dashboardX
      ..dashboardY = domainDoc.dashboardY
      ..isPinned = domainDoc.isPinned
      ..parentFolderId = domainDoc.parentFolderId
      ..isDeleted = domainDoc.isDeleted
      ..deletedAt = domainDoc.deletedAt
      ..ownerEmail = domainDoc.ownerEmail
      ..lastEditedBy = domainDoc.lastEditedBy
      ..driveFileId = domainDoc.driveFileId
      ..isShared = domainDoc.isShared
      ..collaborators = List.from(domainDoc.collaborators)
      ..adminEmails = List.from(domainDoc.adminEmails);
  }

  // ── Element Mappers ────────────────────────────────────────────────────────

  static VectorElement? _elementToDomain(IsarVectorElement isarElem) {
    final type = isarElem.type;
    final id = isarElem.id ?? '';
    final pos = Offset(isarElem.positionX, isarElem.positionY);
    final scale = isarElem.scale;
    final rot = isarElem.rotation;

    switch (type) {
      case 'stroke':
        return VectorStrokeElement(
          id: id,
          position: pos,
          scale: scale,
          rotation: rot,
          isLocked: isarElem.isLocked,
          points: isarElem.strokePoints.map((p) => Offset(p.x, p.y)).toList(),
          pressures: List.from(isarElem.pressures),
          colorValue: isarElem.strokeColorValue,
          strokeWidth: isarElem.strokeWidth,
        );
      case 'text':
        return VectorTextElement(
          id: id,
          position: pos,
          scale: scale,
          rotation: rot,
          isLocked: isarElem.isLocked,
          text: isarElem.text ?? '',
          size: Size(isarElem.textSizeWidth, isarElem.textSizeHeight),
          backgroundColorValue: isarElem.textBgColorValue,
          textColorValue: isarElem.textColorValue,
          isBold: isarElem.isBold,
          isItalic: isarElem.isItalic,
          fontSize: isarElem.fontSize,
        );
      case 'photo':
        return VectorPhotoElement(
          id: id,
          position: pos,
          scale: scale,
          rotation: rot,
          isLocked: isarElem.isLocked,
          filePath: isarElem.filePath ?? '',
          size: Size(isarElem.photoWidth, isarElem.photoHeight),
        );
      case 'connector':
        return VectorConnectorElement(
          id: id,
          position: pos,
          scale: scale,
          rotation: rot,
          isLocked: isarElem.isLocked,
          sourceId: isarElem.sourceId ?? '',
          targetId: isarElem.targetId ?? '',
          sourceAnchor: Offset(isarElem.sourceAnchorX, isarElem.sourceAnchorY),
          targetAnchor: Offset(isarElem.targetAnchorX, isarElem.targetAnchorY),
          colorValue: isarElem.connectorColorValue,
          strokeWidth: isarElem.connectorStrokeWidth,
          isDashed: isarElem.isDashed,
        );
      default:
        return null;
    }
  }

  static IsarVectorElement _elementToIsar(VectorElement domainElem) {
    final isar = IsarVectorElement()
      ..id = domainElem.id
      ..positionX = domainElem.position.dx
      ..positionY = domainElem.position.dy
      ..scale = domainElem.scale
      ..rotation = domainElem.rotation
      ..isLocked = domainElem.isLocked;

    switch (domainElem) {
      case VectorStrokeElement stroke:
        isar.type = 'stroke';
        isar.strokePoints = stroke.points.map((p) => IsarVectorPoint()..x = p.dx..y = p.dy).toList();
        isar.pressures = List.from(stroke.pressures);
        isar.strokeColorValue = stroke.colorValue;
        isar.strokeWidth = stroke.strokeWidth;
        break;
      case VectorTextElement textCard:
        isar.type = 'text';
        isar.text = textCard.text;
        isar.textSizeWidth = textCard.size.width;
        isar.textSizeHeight = textCard.size.height;
        isar.textBgColorValue = textCard.backgroundColorValue;
        isar.textColorValue = textCard.textColorValue;
        isar.isBold = textCard.isBold;
        isar.isItalic = textCard.isItalic;
        isar.fontSize = textCard.fontSize;
        break;
      case VectorPhotoElement photo:
        isar.type = 'photo';
        isar.filePath = photo.filePath;
        isar.photoWidth = photo.size.width;
        isar.photoHeight = photo.size.height;
        break;
      case VectorConnectorElement connector:
        isar.type = 'connector';
        isar.sourceId = connector.sourceId;
        isar.targetId = connector.targetId;
        isar.sourceAnchorX = connector.sourceAnchor.dx;
        isar.sourceAnchorY = connector.sourceAnchor.dy;
        isar.targetAnchorX = connector.targetAnchor.dx;
        isar.targetAnchorY = connector.targetAnchor.dy;
        isar.connectorColorValue = connector.colorValue;
        isar.connectorStrokeWidth = connector.strokeWidth;
        isar.isDashed = connector.isDashed;
        break;
    }
    return isar;
  }
}
