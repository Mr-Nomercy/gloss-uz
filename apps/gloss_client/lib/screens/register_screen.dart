import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  final String phone;

  const RegisterScreen({super.key, required this.phone});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _nameFocus = FocusNode();
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    setState(() => _error = null);

    final success = await ref.read(authProvider.notifier).register(widget.phone, name);
    if (!mounted) return;

    if (success) {
      context.go('/home');
    } else {
      final error = ref.read(authProvider).error;
      setState(() => _error = error ?? "Xatolik yuz berdi");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;
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
                    Text(widget.phone, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: GlossColors.text)),
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
                  border: Border.all(
                    color: _error != null
                        ? Colors.red
                        : _nameCtrl.text.trim().isNotEmpty
                            ? GlossColors.green
                            : GlossColors.border,
                  ),
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
                  onChanged: (_) => setState(() => _error = null),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 13)),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _nameCtrl.text.trim().isNotEmpty && !isLoading ? _submit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GlossColors.green,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: GlossColors.disabled,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: isLoading
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
