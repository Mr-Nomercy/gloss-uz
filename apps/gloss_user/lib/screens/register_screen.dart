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
                  color: context.gloss.green.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(Icons.person_outline_rounded, color: context.gloss.green, size: 40),
              ),
              const SizedBox(height: 24),
              Text(
                'Ismingizni kiriting',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: context.gloss.text),
              ),
              const SizedBox(height: 8),
              Text(
                ' profilingizni yaratish uchun ismingizni kiriting',
                style: TextStyle(fontSize: 15, color: context.gloss.hint),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.gloss.bg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: context.gloss.green.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.phone_rounded, color: context.gloss.green, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Text(widget.phone, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: context.gloss.text)),
                    const Spacer(),
                    Icon(Icons.check_circle_rounded, color: context.gloss.green, size: 20),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: context.gloss.bg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _error != null
                        ? Colors.red
                        : _nameCtrl.text.trim().isNotEmpty
                            ? context.gloss.green
                            : context.gloss.border,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GlossTextField(
                  hint: 'Ismingiz...',
                  controller: _nameCtrl,
                  focusNode: _nameFocus,
                  textCapitalization: TextCapitalization.words,
                  filled: false,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: context.gloss.text),
                  onChanged: (_) => setState(() => _error = null),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 13)),
              ],
              const SizedBox(height: 24),
              GlossButton(
                label: "Ro'yxatdan o'tish",
                isLoading: isLoading,
                onPressed: _nameCtrl.text.trim().isNotEmpty && !isLoading ? _submit : null,
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}