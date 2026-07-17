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
                  Text('Telefon raqam', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: theme.hint)),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: theme.text),
                    decoration: InputDecoration(
                      hintText: '+998 XX XXX XX XX',
                      hintStyle: TextStyle(color: theme.hint),
                      filled: true,
                      fillColor: theme.bg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: theme.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: theme.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: theme.green, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Ism familiya', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: theme.hint)),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nameController,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: theme.text),
                    decoration: InputDecoration(
                      hintText: 'Ismingizni kiriting',
                      hintStyle: TextStyle(color: theme.hint),
                      filled: true,
                      fillColor: theme.bg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: theme.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: theme.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: theme.green, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Parol', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: theme.hint)),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: theme.text),
                    decoration: InputDecoration(
                      hintText: 'Parolingizni kiriting',
                      hintStyle: TextStyle(color: theme.hint),
                      filled: true,
                      fillColor: theme.bg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: theme.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: theme.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: theme.green, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    ),
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
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : () => context.go('/'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.green,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: theme.disabled,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                child: _isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
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
}
