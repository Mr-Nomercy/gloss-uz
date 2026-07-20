import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui_kit/ui_kit.dart';

final loginFormProvider =
    StateNotifierProvider<LoginFormNotifier, LoginFormState>((ref) {
  return LoginFormNotifier();
});

class LoginFormState {
  final String phone;
  final String password;
  final bool isLoading;
  final String? error;

  const LoginFormState(
      {this.phone = '', this.password = '', this.isLoading = false, this.error});

  LoginFormState copyWith(
      {String? phone,
      String? password,
      bool? isLoading,
      String? error}) {
    return LoginFormState(
      phone: phone ?? this.phone,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class LoginFormNotifier extends StateNotifier<LoginFormState> {
  LoginFormNotifier() : super(const LoginFormState());

  void setPhone(String v) =>
      state = state.copyWith(phone: v, error: null);
  void setPassword(String v) =>
      state = state.copyWith(password: v, error: null);
  void setLoading(bool v) => state = state.copyWith(isLoading: v);
  void setError(String? e) => state = state.copyWith(error: e);
}

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
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
    final form = ref.watch(loginFormProvider);
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
              const SizedBox(height: 48),
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
                child: const Icon(Icons.delivery_dining_rounded,
                    color: GlossColors.green, size: 40),
              ),
              const SizedBox(height: 24),
              Text(
                'Xush kelibsiz',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: theme.text,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Hisobingizga kiring',
                style: TextStyle(
                  fontSize: 15,
                  color: theme.hint,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              GlossTextField(
                label: 'Telefon raqam',
                hint: '+998 XX XXX XX XX',
                keyboardType: TextInputType.phone,
                onChanged: (v) =>
                    ref.read(loginFormProvider.notifier).setPhone(v),
              ),
              const SizedBox(height: 16),
              GlossTextField(
                label: 'Parol',
                hint: 'Parolingizni kiriting',
                obscureText: true,
                onChanged: (v) =>
                    ref.read(loginFormProvider.notifier).setPassword(v),
              ),
              if (form.error != null) ...[
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    form.error!,
                    style: const TextStyle(
                        color: GlossColors.red, fontSize: 13),
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Parolni unutdingizmi?',
                    style: TextStyle(
                      color: theme.green,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 52,
                child: _scaleTap(
                  onTap: form.isLoading ? null : () => context.go('/'),
                  child: ElevatedButton(
                    onPressed:
                        form.isLoading ? null : () => context.go('/'),
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
                    child: form.isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Kirish'),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 52,
                child: _scaleTap(
                  onTap: () => context.go('/auth/register'),
                  child: OutlinedButton(
                    onPressed: () => context.go('/auth/register'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.green,
                      side: BorderSide(
                          color: theme.green.withValues(alpha: 0.30)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    child: const Text("Ro'yxatdan o'tish"),
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
