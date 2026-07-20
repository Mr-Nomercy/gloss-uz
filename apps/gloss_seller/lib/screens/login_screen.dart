import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui_kit/ui_kit.dart';
import 'animations.dart';

final loginFormProvider =
    StateNotifierProvider<LoginFormNotifier, LoginFormState>((ref) {
  return LoginFormNotifier();
});

class LoginFormState {
  final String phone;
  final String password;
  final bool isLoading;
  final String? error;

  const LoginFormState({
    this.phone = '',
    this.password = '',
    this.isLoading = false,
    this.error,
  });

  LoginFormState copyWith({
    String? phone,
    String? password,
    bool? isLoading,
    String? error,
  }) {
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

  void setPhone(String v) => state = state.copyWith(phone: v, error: null);
  void setPassword(String v) =>
      state = state.copyWith(password: v, error: null);
  void setLoading(bool v) => state = state.copyWith(isLoading: v);
  void setError(String? e) => state = state.copyWith(error: e);

  bool validate() {
    if (state.phone.trim().isEmpty) {
      state = state.copyWith(error: 'Telefon raqamni kiriting');
      return false;
    }
    if (state.phone.trim().length < 9) {
      state = state.copyWith(error: 'Telefon raqam noto\'g\'ri');
      return false;
    }
    if (state.password.trim().isEmpty) {
      state = state.copyWith(error: 'Parolni kiriting');
      return false;
    }
    if (state.password.trim().length < 4) {
      state = state.copyWith(error: 'Parol kamida 4 ta belgidan iborat bo\'lishi kerak');
      return false;
    }
    return true;
  }

  void login(BuildContext context) {
    if (!validate()) return;
    setLoading(true);
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        setLoading(false);
        context.go('/');
      }
    });
  }
}

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.gloss;
    final form = ref.watch(loginFormProvider);
    final notifier = ref.read(loginFormProvider.notifier);
    return Scaffold(
      backgroundColor: theme.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            FadeSlideOnMount(
              child: Column(
                children: [
                  Text(
                    'Xush kelibsiz',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: theme.text,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Hisobingizga kiring',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: theme.hint,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            FadeSlideOnMount(
              delay: const Duration(milliseconds: 150),
              child: GlossCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GlossTextField(
                      label: 'Telefon raqam',
                      hint: '+998 XX XXX XX XX',
                      keyboardType: TextInputType.phone,
                      onChanged: (v) => notifier.setPhone(v),
                    ),
                    const SizedBox(height: 16),
                    GlossTextField(
                      label: 'Parol',
                      hint: 'Parolingizni kiriting',
                      obscureText: true,
                      onChanged: (v) => notifier.setPassword(v),
                    ),
                  ],
                ),
              ),
            ),
            if (form.error != null) ...[
              const SizedBox(height: 10),
              FadeSlideOnMount(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: theme.red.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, size: 18, color: theme.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          form.error!,
                          style: TextStyle(color: theme.red, fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Parolni unutdingizmi?',
                  style: TextStyle(
                    color: theme.green,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            FadeSlideOnMount(
              delay: const Duration(milliseconds: 300),
              child: ScaleTap(
                onTap: form.isLoading ? null : () => notifier.login(context),
                child: GlossButton(
                  label: 'Kirish',
                  isLoading: form.isLoading,
                  onPressed: form.isLoading ? null : () => notifier.login(context),
                ),
              ),
            ),
            const SizedBox(height: 16),
            FadeSlideOnMount(
              delay: const Duration(milliseconds: 400),
              child: SizedBox(
                height: 52,
                child: OutlinedButton(
                  onPressed: () => context.go('/auth/register'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.green,
                    side: BorderSide(color: theme.green.withValues(alpha: 0.30)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  child: const Text("Ro'yxatdan o'tish"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
