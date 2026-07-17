import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';
import 'register_screen.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final _codeCtrl = TextEditingController();
  final _focusNode = FocusNode();
  bool _loading = false;
  int _resendSeconds = 30;
  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _focusNode.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendSeconds = 30;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_resendSeconds > 0) {
        setState(() => _resendSeconds--);
      } else {
        t.cancel();
      }
    });
  }

  Future<void> _submit() async {
    final code = _codeCtrl.text.trim();
    if (code.length != 4) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _loading = false);
      if (code == '1111') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const RegisterScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Kod noto'g'ri"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          ),
        );
      }
    }
  }

  void _resend() {
    if (_resendSeconds > 0) return;
    _startResendTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kod qayta yuborildi'),
        backgroundColor: GlossColors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: GlossColors.bg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded, color: GlossColors.text, size: 20),
                ),
              ),
              const Spacer(flex: 2),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: GlossColors.green.withAlpha(16),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.sms_rounded, color: GlossColors.green, size: 40),
              ),
              const SizedBox(height: 24),
              const Text(
                'SMS kodni kiriting',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: GlossColors.text),
              ),
              const SizedBox(height: 8),
              const Text(
                'Biz +998 xx xxx xx xx raqamiga 4 xonali kod yubordik',
                style: TextStyle(fontSize: 15, color: GlossColors.hint),
              ),
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  color: GlossColors.bg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _codeCtrl.text.length == 4 ? GlossColors.green : GlossColors.border),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _codeCtrl,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: GlossColors.text, letterSpacing: 12),
                  decoration: const InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                    hintText: '0000',
                    hintStyle: TextStyle(color: GlossColors.disabled, fontSize: 28, letterSpacing: 12),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _codeCtrl.text.length == 4 && !_loading ? _submit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GlossColors.green,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: GlossColors.disabled,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: _loading
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Tasdiqlash', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: _resend,
                  child: Text(
                    _resendSeconds > 0
                        ? 'Kodni $_resendSeconds soniyadan keyin qayta yuborish'
                        : 'Kodni qayta yuborish',
                    style: TextStyle(
                      fontSize: 14,
                      color: _resendSeconds > 0 ? GlossColors.hint : GlossColors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
