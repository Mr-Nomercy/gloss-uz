import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const GlossAppBar(title: 'Sozlamalar'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const GlossSectionHeader(title: 'General'),
          const SizedBox(height: 8),
          GlossCard(
            child: Column(
              children: [
                const GlossMenuItem(
                  icon: Icons.language,
                  title: 'Language',
                  subtitle: "O'zbekcha",
                ),
                const Divider(height: 1),
                GlossToggleRow(
                  icon: Icons.notifications,
                  label: 'Push Notifications',
                  value: true,
                  onChanged: (_) {},
                ),
                const Divider(height: 1),
                GlossToggleRow(
                  icon: Icons.dark_mode,
                  label: 'Dark Mode',
                  value: false,
                  onChanged: (_) {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const GlossSectionHeader(title: 'Account'),
          const SizedBox(height: 8),
          GlossCard(
            child: Column(
              children: [
                const GlossMenuItem(
                  icon: Icons.person,
                  title: 'Admin Profile',
                  subtitle: 'admin@gloss.uz',
                ),
                const Divider(height: 1),
                GlossMenuItem(
                  icon: Icons.logout,
                  title: 'Sign Out',
                  destructive: true,
                  onTap: () {
                    context.go('/login');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
