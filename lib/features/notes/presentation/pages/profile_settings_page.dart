import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/dashboard/dashboard_bloc.dart';
import '../../data/models/isar_note_model.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  int _activeTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: Row(
        children: [
          // Sidebar Settings Navigation
          Container(
            width: 280,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Colors.black54),
                      const SizedBox(width: 12),
                      Text('Back to Dashboard', style: GoogleFonts.outfit(color: Colors.black54, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                Text('SETTINGS', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 2, color: Colors.black26)),
                const SizedBox(height: 24),
                _SettingsNavItem(
                  icon: Icons.person_outline_rounded,
                  label: 'Account',
                  isActive: _activeTab == 0,
                  onTap: () => setState(() => _activeTab = 0),
                ),
                _SettingsNavItem(
                  icon: Icons.palette_outlined,
                  label: 'Appearance',
                  isActive: _activeTab == 1,
                  onTap: () => setState(() => _activeTab = 1),
                ),
                _SettingsNavItem(
                  icon: Icons.cloud_sync_outlined,
                  label: 'Sync & Backup',
                  isActive: _activeTab == 2,
                  onTap: () => setState(() => _activeTab = 2),
                ),
                _SettingsNavItem(
                  icon: Icons.security_outlined,
                  label: 'Privacy',
                  isActive: _activeTab == 3,
                  onTap: () => setState(() => _activeTab = 3),
                ),
                const Spacer(),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is Authenticated) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _SettingsNavItem(
                          icon: Icons.logout,
                          label: 'Logout',
                          isActive: false,
                          onTap: () {
                            context.read<AuthBloc>().add(LogoutRequested());
                            Navigator.pop(context); // Close settings after logout
                          },
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                Text('VisNotes v1.0.0', style: GoogleFonts.outfit(color: Colors.black12, fontSize: 12)),
              ],
            ),
          ),
          
          // Main Settings Content
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 60),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_activeTab == 0) _AccountSettings(),
                    if (_activeTab == 1) _AppearanceSettings(),
                    if (_activeTab == 2) _SyncSettings(),
                    if (_activeTab == 3) _PrivacySettings(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _SettingsNavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? Colors.black.withOpacity(0.03) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: isActive ? Colors.black : Colors.black38),
              const SizedBox(width: 16),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? Colors.black : Colors.black54,
                ),
              ),
              if (isActive) ...[
                const Spacer(),
                Container(width: 4, height: 4, decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isAuthenticated = state is Authenticated;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Account', style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Manage your personal information and cloud identity.', style: GoogleFonts.outfit(color: Colors.black38)),
            const SizedBox(height: 48),
            
            if (isAuthenticated) ...[
              _buildProfileCard(context, state),
              const SizedBox(height: 32),
              _buildSettingSection('Preferences', [
                _buildSettingTile(Icons.alternate_email, 'Email Address', state.user.email ?? 'Not set'),
                _buildSettingTile(Icons.badge_outlined, 'Display Name', state.user.name ?? 'User'),
              ]),
            ] else ...[
              _buildLoginPrompt(context),
            ],
          ],
        );
      },
    );
  }

  Widget _buildProfileCard(BuildContext context, Authenticated state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(color: Color(0xFFF0F0F0), shape: BoxShape.circle),
            clipBehavior: Clip.antiAlias,
            child: state.user.avatarUrl != null && state.user.avatarUrl!.isNotEmpty
              ? Image.network(
                  state.user.avatarUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Text(
                      (state.user.name ?? '?').substring(0, 1).toUpperCase(),
                      style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black26),
                    ),
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                  },
                )
              : Center(
                  child: Text(
                    (state.user.name ?? '?').substring(0, 1).toUpperCase(),
                    style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black26),
                  ),
                ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(state.user.name ?? 'User', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(state.user.email ?? '', style: GoogleFonts.outfit(color: Colors.black38)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Edit Profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.blue.withOpacity(0.05), shape: BoxShape.circle),
            child: const Icon(Icons.cloud_queue_rounded, size: 48, color: Colors.blue),
          ),
          const SizedBox(height: 24),
          Text('Cloud Sync', style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(
            'Sign in to VisNotes to sync your canvas, notes, and tags across all your devices securely.',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(color: Colors.black38, height: 1.5),
          ),
          const SizedBox(height: 40),
          
          // Google Login Button
          _SocialLoginButton(
            icon: Icons.g_mobiledata_rounded,
            label: 'Continue with Google',
            onTap: () {
               context.read<AuthBloc>().add(GoogleLoginRequested());
            },
          ),
          const SizedBox(height: 12),
          _SocialLoginButton(
            icon: Icons.email_outlined,
            label: 'Continue with Email',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SocialLoginButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 54,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.black.withOpacity(0.1)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: Colors.black),
            const SizedBox(width: 12),
            Text(label, style: GoogleFonts.outfit(color: Colors.black, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _AppearanceSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Appearance', style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold)),
        const SizedBox(height: 48),
        _buildSettingSection('Theme', [
          _buildThemeOption('System Default', true),
          _buildThemeOption('Light Mode', false),
          _buildThemeOption('Dark Mode', false),
        ]),
      ],
    );
  }

  Widget _buildThemeOption(String label, bool isSelected) {
    return ListTile(
      title: Text(label, style: GoogleFonts.outfit(fontSize: 14)),
      trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: Colors.black) : null,
      onTap: () {},
    );
  }
}

