import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';
import '../providers/auth_provider.dart';
import '../utils/string_utils.dart';

class MoreTab extends ConsumerWidget {
  const MoreTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.gloss;
    final user = ref.watch(authProvider).user;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          GlossCard(
            accentColor: theme.green,
            padding: const EdgeInsets.all(16),
            onTap: () => context.push('/profile'),
            child: Row(
              children: [
                Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(
                    color: theme.green,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: theme.green.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3))],
                  ),
                  child: Center(child: Text(safeFirstChar(user?.fullName), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white))),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user?.fullName ?? 'Admin', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: GlossColors.text)),
                      Text('Super Admin', style: TextStyle(fontSize: 13, color: theme.hint)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: GlossColors.hint),
              ],
            ),
          ),
          const SizedBox(height: 24),
          GlossCard(
            accentColor: theme.green,
            child: Column(
              children: [
                _Link(icon: Icons.settings_rounded, title: 'Sozlamalar', onTap: () => context.push('/settings')),
                Divider(height: 1, color: theme.divider),
                _Link(icon: Icons.headset_mic_rounded, title: 'Yordam', onTap: () {}),
                Divider(height: 1, color: theme.divider),
                _Link(icon: Icons.info_outline_rounded, title: 'Dastur haqida', subtitle: 'v0.1.0', onTap: () {}),
              ],
            ),
          ),
          const SizedBox(height: 24),
          GlossButton(
            label: 'Chiqish',
            isOutlined: true,
            onPressed: () => ref.read(authProvider.notifier).logout(),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _Link extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _Link({required this.icon, required this.title, this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 13),
        child: Row(
          children: [
            Icon(icon, size: 20, color: theme.green),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: GlossColors.text))),
            if (subtitle != null) Text(subtitle!, style: TextStyle(fontSize: 13, color: theme.hint)),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right_rounded, size: 20, color: theme.hint),
          ],
        ),
      ),
    );
  }
}
