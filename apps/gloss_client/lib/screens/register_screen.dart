import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _nameFocus = FocusNode();
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _loading = false);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
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
                child: const Icon(Icons.person_outline_rounded, color: GlossColors.green, size: 40),
              ),
              const SizedBox(height: 24),
              const Text(
                'Ismingizni kiriting',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: GlossColors.text),
              ),
              const SizedBox(height: 8),
              const Text(
                ' profilingizni yaratish uchun ismingizni kiriting',
                style: TextStyle(fontSize: 15, color: GlossColors.hint),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: GlossColors.bg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: GlossColors.green.withAlpha(16),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.phone_rounded, color: GlossColors.green, size: 18),
                    ),
                    const SizedBox(width: 12),
                    const Text('+998 xx xxx xx xx', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: GlossColors.text)),
                    const Spacer(),
                    const Icon(Icons.check_circle_rounded, color: GlossColors.green, size: 20),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: GlossColors.bg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _nameCtrl.text.trim().isNotEmpty ? GlossColors.green : GlossColors.border),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _nameCtrl,
                  focusNode: _nameFocus,
                  textCapitalization: TextCapitalization.words,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: GlossColors.text),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Ismingiz...',
                    hintStyle: TextStyle(color: GlossColors.disabled),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _nameCtrl.text.trim().isNotEmpty && !_loading ? _submit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GlossColors.green,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: GlossColors.disabled,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: _loading
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text("Ro'yxatdan o'tish", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
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
