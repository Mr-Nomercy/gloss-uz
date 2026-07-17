import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';
import '../providers/auth_provider.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _phoneCtrl = TextEditingController();
  final _focusNode = FocusNode();
  bool _valid = false;
  String? _error;

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
    setState(() {
      _valid = digits.length == 9;
      _error = null;
    });
  }

  String get _fullPhone => '+998${_phoneCtrl.text.replaceAll(' ', '')}';

  Future<void> _submit() async {
    if (!_valid) return;
    setState(() => _error = null);
    await ref.read(authProvider.notifier).login(_fullPhone);
    final state = ref.read(authProvider);
    if (!mounted) return;
    if (state.error != null) {
      setState(() => _error = state.error);
    } else {
      context.push('/verify', extra: _fullPhone);
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
                  border: Border.all(
                    color: _error != null
                        ? Colors.red
                        : _valid
                            ? GlossColors.green
                            : GlossColors.border,
                  ),
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
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 13)),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _valid && !isLoading ? _submit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GlossColors.green,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: GlossColors.disabled,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: isLoading
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
