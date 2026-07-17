import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';
import 'verify_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _phoneCtrl = TextEditingController();
  final _focusNode = FocusNode();
  bool _valid = false;
  bool _loading = false;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onPhoneChanged(String v) {
    final digits = v.replaceAll(RegExp(r'[^0-9]'), '');
    final buf = StringBuffer();
    for (int i = 0; i < digits.length && i < 9; i++) {
      if (i == 2 || i == 5) buf.write(' ');
      buf.write(digits[i]);
    }
    final formatted = buf.toString();
    if (formatted != v) {
      _phoneCtrl.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
    setState(() => _valid = digits.length == 9);
  }

  Future<void> _submit() async {
    if (!_valid) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _loading = false);
      Navigator.push(context, MaterialPageRoute(builder: (_) => const VerifyScreen()));
    }
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
              const Spacer(flex: 2),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: GlossColors.green.withAlpha(16),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.phone_android_rounded, color: GlossColors.green, size: 40),
              ),
              const SizedBox(height: 24),
              const Text(
                'Telefon raqamingiz',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: GlossColors.text),
              ),
              const SizedBox(height: 8),
              const Text(
                "Ro'yxatdan o'tish uchun telefon raqamingizni kiriting",
                style: TextStyle(fontSize: 15, color: GlossColors.hint),
              ),
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  color: GlossColors.bg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _valid ? GlossColors.green : GlossColors.border),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Text('+998 ', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: GlossColors.text)),
                    Expanded(
                      child: TextField(
                        controller: _phoneCtrl,
                        focusNode: _focusNode,
                        keyboardType: TextInputType.phone,
                        maxLength: 11,
                        onChanged: _onPhoneChanged,
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: GlossColors.text),
                        decoration: const InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                          hintText: 'xx xxx xx xx',
                          hintStyle: TextStyle(color: GlossColors.disabled, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    if (_valid) const Icon(Icons.check_circle_rounded, color: GlossColors.green, size: 22),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _valid && !_loading ? _submit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GlossColors.green,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: GlossColors.disabled,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: _loading
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Davom etish', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
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
