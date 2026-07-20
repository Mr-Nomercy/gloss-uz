import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final bool _isLoading = false;
  bool _agreeToTerms = true;

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
    _phoneController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: _scaleTap(
            onTap: () => context.pop(),
            child: Container(
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
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.greenBgLight,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: theme.green.withValues(alpha: 0.10),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(Icons.person_add_alt_rounded,
                    color: theme.green, size: 40),
              ),
              const SizedBox(height: 24),
              Text(
                'Hisob yaratish',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: theme.text,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "Ma'lumotlaringizni kiriting",
                style: TextStyle(fontSize: 15, color: theme.hint),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              GlossTextField(
                label: 'Telefon raqam',
                hint: '+998 XX XXX XX XX',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              GlossTextField(
                label: 'Ism familiya',
                hint: 'Ismingizni kiriting',
                controller: _nameController,
              ),
              const SizedBox(height: 16),
              GlossTextField(
                label: 'Parol',
                hint: 'Parolingizni kiriting',
                controller: _passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _agreeToTerms,
                    activeColor: theme.green,
                    onChanged: (v) =>
                        setState(() => _agreeToTerms = v ?? true),
                  ),
                  Expanded(
                    child: Text(
                      "Foydalanish shartlari va maxfiylik siyosatiga roziman",
                      style: TextStyle(fontSize: 13, color: theme.hint),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 52,
                child: _scaleTap(
                  onTap:
                      _isLoading ? null : () => context.go('/'),
                  child: ElevatedButton(
                    onPressed:
                        _isLoading ? null : () => context.go('/'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.green,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: theme.grayLight,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Text("Ro'yxatdan o'tish"),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 52,
                child: _scaleTap(
                  onTap: () => context.go('/auth/login'),
                  child: OutlinedButton(
                    onPressed: () => context.go('/auth/login'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.green,
                      side: BorderSide(
                          color: theme.green.withValues(alpha: 0.30)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    child: const Text("Hisobingiz bormi? Kirish"),
                  ),
                ),
              ),
            ],
          ),
        ),
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
