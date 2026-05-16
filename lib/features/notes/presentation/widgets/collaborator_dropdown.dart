import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/collaboration/collaboration_bloc.dart';
import '../../domain/entities/collaborator_profile.dart';

/// Dropdown overlay that lists all collaborators for a shared item.
/// Includes a Leave button for non-owners, role badges, and per-user "..." menus.
class CollaboratorDropdown extends StatelessWidget {
  final String itemId;
  final bool isFolder;
  final VoidCallback onDismiss;

  const CollaboratorDropdown({
    super.key,
    required this.itemId,
    required this.isFolder,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 16,
      borderRadius: BorderRadius.circular(16),
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      child: Container(
        width: 320,
        constraints: const BoxConstraints(maxHeight: 400),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: BlocConsumer<CollaborationBloc, CollaborationState>(
          listener: (ctx, state) {
            if (state is CollaborationActionSuccess) {
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: const Color(0xFF43B89C),
                ),
              );
              if (state.message.contains('left')) {
                onDismiss();
              }
            } else if (state is CollaborationError) {
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: const Color(0xFFE05C5C),
                ),
              );
            }
          },
          builder: (ctx, state) {
            if (state is CollaborationLoading) {
              return const SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (state is! CollaborationLoaded) {
              return const SizedBox(
                height: 100,
                child: Center(child: Text('Unable to load collaborators.')),
              );
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DropdownHeader(
                  isCurrentUserOwner: state.isCurrentUserOwner,
                  itemId: itemId,
                  isFolder: isFolder,
                  onDismiss: onDismiss,
                ),
                const Divider(height: 1),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: state.profiles.length,
                    itemBuilder: (_, i) => _CollaboratorTile(
                      profile: state.profiles[i],
                      itemId: itemId,
                      isFolder: isFolder,
                      isCurrentUserAdmin: state.isCurrentUserAdmin,
                      isCurrentUserOwner: state.isCurrentUserOwner,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ─── Header ────────────────────────────────────────────────────────────────

class _DropdownHeader extends StatelessWidget {
  final bool isCurrentUserOwner;
  final String itemId;
  final bool isFolder;
  final VoidCallback onDismiss;

  const _DropdownHeader({
    required this.isCurrentUserOwner,
    required this.itemId,
    required this.isFolder,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 8, 10),
      child: Row(
        children: [
          const Icon(Icons.group_outlined, size: 18, color: Color(0xFF6C63FF)),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Collaborators',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
          ),
          if (!isCurrentUserOwner)
            TextButton.icon(
              onPressed: () => _confirmLeave(context),
              icon: const Icon(Icons.exit_to_app, size: 16, color: Color(0xFFE05C5C)),
              label: const Text(
                'Leave',
                style: TextStyle(color: Color(0xFFE05C5C), fontSize: 13),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
        ],
      ),
    );
  }

  void _confirmLeave(BuildContext context) {
    final bloc = context.read<CollaborationBloc>();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        actionsPadding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        title: const Text('Leave item?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        content: const Text(
          'You will lose access to this item.',
          style: TextStyle(fontSize: 13, color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(fontSize: 13)),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: const Color(0xFFE05C5C)),
            onPressed: () {
              Navigator.pop(ctx);
              bloc.add(LeaveCollaboration(itemId: itemId, isFolder: isFolder));
              onDismiss();
            },
            child: const Text('Leave', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

// ─── Collaborator Tile ─────────────────────────────────────────────────────

class _CollaboratorTile extends StatelessWidget {
  final CollaboratorProfile profile;
  final String itemId;
  final bool isFolder;
  final bool isCurrentUserAdmin;
  final bool isCurrentUserOwner;

  const _CollaboratorTile({
    required this.profile,
    required this.itemId,
    required this.isFolder,
    required this.isCurrentUserAdmin,
    required this.isCurrentUserOwner,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: _CollaboratorAvatar(profile: profile),
      title: Text(
        profile.displayName,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        profile.email,
        style: const TextStyle(fontSize: 12, color: Colors.black54),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _RoleBadge(role: profile.role),
          const SizedBox(width: 4),
          if (isCurrentUserAdmin && !profile.isOwner)
            _ContextMenu(
              profile: profile,
              itemId: itemId,
              isFolder: isFolder,
              isCurrentUserOwner: isCurrentUserOwner,
            ),
        ],
      ),
    );
  }
}

// ─── Collaborator Avatar ───────────────────────────────────────────────────

class _CollaboratorAvatar extends StatelessWidget {
  final CollaboratorProfile profile;
  const _CollaboratorAvatar({required this.profile});

  static const _colors = [
    Color(0xFF6C63FF), Color(0xFF43B89C), Color(0xFFE05C5C),
    Color(0xFFF5A623), Color(0xFF4A90E2),
  ];

  @override
  Widget build(BuildContext context) {
    final color = _colors[profile.email.hashCode.abs() % _colors.length];

    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: ClipOval(
        child: profile.photoUrl != null
            ? Image.network(
                profile.photoUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Center(
                  child: Text(
                    profile.initials,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14),
                  ),
                ),
              )
            : Center(
                child: Text(
                  profile.initials,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14),
                ),
              ),
      ),
    );
  }
}

// ─── Role Badge ────────────────────────────────────────────────────────────

class _RoleBadge extends StatelessWidget {
  final CollaboratorRole role;
  const _RoleBadge({required this.role});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (role) {
      CollaboratorRole.owner        => ('Owner', const Color(0xFF6C63FF)),
      CollaboratorRole.admin        => ('Admin', const Color(0xFF43B89C)),
      CollaboratorRole.collaborator => ('Editor', Colors.grey),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ─── Context Menu ──────────────────────────────────────────────────────────

class _ContextMenu extends StatelessWidget {
  final CollaboratorProfile profile;
  final String itemId;
  final bool isFolder;
  final bool isCurrentUserOwner;

  const _ContextMenu({
    required this.profile,
    required this.itemId,
    required this.isFolder,
    required this.isCurrentUserOwner,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      icon: const Icon(Icons.more_horiz, size: 18, color: Colors.black54),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 4,
      padding: EdgeInsets.zero,
      offset: const Offset(0, 32),
      onSelected: (value) => _handleAction(context, value),
      itemBuilder: (_) => [
        // Make/Remove Admin
        PopupMenuItem(
          value: profile.isAdmin ? 'remove_admin' : 'make_admin',
          height: 36,
          child: Row(
            children: [
              Icon(
                profile.isAdmin ? Icons.shield_outlined : Icons.shield,
                size: 16,
                color: const Color(0xFF43B89C),
              ),
              const SizedBox(width: 8),
              Text(
                profile.isAdmin ? 'Remove Admin' : 'Make Admin',
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),

        // Transfer Ownership (owner only, target must be admin)
        if (isCurrentUserOwner && profile.isAdmin)
          PopupMenuItem(
            value: 'transfer_ownership',
            height: 36,
            child: Row(
              children: const [
                Icon(Icons.swap_horiz, size: 16, color: Color(0xFF6C63FF)),
                SizedBox(width: 8),
                Text('Transfer Ownership', style: TextStyle(fontSize: 13)),
              ],
            ),
          ),

        const PopupMenuDivider(height: 1),

        // Remove
        PopupMenuItem(
          value: 'remove',
          height: 36,
          child: Row(
            children: const [
              Icon(Icons.person_remove_outlined, size: 16, color: Color(0xFFE05C5C)),
              SizedBox(width: 8),
              Text(
                'Remove',
                style: TextStyle(color: Color(0xFFE05C5C), fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleAction(BuildContext context, String action) {
    switch (action) {
      case 'make_admin':
        _confirmRoleChange(context, true);
      case 'remove_admin':
        _confirmRoleChange(context, false);
      case 'transfer_ownership':
        _confirmTransfer(context);
      case 'remove':
        _confirmRemove(context);
    }
  }

  void _confirmRoleChange(BuildContext context, bool makeAdmin) {
    final bloc = context.read<CollaborationBloc>();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        actionsPadding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        title: Text(makeAdmin ? 'Make Admin?' : 'Remove Admin?', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        content: Text(
          makeAdmin 
            ? 'Give admin permissions to ${profile.displayName}?'
            : 'Remove admin permissions from ${profile.displayName}?',
          style: const TextStyle(fontSize: 13, color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(fontSize: 13)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              bloc.add(SetAdminStatus(
                itemId: itemId,
                isFolder: isFolder,
                targetEmail: profile.email,
                makeAdmin: makeAdmin,
              ));
            },
            child: Text(
              makeAdmin ? 'Make Admin' : 'Remove Admin',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF43B89C)),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmRemove(BuildContext context) {
    final bloc = context.read<CollaborationBloc>();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        actionsPadding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        title: Text('Remove ${profile.displayName}?', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        content: const Text(
          'They will lose access to this item.',
          style: TextStyle(fontSize: 13, color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(fontSize: 13)),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: const Color(0xFFE05C5C)),
            onPressed: () {
              Navigator.pop(ctx);
              bloc.add(RemoveCollaborator(
                itemId: itemId,
                isFolder: isFolder,
                emailToRemove: profile.email,
              ));
            },
            child: const Text('Remove', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _confirmTransfer(BuildContext context) {
    final bloc = context.read<CollaborationBloc>();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        actionsPadding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        title: const Text('Transfer Ownership?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        content: Text(
          'Transfer to ${profile.displayName}?',
          style: const TextStyle(fontSize: 13, color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(fontSize: 13)),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: const Color(0xFF6C63FF)),
            onPressed: () {
              Navigator.pop(ctx);
              bloc.add(TransferOwnership(
                itemId: itemId,
                isFolder: isFolder,
                newOwnerEmail: profile.email,
              ));
            },
            child: const Text('Transfer', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
