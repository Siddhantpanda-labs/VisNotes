import 'dart:ui';
import '../../../data/models/isar_vector_note_model.dart';
import '../../../domain/entities/vector_canvas/vector_element.dart';
import '../../../domain/entities/vector_canvas/vector_note_document.dart';

class VectorNoteMapper {
  /// Translates an [IsarVectorNoteDocument] to a domain [VectorNoteDocument]
  static VectorNoteDocument toDomain(IsarVectorNoteDocument isarDoc) {
    // 1. Map all flat Isar elements to domain objects
    final allDomainElems = isarDoc.elements
        .map(_elementToDomain)
        .whereType<VectorElement>()
        .toList();

    // 2. Build map of parentId -> children
    final Map<String, List<VectorElement>> childrenMap = {};
    for (final elem in allDomainElems) {
      if (elem.parentGroupId != null) {
        childrenMap.putIfAbsent(elem.parentGroupId!, () => []).add(elem);
      }
    }

    // 3. Recursive helper to populate group children
    VectorElement populateChildren(VectorElement elem) {
      if (elem is VectorCanvasGroup) {
        final rawChildren = childrenMap[elem.id] ?? [];
        final populatedChildren = rawChildren.map(populateChildren).toList();
        return elem.copyWith(children: populatedChildren);
      }
      return elem;
    }

    // 4. Root elements are those with parentGroupId == null
    final rootElements = allDomainElems
        .where((e) => e.parentGroupId == null)
        .map(populateChildren)
        .toList();

    return VectorNoteDocument(
      id: isarDoc.id ?? '',
      title: isarDoc.title ?? '',
      elements: rootElements,
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
      ..elements = _flattenElements(domainDoc.elements, null)
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

  /// Recursively flattens a nested domain elements tree into a list of Isar elements
  static List<IsarVectorElement> _flattenElements(
    List<VectorElement> domainElems,
    String? parentGroupId,
  ) {
    final List<IsarVectorElement> isarElems = [];
    for (final elem in domainElems) {
      final isarElem = _elementToIsar(elem);
      isarElem.parentGroupId = parentGroupId;
      isarElems.add(isarElem);

      if (elem is VectorCanvasGroup) {
        isarElems.addAll(_flattenElements(elem.children, elem.id));
      }
    }
    return isarElems;
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
          parentGroupId: isarElem.parentGroupId,
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
          parentGroupId: isarElem.parentGroupId,
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
          parentGroupId: isarElem.parentGroupId,
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
          parentGroupId: isarElem.parentGroupId,
          sourceId: isarElem.sourceId ?? '',
          targetId: isarElem.targetId ?? '',
          sourceAnchor: Offset(isarElem.sourceAnchorX, isarElem.sourceAnchorY),
          targetAnchor: Offset(isarElem.targetAnchorX, isarElem.targetAnchorY),
          colorValue: isarElem.connectorColorValue,
          strokeWidth: isarElem.connectorStrokeWidth,
          isDashed: isarElem.isDashed,
        );
      case 'group':
        return VectorCanvasGroup(
          id: id,
          position: pos,
          scale: scale,
          rotation: rot,
          isLocked: isarElem.isLocked,
          parentGroupId: isarElem.parentGroupId,
          size: Size(isarElem.groupWidth, isarElem.groupHeight),
          children: const [], // Populated recursively in toDomain
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
      ..isLocked = domainElem.isLocked
      ..parentGroupId = domainElem.parentGroupId;

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
      case VectorCanvasGroup group:
        isar.type = 'group';
        isar.groupWidth = group.size.width;
        isar.groupHeight = group.size.height;
        break;
    }
    return isar;
  }
}
