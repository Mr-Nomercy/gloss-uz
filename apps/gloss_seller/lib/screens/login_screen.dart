import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui_kit/ui_kit.dart';

final loginFormProvider = StateNotifierProvider<LoginFormNotifier, LoginFormState>((ref) {
  return LoginFormNotifier();
});

class LoginFormState {
  final String phone;
  final String password;
  final bool isLoading;
  final String? error;

  const LoginFormState({this.phone = '', this.password = '', this.isLoading = false, this.error});

  LoginFormState copyWith({String? phone, String? password, bool? isLoading, String? error}) {
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
  void setPassword(String v) => state = state.copyWith(password: v, error: null);
  void setLoading(bool v) => state = state.copyWith(isLoading: v);
  void setError(String? e) => state = state.copyWith(error: e);
}

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.gloss;
    final form = ref.watch(loginFormProvider);
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
            Text(
              'Xush kelibsiz',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: theme.text, height: 1.3),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Hisobingizga kiring',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: theme.hint, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            GlossCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlossTextField(
                    label: 'Telefon raqam',
                    hint: '+998 XX XXX XX XX',
                    keyboardType: TextInputType.phone,
                    onChanged: (v) => ref.read(loginFormProvider.notifier).setPhone(v),
                  ),
                  const SizedBox(height: 16),
                  GlossTextField(
                    label: 'Parol',
                    hint: 'Parolingizni kiriting',
                    obscureText: true,
                    onChanged: (v) => ref.read(loginFormProvider.notifier).setPassword(v),
                  ),
                ],
              ),
            ),
            if (form.error != null) ...[
              const SizedBox(height: 8),
              Text(form.error!, style: TextStyle(color: theme.red, fontSize: 13)),
            ],
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Parolni unutdingizmi?',
                  style: TextStyle(color: theme.green, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 24),
            GlossButton(
              label: 'Kirish',
              isLoading: form.isLoading,
              onPressed: form.isLoading ? null : () => context.go('/'),
            ),
            const SizedBox(height: 16),
            SizedBox(
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
          ],
        ),
      ),
    );
  }
}