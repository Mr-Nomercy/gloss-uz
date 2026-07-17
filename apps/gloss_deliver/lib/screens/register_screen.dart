import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final bool _isLoading = false;
  bool _agreeToTerms = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
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
      body: SingleChildScrollView(
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
              child: const Icon(Icons.person_add_alt_rounded, color: GlossColors.green, size: 40),
            ),
            const SizedBox(height: 24),
            const Text(
              'Hisob yaratish',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: GlossColors.text),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              "Ma'lumotlaringizni kiriting",
              style: TextStyle(fontSize: 15, color: GlossColors.hint),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildTextField(theme, label: 'Telefon raqam', hint: '+998 XX XXX XX XX', controller: _phoneController, phone: true),
            const SizedBox(height: 16),
            _buildTextField(theme, label: 'Ism familiya', hint: 'Ismingizni kiriting', controller: _nameController),
            const SizedBox(height: 16),
            _buildTextField(theme, label: 'Parol', controller: _passwordController, obscure: true),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _agreeToTerms,
                  activeColor: theme.green,
                  onChanged: (v) => setState(() => _agreeToTerms = v ?? true),
                ),
                Expanded(
                  child: Text(
                    "Foydalanish shartlari va maxfiylik siyosatiga roziman",
                    style: TextStyle(fontSize: 13, color: theme.hint),
                  ),
                ),
              ],
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
                    : const Text("Ro'yxatdan o'tish"),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.go('/auth/login'),
              child: Text(
                "Hisobingiz bormi? Kirish",
                style: TextStyle(color: theme.green, fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(GlossTheme theme, {
    required String label,
    String? hint,
    required TextEditingController controller,
    bool obscure = false,
    bool phone = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: theme.hint)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: phone ? TextInputType.phone : TextInputType.text,
            obscureText: obscure,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: theme.text),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(color: theme.disabled, fontWeight: FontWeight.w400),
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