class _SyncSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isAuthenticated = state is Authenticated || state is AuthSyncing || state is AuthRestoring;
        final isSyncing       = state is AuthSyncing;
        final isRestoring     = state is AuthRestoring;
        final user = isAuthenticated
          ? (state is Authenticated ? state.user
              : state is AuthSyncing ? state.user
              : null)
          : null;
        final isSyncEnabled = user?.isCloudSyncEnabled ?? false;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sync & Backup',
                style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 48),
            _buildSettingSection('Status', [
              SwitchListTile(
                title: Text('Enable Cloud Sync',
                    style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600)),
                subtitle: Text('Automatically save changes to cloud',
                    style: GoogleFonts.outfit(fontSize: 12)),
                value: isSyncEnabled,
                onChanged: isAuthenticated
                    ? (val) => context.read<AuthBloc>().add(ToggleCloudSync(val))
                    : null,
                activeColor: Colors.black,
              ),

              if (isAuthenticated) ...[
                const Divider(height: 1, indent: 16, endIndent: 16),

                // ── Sync Now row ────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Manual Sync',
                                style: GoogleFonts.outfit(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                            Text(
                              isSyncing
                                  ? 'Syncing…'
                                  : user?.lastSyncTime != null
                                      ? 'Last synced: ${user!.lastSyncTime!.toLocal().toString().split('.')[0]}'
                                      : 'Never synced',
                              style: GoogleFonts.outfit(fontSize: 12, color: Colors.black38),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: (isSyncEnabled && !isSyncing && !isRestoring)
                            ? () => context.read<AuthBloc>().add(SyncNow())
                            : null,
                        icon: isSyncing
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white))
                            : const Icon(Icons.sync_rounded, size: 18),
                        label: Text(isSyncing ? 'Syncing…' : 'Sync Now'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.black38,
                          disabledForegroundColor: Colors.white70,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1, indent: 16, endIndent: 16),

                // ── Restore from Drive row ──────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Restore from Drive',
                                style: GoogleFonts.outfit(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                            Text(
                              isRestoring
                                  ? 'Downloading your notes…'
                                  : 'Pull your latest backup from Google Drive',
                              style: GoogleFonts.outfit(
                                  fontSize: 12, color: Colors.black38),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: (!isSyncing && !isRestoring)
                            ? () => context.read<AuthBloc>().add(RestoreFromDrive())
                            : null,
                        icon: isRestoring
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.black))
                            : const Icon(Icons.cloud_download_rounded, size: 18),
                        label: Text(isRestoring ? 'Restoring…' : 'Restore'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: const BorderSide(color: Colors.black26),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ]),
          ],
        );
      },
    );
  }
}



