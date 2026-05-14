# VisNotes Roadmap 🚀

This roadmap outlines the development phases for **VisNotes**, a spatial, professional-grade note-taking application designed for Android and Desktop.

---

## 🏗 Phase 1: Foundation & Custom Editor Core
*The goal is to build the custom rendering and layout engine from scratch.*

- [x] **Project Setup**
  - [x] Initialize Flutter project (Android + Desktop support).
  - [x] Configure standard directory structure (Domain/Data/Presentation).
  - [x] Setup core state management (e.g., Bloc or Provider).
- [x] **Core Data Models**
  - [x] Define `Block` schema (Text, Canvas, Image).
  - [x] Define `Page` and `Document` structures.
  - [x] Serialization logic (JSON to/from local storage).
- [x] **Custom Layout Engine**
  - [x] Implement `PagePainter` using `CustomPainter`.
  - [x] Build `TextBlock` with `ParagraphBuilder` for manual text measurement.
  - [x] **Pagination Engine**: Implement overflow detection and page-to-page caret jumping.
- [ ] **Basic Tools**
  - [ ] Rich text styling (Bold, Italic, Headings).
  - [x] Basic stroke drawing (non-pressure sensitive for now).
  - [ ] Undo/Redo system.

---

## 🎨 Phase 2: Spatial Canvas & UI/UX
*Transitioning from a list of pages to a fluid, infinite workspace.*

- [x] **Spatial Canvas**
  - [x] Implement infinite zoomable/pannable canvas (`InteractiveViewer` custom).
  - [ ] Quadtree indexing for efficient block hit-testing on canvas.
- [ ] **Block Manipulation**
  - [ ] Drag, resize, and rotate blocks on the canvas.
  - [ ] Snapping-to-grid and alignment guides.
- [ ] **Modern UI Design**
  - [ ] Material Depth design system (vibrant colors, glassmorphism).
  - [ ] Fluid transitions (card-to-editor expansion).
  - [ ] Dark/Light mode adaptive surfaces.

---

## ⚡ Phase 3: Advanced Ink Engine (C++ FFI)
*Making handwriting feel like a first-class medium.*

- [ ] **FFI Integration**
  - [ ] Setup C++ NDK (Android) and DLL (Windows) toolchains.
- [ ] **Ink Logic**
  - [ ] Port `perfect_freehand` or similar algorithm to C++.
  - [ ] Velocity-based taper and pressure-sensitive stroke width.
  - [ ] Low-latency path rendering on `Canvas`.
- [ ] **Stylus Integration**
  - [ ] S Pen / Surface Pen deep integration (Button shortcuts, Hover).

---

## ☁️ Phase 4: Sync & Offline-First
*Ensuring notes are safe and available everywhere.*

- [ ] **Local Storage**
  - [ ] SQLite integration for high-performance local caching.
- [ ] **Supabase Integration**
  - [ ] Auth and Real-time database sync.
- [ ] **Conflict Resolution**
  - [ ] Implement CRDT (Conflict-free Replicated Data Type) for multi-device editing.

---

## 🧠 Phase 5: Intelligence & Advanced Features
*The "Thinker's App" differentiators.*

- [ ] **On-Device AI**
  - [ ] Local vector search (embeddings).
  - [ ] Handwriting OCR search (ML Kit).
  - [ ] Smart shape/diagram recognition.
- [ ] **Audio Synchronization**
  - [ ] Timestamped audio recording synced to strokes/text.
- [ ] **Export & Share**
  - [ ] High-fidelity PDF export with vector ink.
  - [ ] Markdown/JSON export.

---

## 🏁 Phase 6: Packaging & Distribution
- [ ] Android APK/Play Store optimization.
- [ ] Windows MSIX/Installer packaging.
- [ ] Performance profiling and 120fps optimization.

---

> [!NOTE]
> This roadmap is living and will be updated as we complete milestones. Current Focus: **Phase 2**.
