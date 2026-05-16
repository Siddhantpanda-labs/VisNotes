import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../pages/profile_settings_page.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String initials = '??';
        if (state is Authenticated) {
          final name = state.user.name ?? state.user.email ?? 'User';
          initials = name.substring(0, 1).toUpperCase();
        }

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileSettingsPage()),
            );
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.black.withOpacity(0.05)),
              ),
              child: Center(
                child: state is Authenticated
                    ? (state.user.avatarUrl != null && state.user.avatarUrl!.isNotEmpty
                        ? ClipOval(
                            child: Image.network(
                              state.user.avatarUrl!,
                              fit: BoxFit.cover,
                              width: 36,
                              height: 36,
                              errorBuilder: (context, error, stackTrace) => Text(
                                initials,
                                style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                              ),
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(child: SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 1.5)));
                              },
                            ),
                          )
                        : Text(initials, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)))
                    : const Icon(Icons.person_outline, size: 20, color: Colors.black38),
              ),
            ),
          ),
        );
      },
    );
  }
}
