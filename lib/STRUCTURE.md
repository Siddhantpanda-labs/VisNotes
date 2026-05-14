# VisNotes Project Structure

This project follows a modular, feature-based architecture with a clear separation of concerns between Data, Domain, and Presentation layers.

## 📁 lib/core
Shared utilities and system-wide configurations.
*   **`theme.dart`**: Defines the "Warm Minimalist" color palette (Sage, Burnt Orange, Ochre).
*   **`constants.dart`**: Global app constants and layout metrics.

## 📁 lib/features/notes
The core functionality of the app, organized by Clean Architecture layers.

### 🏗️ Data Layer (`/data`)
Responsible for persistence and raw data mapping.
*   **`models/`**: Isar database schemas.
    *   `isar_note_model.dart`: The source of truth for Note and Folder persistence.
    *   `isar_note_model.g.dart`: Generated Isar code (patched via `fix_isar_ids.dart`).
*   **`repositories/`**: Concrete implementations of data access.
    *   `note_repository.dart`: Orchestrates Isar database operations.

### 🏗️ Domain Layer (`/domain`)
The "Brain" of the application. Pure Dart logic and entities.
*   **`entities/`**: Plain Dart objects used throughout the UI.
    *   `note_document.dart`: The hierarchical structure of a Note (Pages -> Blocks).
    *   `text_content.dart`: Rich text segments and formatting logic.
    *   `stroke.dart`: Vector drawing data structures.
*   **`services/`**: Complex business logic.
    *   `text_layout_service.dart`: Low-level text measurement and selection math.
    *   `pagination_service.dart`: The engine that handles multi-page text overflow.

### 🏗️ Presentation Layer (`/presentation`)
The UI and State Management.
*   **`bloc/`**: State management using the BLoC pattern.
    *   `dashboard/`: Logic for the home screen grid and folders.
    *   `editor/`: Real-time state for the rich-text/vector editor.
*   **`pages/`**: Full-screen widgets.
    *   `notes_dashboard_page.dart`: The "My Notes" home screen.
    *   `note_editor_page.dart`: The main entry point for editing a note.
    *   `splash_screen.dart`: The cinematic brand intro.
*   **`widgets/`**: Reusable UI components.
    *   `dashboard/`: Components for the home screen (Grid, Toolbar, Carousel).
    *   `editor/`: Specialized editor tools (CaretTracker, RichTextController).
    *   `shared/`: Common UI elements like custom buttons and cards.

---

## 🛠️ Key Tooling
*   **`fix_isar_ids.dart`**: A critical post-build script that patches the Isar generated code to allow 64-bit IDs on Windows/Web.
*   **`build.yaml`**: Configuration for the code generator.
