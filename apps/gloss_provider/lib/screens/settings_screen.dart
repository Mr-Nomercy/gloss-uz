import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  String _selectedLanguage = "O'zbekcha";
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        setState(() => _isLoading = false);
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    return Scaffold(
      backgroundColor: theme.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Sozlamalar',
          style: TextStyle(
            color: theme.text,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.arrow_back_ios_new_rounded,
                color: theme.text, size: 18),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _StaggeredItem(
                      index: 0,
                      controller: _controller,
                      child: _buildSection(
                        theme: theme,
                        title: 'Umumiy',
                        children: [
                          GlossMenuItem(
                            icon: Icons.language_rounded,
                            title: 'Til',
                            trailing: _LanguageChip(
                              language: _selectedLanguage,
                              onTap: () =>
                                  _showLanguageSheet(context, theme),
                            ),
                            onTap: null,
                            showDivider: true,
                          ),
                          GlossToggleRow(
                            icon: Icons.notifications_outlined,
                            label: 'Bildirishnomalar',
                            value: _notificationsEnabled,
                            onChanged: (v) => setState(
                                () => _notificationsEnabled = v),
                            showDivider: true,
                          ),
                          GlossToggleRow(
                            icon: Icons.volume_up_outlined,
                            label: 'Ovoz',
                            value: _soundEnabled,
                            onChanged: (v) =>
                                setState(() => _soundEnabled = v),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _StaggeredItem(
                      index: 1,
                      controller: _controller,
                      child: _buildSection(
                        theme: theme,
                        title: 'Huquqiy',
                        children: [
                          GlossMenuItem(
                            icon: Icons.description_outlined,
                            title: 'Foydalanish shartlari',
                            onTap: () {},
                            showDivider: true,
                          ),
                          GlossMenuItem(
                            icon: Icons.privacy_tip_outlined,
                            title: 'Maxfiylik siyosati',
                            onTap: () {},
                            showDivider: true,
                          ),
                          GlossMenuItem(
                            icon: Icons.info_outline,
                            title: 'Dastur haqida',
                            onTap: () =>
                                _showAboutDialog(context, theme),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _StaggeredItem(
                      index: 2,
                      controller: _controller,
                      child:
                          _buildLogoutButton(theme, context),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSection({
    required GlossTheme theme,
    required String title,
    required List<Widget> children,
  }) {
    return GlossCard(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlossSectionHeader(title: title),
          ...children,
        ],
      ),
    );
  }

  void _showLanguageSheet(BuildContext context, GlossTheme theme) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: theme.card,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.grayMedium,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Tilni tanlang',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: theme.text,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _LanguageOption(
                    label: "O'zbekcha",
                    isSelected: _selectedLanguage == "O'zbekcha",
                    theme: theme,
                    onTap: () {
                      setState(() => _selectedLanguage = "O'zbekcha");
                      Navigator.pop(ctx);
                    },
                  ),
                  _LanguageOption(
                    label: 'Русский',
                    isSelected: _selectedLanguage == 'Русский',
                    theme: theme,
                    onTap: () {
                      setState(() => _selectedLanguage = 'Русский');
                      Navigator.pop(ctx);
                    },
                  ),
                  _LanguageOption(
                    label: 'English',
                    isSelected: _selectedLanguage == 'English',
                    theme: theme,
                    onTap: () {
                      setState(() => _selectedLanguage = 'English');
                      Navigator.pop(ctx);
                    },
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context, GlossTheme theme) {
    GlossDialog.show(
      context: context,
      title: 'Gloss Provider',
      contentWidget: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.greenBgLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.cleaning_services_rounded,
                    color: theme.green),
              ),
              const SizedBox(width: 8),
              const Text('Gloss Provider',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 12),
          Text('Versiya: 1.0.0',
              style: TextStyle(color: theme.text)),
          const SizedBox(height: 8),
          Text(
            'Gloss tozalash xizmati yetkazib beruvchilari uchun maxsus dastur.',
            style: TextStyle(color: theme.hint, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Text(
            '© 2026 Gloss. Barcha huquqlar himoyalangan.',
            style: TextStyle(color: theme.hint, fontSize: 12),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Yopish',
              style: TextStyle(color: theme.green)),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(GlossTheme theme, BuildContext context) {
    return _TapButton(
      onTap: () {
        GlossDialog.show(
          context: context,
          title: 'Chiqish',
          content: 'Akkountingizdan chiqishni xohlaysizmi?',
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Bekor qilish'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.go('/splash');
              },
              child: Text('Chiqish',
                  style: TextStyle(color: theme.red)),
            ),
          ],
        );
      },
      builder: (scale) {
        return AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 100),
          child: SizedBox(
            height: 52,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.red,
                side: BorderSide(
                    color: theme.red.withValues(alpha: 0.30)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                textStyle: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600),
              ),
              child: const Text('Chiqish'),
            ),
          ),
        );
      },
    );
  }
}

class _StaggeredItem extends StatelessWidget {
  final int index;
  final AnimationController controller;
  final Widget child;

  const _StaggeredItem({
    required this.index,
    required this.controller,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final begin = (index * 0.12).clamp(0.0, 0.88);
    final end = (index * 0.12 + 0.12).clamp(0.12, 1.0);
    final animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(begin, end, curve: Curves.easeOutCubic),
      ),
    );
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - animation.value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _LanguageChip extends StatefulWidget {
  final String language;
  final VoidCallback onTap;

  const _LanguageChip({required this.language, required this.onTap});

  @override
  State<_LanguageChip> createState() => _LanguageChipState();
}

class _LanguageChipState extends State<_LanguageChip> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.93),
      onTapUp: (_) {
        setState(() => _scale = 1.0);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: theme.greenBgLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.language,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: theme.green,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, color: theme.hint, size: 18),
          ],
        ),
      ),
    );
  }
}

class _LanguageOption extends StatefulWidget {
  final String label;
  final bool isSelected;
  final GlossTheme theme;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.label,
    required this.isSelected,
    required this.theme,
    required this.onTap,
  });

  @override
  State<_LanguageOption> createState() => _LanguageOptionState();
}

class _LanguageOptionState extends State<_LanguageOption> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.97),
      onTapUp: (_) {
        setState(() => _scale = 1.0);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? theme.greenBgLight
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isSelected
                  ? theme.green.withValues(alpha: 0.3)
                  : theme.border,
            ),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.isSelected
                        ? theme.green
                        : theme.grayMedium,
                    width: 2,
                  ),
                ),
                child: widget.isSelected
                    ? Center(
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: theme.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: theme.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TapButton extends StatefulWidget {
  final Widget Function(double scale) builder;
  final VoidCallback onTap;

  const _TapButton({required this.builder, required this.onTap});

  @override
  State<_TapButton> createState() => _TapButtonState();
}

class _TapButtonState extends State<_TapButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.97),
      onTapUp: (_) {
        setState(() => _scale = 1.0);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _scale = 1.0),
      child: widget.builder(_scale),
    );
  }
}
