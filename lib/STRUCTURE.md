# VisNotes Project Structure

This project follows a modular, feature-based Clean Architecture with a strict separation of concerns between Data, Domain, and Presentation layers, complemented by a fully decoupled Serialization/DTO layer.

---

## 📁 lib/core
Shared system utilities, global state wrappers, and styling systems.
*   **`theme.dart`**: Defines the "Warm Minimalist" brand identity and HSL color design tokens (Sage, Burnt Orange, Ochre).
*   **`constants.dart`**: Layout dimensions, typography scales, and animation configurations.

---

## 📁 lib/features/notes
The core functional scope of the app, cleanly layered to decouple UI, business logic, persistence, and synchronization.

### 🏗️ Data Layer (`/data`)
Orchestrates database persistence, networking (OAuth2/Google Drive v3 API), and low-level data transformation.
*   **`models/`**: Isar database schemas.
    *   `isar_note_model.dart`: Database persistence schemas for folders, notes, and user settings.
    *   `isar_note_model.g.dart`: Generated Isar collection adapters.
*   **`repositories/`**: Core implementations of database and network contracts.
    *   `note_repository.dart`: Manages CRUD and queries for Isar storage.
    *   `cloud_sync_repository.dart`: Central engine for authentication, deep-nested recursive shared folder crawling, background idle timers, metadata-driven Google Drive folder syncing, and permissions administration.
*   **`serialization/`**: Dedicated, decoupled serialization layer to insulate Isar and Domain entities from JSON storage schemas.
    *   `dto/note_dto.dart`: Data Transfer Objects serving as the canonical layout for import/export formats.
    *   `mappers/`: Translates between `IsarNoteDocument` <-> `NoteDto` <-> `NoteDocument` domain entities (e.g., `isar_note_mapper.dart`, `note_mapper.dart`).
    *   `note_serialization.dart`: High-level interfaces for serializing document structures.

### 🏗️ Domain Layer (`/domain`)
The core platform rules and purely functional business structures (contains zero Flutter dependencies).
*   **`entities/`**: Plain Dart models defining logical data shapes.
    *   `note_document.dart`: Model representation of a multi-page Note hierarchy (Pages -> Blocks).
    *   `note_block.dart`: Abstract blocks composing a note page (`TextBlock`, `CanvasBlock`).
    *   `text_content.dart`: Rich-text model tracking typographic ranges, formatting spans, and layout alignments.
    *   `stroke.dart`: Vector coordinates, velocity, and pressure values for real-time ink canvas strokes.
    *   `collaborator_profile.dart`: Represents active users, access profiles, and administrative permissions.
*   **`services/`**: Mathematical engines driving real-time editor systems.
    *   `text_layout_service.dart`: High-performance glyph boundary tracking, cursor placement, and selection math.
    *   `pagination_service.dart`: Dynamic layout flow engine handling text-overflow wrapping across pages.

### 🏗️ Presentation Layer (`/presentation`)
Manages rendering state and interactive layout components.
*   **`bloc/`**: Reactive state management blocks.
    *   `auth/`: Handles Google authentication lifecycles, background session polling, and secure credentials management.
    *   `collaboration/`: Drives administrative roles, sharing states, promotions, ownership transfers, and removals.
    *   `dashboard/`: Coordinates folder systems, note grids, and dashboard arrangement states.
    *   `editor/`: Real-time state flow for rich-text input, formatting updates, and hand-drawn strokes.
*   **`pages/`**: Full-screen layouts.
    *   `notes_dashboard_page.dart`: Dashboard home page showing active workspaces, pinned collections, and shared spaces.
    *   `note_editor_page.dart`: Real-time multi-page document editor.
    *   `splash_screen.dart`: Cinematic, premium intro sequence.
*   **`widgets/`**: Reusable interactive widgets.
    *   `collaborator_bar.dart`: Sleek editor group presence display showing active notes collaborators.
    *   `collaborator_dropdown.dart`: Premium administration control interface to manage, invite, or leave collaborative notes.
    *   `dashboard/`: Desktop widgets (grid nodes, folders, dashboard settings).
    *   `editor/`: Precision canvas and rich-text controllers (cursor widgets, text formatters, pressure painters).

---

## 🛠️ Key Scripts & Tooling
*   **`fix_isar_ids.dart`**: Indispensable build-utility patching generated files to support 64-bit ID schemas on desktop environments.
*   **`build.yaml`**: Configuration settings for build_runner.
