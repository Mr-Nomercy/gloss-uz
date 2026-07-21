import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gloss_worker/widgets/staggered_item.dart';
import 'package:ui_kit/ui_kit.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  late final AnimationController _errorShakeController;
  late final Animation<double> _errorShakeAnimation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic);
    _errorShakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _errorShakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10, end: 10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10, end: -6), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -6, end: 6), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 6, end: 0), weight: 1),
    ]).animate(
      CurvedAnimation(parent: _errorShakeController, curve: Curves.easeInOut),
    );
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() => _isLoading = false);
        _fadeController.forward();
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fadeController.dispose();
    _errorShakeController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      GlossSnackBar.showSuccess(
          context, "Ro'yxatdan muvaffaqiyatli o'tdingiz!");
      context.go('/');
    } else {
      _errorShakeController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    return Scaffold(
      backgroundColor: theme.bg,
      appBar: const GlossAppBar(title: "Ro'yxatdan o'tish"),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: AnimatedBuilder(
                    animation: _errorShakeAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_errorShakeAnimation.value, 0),
                        child: child,
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 32),
                        GlossStaggeredItem(
                          index: 0,
                          controller: _fadeController,
                          child: Center(
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: theme.greenBgLight,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: theme.green
                                      .withValues(alpha: 0.20),
                                  width: 2,
                                ),
                              ),
                              child: Icon(Icons.person_add_alt_rounded,
                                  size: 48, color: theme.green),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        GlossStaggeredItem(
                          index: 1,
                          controller: _fadeController,
                          child: GlossCard(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ismingiz',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: theme.hint,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                GlossTextField(
                                  label: 'Ismingiz',
                                  hint: 'Ismingizni kiriting',
                                  controller: _nameController,
                                  prefixIcon: Icon(Icons.person_outline,
                                      color: theme.hint),
                                  validator: GlossFormValidators.required,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        GlossStaggeredItem(
                          index: 2,
                          controller: _fadeController,
                          child: GlossCard(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Telefon raqam',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: theme.hint,
                                  ),
                                ),
                                const SizedBox(height: 8),
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
                                      child: Icon(Icons.phone_outlined,
                                          color: theme.green, size: 18),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      '+998 90 123 45 67',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: theme.text,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        GlossStaggeredItem(
                          index: 3,
                          controller: _fadeController,
                          child: _TapButton(
                            onTap: _handleRegister,
                            builder: (scale) {
                              return AnimatedScale(
                                scale: scale,
                                duration:
                                    const Duration(milliseconds: 100),
                                child: const GlossButton(
                                  label: "Ro'yxatdan o'tish",
                                  onPressed: null,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        GlossStaggeredItem(
                          index: 4,
                          controller: _fadeController,
                          child: Text(
                            "Ro'yxatdan o'tish orqali siz foydalanish shartlariga rozilik bildirasiz",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 12, color: theme.hint),
                          ),
                        ),
                      ],
                    ),
                  ),
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
