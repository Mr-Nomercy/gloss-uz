import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
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
          'Profil',
          style: TextStyle(
            color: theme.text,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: RefreshIndicator(
          color: theme.green,
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildProfileHeader(theme),
              const SizedBox(height: 24),
              _buildVehicleInfo(theme),
              const SizedBox(height: 24),
              _buildRatingCard(theme),
              const SizedBox(height: 24),
              _buildMenuSection(theme),
              const SizedBox(height: 24),
              _buildLogoutButton(theme),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(GlossTheme theme) {
    return GlossCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _scaleTap(
            onTap: () {},
            child: Stack(
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: theme.greenBgLight,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.green.withValues(alpha: 0.20),
                      width: 3,
                    ),
                  ),
                  child: Icon(Icons.person, size: 40, color: theme.green),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: theme.green,
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
          const SizedBox(height: 16),
          Text(
            'Jasur Qurbonov',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.text,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '+998 93 123 45 67',
            style: TextStyle(fontSize: 14, color: theme.hint),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: theme.greenBgLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, size: 16, color: GlossColors.star),
                const SizedBox(width: 4),
                Text(
                  '4.8',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.text,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '(487 ta buyurtma)',
                  style: TextStyle(fontSize: 13, color: theme.hint),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleInfo(GlossTheme theme) {
    return GlossCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: theme.greenBgLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.directions_car, color: theme.green, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Transport',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.text,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: theme.bg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: theme.greenBgLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      Icon(Icons.local_shipping, color: theme.green, size: 26),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chevrolet Lacetti',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: theme.text,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '01A123AA • Oq',
                        style: TextStyle(fontSize: 13, color: theme.hint),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: theme.greenBgLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Tasdiqlangan',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.green,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingCard(GlossTheme theme) {
    return GlossCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: theme.star.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.star, color: GlossColors.star, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Reyting',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.text,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                '4.8',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: theme.text,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                '/ 5.0',
                style: TextStyle(
                  fontSize: 16,
                  color: GlossColors.hint,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _ratingBar('5', 65, theme),
                  const SizedBox(height: 3),
                  _ratingBar('4', 22, theme),
                  const SizedBox(height: 3),
                  _ratingBar('3', 8, theme),
                  const SizedBox(height: 3),
                  _ratingBar('2', 3, theme),
                  const SizedBox(height: 3),
                  _ratingBar('1', 2, theme),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _ratingBar(String label, int percent, GlossTheme theme) {
    return Row(
      children: [
        SizedBox(
          width: 16,
          child: Text(
            label,
            style: TextStyle(fontSize: 11, color: theme.hint),
          ),
        ),
        const SizedBox(width: 6),
        SizedBox(
          width: 100,
          height: 4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: percent / 100,
              backgroundColor: theme.grayLight,
              valueColor:
                  AlwaysStoppedAnimation<Color>(theme.star),
            ),
          ),
        ),
        const SizedBox(width: 6),
        SizedBox(
          width: 28,
          child: Text(
            '$percent%',
            style: TextStyle(fontSize: 11, color: theme.hint),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection(GlossTheme theme) {
    return GlossCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          GlossMenuItem(
            icon: Icons.person_outline,
            title: "Shaxsiy ma'lumotlar",
            onTap: () {},
          ),
          Divider(height: 1, indent: 56, color: theme.divider),
          GlossMenuItem(
            icon: Icons.directions_car_outlined,
            title: "Transport ma'lumotlari",
            onTap: () {},
          ),
          Divider(height: 1, indent: 56, color: theme.divider),
          GlossMenuItem(
            icon: Icons.description_outlined,
            title: 'Hujjatlar',
            onTap: () {},
          ),
          Divider(height: 1, indent: 56, color: theme.divider),
          GlossMenuItem(
            icon: Icons.help_outline,
            title: 'Yordam',
            onTap: () {},
          ),
          Divider(height: 1, indent: 56, color: theme.divider),
          GlossMenuItem(
            icon: Icons.info_outline,
            title: 'Ilova haqida',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(GlossTheme theme) {
    return SizedBox(
      height: 52,
      child: _scaleTap(
        onTap: () => _showLogoutDialog(theme),
        child: OutlinedButton(
          onPressed: () => _showLogoutDialog(theme),
          style: OutlinedButton.styleFrom(
            foregroundColor: theme.red,
            side: BorderSide(color: theme.red.withValues(alpha: 0.30)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          child: const Text('Chiqish'),
        ),
      ),
    );
  }

  void _showLogoutDialog(GlossTheme theme) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Chiqishni tasdiqlash'),
        content: const Text('Haqiqatan ham akkauntdan chiqmoqchimisiz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Yo'q", style: TextStyle(color: theme.hint)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: const Text('Chiqish'),
          ),
        ],
      ),
    );
  }

  Widget _scaleTap({required Widget child, VoidCallback? onTap}) {
    return _ScaleTapWidget(onTap: onTap, child: child);
  }
}

class _ScaleTapWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _ScaleTapWidget({required this.child, this.onTap});

  @override
  State<_ScaleTapWidget> createState() => _ScaleTapWidgetState();
}

class _ScaleTapWidgetState extends State<_ScaleTapWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) => Transform.scale(
          scale: _scale.value,
          child: child,
        ),
        child: widget.child,
      ),
    );
  }
}
