import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _nameController.dispose();
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
        title: Text(
          "Ro'yxatdan o'tish",
          style: TextStyle(color: theme.text, fontWeight: FontWeight.w700, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: theme.greenBgLight,
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.green.withAlpha(50), width: 2),
                  ),
                  child: Icon(Icons.person_add_alt_rounded, size: 48, color: theme.green),
                ),
              ),
              const SizedBox(height: 32),
              GlossCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ismingiz',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: theme.hint,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      style: TextStyle(fontSize: 16, color: theme.text),
                      decoration: InputDecoration(
                        hintText: 'Ismingizni kiriting',
                        hintStyle: TextStyle(color: theme.hint),
                        filled: true,
                        fillColor: theme.bg,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: theme.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: theme.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: theme.green, width: 2),
                        ),
                        prefixIcon: Icon(Icons.person_outline, color: theme.hint),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Ism kiritish shart';
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              GlossCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Telefon raqam',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: theme.hint,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.phone_outlined, color: theme.hint),
                        const SizedBox(width: 8),
                        Text(
                          '+998 90 123 45 67',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: theme.text,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Ro'yxatdan muvaffaqiyatli o'tdingiz!"),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                      ),
                    );
                    context.go('/');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                child: const Text("Ro'yxatdan o'tish"),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Ro'yxatdan o'tish orqali siz foydalanish shartlariga rozilik bildirasiz",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: theme.hint),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