class _PrivacySettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is! DashboardLoaded) return const Center(child: CircularProgressIndicator());

        final isPinSet = state.settings.isPinSet;
        final relockLogic = state.settings.relockLogic;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Privacy', style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Control your note security and access permissions.', style: GoogleFonts.outfit(color: Colors.black38)),
            const SizedBox(height: 48),

            _buildSettingSection('Note Locking', [
              ListTile(
                leading: Icon(isPinSet ? Icons.lock_outline : Icons.lock_open_outlined, 
                    size: 20, color: isPinSet ? Colors.black87 : Colors.black26),
                title: Text(isPinSet ? 'Update Master PIN' : 'Set Master PIN', 
                    style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600)),
                subtitle: Text(isPinSet ? 'Change your current security PIN' : 'Create a PIN to secure individual notes', 
                    style: GoogleFonts.outfit(fontSize: 12)),
                trailing: const Icon(Icons.chevron_right, size: 20),
                onTap: () => _showSetPinDialog(context, isPinSet: isPinSet, currentPinHash: isPinSet ? state.settings.masterPinHash : null),
              ),
              if (isPinSet) ...[
                const Divider(height: 1, indent: 16, endIndent: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Auto-Relock Logic', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _ChoiceChip(
                            label: 'On App Close',
                            isSelected: relockLogic == 0,
                            onTap: () => context.read<DashboardBloc>().add(const UpdateLockSettings(relockLogic: 0)),
                          ),
                          const SizedBox(width: 8),
                          _ChoiceChip(
                            label: 'On Note Close',
                            isSelected: relockLogic == 1,
                            onTap: () => context.read<DashboardBloc>().add(const UpdateLockSettings(relockLogic: 1)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ]),

            if (isPinSet)
              _buildSettingSection('Danger Zone', [
                ListTile(
                  leading: const Icon(Icons.no_encryption_gmailerrorred_outlined, size: 20, color: Colors.redAccent),
                  title: Text('Reset Master PIN', 
                      style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.redAccent)),
                  subtitle: Text('DELETES ALL LOCKED NOTES for security', 
                      style: GoogleFonts.outfit(fontSize: 12, color: Colors.redAccent.withOpacity(0.6))),
                  onTap: () => _showResetConfirmDialog(context),
                ),
              ]),
          ],
        );
      },
    );
  }

  void _showSetPinDialog(BuildContext context, {required bool isPinSet, String? currentPinHash}) {
    String currentPinInput = '';
    String newPinInput = '';
    bool showError = false;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(isPinSet ? 'Change Master PIN' : 'Set Master PIN', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(isPinSet ? 'Enter your current PIN and a new 4-6 digit PIN.' : 'Enter a 4-6 digit numeric PIN.', 
                      style: GoogleFonts.outfit(fontSize: 14, color: Colors.black54)),
                  const SizedBox(height: 20),
                  
                  if (isPinSet) ...[
                    TextField(
                      autofocus: true,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: const InputDecoration(
                        labelText: 'Current PIN',
                        counterText: '',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) {
                        currentPinInput = val;
                        if (showError) setState(() => showError = false);
                      },
                    ),
                    const SizedBox(height: 16),
                  ],

                  TextField(
                    autofocus: !isPinSet,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: const InputDecoration(
                      labelText: 'New PIN',
                      counterText: '',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                      newPinInput = val;
                      if (showError) setState(() => showError = false);
                    },
                  ),
                  
                  if (showError)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text('Current PIN is incorrect.', style: GoogleFonts.outfit(color: Colors.red, fontSize: 12)),
                    ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    if (isPinSet && currentPinInput != currentPinHash) {
                      setState(() => showError = true);
                      return;
                    }
                    if (newPinInput.length >= 4) {
                      context.read<DashboardBloc>().add(UpdateLockSettings(newPin: newPinInput));
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PIN updated successfully')));
                    }
                  },
                  child: const Text('Save PIN'),
                ),
              ],
            );
          }
        );
      },
    );
  }

  void _showResetConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Reset PIN?', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.red)),
        content: Text(
          'Resetting your PIN will permanently DELETE all notes that are currently locked. This is an anti-tamper security measure.',
          style: GoogleFonts.outfit(),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              context.read<DashboardBloc>().add(ResetPinAndClearLockedNotes());
              Navigator.pop(ctx);
            },
            child: const Text('Delete Notes & Reset PIN'),
          ),
        ],
      ),
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ChoiceChip({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : Colors.black54,
          ),
        ),
      ),
    );
  }
}

// Helpers
Widget _buildSettingSection(String title, List<Widget> children) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title.toUpperCase(), style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.5, color: Colors.black26)),
      const SizedBox(height: 16),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black.withOpacity(0.05)),
        ),
        child: Column(children: children),
      ),
      const SizedBox(height: 32),
    ],
  );
}

Widget _buildSettingTile(IconData icon, String title, String value) {
  return ListTile(
    leading: Icon(icon, size: 20, color: Colors.black54),
    title: Text(title, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w500)),
    trailing: Text(value, style: GoogleFonts.outfit(color: Colors.black26, fontSize: 13)),
    onTap: () {},
  );
}
