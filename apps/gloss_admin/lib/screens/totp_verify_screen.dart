import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';
import '../providers/auth_provider.dart';

/// Every platform_admin login after the first: 2FA is already enrolled,
/// this just asks for the current code from the authenticator app.
class TotpVerifyScreen extends ConsumerStatefulWidget {
  const TotpVerifyScreen({super.key});

  @override
  ConsumerState<TotpVerifyScreen> createState() => _TotpVerifyScreenState();
}

class _TotpVerifyScreenState extends ConsumerState<TotpVerifyScreen> {
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    final authState = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (prev, next) {
      if (next.isAuthenticated) {
        context.go('/dashboard');
      }
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: theme.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
        ref.read(authProvider.notifier).clearError();
      }
    });

    if (!authState.totpVerifyRequired) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go('/login');
      });
      return const Scaffold(body: SizedBox.shrink());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Tasdiqlash kodi')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Authenticator ilovangizdagi 6 xonali kodni kiriting.',
                  style: TextStyle(fontSize: 14, color: theme.hint),
                ),
                const SizedBox(height: 24),
                GlossTextField(
                  controller: _codeController,
                  hint: '000000',
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  autofocus: true,
                  validator: (v) {
                    if (v == null || v.trim().length != 6) return '6 xonali kod kiriting';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                GlossButton(
                  label: 'Kirish',
                  isLoading: authState.isLoading,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ref.read(authProvider.notifier).verifyTotp(_codeController.text.trim());
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
