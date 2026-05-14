# VisNotes 📝🚀

VisNotes is a high-performance, professional-grade **Spatial Note-Taking Application** built with Flutter. It features a custom 2D rendering engine that blends rich text editing with fluid handwriting on an infinite canvas.

![VisNotes Hero](https://github.com/Siddhantpanda-labs/VisNotes/raw/main/assets/hero_mockup.png)

## ✨ Features

- **Infinite Spatial Canvas**: Pan and zoom across an expansive 2D workspace (0.01x to 5.0x).
- **Pro Rich Text Engine**: Context-aware formatting (Bold, Italic, Headings) with "Sticky" state management similar to Microsoft Word/Notion.
- **Fluid Pagination**: Automatic document cascading across virtual A4 pages. Text flows seamlessly from Page 1 to Page 2 as you type.
- **Hybrid Input**: Switch between professional typing and velocity-tapered ink strokes for diagrams and handwriting.
- **Smart Focus Management**: Caret persistence and focus-shielded toolbars for a zero-interruption workflow.
- **Cross-Platform**: Designed for Web, Desktop, and Mobile with optimized rendering using Flutter's `CustomPainter`.

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (Latest Stable)
- Dart SDK

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Siddhantpanda-labs/VisNotes.git
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the application**:
   ```bash
   flutter run -d chrome
   ```

## 🏗️ Architecture

VisNotes follows a clean, scalable architecture:
- **State Management**: `flutter_bloc` for robust document and tool state tracking.
- **Domain Logic**: Decoupled Text Layout Service for pixel-perfect character measurement.
- **Rendering**: Custom `PagePainter` for high-fidelity spatial document display.
- **Data Model**: Delta-based rich text segments for efficient formatting and persistence.

## 🗺️ Roadmap

- [x] Infinite Spatial Canvas Engine
- [x] Rich Text Pagination & Flow
- [x] Context-Aware Formatting System
- [x] Basic Ink Stroke Engine
- [ ] Advanced Selection & Block Manipulation
- [ ] Perfect Freehand (C++ FFI) Integration
- [ ] SQLite Offline Persistence
- [ ] Real-time Collaboration (Websockets)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Built with ❤️ by [Siddhant Panda](https://github.com/Siddhantpanda-labs)
