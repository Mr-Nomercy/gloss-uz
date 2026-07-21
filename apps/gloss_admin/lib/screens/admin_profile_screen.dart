import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui_kit/ui_kit.dart';
import '../providers/auth_provider.dart';
import '../utils/string_utils.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final theme = context.gloss;
        final user = ref.watch(authProvider).user;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: const GlossAppBar(title: 'Profil'),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              _profileCard(theme, user),
              const SizedBox(height: 24),
              _detailCard(theme, user),
              const SizedBox(height: 24),
              GlossButton(label: 'Chiqish', isOutlined: true, onPressed: () => ref.read(authProvider.notifier).logout()),
              const SizedBox(height: 40),
            ]),
          ),
        );
      },
    );
  }

  Widget _profileCard(GlossTheme theme, user) {
    return GlossCard(
      accentColor: theme.green,
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        Container(
          width: 72, height: 72,
          decoration: BoxDecoration(color: theme.green.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(18)),
          child: Center(child: Text(safeFirstChar(user?.fullName), style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: theme.green))),
        ),
        const SizedBox(height: 12),
        Text(user?.fullName ?? 'Admin', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: theme.text)),
        const SizedBox(height: 4),
        Text(user?.email ?? 'admin@gloss.uz', style: TextStyle(fontSize: 14, color: theme.hint)),
        const SizedBox(height: 4),
        Text(user?.phone ?? '+998 90 000 00 00', style: TextStyle(fontSize: 13, color: theme.hint)),
        const SizedBox(height: 12),
        GlossBadge(label: 'Super Admin', variant: BadgeVariant.success),
      ]),
    );
  }

  Widget _detailCard(GlossTheme theme, user) {
    return GlossCard(
      accentColor: theme.green,
      child: Column(children: [
        _row(theme, Icons.email_outlined, 'Email', user?.email ?? 'admin@gloss.uz'),
        _divider(theme),
        _row(theme, Icons.phone_outlined, 'Telefon', user?.phone ?? '+998 90 000 00 00'),
        _divider(theme),
        _row(theme, Icons.shield_rounded, 'Rol', 'Super Admin'),
        _divider(theme),
        _row(theme, Icons.calendar_today_rounded, 'Ro\'yxatdan o\'tgan', '2026-01-15'),
      ]),
    );
  }

  Widget _row(GlossTheme theme, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(children: [
        Icon(icon, size: 20, color: theme.green),
        const SizedBox(width: 12),
        Text(label, style: TextStyle(fontSize: 14, color: theme.hint)),
        const Spacer(),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.text)),
      ]),
    );
  }

  Widget _divider(GlossTheme theme) {
    return Divider(height: 1, color: theme.divider, indent: 16, endIndent: 16);
  }
}
