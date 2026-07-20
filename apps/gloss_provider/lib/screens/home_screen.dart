import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool _isOnline = true;
  bool _showBalance = true;
  bool _hasNewOffer = true;
  int _countdown = 15;
  Timer? _offerTimer;
  bool _pageLoaded = false;

  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;
  late final AnimationController _staggerController;

  final String _userName = 'Jasur';

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _startOfferTimer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _pageLoaded = true);
        _staggerController.forward();
      }
    });
  }

  void _startOfferTimer() {
    _offerTimer?.cancel();
    _offerTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown <= 1) {
        timer.cancel();
        if (mounted) setState(() => _hasNewOffer = false);
      } else {
        if (mounted) setState(() => _countdown--);
      }
    });
  }

  @override
  void dispose() {
    _offerTimer?.cancel();
    _pulseController.dispose();
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    return AnimatedOpacity(
      opacity: _pageLoaded ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 600),
      child: Scaffold(
        backgroundColor: theme.bg,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 18, color: theme.text),
              children: [
                TextSpan(
                  text: 'Assalom, ',
                  style: TextStyle(color: theme.hint, fontWeight: FontWeight.normal, fontSize: 16),
                ),
                TextSpan(
                  text: _userName,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                ),
              ],
            ),
          ),
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.notifications_outlined, color: theme.text),
                  onPressed: () => context.push('/notifications'),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: theme.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
          color: theme.green,
          backgroundColor: Colors.white,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildOnlineToggle(theme),
                const SizedBox(height: 24),
                _buildBalanceCard(theme),
                const SizedBox(height: 24),
                _buildOfferSection(theme),
                _buildQuickActions(theme),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOnlineToggle(GlossTheme theme) {
    final Color bgStart = theme.greenBgLight;
    const Color bgEnd = Colors.white;

    return AnimatedScale(
      scale: 1.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      child: Container(
        decoration: BoxDecoration(
          gradient: _isOnline
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [bgStart, bgEnd],
                )
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, Colors.white],
                ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.blackTint4,
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            ScaleTransition(
              scale: _pulseAnimation,
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: _isOnline ? theme.green.withValues(alpha: 0.12) : theme.red.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    _isOnline ? Icons.check_circle_rounded : Icons.cancel_rounded,
                    key: ValueKey<bool>(_isOnline),
                    color: _isOnline ? theme.green : theme.red,
                    size: 30,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Column(
                  key: ValueKey<bool>(_isOnline),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isOnline ? "Buyurtmalarni qabul qilyapsiz" : "Yangi buyurtmalar kelmaydi",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: _isOnline ? theme.green : theme.red,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isOnline ? "Online rejimdasiz" : "Offline rejim",
                      style: TextStyle(fontSize: 13, color: theme.hint),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => setState(() => _isOnline = !_isOnline),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                width: 56,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: _isOnline ? theme.green : theme.grayMedium,
                ),
                alignment: _isOnline ? Alignment.centerRight : Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(GlossTheme theme) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [GlossColors.green, GlossColors.darkGreen],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: theme.green.withValues(alpha: 0.35),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    const Icon(Icons.account_balance_wallet_outlined, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Mavjud balans',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.78),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(scale: animation, child: child),
                  ),
                  child: Text(
                    _showBalance ? "2 450 000 so'm" : "•••••••• so'm",
                    key: ValueKey<bool>(_showBalance),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.push('/wallet'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: theme.green,
                    minimumSize: const Size(double.infinity, 44),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  child: const Text('Pul chiqarish'),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 16,
          top: 46,
          child: Material(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => setState(() => _showBalance = !_showBalance),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  _showBalance ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOfferSection(GlossTheme theme) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -0.15),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: _isOnline && _hasNewOffer
          ? _buildNewOfferCard(theme)
          : const SizedBox.shrink(),
    );
  }

  Widget _buildNewOfferCard(GlossTheme theme) {
    return Container(
      key: const ValueKey('new_offer'),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [GlossColors.orangeBgLight, Colors.white],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.transparent, width: 2),
        boxShadow: [
          BoxShadow(
            color: theme.blackTint4,
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: _PulsingBorder(
        borderColor: theme.red.withValues(alpha: 0.5),
        borderRadius: 16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.red.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.timer_rounded, size: 16, color: theme.red),
                      const SizedBox(width: 6),
                      Text(
                        '${_countdown}s',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: theme.red,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                const GlossBadge(label: 'Yangi'),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: theme.bg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.cleaning_services_rounded, color: theme.green, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Uy tozalash',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 14, color: theme.hint),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              "Mirzo Ulug'bek tumani, Mustaqillik 45",
                              style: TextStyle(fontSize: 12, color: theme.hint),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              "120 000 so'm",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: theme.greenText,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: GlossButton(
                      label: 'Qabul qilish',
                      onPressed: () {
                        setState(() => _hasNewOffer = false);
                        GlossSnackBar.showSuccess(context, 'Buyurtma qabul qilindi');
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() => _hasNewOffer = false);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.red,
                        side: BorderSide(color: theme.red.withValues(alpha: 0.30)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      child: const Text('Rad etish'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(GlossTheme theme) {
    const actions = [
      _QuickAction(Icons.receipt_long_outlined, 'Buyurtmalar', '/orders', GlossColors.catBlue),
      _QuickAction(Icons.schedule_outlined, 'Vaqtlarim', '/availability', GlossColors.catPurple),
      _QuickAction(Icons.bar_chart_rounded, 'Statistika', '/stats', GlossColors.green),
      _QuickAction(Icons.account_balance_wallet_outlined, 'Hamyon', '/wallet', GlossColors.orange),
      _QuickAction(Icons.person_outline, 'Profil', '/profile', GlossColors.catCyan),
      _QuickAction(Icons.help_outline, 'Yordam', '/support', GlossColors.catAmber),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final item = actions[index];
        final double itemDelay = index / actions.length;
        final Animation<double> itemAnimation = CurvedAnimation(
          parent: _staggerController,
          curve: Interval(itemDelay, itemDelay + 0.4, curve: Curves.easeOutCubic),
        );

        return AnimatedBuilder(
          animation: _staggerController,
          builder: (context, child) {
            return Opacity(
              opacity: itemAnimation.value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - itemAnimation.value)),
                child: child,
              ),
            );
          },
          child: _buildQuickActionTile(theme, item),
        );
      },
    );
  }

  Widget _buildQuickActionTile(GlossTheme theme, _QuickAction item) {
    return _TapScale(
      onTap: () => context.push(item.route),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border(
            left: BorderSide(
              color: item.color.withValues(alpha: 0.6),
              width: 4,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.blackTint4,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
            child: InkWell(
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: item.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(item.icon, color: item.color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: theme.text,
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right, color: theme.hint, size: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final String route;
  final Color color;

  const _QuickAction(this.icon, this.label, this.route, this.color);
}

class _PulsingBorder extends StatefulWidget {
  final Widget child;
  final Color borderColor;
  final double borderRadius;

  const _PulsingBorder({
    required this.child,
    required this.borderColor,
    required this.borderRadius,
  });

  @override
  State<_PulsingBorder> createState() => _PulsingBorderState();
}

class _PulsingBorderState extends State<_PulsingBorder> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
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
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final alpha = 0.15 + (_animation.value * 0.40);
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: widget.borderColor.withValues(alpha: alpha),
              width: 2,
            ),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _TapScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _TapScale({required this.child, this.onTap});

  @override
  State<_TapScale> createState() => _TapScaleState();
}

class _TapScaleState extends State<_TapScale> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}
