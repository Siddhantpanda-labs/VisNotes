import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/collaboration/collaboration_bloc.dart';
import '../../domain/entities/collaborator_profile.dart';
import 'collaborator_dropdown.dart';

/// Compact collaboration bar for the note editor / folder app bar.
///
/// Shows an avatar stack (up to 2 visible + overflow count) and an
/// [+] people button. Tapping the avatar stack opens [CollaboratorDropdown].
class CollaboratorBar extends StatefulWidget {
  final String itemId;
  final bool isFolder;

  const CollaboratorBar({
    super.key,
    required this.itemId,
    required this.isFolder,
  });

  @override
  State<CollaboratorBar> createState() => _CollaboratorBarState();
}

class _CollaboratorBarState extends State<CollaboratorBar> {
  final LayerLink _layerLink = LayerLink();
  bool _isDropdownOpen = false;

  void _toggleDropdown(BuildContext blocContext) {
    if (_isDropdownOpen) {
      Navigator.of(context).pop();
      return;
    }
    _isDropdownOpen = true;

    showGeneralDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (ctx, anim1, anim2) {
        return Stack(
          children: [
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: const Offset(-240, 48),
              child: GestureDetector(
                onTap: () {}, // Prevent dismiss on dropdown tap
                child: BlocProvider.value(
                  value: blocContext.read<CollaborationBloc>(),
                  child: CollaboratorDropdown(
                    itemId: widget.itemId,
                    isFolder: widget.isFolder,
                    onDismiss: () => Navigator.of(ctx).pop(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ).then((_) {
      if (mounted) {
        setState(() {
          _isDropdownOpen = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollaborationBloc, CollaborationState>(
      builder: (ctx, state) {
        final profiles = state is CollaborationLoaded
            ? state.profiles
            : <CollaboratorProfile>[];
        return CompositedTransformTarget(
          link: _layerLink,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Avatar stack — tapping opens the dropdown
              if (profiles.isNotEmpty)
                GestureDetector(
                  onTap: () => _toggleDropdown(ctx),
                  child: _AvatarStack(profiles: profiles),
                ),

              const SizedBox(width: 4),

              // Add collaborator button
              _AddButton(onTap: () => _showInviteDialog(ctx)),
            ],
          ),
        );
      },
    );
  }

  void _showInviteDialog(BuildContext ctx) {
    final emailController = TextEditingController();
    showDialog<void>(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add Collaborator', style: TextStyle(fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter the Google account email of the person you want to add.',
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Email address',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.email_outlined),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              final email = emailController.text.trim();
              if (email.isNotEmpty && email.contains('@')) {
                ctx.read<CollaborationBloc>().add(
                  AddCollaborator(
                    itemId: widget.itemId,
                    isFolder: widget.isFolder,
                    email: email,
                  ),
                );
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

// ─── Avatar Stack ──────────────────────────────────────────────────────────

class _AvatarStack extends StatelessWidget {
  final List<CollaboratorProfile> profiles;
  static const int _maxVisible = 2;

  const _AvatarStack({required this.profiles});

  @override
  Widget build(BuildContext context) {
    final visible = profiles.take(_maxVisible).toList();
    final overflow = profiles.length - _maxVisible;

    return SizedBox(
      width: visible.length * 24.0 + (overflow > 0 ? 28 : 0),
      height: 32,
      child: Stack(
        children: [
          ...visible.asMap().entries.map(
            (e) => Positioned(
              left: e.key * 20.0,
              child: _Avatar(profile: e.value, size: 30),
            ),
          ),
          if (overflow > 0)
            Positioned(
              left: visible.length * 20.0,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF6C63FF),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Text(
                    '+$overflow',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Single Avatar ─────────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  final CollaboratorProfile profile;
  final double size;

  const _Avatar({required this.profile, this.size = 32});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: ClipOval(
        child: profile.photoUrl != null
            ? Image.network(
                profile.photoUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    _Initials(profile: profile, size: size),
              )
            : _Initials(profile: profile, size: size),
      ),
    );
  }
}

class _Initials extends StatelessWidget {
  final CollaboratorProfile profile;
  final double size;

  const _Initials({required this.profile, required this.size});

  static const _colors = [
    Color(0xFF6C63FF),
    Color(0xFF43B89C),
    Color(0xFFE05C5C),
    Color(0xFFF5A623),
    Color(0xFF4A90E2),
  ];

  @override
  Widget build(BuildContext context) {
    final color = _colors[profile.email.hashCode.abs() % _colors.length];
    return Container(
      color: color,
      width: size,
      height: size,
      child: Center(
        child: Text(
          profile.initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.36,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ─── Add Button ────────────────────────────────────────────────────────────

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Add collaborator',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF6C63FF).withOpacity(0.5),
              width: 1.5,
            ),
          ),
          child: const Icon(
            Icons.group_add_outlined,
            size: 18,
            color: Color(0xFF6C63FF),
          ),
        ),
      ),
    );
  }
}
