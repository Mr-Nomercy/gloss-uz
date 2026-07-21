import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gloss_worker/widgets/gloss_tap_scale.dart';
import 'package:gloss_worker/widgets/mock_async_loader.dart';
import 'package:gloss_worker/widgets/staggered_item.dart';
import 'package:ui_kit/ui_kit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  final _loaderKey = GlobalKey<MockAsyncLoaderState>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
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
      appBar: const GlossAppBar(title: 'Profil'),
      body: RefreshIndicator(
        color: theme.green,
        backgroundColor: theme.card,
        onRefresh: () async => _loaderKey.currentState?.reload(),
        child: MockAsyncLoader(
          key: _loaderKey,
          delay: const Duration(milliseconds: 200),
          loadingBuilder: (_) =>
              const GlossLoadingView(message: 'Yuklanmoqda...'),
          contentBuilder: (_) => FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  GlossStaggeredItem(
                    index: 0,
                    controller: _controller,
                    child: _buildProfileHeader(theme),
                  ),
                  const SizedBox(height: 16),
                  GlossStaggeredItem(
                    index: 1,
                    controller: _controller,
                    child: _buildStatsRow(theme),
                  ),
                  const SizedBox(height: 16),
                  GlossStaggeredItem(
                    index: 2,
                    controller: _controller,
                    child: _buildTeamBadge(theme),
                  ),
                  const SizedBox(height: 16),
                  GlossStaggeredItem(
                    index: 3,
                    controller: _controller,
                    child: _buildMenuItems(theme, context),
                  ),
                  const SizedBox(height: 24),
                  GlossStaggeredItem(
                    index: 4,
                    controller: _controller,
                    child: _buildLogoutButton(theme, context),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          errorBuilder: (_, onRetry) =>
              GlossErrorView.connection(onRetry: onRetry),
          onLoadStart: _controller.reset,
          onLoaded: _controller.forward,
        ),
      ),
    );
  }

  Widget _buildProfileHeader(GlossTheme theme) {
    return GlossCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _AnimatedAvatar(theme: theme),
          const SizedBox(height: 16),
          const Text(
            'Jasur Aliyev',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            '+998 90 123 45 67',
            style: TextStyle(fontSize: 14, color: theme.hint),
          ),
          const SizedBox(height: 4),
          const GlossBadge(label: 'Faol', variant: BadgeVariant.success),
        ],
      ),
    );
  }

  Widget _buildStatsRow(GlossTheme theme) {
    final stats = [
      {'label': 'Buyurtmalar', 'value': '156', 'icon': Icons.receipt_long_rounded},
      {'label': 'Reyting', 'value': '4.8', 'icon': Icons.star_rounded},
      {'label': 'Daromad', 'value': '2.4M', 'icon': Icons.payments_rounded},
    ];

    return Row(
      children: stats.map((stat) {
        return Expanded(
          child: GlossCard(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Icon(
                  stat['icon'] as IconData,
                  color: theme.green,
                  size: 22,
                ),
                const SizedBox(height: 8),
                Text(
                  stat['value'] as String,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: theme.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  stat['label'] as String,
                  style: TextStyle(fontSize: 11, color: theme.hint),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTeamBadge(GlossTheme theme) {
    return GlossTapScale(
      scale: 0.98,
      duration: const Duration(milliseconds: 100),
      onTap: () {
        GlossSnackBar.showInfo(context, 'Jamoa ma\'lumotlari tez orada');
      },
      child: GlossCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: theme.greenBgLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.group_rounded, color: theme.green, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gloss Toshkent Jamoasi',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: theme.text,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Faol jamoa a'zosi",
                    style: TextStyle(fontSize: 12, color: theme.greenText),
                  ),
                ],
              ),
            ),
            const GlossBadge(label: 'Faol'),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItems(GlossTheme theme, BuildContext context) {
    final items = [
      {'icon': Icons.person_outline, 'label': "Shaxsiy ma'lumotlar", 'route': null},
      {'icon': Icons.badge_outlined, 'label': "Team ma'lumotlari", 'route': null},
      {'icon': Icons.description_outlined, 'label': 'Hujjatlar', 'route': null},
      {'icon': Icons.settings_outlined, 'label': 'Sozlamalar', 'route': '/settings'},
    ];

    return GlossCard(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final isLast = entry.key == items.length - 1;
          final item = entry.value;
          return GlossMenuItem(
            icon: item['icon'] as IconData,
            title: item['label'] as String,
            showDivider: !isLast,
            iconColor: theme.green,
            onTap: () {
              final route = item['route'] as String?;
              if (route != null) {
                context.push(route);
              } else {
                GlossSnackBar.showInfo(context, 'Tez orada');
              }
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLogoutButton(GlossTheme theme, BuildContext context) {
    return _TapButton(
      onTap: () => _showLogoutDialog(theme, context),
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
                side: BorderSide(color: theme.red.withValues(alpha: 0.30)),
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

  void _showLogoutDialog(GlossTheme theme, BuildContext context) {
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
          child: Text('Chiqish', style: TextStyle(color: theme.red)),
        ),
      ],
    );
  }
}

class _AnimatedAvatar extends StatefulWidget {
  final GlossTheme theme;
  const _AnimatedAvatar({required this.theme});

  @override
  State<_AnimatedAvatar> createState() => _AnimatedAvatarState();
}

class _AnimatedAvatarState extends State<_AnimatedAvatar>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _pulseController.forward().then((_) => _pulseController.reverse());
      },
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Stack(
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: widget.theme.greenBgLight,
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.theme.green.withValues(alpha: 0.20),
                  width: 3,
                ),
              ),
              child: Icon(Icons.person, size: 40, color: widget.theme.green),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: widget.theme.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.camera_alt,
                    size: 14, color: Colors.white),
              ),
            ),
          ],
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
