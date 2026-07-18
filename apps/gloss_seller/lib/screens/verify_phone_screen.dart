import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class VerifyPhoneScreen extends StatefulWidget {
  final String phone;
  const VerifyPhoneScreen({super.key, required this.phone});

  @override
  State<VerifyPhoneScreen> createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  final _codeController = TextEditingController();
  final bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            Text(
              'SMS kodni kiriting',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: theme.text, height: 1.3),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.phone} raqamiga SMS yuborildi',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: theme.hint, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            GlossCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlossTextField(
                    label: 'SMS kod',
                    hint: '000000',
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: theme.text, letterSpacing: 8),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GlossButton(
              label: 'Tasdiqlash',
              isLoading: _isLoading,
              onPressed: _isLoading ? null : () => context.go('/'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {},
              child: Text(
                'Kodni qayta yuborish',
                style: TextStyle(color: theme.green, fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}