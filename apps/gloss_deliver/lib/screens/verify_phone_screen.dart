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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.arrow_back_ios_new_rounded, color: theme.text, size: 18),
          ),
        ),
      ),
      body: Padding(
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
              ),
              child: const Icon(Icons.sms_rounded, color: GlossColors.green, size: 40),
            ),
            const SizedBox(height: 24),
            const Text(
              'SMS kodni kiriting',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: GlossColors.text),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.phone} raqamiga SMS yuborildi',
              style: const TextStyle(fontSize: 15, color: GlossColors.hint),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                color: theme.bg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: theme.border),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: theme.text, letterSpacing: 8),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '000000',
                  hintStyle: TextStyle(color: GlossColors.disabled, fontSize: 24, letterSpacing: 8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : () => context.go('/'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.green,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: theme.grayLight,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                child: _isLoading
                    ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Tasdiqlash'),
              ),
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
