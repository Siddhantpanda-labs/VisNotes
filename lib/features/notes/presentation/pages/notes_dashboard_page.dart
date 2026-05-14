import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/dashboard/folder_carousel.dart';
import '../widgets/dashboard/notes_grid.dart';
import '../widgets/dashboard/dashboard_toolbar.dart';
import '../widgets/dashboard/explorer_panel.dart';

class NotesDashboardPage extends StatefulWidget {
  const NotesDashboardPage({super.key});

  @override
  State<NotesDashboardPage> createState() => _NotesDashboardPageState();
}

class _NotesDashboardPageState extends State<NotesDashboardPage> {
  bool _isExplorerOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // Very clean off-white
      body: Stack(
        children: [
          // Main Content
          SafeArea(
            child: CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 40, 30, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MY NOTES',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 4,
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ),
                        Text(
                          'All Documents',
                          style: GoogleFonts.outfit(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Folders Section
                const SliverToBoxAdapter(
                  child: FoldersSection(),
                ),

                // Notes Section Label
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    child: Text(
                      'Recent Notes',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),

                // Notes Grid
                const NotesGridSection(),
                
                // Bottom Padding for Toolbar
                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),
          ),

          // Bottom Compact Toolbar
          Positioned(
            left: 0,
            right: 0,
            bottom: 30,
            child: Center(
              child: BottomCompactToolbar(
                onExplorerToggle: () => setState(() => _isExplorerOpen = !_isExplorerOpen),
                isExplorerOpen: _isExplorerOpen,
              ),
            ),
          ),

          // Explorer Panel
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutCubic,
            left: _isExplorerOpen ? 20 : -350,
            top: 40,
            bottom: 120,
            child: ExplorerPanel(onClose: () => setState(() => _isExplorerOpen = false)),
          ),
        ],
      ),
    );
  }
}
