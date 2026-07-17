import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _phoneController = TextEditingController(text: '');
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  String _formatPhone(String value) {
    final digits = value.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.isEmpty) return '';
    var formatted = StringBuffer();
    if (digits.length > 2) formatted.write('${digits.substring(0, 2)} ');
    if (digits.length > 5) formatted.write('${digits.substring(2, 5)} ');
    if (digits.length > 7) formatted.write('${digits.substring(5, 7)} ');
    if (digits.length > 9) formatted.write(digits.substring(7, 9));
    if (digits.length == 9 && formatted.isEmpty) formatted.write(digits);
    if (digits.length > 9 && digits.length <= 12) {
      final rest = digits.substring(2);
      formatted.clear();
      var f = StringBuffer();
      if (rest.length > 3) f.write('${rest.substring(0, 3)} ');
      if (rest.length > 5) f.write('${rest.substring(3, 5)} ');
      if (rest.length > 7) f.write('${rest.substring(5, 7)} ');
      if (rest.length > 9) f.write(rest.substring(7, 9));
      formatted.write(f.toString().trim());
    }
    return formatted.toString().trim();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.gloss;
    return Scaffold(
      backgroundColor: theme.bg,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 260,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [theme.green, theme.darkGreen],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    const Text(
                      'Assalom,\nXush kelibsiz!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Ro'yxatdan o'tish uchun\ntelefon raqamingizni kiriting",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withAlpha(200),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),
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
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                decoration: BoxDecoration(
                                  color: theme.bg,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: theme.border),
                                ),
                                child: Text(
                                  '+998',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: theme.text,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: theme.text,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'XX XXX XX XX',
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
                                  onChanged: (value) {
                                    final formatted = _formatPhone(value);
                                    if (formatted != value) {
                                      _phoneController.value = TextEditingValue(
                                        text: formatted,
                                        selection: TextSelection.collapsed(offset: formatted.length),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          final digits = _phoneController.text.replaceAll(RegExp(r'[^\d]'), '');
                          if (digits.length == 9) {
                            context.push('/auth/verify', extra: '+998$digits');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("To'g'ri telefon raqam kiriting"),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        child: const Text('Kirish'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => context.push('/auth/register'),
                      child: RichText(
                        text: TextSpan(
                          text: "Akkountingiz yo'qmi? ",
                          style: TextStyle(color: theme.hint, fontSize: 14),
                          children: [
                            TextSpan(
                              text: "Ro'yxatdan o'tish",
                              style: TextStyle(color: theme.green, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
