import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneCtrl = TextEditingController();

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    final authState = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (prev, next) {
      if (next.isAuthenticated && !(prev?.isAuthenticated ?? false)) {
        context.go(next.homePath);
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: theme.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(Icons.handyman_rounded, color: theme.green, size: 36),
              ),
              const SizedBox(height: 24),
              Text(
                'Gloss Partner',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: theme.text),
              ),
              const SizedBox(height: 8),
              Text(
                'Tozalash yoki yetkazib berish bo\'yicha hamkoringiz',
                style: TextStyle(fontSize: 14, color: theme.hint),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              GlossTextField(
                label: 'Telefon raqam',
                hint: '998 XX XXX XX XX',
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                prefixIcon: Icon(Icons.phone_rounded, color: theme.hint, size: 20),
              ),
              if (authState.error != null) ...[
                const SizedBox(height: 8),
                Text(authState.error!, style: TextStyle(fontSize: 12, color: theme.red)),
              ],
              const SizedBox(height: 24),
              GlossButton(
                label: 'Kirish',
                isLoading: authState.isLoading,
                onPressed: () => ref.read(authProvider.notifier).login(_phoneCtrl.text.trim()),
              ),
              const Spacer(flex: 3),
              Text(
                'Worker: 998901234567, Kuryer: 998907654321',
                style: TextStyle(fontSize: 12, color: theme.disabled),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
