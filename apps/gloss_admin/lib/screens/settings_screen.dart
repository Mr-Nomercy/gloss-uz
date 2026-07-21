import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui_kit/ui_kit.dart';
import '../providers/auth_provider.dart';
import '../widgets/section_title.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;

    return Scaffold(
      backgroundColor: theme.bg,
      appBar: const GlossAppBar(title: 'Sozlamalar'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlossSectionTitle(title: 'Platforma'),
            const SizedBox(height: 10),
            GlossCard(
              accentColor: theme.green,
              child: Column(
                children: [
                  _settingItem(
                    Icons.business_rounded,
                    'Platforma nomi',
                    'Gloss',
                    theme,
                  ),
                  _divider(theme),
                  _settingItem(
                    Icons.language_rounded,
                    'Asosiy til',
                    "O'zbek",
                    theme,
                  ),
                  _divider(theme),
                  _settingItem(
                    Icons.money_rounded,
                    'Valyuta',
                    "UZS (so'm)",
                    theme,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GlossSectionTitle(title: 'Komissiyalar'),
            const SizedBox(height: 10),
            GlossCard(
              accentColor: theme.green,
              child: Column(
                children: [
                  _settingItem(
                    Icons.cleaning_services_rounded,
                    'Xizmat komissiyasi',
                    '20%',
                    theme,
                  ),
                  _divider(theme),
                  _settingItem(
                    Icons.shopping_bag_rounded,
                    'Mahsulot komissiyasi',
                    '15%',
                    theme,
                  ),
                  _divider(theme),
                  _settingItem(
                    Icons.percent_rounded,
                    'Minimal komissiya',
                    '10%',
                    theme,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GlossSectionTitle(title: 'Bildirishnomalar'),
            const SizedBox(height: 10),
            GlossCard(
              accentColor: theme.green,
              child: Column(
                children: [
                  _toggleItem(
                    'Yangi buyurtmalar',
                    true,
                    theme,
                  ),
                  _divider(theme),
                  _toggleItem(
                    "To'lov so'rovlari",
                    true,
                    theme,
                  ),
                  _divider(theme),
                  _toggleItem(
                    'Yangi provayderlar',
                    true,
                    theme,
                  ),
                  _divider(theme),
                  _toggleItem(
                    'Shikoyatlar',
                    true,
                    theme,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GlossSectionTitle(title: 'Xavfsizlik'),
            const SizedBox(height: 10),
            GlossCard(
              accentColor: theme.green,
              child: Column(
                children: [
                  _settingItem(
                    Icons.lock_outlined,
                    'Parolni o\'zgartirish',
                    '********',
                    theme,
                  ),
                  _divider(theme),
                  _settingItem(
                    Icons.security_rounded,
                    'Ikki faktorli autentifikatsiya',
                    "O'chiq",
                    theme,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            GlossButton(
              label: 'Chiqish',
              isOutlined: true,
              onPressed: () => ref.read(authProvider.notifier).logout(),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _settingItem(IconData icon, String title, String value, GlossTheme theme) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: theme.green),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: GlossColors.text,
                ),
              ),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 13, color: theme.hint),
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right_rounded, size: 20, color: theme.hint),
          ],
        ),
      ),
    );
  }

  Widget _toggleItem(String title, bool value, GlossTheme theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: GlossColors.text,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: (_) {},
            activeTrackColor: theme.green.withValues(alpha: 0.4),
            activeThumbColor: theme.green,
          ),
        ],
      ),
    );
  }

  Widget _divider(GlossTheme theme) {
    return Divider(height: 1, color: theme.divider);
  }
}
