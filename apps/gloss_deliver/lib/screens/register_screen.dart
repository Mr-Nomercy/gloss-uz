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
              child: Icon(Icons.person_add_alt_rounded, color: theme.green, size: 40),
            ),
            const SizedBox(height: 24),
            Text(
              'Hisob yaratish',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: theme.text),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Ma'lumotlaringizni kiriting",
              style: TextStyle(fontSize: 15, color: theme.hint),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
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