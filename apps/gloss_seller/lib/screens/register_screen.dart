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
      backgroundColor: theme.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            Text(
              "Hisob yaratish",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: theme.text, height: 1.3),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Ma'lumotlaringizni kiriting",
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
                    label: 'Telefon raqam',
                    hint: '+998 XX XXX XX XX',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  GlossTextField(
                    label: 'Ism familiya',
                    hint: 'Ismingizni kiriting',
                    controller: _nameController,
                  ),
                  const SizedBox(height: 16),
                  GlossTextField(
                    label: 'Parol',
                    hint: 'Parolingizni kiriting',
                    controller: _passwordController,
                    obscureText: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    value: _agreeToTerms,
                    onChanged: (v) => setState(() => _agreeToTerms = v ?? true),
                    activeColor: theme.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Foydalanish shartlari va maxfiylik siyosatiga roziman",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: theme.hint, height: 1.4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            GlossButton(
              label: "Ro'yxatdan o'tish",
              isLoading: _isLoading,
              onPressed: _isLoading ? null : () => context.go('/'),
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
}