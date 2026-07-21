import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gloss_worker/widgets/staggered_item.dart';
import 'package:ui_kit/ui_kit.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with TickerProviderStateMixin {
  final _phoneController = TextEditingController(text: '');
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic);
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  String _formatPhone(String value) {
    final digits = value.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.length <= 2) return digits;
    if (digits.length <= 5) return '${digits.substring(0, 2)} ${digits.substring(2)}';
    if (digits.length <= 7) return '${digits.substring(0, 2)} ${digits.substring(2, 5)} ${digits.substring(5)}';
    if (digits.length <= 9) return '${digits.substring(0, 2)} ${digits.substring(2, 5)} ${digits.substring(5, 7)} ${digits.substring(7)}';
    return '${digits.substring(0, 2)} ${digits.substring(2, 5)} ${digits.substring(5, 7)} ${digits.substring(7, 9)}';
  }

  Future<void> _handleLogin() async {
    final digits = _phoneController.text.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.length == 9) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        setState(() => _isLoading = false);
        context.push('/auth/verify', extra: '+998$digits');
      }
    } else {
      GlossSnackBar.showError(context, "To'g'ri telefon raqam kiriting");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    return Scaffold(
      backgroundColor: theme.bg,
      body: Column(
        children: [
          _buildHeader(theme),
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 32),
                      GlossStaggeredItem.tight(
                        index: 0,
                        controller: _fadeController,
                        child: GlossCard(
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
                                      borderRadius:
                                          BorderRadius.circular(8),
                                    ),
                                    child: Icon(Icons.phone_android_rounded,
                                        color: theme.green, size: 18),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Telefon raqam',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: theme.hint,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 14),
                                    decoration: BoxDecoration(
                                      color: theme.bg,
                                      borderRadius:
                                          BorderRadius.circular(12),
                                      border: Border.all(
                                          color: theme.border),
                                    ),
                                    child: Text(
                                      '+998',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: theme.text,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: GlossTextField(
                                      label: '',
                                      hint: 'XX XXX XX XX',
                                      controller: _phoneController,
                                      keyboardType: TextInputType.phone,
                                      onChanged: (value) {
                                        final formatted =
                                            _formatPhone(value);
                                        if (formatted != value) {
                                          _phoneController.value =
                                              TextEditingValue(
                                            text: formatted,
                                            selection:
                                                TextSelection.collapsed(
                                                    offset:
                                                        formatted.length),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      GlossStaggeredItem.tight(
                        index: 1,
                        controller: _fadeController,
                        child: GlossButton(
                          label: 'Kirish',
                          isLoading: _isLoading,
                          onPressed: _isLoading ? null : _handleLogin,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GlossStaggeredItem.tight(
                        index: 2,
                        controller: _fadeController,
                        child: _TapButton(
                          onTap: () => context.push('/auth/register'),
                          builder: (scale) {
                            return AnimatedScale(
                              scale: scale,
                              duration:
                                  const Duration(milliseconds: 100),
                              child: TextButton(
                                onPressed: () {},
                                child: RichText(
                                  text: TextSpan(
                                    text: "Akkountingiz yo'qmi? ",
                                    style: TextStyle(
                                      color: theme.hint,
                                      fontSize: 14,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "Ro'yxatdan o'tish",
                                        style: TextStyle(
                                          color: theme.green,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(GlossTheme theme) {
    return Container(
      width: double.infinity,
      height: 260,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [theme.green, theme.darkGreen],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Text(
                'Assalom,\nXush kelibsiz!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Ro'yxatdan o'tish uchun\ntelefon raqamingizni kiriting",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.78),
                  height: 1.4,
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
